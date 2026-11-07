data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "preview" {
  ami           = nonsensitive(data.aws_ssm_parameter.al2023.value)
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = aws_iam_instance_profile.preview.name

  user_data                   = file("${path.module}/user-data.sh")
  user_data_replace_on_change = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "Prestech preview server"
  }

  depends_on = [
    aws_route_table_association.public,
    aws_vpc_security_group_egress_rule.web,
    aws_iam_role_policy_attachment.ssm
  ]

}

output "instance_id" {
  value = aws_instance.preview.id
}

output "preview_url" {
  value = "http://${aws_instance.preview.public_ip}"
}
