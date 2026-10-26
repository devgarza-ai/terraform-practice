# AWS Data Sources

Use Terraform data sources to discover an existing AMI and VPC, inspect the active AWS context, and generate an IAM policy document. The exercise combines those reads with two managed resources: an EC2 instance and an S3 bucket.

[Exercise guide](../README.md#exercise-guide) · [Workflow](../docs/workflow.md) · [Verification](../docs/verification.md) · [Review notes](../docs/review-notes.md)

## What the configuration demonstrates

| Data source | Purpose | How the result is used |
| --- | --- | --- |
| `aws_ami.ubuntu_east_1` | Find the newest matching Canonical Ubuntu 22.04 x86_64 HVM image | Its `id` supplies `aws_instance.web.ami` |
| `aws_caller_identity.current` | Inspect the authenticated AWS account and caller | Output the returned object for inspection |
| `aws_region.current` | Inspect the AWS provider's Region | Output the returned object |
| `aws_availability_zones.available` | Discover available AZs for the active account and Region | Output the returned object |
| `aws_vpc.prod_vpc` | Find an existing VPC with `Env = "Prod"` | Output its `id`; it does not configure the instance's placement |
| `aws_iam_policy_document.static_website` | Generate policy JSON from HCL | Output the document; it is not attached to the bucket |

Most of these data sources query AWS. `aws_iam_policy_document` instead builds a JSON document locally from its inputs. A `data` block does not by itself create or import the object it describes. The `resource` blocks in this root do manage AWS objects.

## AMI lookup instead of a hardcoded ID

The provider selects `us-east-1`. AMI IDs are regional, so the lookup searches that Region for a matching image from Canonical rather than reusing an ID copied from another Region. The image-name filter retains the Ubuntu 22.04 family used in the supplied practice file, with explicit architecture and virtualization filters.

`most_recent = true` chooses the newest result within those requirements. It does not mean the newest Ubuntu release, and it does not patch an existing instance. A newly selected AMI can change a later plan; review that plan before applying it. The label `ubuntu_east_1` is an address chosen in the course exercise, not a Region-setting argument.

The instance references the lookup directly:

```hcl
ami = data.aws_ami.ubuntu_east_1.id
```

That reference establishes the dependency. A separate `depends_on` is unnecessary here.

## Files

| File | Responsibility |
| --- | --- |
| [providers.tf](providers.tf) | Terraform 1.17.x, AWS provider 6.4.x, and Region |
| [data.tf](data.tf) | The six data-source declarations |
| [compute.tf](compute.tf) | EC2 instance consuming the discovered AMI |
| [s3.tf](s3.tf) | Separately managed S3 bucket with a generated name |
| [outputs.tf](outputs.tf) | Data-source attributes, objects, and policy JSON |

## Prerequisites and boundaries

The `aws_vpc` lookup must match exactly one existing VPC tagged `Env = "Prod"` in the active account and Region. This root does not create that VPC. A missing or ambiguous match is a lookup failure, not a reason to assume Terraform should create a replacement.

The supplied EC2 example omits `subnet_id`, so deployment depends on an available default VPC and default subnet. Reading `prod_vpc` does not put the instance inside that VPC. The example does not install NGINX, configure application access, or demonstrate a reachable web service. It is a data-source exercise rather than an extension of the public web-server lab.

The S3 bucket's historical resource name is `public_read_bucket`, but this root does not attach a bucket policy or change Block Public Access. The output JSON describes public `s3:GetObject` access scoped to this exercise's bucket objects; printing JSON grants no permissions. No public-access policy resource was added during repository preparation.

Actual deployment requires AWS credentials and permissions for the lookups and managed resources. EC2, its EBS volume, and its public IPv4 address can incur charges. Account/caller outputs should be reviewed before sharing; credentials and Terraform state stay outside version control.

## Configuration-only checks

From this folder:

```bash
terraform init -backend=false -input=false -lockfile=readonly
terraform fmt -check -diff
terraform validate
```

These checks do not contact AWS to prove that the AMI or tagged VPC exists. The repository workflow runs the same configuration checks without AWS credentials.

For a deliberate AWS run, first confirm the prerequisites, then follow the [reviewed plan and verification workflow](../docs/workflow.md). Keep this root's state separate from other exercises. Destroying its managed resources does not delete the VPC that was only read through a data source.

## Completion evidence

The learner supplied `compute(2).tf` and `provider(3).tf` as data-source practice. Repository preparation split the declarations into focused files, retained their addresses and outputs, and documented the changes in the [review notes](../docs/review-notes.md). No apply, running-instance test, policy attachment, or teardown transcript was supplied for this snapshot. Automated validation is recorded separately in the [verification ledger](../docs/verification.md).

## References

- [Terraform data sources](https://developer.hashicorp.com/terraform/language/data-sources)
- [AWS provider: AMI data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
- [AWS provider: VPC data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)
- [AWS provider: IAM policy document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)
- [AWS: AMI selection and regional IDs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html)
