# 03 · First S3 Project

Create a bucket using two providers and expose the resulting bucket name.

## What happens

- The AWS provider manages the bucket in `us-east-1`.
- `random_id.bucket_suffix` generates six random bytes, exposed as twelve hexadecimal characters.
- String interpolation incorporates that value into the bucket name.
- The random resource's result is retained in state; a normal plan does not generate a fresh suffix.
- `bucket_name` returns the created bucket's name.

The suffix reduces naming collisions; bucket creation still determines whether a name is available.

## Files

| File | Responsibility |
| --- | --- |
| [providers.tf](providers.tf) | Terraform and provider requirements; AWS configuration |
| [s3.tf](s3.tf) | Random resource and S3 bucket |
| [outputs.tf](outputs.tf) | Bucket-name output |

The uploaded provider snapshot repeated the resource and output blocks also found in the S3 file. Those definitions appear once in this root. Terraform combines ordinary `.tf` files within the same directory.

## Run and verify

Use the [shared workflow](../docs/workflow.md): initialize, validate, review a saved plan, and apply it. Then inspect:

```bash
terraform output -raw bucket_name
terraform state list
```

Confirm that AWS contains the named bucket. This configuration does not publish a website or grant anonymous object access.

## Teardown

```bash
terraform destroy
terraform state list
```

Keep the bucket empty or remove only the learning objects you intentionally added before attempting destruction. [Evidence scope](../docs/verification.md).
