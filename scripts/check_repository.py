#!/usr/bin/env python3
"""Check repository structure, tracked publication inputs, and local Markdown links."""
from __future__ import annotations
import json
from pathlib import Path
import re
import subprocess
import sys

ROOT=Path(__file__).resolve().parents[1]
errors=[]
manifest=json.loads((ROOT/'docs/exercises.json').read_text())['exercises']
for exercise in manifest:
    folder=ROOT/exercise['path']
    if not (folder/'README.md').is_file():
        errors.append(f"Missing exercise README: {exercise['path']}")
    roots=list(folder.glob('*.tf'))
    if exercise['runnable'] and not roots:
        errors.append(f"Runnable exercise has no Terraform files: {exercise['path']}")
    if not exercise['runnable'] and roots:
        errors.append(f"Reference exercise unexpectedly contains runnable .tf files: {exercise['path']}")
    if exercise['runnable'] and not (folder/'.terraform.lock.hcl').is_file():
        errors.append(f"Missing provider lock file: {exercise['path']}")

proc=subprocess.run(['git','ls-files','-z'],cwd=ROOT,capture_output=True,check=True)
files=[Path(p.decode()) for p in proc.stdout.split(b'\0') if p]
if not files:
    errors.append('No tracked files found; stage the intended repository files before checking.')
secret_patterns=[
    re.compile(r'\b(?:AKIA|ASIA)[A-Z0-9]{16}\b'),
    re.compile(r'-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----'),
    re.compile(r"""(?im)^\s*(?:access_key|secret_key|aws_access_key_id|aws_secret_access_key|aws_session_token)\s*=\s*["'][^"'\r\n]{12,}["']"""),
]
for relative in files:
    path=ROOT/relative
    name=relative.name
    if '.terraform' in relative.parts or name.endswith(('.tfstate','.tfplan','.pem','.key')) or '.tfstate.' in name or name in {'.env','tfplan'} or (name.startswith('.env.') and name != '.env.example'):
        errors.append(f'Generated or sensitive file is tracked: {relative}')
    if name.endswith(('.tfvars','.tfvars.json','.tfbackend')):
        errors.append(f'Local environment configuration is tracked: {relative}')
    text=path.read_text(encoding='utf-8')
    if any(pattern.search(text) for pattern in secret_patterns):
        errors.append(f'Credential-like material found in: {relative}')
    if path.suffix=='.md':
        for match in re.finditer(r'!?\[[^\]]*\]\(([^\s)]+)\)',text):
            target=match.group(1)
            if target.startswith(('https://','http://','mailto:','#')):
                continue
            target=target.split('#',1)[0]
            if target and not (path.parent/target).resolve().exists():
                errors.append(f'Broken local link in {relative}: {target}')
for page in ['index.html','error.html']:
    text=(ROOT/'06-s3-static-website/build'/page).read_text()
    if not text.lower().startswith('<!doctype html>') or re.search(r'(?m)^#\s',text):
        errors.append(f'Unexpected HTML prolog/comment in {page}')
for example in (ROOT/'04-s3-backend/backend-config').glob('*.example'):
    text=example.read_text()
    if 'REPLACE_WITH_EXISTING_STATE_BUCKET' not in text:
        errors.append(f'Backend example lacks its portability placeholder: {example.name}')

if errors:
    for error in errors:
        print('ERROR:',error,file=sys.stderr)
    sys.exit(1)
print(f"Repository checks passed: {len(files)} tracked files; {sum(e['runnable'] for e in manifest)} runnable roots; local links and publication patterns checked.")
