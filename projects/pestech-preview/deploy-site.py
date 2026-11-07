#!/usr/bin/env python3
"""Install the approved Pestech bundle on the EC2 instance in this Terraform project."""
import argparse
import json
import re
import shlex
import subprocess
import sys
import time
from pathlib import Path
from urllib.parse import urlsplit

REGION = "us-east-1"
APPROVED_SHA256 = "90d4644df15786085bb5b23cbba825f51056356b642c9d72e5c63bc02f319f6e"
RECEIPT = Path("pestech-deploy-receipt.json")
SHARE_IMAGE = "/assets/pestech-share-wordmark-v1.png"
SHARE_SETUP = r'''import re
import struct
import sys
from pathlib import Path

origin = sys.argv[1]
root = Path("/usr/share/nginx/html")
pattern = re.compile(r"<!-- PESTECH_SHARE_START -->.*?<!-- PESTECH_SHARE_END -->", re.S)
count = 0
for page in root.rglob("*.html"):
    html = page.read_text()
    blocks = pattern.findall(html)
    if not blocks:
        if page == root / "index.html":
            raise SystemExit("The homepage is missing its share metadata.")
        continue
    if len(blocks) != 1:
        raise SystemExit("Duplicate share metadata in " + str(page))
    block = re.sub(r'content="https?://[^/\"]+(/[^\"]*)"',
                   lambda match: 'content="' + origin + match.group(1) + '"', blocks[0])
    expected = 'property="og:image" content="' + origin + '/assets/pestech-share-wordmark-v1.png"'
    if expected not in block:
        raise SystemExit("Incorrect share-image URL in " + str(page))
    page.write_text(html.replace(blocks[0], block))
    count += 1
if not count:
    raise SystemExit("No share metadata was configured.")
image = root / "assets/pestech-share-wordmark-v1.png"
header = image.read_bytes()[:24]
if header[:8] != b"\x89PNG\r\n\x1a\n" or struct.unpack(">II", header[16:24]) != (1200, 630):
    raise SystemExit("The PESTECH share image did not pass validation.")
print("Configured PESTECH share metadata for", count, "pages at", origin)
'''

def select_site_origin(outputs):
    for name in ("https_preview_url", "preview_url"):
        value = outputs.get(name, {}).get("value")
        if value:
            parsed = urlsplit(value)
            if (
                parsed.scheme not in {"http", "https"} or not parsed.hostname
                or parsed.username or parsed.password or parsed.query or parsed.fragment
                or parsed.path not in {"", "/"}
            ):
                raise ValueError("Unexpected public preview URL in Terraform outputs.")
            return f"{parsed.scheme}://{parsed.netloc}"
    raise ValueError("Terraform must output https_preview_url or preview_url for link previews.")

def cli_json(arguments):
    result = subprocess.run(arguments, text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip())
    return json.loads(result.stdout)

def aws_json(operation, *arguments):
    return cli_json([
        "aws", "ssm", operation, "--region", REGION,
        "--output", "json", "--no-cli-pager",
        "--cli-connect-timeout", "5", "--cli-read-timeout", "15",
        *arguments,
    ])

def make_payload(values):
    instance = values["instance_id"]
    bucket = values["assets_bucket"]
    key = values["website_bundle_key"]
    digest = values["website_bundle_sha256"]
    if not re.fullmatch(r"i-(?:[0-9a-f]{8}|[0-9a-f]{17})", instance):
        raise ValueError("Unexpected instance ID in Terraform outputs.")
    if not re.fullmatch(r"[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]", bucket):
        raise ValueError("Unexpected S3 bucket name in Terraform outputs.")
    if key != "releases/pestech-site.tar.gz" or digest != APPROVED_SHA256:
        raise ValueError("Terraform outputs do not match the approved website bundle.")
    uri = shlex.quote(f"s3://{bucket}/{key}")
    origin = shlex.quote(values["site_origin"])
    script = f"""set -euo pipefail
command -v aws >/dev/null
command -v python3 >/dev/null
test -d /usr/share/nginx/html
pestech_stage=$(mktemp -d /tmp/pestech-deploy.XXXXXX)
trap 'rm -rf "$pestech_stage"' EXIT
aws s3 cp {uri} "$pestech_stage/site.tar.gz" --region {REGION} --only-show-errors
printf '%s  %s\\n' '{digest}' "$pestech_stage/site.tar.gz" | sha256sum -c -
tar -xzf "$pestech_stage/site.tar.gz" -C /usr/share/nginx/html --no-same-owner
python3 - {origin} <<'PESTECH_SHARE_PY'
{SHARE_SETUP}PESTECH_SHARE_PY
chmod -R a+rX /usr/share/nginx/html
nginx -t
systemctl reload nginx
curl --fail --silent --show-error --max-time 10 http://127.0.0.1/healthz
curl --fail --silent --show-error --max-time 10 http://127.0.0.1/ -o "$pestech_stage/served-index.html"
cmp /usr/share/nginx/html/index.html "$pestech_stage/served-index.html"
curl --fail --silent --show-error --max-time 10 http://127.0.0.1/owner/ -o /dev/null
curl --fail --silent --show-error --max-time 10 http://127.0.0.1/assets/pestech-truck-640.webp -o /dev/null
curl --fail --silent --show-error --max-time 10 http://127.0.0.1{SHARE_IMAGE} -o "$pestech_stage/served-share.png"
cmp /usr/share/nginx/html{SHARE_IMAGE} "$pestech_stage/served-share.png"
printf '\\nPESTECH_DEPLOY_OK\\n'
"""
    return {
        "DocumentName": "AWS-RunShellScript",
        "InstanceIds": [instance],
        "Comment": "Install the approved Pestech preview website",
        "TimeoutSeconds": 60,
        "Parameters": {
            "commands": ["bash <<'PESTECH_REMOTE'\n" + script + "PESTECH_REMOTE"],
            "executionTimeout": ["180"],
        },
    }

def check_result(receipt):
    result = aws_json(
        "get-command-invocation", "--command-id", receipt["command_id"],
        "--instance-id", receipt["instance_id"],
    )
    status = result["Status"]
    if status in {"Pending", "InProgress", "Delayed", "Cancelling"}:
        return status, False
    for name in ("StandardOutputContent", "StandardErrorContent"):
        if result.get(name):
            print(result[name].rstrip(), flush=True)
    if (
        status == "Success"
        and result.get("ResponseCode") == 0
        and "PESTECH_DEPLOY_OK" in result.get("StandardOutputContent", "")
    ):
        print("Deployment verified on EC2.", flush=True)
        return status, True
    raise RuntimeError(f"Remote deployment did not pass: {status}. Send this output for review.")

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--show-command", action="store_true",
                        help="Show the remote command without sending it.")
    parser.add_argument("--check-status", action="store_true",
                        help="Check the last deployment without resending it.")
    args = parser.parse_args()
    if args.check_status:
        receipt = json.loads(RECEIPT.read_text())
    else:
        outputs = cli_json(["terraform", "output", "-json"])
        names = ("instance_id", "assets_bucket", "website_bundle_key", "website_bundle_sha256")
        values = {name: outputs[name]["value"] for name in names}
        values["site_origin"] = select_site_origin(outputs)
        payload = make_payload(values)
        if args.show_command:
            print("Target:", values["instance_id"])
            print("Share-preview origin:", values["site_origin"])
            print(payload["Parameters"]["commands"][0])
            return 0
        print("Sending deployment commands to", values["instance_id"], "through SSM...", flush=True)
        result = aws_json("send-command", "--cli-input-json", json.dumps(payload))
        receipt = {
            "command_id": result["Command"]["CommandId"], "instance_id": values["instance_id"],
            "bundle_sha256": values["website_bundle_sha256"], "site_origin": values["site_origin"],
        }
        RECEIPT.write_text(json.dumps(receipt, indent=2) + "\n")
        print("Command ID:", receipt["command_id"], flush=True)

    deadline = time.monotonic() + 45
    previous = None
    while time.monotonic() < deadline:
        try:
            status, done = check_result(receipt)
        except RuntimeError as error:
            if "InvocationDoesNotExist" not in str(error):
                raise
            status, done = "Registering command", False
        if done:
            return 0
        if status != previous:
            print("Status:", status, flush=True)
            previous = status
        time.sleep(2)
    print("Command is still running. Check it without resending:", flush=True)
    print("python3 deploy-site.py --check-status", flush=True)
    return 2

if __name__ == "__main__":
    try:
        sys.exit(main())
    except (RuntimeError, ValueError, KeyError, OSError) as error:
        print("Deployment check:", error, file=sys.stderr)
        sys.exit(1)
