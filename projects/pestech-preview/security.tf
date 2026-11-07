resource "aws_security_group" "web" {
  name        = "pestech-preview-web-sg"
  description = "Web access for Pestech Preview"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "pestech-preview-web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  description       = "Allows visitors to the HTTP Server"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "web" {
  for_each = {
    http  = 80
    https = 443
  }

  security_group_id = aws_security_group.web.id
  description       = "Outbound ${each.key}"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = each.value
  to_port     = each.value
}
