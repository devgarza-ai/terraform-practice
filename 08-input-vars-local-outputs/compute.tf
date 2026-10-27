data "aws_ami" "ubuntu_east_1" {
  most_recent = true
  owners      = ["099720109477"] # Owner ID for Canonical, the publisher of Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "compute" {
  ami           = data.aws_ami.ubuntu_east_1.id
  instance_type = var.ec2_instance_type

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume_size
    volume_type           = var.ec2_volume_type
  }
}