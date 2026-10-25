# This file contains the outputs for the S3 static website Terraform configuration.

output "static_website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}
output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.static_website.website_endpoint}"
}
