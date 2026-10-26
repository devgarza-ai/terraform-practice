# These outputs demonstrate both individual attributes and full data-source objects.
output "iam_policy" {
  description = "Generated study policy JSON; it is not attached to the S3 bucket."
  value       = data.aws_iam_policy_document.static_website.json
}

output "azs" {
  description = "Available-AZ data returned in the configured Region."
  value       = data.aws_availability_zones.available
}

output "prod_vpc_id" {
  description = "ID of the existing VPC selected by its Env=Prod tag."
  value       = data.aws_vpc.prod_vpc.id
}

output "ubuntu_ami_id_east_1" {
  description = "Newest matching Ubuntu 22.04 AMI in the configured Region."
  value       = data.aws_ami.ubuntu_east_1.id
}

output "aws_caller_identity" {
  description = "Account and caller information; review before sharing output."
  value       = data.aws_caller_identity.current
}

output "aws_region" {
  description = "Region information returned by the AWS provider."
  value       = data.aws_region.current
}
