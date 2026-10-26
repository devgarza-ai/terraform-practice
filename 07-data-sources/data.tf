# Find the newest matching Ubuntu 22.04 image in the AWS provider's Region.
# The local label does not configure the Region; providers.tf does.
data "aws_ami" "ubuntu_east_1" {
  most_recent = true
  owners      = ["099720109477"] # Canonical, the publisher of Ubuntu AMIs.

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

# Read an existing VPC. This does not create it or place the EC2 instance in it.
data "aws_vpc" "prod_vpc" {
  tags = {
    Env = "Prod"
  }
}

# Generate a policy document for study; no resource attaches it to the bucket.
data "aws_iam_policy_document" "static_website" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.public_read_bucket.arn}/*"]
  }
}
