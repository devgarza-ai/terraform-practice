# This course example uses default-VPC placement because no subnet is supplied.
# It does not consume data.aws_vpc.prod_vpc.id or configure a web application.
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu_east_1.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "terraform-practice-data-sources"
    Project = "terraform-practice"
  }
}
