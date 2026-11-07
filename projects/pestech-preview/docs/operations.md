# Operating the Temporary Preview

## Current working copy

The existing infrastructure is managed from the learner's WSL directory `~/terraform/pestech-preview`. Keep its original state/backend in place. This publication currently contains documentation, the uploaded bootstrap, and the deployment helper; the remaining typed Terraform source and provider lock file are pending upload. Do not treat this partial folder as a new deployment root.

## Release update workflow

Once working in the original complete Terraform root, place the approved bundle and its matching helper there. Check the artifact and review the plan before applying:

```bash
sha256sum -c pestech-site.tar.gz.sha256
terraform plan -out=preview-update.tfplan
terraform apply preview-update.tfplan
python3 deploy-site.py --show-command
python3 deploy-site.py
```

The helper selects the applied `https_preview_url` when present, otherwise `preview_url`, and uses it for sharing metadata. A successful S3 upload is followed by the explicit SSM installation step.

If the command is still running, inspect the existing receipt:

```bash
python3 deploy-site.py --check-status
```

Expected proof includes `PESTECH_DEPLOY_OK` and `Deployment verified on EC2.` Check the public HTTPS homepage, owner demo, image asset and a fresh phone link preview. Finish with a plain `terraform plan` to check for pending infrastructure changes.

## Bootstrap and deployment responsibilities

`user-data.sh` installs and configures Nginx and enables SSM Agent. The successful later deployment also establishes that AWS CLI was present on the instance; the uploaded bootstrap does not itself install that CLI. A clean rebuild must include the corresponding CLI preparation before the helper's remote `aws s3 cp` step. Exact rebuild instructions will be reconciled against the complete WSL source rather than inferred from an older plan.

## End of the preview

When the preview is deliberately retired, use the original complete Terraform root and its existing state/backend to review a destroy plan and remove the managed resources. Confirm removal through Terraform and AWS before recording teardown as complete. This project records a deployed preview; teardown has not yet been verified.
