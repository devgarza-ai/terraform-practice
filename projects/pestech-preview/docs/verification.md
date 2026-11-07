# Deployment Verification · November 6, 2026

This record separates observed runtime results from planned features. Terminal excerpts below are transcribed from learner-supplied screenshots; account/resource identifiers and private conversations are not republished.

| Check | Observed result | Evidence |
| --- | --- | --- |
| Reviewed update plan | One CloudFront distribution added, one S3 release object updated, no destruction | Learner supplied the saved execution plan |
| Infrastructure apply | `Apply complete! Resources: 1 added, 1 changed, 0 destroyed.` | Learner supplied the apply output |
| Release integrity | Downloaded archive reported `OK` against the approved SHA-256 | SSM deployment terminal output |
| Installation | `PESTECH_DEPLOY_OK` and `Deployment verified on EC2.` | SSM command result, including a subsequent status check |
| Nginx validation | Configuration syntax and test successful | SSM command output; a non-blocking types-hash warning was also present |
| Public HTTPS | Homepage and `/owner/` returned HTTP 200 | Independent HTTPS requests during the deployment session |
| Share image | PNG returned HTTP 200, was 1200 × 630, and matched the approved wordmark bytes | Independent asset fetch and byte comparison |
| Sharing metadata | Homepage and owner demo declared the HTTPS CloudFront image URL | Initial HTML metadata parsed during verification |
| Motion assets | Served JavaScript/CSS matched the approved files; 700 ms entrances and 1.2-second Lenis configuration retained | Independent public fetches and byte comparison |
| Physical phone check | iPhone Messages displayed only the PESTECH wordmark as the link image | Learner supplied the actual phone preview screenshot |
| Final Terraform plan | `No changes. Your infrastructure matches the configuration.` | Learner supplied the final plan screenshot |

## Approved release

```text
90d4644df15786085bb5b23cbba825f51056356b642c9d72e5c63bc02f319f6e  pestech-site.tar.gz
```

The helper is paired to this checksum and rejects a different artifact. The website archive is kept outside the public infrastructure repository.

## Completion boundaries

The final plan indicates no pending Terraform-managed changes at that time. Runtime serving was verified separately. No future availability, full security audit, load test, production launch, live email delivery, owner authentication, shared database, or full business acceptance is claimed. Family feedback was requested after the phone preview check.

The exact typed Terraform source from WSL is still awaiting upload. The included bootstrap file is the learner-uploaded `user-data.sh`, with only trailing whitespace and its final newline normalized for publication; the diagram and helper do not replace the missing Terraform source. No new Terraform validation result is claimed for this incomplete project folder. Existing numbered exercises retain their separate validation history.
