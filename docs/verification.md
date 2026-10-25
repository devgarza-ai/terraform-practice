# Verification Ledger

This ledger distinguishes what the supplied material establishes from what repository preparation checks establish.

## Supplied work and learner reports

| Exercise | Evidence available | Boundary |
| --- | --- | --- |
| VPC foundations | Supplied Terraform configuration for six network resources | No separate apply/destroy transcript for this exact root is included |
| HCL building blocks | Supplied syntax example | External-bucket and child-module placeholders remain unresolved; this is a reference |
| First S3 project | Supplied bucket, random-suffix, provider, and output definitions; course deployment reported by the learner | No standalone live bucket verification is attached to this repository |
| S3 backend | Supplied backend files and course completion markers | Migration output and a controlled lock test are not included; native lock options are repository maintenance additions |
| EC2 and NGINX | Supplied source and a completed learner checklist covering deployment and destruction | The supplied recording independently verifies the networking portion, not a successful HTTP response for this maintained snapshot |
| S3 static website | Supplied source and HTML; learner explicitly confirmed the website worked and the resources were destroyed | The maintenance edits were not deployed again during repository preparation |

The network recording shows `Apply complete! Resources: 3 added, 0 changed, 0 destroyed` for the internet gateway, public route table, and subnet association. The console recording shows matching routing and association information. Raw console recordings are not published here because they include account identifiers; a public demonstration requires a separate sanitized edit.

## Configuration checks

[validation-results.json](validation-results.json) records the Terraform validation results for the five runnable roots. Formatting uses Terraform 1.17.0. Provider-schema validation is run on GitHub Actions with backend-free initialization. Provider lock files record selected versions, verified archive checksums, and the canonical Linux package hash. A local provider-installation problem left incomplete files in this preparation environment, so successful local schema validation is not claimed.

The checks cover:

- Terraform syntax, internal consistency, and provider-schema compatibility.
- Standard formatting for each runnable root.
- The presence of exercise READMEs and provider lock files.
- Local documentation links, HTML comment/prolog structure, and patterns associated with accidentally tracked credentials, state, plans, or local configuration.

The non-runnable HCL reference is formatted as HCL but is not counted as a validated deployment root. Pattern checks are a focused publication guard, not a comprehensive security audit.

## Checks performed by GitHub Actions

The [workflow](../.github/workflows/terraform-checks.yml) runs the repository check and each root's formatting, backend-free initialization, and validation on pushes and pull requests. Its current result is visible in the repository's Actions tab.

The workflow uses read-only repository permissions, immutable action references, and no AWS secrets. A green result demonstrates configuration checks, not a new AWS deployment.

## What remains separately verifiable

AMI identity and availability, effective AWS permissions, backend security and locking behavior, application readiness, successful teardown, and final billing require their own runtime evidence. No AWS plan, apply, or destroy is performed by this repository's validation workflow.
