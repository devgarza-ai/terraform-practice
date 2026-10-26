# Terraform Practice · AWS Foundations

**Ivan Garza · AWS Certified Cloud Practitioner · [devgarza-ai](https://github.com/devgarza-ai)**

[![Terraform checks](https://github.com/devgarza-ai/terraform-practice/actions/workflows/terraform-checks.yml/badge.svg)](https://github.com/devgarza-ai/terraform-practice/actions/workflows/terraform-checks.yml)

A documented collection of Terraform course exercises covering AWS networking, S3, remote state, EC2 bootstrapping, static website hosting, and data-source lookups. Each runnable exercise is an independent Terraform root with a focused learning objective and its own provider lock file.

[Exercise guide](#exercise-guide) · [Workflow](docs/workflow.md) · [Verification](docs/verification.md) · [Review notes](docs/review-notes.md) · [Attribution](ATTRIBUTION.md)

## Exercise guide

| Exercise | What it demonstrates | Starting point |
| --- | --- | --- |
| **01 · VPC foundations** | VPC, public routing, a second subnet, and resource references | [Open exercise](01-vpc-foundations/README.md) |
| **02 · HCL building blocks** | Common block types and reference syntax; a non-runnable reference | [Open reference](02-hcl-building-blocks/README.md) |
| **03 · First S3 project** | Provider requirements, random suffixes, S3 creation, and outputs | [Open exercise](03-first-s3-project/README.md) |
| **04 · S3 remote state** | Partial configuration, separate state keys, encryption, and native locking | [Open exercise](04-s3-backend/README.md) |
| **05 · EC2 and NGINX** | A public web-server lab, shared tags, security rules, and bootstrapping | [Open exercise](05-ec2-nginx/README.md) |
| **06 · S3 static website** | Bucket policy, website documents, HTML uploads, and change detection | [Open exercise](06-s3-static-website/README.md) |
| **07 · AWS data sources** | Regional AMI discovery, account/Region/AZ context, tagged VPC lookup, and policy JSON generation | [Open exercise](07-data-sources/README.md) |

## How the repository is organized

Each numbered folder has one purpose. Run Terraform from the exercise folder you intend to manage. The top-level directory is a repository index, not a deployable root.

The HCL reference keeps its `.tf.example` extension because its external bucket and child module were placeholders in the supplied exercise. All six runnable roots are checked by the validation workflow.

## Work locally

Use Terraform **1.17.x**, an AWS identity with appropriate permissions, and an isolated learning environment. Credentials belong in a local profile or environment, outside this repository.

Start with a configuration-only check:

```bash
cd 01-vpc-foundations
terraform init -backend=false
terraform fmt -check
terraform validate
```

For a deliberate deployment, follow the selected exercise's README and the [full workflow](docs/workflow.md). Review the plan before applying. Keep the same root, state, and backend when destroying the resources you created.

## Evidence and scope

The uploaded work and course records establish the learning context. The learner confirmed that the S3 website worked and was destroyed; the EC2 exercise checklist also records deployment and destruction. The supplied recording independently shows a successful three-resource network apply and matching console routes.

The repository's maintenance changes are documented separately. Formatting and validation checks establish configuration consistency; they do not establish a new AWS deployment, a successful bootstrap, or verified final account charges. See the [verification ledger](docs/verification.md).

These are course-based practice exercises. The separate [Resilient AWS CloudOps Web Service](https://github.com/devgarza-ai/aws-resilient-cloudops-service) contains the console-built portfolio project and its measured recovery evidence.

## Automation

The [Terraform checks workflow](.github/workflows/terraform-checks.yml) runs repository checks, formatting checks, backend-free initialization, and validation. It uses read-only repository permissions and does not request AWS credentials. The workflow's action versions are pinned to reviewed commits.

## Repository guide

| Path | Purpose |
| --- | --- |
| [docs/workflow.md](docs/workflow.md) | State ownership, initialization, reviewed plans, verification, teardown |
| [docs/learning-map.md](docs/learning-map.md) | Concepts practiced and how the exercises connect |
| [docs/verification.md](docs/verification.md) | Learner-reported results, observed evidence, and automated checks |
| [docs/review-notes.md](docs/review-notes.md) | Changes made while preparing the practice repository |
| [docs/source-map.md](docs/source-map.md) | Mapping from uploaded files to their documented exercise |
| [scripts/check_repository.py](scripts/check_repository.py) | Repository structure, local links, and publication checks |
| [ATTRIBUTION.md](ATTRIBUTION.md) | Course provenance and implementation context |

## Ownership

Ivan Garza typed and adapted the course exercises while learning Terraform. Repository organization, documentation, validation automation, and the maintenance changes described in the review notes were prepared with AI assistance. Demonstrated outcomes are distinguished from planned work and professional employment experience.

[GitHub](https://github.com/devgarza-ai) · [LinkedIn](https://www.linkedin.com/in/ivan-garza-cloud/)
