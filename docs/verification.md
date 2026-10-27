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
| AWS data sources | Learner supplied AMI/context/AZ/VPC lookups, generated policy JSON, and EC2/S3 resource declarations as course practice | No apply, live-resource, policy-attachment, or teardown transcript was supplied for this snapshot |
| Input variables | Learner supplied three Terraform files and reported smooth input-variable testing | Uploaded validation typo corrected for publication; no live runtime transcript supplied; maintenance tests use a mocked provider |

The network recording shows `Apply complete! Resources: 3 added, 0 changed, 0 destroyed` for the internet gateway, public route table, and subnet association. The console recording shows matching routing and association information. Raw console recordings are not published here because they include account identifiers; a public demonstration requires a separate sanitized edit.

## Configuration checks

[validation-results.json](validation-results.json) records configuration checks and their evidence for seven runnable roots and their exact checked commit. Formatting uses Terraform 1.17.0. Provider lock files record selected versions, verified archive checksums, and the canonical Linux package hash. Schema results come from GitHub Actions; local checks cover formatting and repository publication inputs.

The checks cover:

- Terraform syntax, internal consistency, and provider-schema compatibility.
- Standard formatting for each runnable root.
- The presence of exercise READMEs and provider lock files.
- Local documentation links, HTML comment/prolog structure, and patterns associated with accidentally tracked credentials, state, plans, or local configuration.

The non-runnable HCL reference is formatted as HCL but is not counted as a validated deployment root. Pattern checks are a focused publication guard, not a comprehensive security audit.

## Checks performed by GitHub Actions

The [workflow](../.github/workflows/terraform-checks.yml) runs the repository check and each root's formatting, backend-free initialization, and validation on pushes and pull requests. The initial [Run 1](https://github.com/devgarza-ai/terraform-practice/actions/runs/40229755087) passed all six jobs against [the original published configuration](https://github.com/devgarza-ai/terraform-practice/commit/ee6c5bce7889f9b7e4530238bbf4a9c5d000fbde): the repository check and the first five runnable Terraform roots. The expanded [data-source validation run](https://github.com/devgarza-ai/terraform-practice/actions/runs/40271008627) passed all seven jobs against [the six-root configuration](https://github.com/devgarza-ai/terraform-practice/commit/ede14a1aedf32832b0a0b988da516dc2ac5a8d40), including Exercise 07. The machine-readable ledger preserves the original evidence and records this newer checked commit. Later workflow results are available in the Actions tab.

The workflow uses read-only repository permissions, immutable action references, and no AWS secrets. A green result demonstrates configuration checks, not a new AWS deployment.

## What remains separately verifiable

AMI identity and availability, effective AWS permissions, backend security and locking behavior, application readiness, successful teardown, and final billing require their own runtime evidence. No live AWS plan, apply, or destroy is performed by this repository's validation workflow. Exercise 08 adds four plan-based tests using a mocked AWS provider. The [input-variable validation run](https://github.com/devgarza-ai/terraform-practice/actions/runs/40448139070) passed all eight jobs against [the seven-root snapshot](https://github.com/devgarza-ai/terraform-practice/commit/95e8fac4c06d682b4dddb223f57e83e4837a2b39); all four mocked test runs passed with zero failures. The ledger records that exact checked commit.
