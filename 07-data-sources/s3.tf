# The name is historical: the generated read policy is not attached to this bucket.
resource "aws_s3_bucket" "public_read_bucket" {
  bucket_prefix = "terraform-practice-data-sources-"

  tags = {
    Name    = "terraform-practice-data-sources"
    Project = "terraform-practice"
  }
}
