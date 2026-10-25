# Terraform code for deploying an NGINX EC2 instance
# in a public subnet with security group rules for HTTP 80 and HTTPS 443 traffic.

resource "aws_instance" "web" {
  ami                         = var.ami_id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  # Bootstrap downloads need both the subnet route and outbound rule ready.
  depends_on = [
    aws_route_table_association.public,
    aws_vpc_security_group_egress_rule.all,
  ]

  metadata_options {
    http_tokens = "required"
  }

  user_data = <<-EOF
                #!/bin/bash
                set -euo pipefail
                apt-get update -y
                apt-get install -y nginx
                systemctl enable nginx
                systemctl start nginx
                EOF

  tags = merge(local.common_tags, {
    Name = "06-resources-ec2"
  })
}

resource "aws_security_group" "public_http_traffic" {
  description = "Allow HTTP 80 and HTTPS 443 traffic"
  name        = "public_http_traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "06-resources-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
