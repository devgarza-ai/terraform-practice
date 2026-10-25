# 01 · VPC Foundations

Build the networking baseline from the initial infrastructure-as-code exercise.

## Resources

| Component | Configuration |
| --- | --- |
| VPC | `10.0.0.0/16` |
| Public-labeled subnet | `10.0.0.0/24`, associated with a default route to the internet gateway |
| Private-labeled subnet | `10.0.1.0/24`; no NAT or default internet route is configured here |
| Internet gateway | Attached to the VPC |
| Route table and association | `0.0.0.0/0` to the gateway, associated with the public subnet |

The six resources reference their prerequisites. A subnet name alone does not make it public, and this example does not place subnets in explicitly selected Availability Zones.

## Run

Follow the [shared workflow](../docs/workflow.md) from this directory:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Verify

Inspect the VPC, both subnet CIDRs, the attached gateway, and the public route-table association in AWS. The other subnet should have no configured default internet route. No EC2 instance is launched by this exercise.

## Teardown

```bash
terraform destroy
terraform state list
```

Destroy with the same state used for creation. A successful destroy and an empty managed-resource list provide the teardown evidence. [Evidence scope](../docs/verification.md).
