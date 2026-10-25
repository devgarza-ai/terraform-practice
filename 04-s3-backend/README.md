# 04 · S3 Remote State

Use an existing private S3 bucket to store this exercise's state, while Terraform manages a separate demonstration bucket.

## Two buckets, two responsibilities

| Bucket | Purpose |
| --- | --- |
| Existing backend bucket | Stores Terraform state and the lock object |
| `aws_s3_bucket.example_bucket` | The demonstration infrastructure managed by that state |

This root does not create its own backend bucket. Prepare a private, versioned state bucket and appropriate state/lock permissions before initializing the backend.

## Partial configuration

[providers.tf](providers.tf) contains `backend "s3" {}`. Copy the selected template, replace its bucket placeholder, and keep the resulting environment-specific file local:

```bash
cp backend-config/dev.s3.tfbackend.example backend-config/dev.s3.tfbackend
```

[Dev template](backend-config/dev.s3.tfbackend.example) and [prod template](backend-config/prod.s3.tfbackend.example) use separate state keys. `encrypt = true` requests server-side encryption, and `use_lockfile = true` enables native S3 state locking. The bucket's existing security configuration still matters.

Use a separate Terraform data directory for each environment so its cached backend configuration stays distinct:

```bash
TF_DATA_DIR=.terraform/dev terraform init -backend-config=backend-config/dev.s3.tfbackend
TF_DATA_DIR=.terraform/dev terraform plan -out=dev.tfplan
TF_DATA_DIR=.terraform/dev terraform apply dev.tfplan
```

Use `.terraform/prod` and the prod backend file consistently for a separate prod practice environment. Different state keys do not create account or IAM isolation. The template labels are learning environments, not a production-readiness claim.

## Permissions and migration

The identity needs access to the state path and permission to read, write, and delete its `.tflock` object. Native S3 locking replaces the older DynamoDB-locking pattern for this repository; DynamoDB-based backend locking is deprecated.

When adopting an existing state, preserve a secure backup and deliberately review state migration. Reconfiguration is not a substitute for migrating the state you intend to keep. See the [shared workflow](../docs/workflow.md).

## Checks and teardown

For syntax/internal consistency without accessing the backend:

```bash
terraform init -backend=false
terraform validate
```

In an initialized environment, observe the chosen state key in the backend bucket and verify locking with a deliberately controlled exercise before claiming it tested.

Destroy the demonstration bucket using the same environment selection:

```bash
TF_DATA_DIR=.terraform/dev terraform destroy
TF_DATA_DIR=.terraform/dev terraform state list
```

The separately managed backend bucket and retained state versions have their own lifecycle. Their cleanup is not established by destroying this demonstration root.

[HashiCorp S3 backend reference](https://developer.hashicorp.com/terraform/language/backend/s3) · [Evidence scope](../docs/verification.md)
