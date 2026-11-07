# Operating the Temporary Preview

## Current working copy

The existing infrastructure is managed from the learner's WSL directory `~/terraform/pestech-preview`. Keep its original state/backend in place when operating that deployment. This publication includes the uploaded Terraform root and original provider lock file. A fresh clone has no state for the existing resources and must not be applied as if it owned that deployment.

Use Terraform 1.17.1 and the supplied AWS provider 6.72.0 lock. Obtain the approved website archive separately before planning a deployment; `assets.tf` evaluates its SHA-256. CI's empty validation fixture is not a deployable website archive.

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

`user-data.sh` installs and configures Nginx and enables SSM Agent. The successful later deployment also establishes that AWS CLI was present on the instance; the uploaded bootstrap does not itself install that CLI. The helper checks for `aws` and `python3` before downloading the bundle. Verify these prerequisites on a newly built instance and install AWS CLI through its official method if it is absent. The uploaded bootstrap is preserved rather than silently extended during portfolio publication.

## End of the preview

When the preview is deliberately retired, use the original complete Terraform root and its existing state/backend to review a destroy plan and remove the managed resources. Confirm removal through Terraform and AWS before recording teardown as complete. This project records a deployed preview; teardown has not yet been verified.
