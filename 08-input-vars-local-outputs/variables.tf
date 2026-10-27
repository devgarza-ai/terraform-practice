# variable "aws_region" {
#   type    = string
#   default = "us-east-1"
# }

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The size of managed EC2 instances."

  validation { # Restrict this learning exercise to the two permitted instance types.
    condition     = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
    error_message = "only supports t2.micro and t3.micro"
  }
}

variable "ec2_volume_size" {
  type        = number
  default     = 10
  description = "The size in GB of the root block volume attached to managed EC2 instances."
}

variable "ec2_volume_type" {
  type        = string
  default     = "gp3"
  description = "The volume type between gp2 and gp3."
}