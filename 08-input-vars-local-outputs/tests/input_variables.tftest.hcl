# Repository-maintenance tests: mocked plans, no AWS credentials or API calls.
mock_provider "aws" {
  override_during = "plan"

  override_data {
    target = data.aws_ami.ubuntu_east_1
    values = {
      id = "ami-0123456789abcdef0"
    }
  }
}

run "default_values" {
  command = plan

  assert {
    condition = (
      aws_instance.compute.instance_type == "t2.micro" &&
      aws_instance.compute.root_block_device[0].volume_size == 10 &&
      aws_instance.compute.root_block_device[0].volume_type == "gp3"
    )
    error_message = "The instance must consume the declared instance and volume defaults."
  }
}

run "override_values" {
  command = plan

  variables {
    ec2_instance_type = "t3.micro"
    ec2_volume_size   = 12
    ec2_volume_type   = "gp2"
  }

  assert {
    condition = (
      aws_instance.compute.instance_type == "t3.micro" &&
      aws_instance.compute.root_block_device[0].volume_size == 12 &&
      aws_instance.compute.root_block_device[0].volume_type == "gp2"
    )
    error_message = "Supplied input values must reach the matching EC2 resource arguments."
  }
}

run "reject_unsupported_instance_type" {
  command = plan

  variables {
    ec2_instance_type = "m5.large"
  }

  expect_failures = [var.ec2_instance_type]
}

run "reject_comma_typo" {
  command = plan

  variables {
    ec2_instance_type = "t2,micro"
  }

  expect_failures = [var.ec2_instance_type]
}
