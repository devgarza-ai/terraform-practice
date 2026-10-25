variable "ami_id" {
  description = "A verified Ubuntu x86_64 AMI in us-east-1; its OS must support the apt-get bootstrap."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^ami-([0-9a-f]{8}|[0-9a-f]{17})$", var.ami_id))
    error_message = "Supply a valid-format AMI ID after verifying its Region, OS, and x86_64 architecture."
  }
}
