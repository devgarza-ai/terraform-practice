# Input Variables

Customize an EC2 learning configuration through declared inputs rather than editing each resource argument. This snapshot covers input variables, types, defaults, descriptions, and instance-type validation. The supplied course folder is named `08-input-vars-local-outputs`; locals and outputs are later topics and are not implemented in this snapshot.

[Exercise guide](../README.md#exercise-guide) · [Workflow](../docs/workflow.md) · [Verification](../docs/verification.md) · [Review notes](../docs/review-notes.md)

## Configuration

| Input | Type | Default | Consumer / validation |
| --- | --- | --- | --- |
| `ec2_instance_type` | `string` | `t2.micro` | EC2 `instance_type`; custom validation accepts only `t2.micro` or `t3.micro` |
| `ec2_volume_size` | `number` | `10` | Root volume size in GiB |
| `ec2_volume_type` | `string` | `gp3` | Root volume type; description mentions `gp2` and `gp3`, but no custom allowed-value validation is defined |

The EC2 resource uses `var.ec2_instance_type`, `var.ec2_volume_size`, and `var.ec2_volume_type`. The AMI comes from the existing Canonical Ubuntu 22.04 x86_64/HVM lookup in `us-east-1`.

`variables.tf` declares inputs. Variable values may come from defaults, `TF_VAR_` environment variables, variable files, or explicit CLI arguments. A `.tfvars` file assigns values to already declared inputs; it does not declare `variable` blocks. No environment-specific variable file was supplied or added here.

The commented `aws_region` example is retained as a learning note. The active provider still selects `us-east-1` directly, so that commented variable does not control deployment.

## Files

| File | Responsibility |
| --- | --- |
| [providers.tf](providers.tf) | Terraform 1.17.x, the supplied AWS `~> 6.0` constraint, and Region |
| [variables.tf](variables.tf) | The three active input declarations and the instance-type guardrail |
| [compute.tf](compute.tf) | Regional AMI lookup and EC2 resource consuming the variables |
| [tests/input_variables.tftest.hcl](tests/input_variables.tftest.hcl) | Mocked plan tests added during repository preparation |

The provider lock selects AWS 6.4.0, the existing EC2 practice baseline, within the supplied 6.x requirement. This avoids silently selecting a different release on every initialization.

## Validation guardrail

The maintained expression is:

```hcl
condition = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
```

`contains` receives the allowed collection and the candidate value as two separate arguments. The uploaded file used commas inside the instance-type strings and a dot between the list and variable. That uploaded snapshot was corrected for publication. The learner reported successful tests during the session; this correction is recorded separately and does not establish that the same typo was present in those tests.

Only the instance type has a custom allowed-value condition in this snapshot. The volume inputs have declared types; descriptions alone do not enforce the suggested values or all AWS compatibility requirements.

## Checks without AWS deployment

```bash
terraform init -backend=false -input=false -lockfile=readonly
terraform fmt -check -diff -recursive
terraform validate
terraform test -no-color
```

The test file uses a mocked AWS provider and an overridden AMI lookup. All four run blocks use `command = plan`. They check defaults, permitted overrides reaching the resource, rejection of an unsupported instance type, and rejection of the comma typo. These tests do not call AWS or create resources. They are repository-maintenance evidence, separate from the learner's reported session tests.

## Runtime prerequisites and evidence

A deliberate live run requires AWS credentials, permission to describe AMIs and manage EC2, and an available default VPC/default subnet because the supplied instance omits `subnet_id`. This root does not configure a security group, install a web application, or demonstrate a reachable endpoint. Follow the [reviewed workflow](../docs/workflow.md) before any live deployment; retain the correct state for teardown. EC2, EBS, and any allocated public IPv4 address may incur charges.

The learner supplied `compute(3).tf`, `provider(4).tf`, and `variables.tf` and reported that testing went smoothly. No live plan, apply, instance inspection, or teardown transcript was supplied with this batch. Original source hashes and the validation correction are preserved in the [source map](../docs/source-map.md) and [review notes](../docs/review-notes.md).

## References

- [Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform contains function](https://developer.hashicorp.com/terraform/language/functions/contains)
- [Terraform provider mocking](https://developer.hashicorp.com/terraform/language/tests/mocking)
