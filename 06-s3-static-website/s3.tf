# S3 configuration for a static website. Index and error pages are stored in the build/ directory.
# This S3 bucket is configured to allow public read access to the objects in the bucket, and the website endpoint is outputted for easy access.

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "static_website" {
  bucket = "terraform-project-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "disable_access_block" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_public_read" {
  depends_on = [aws_s3_bucket_public_access_block.disable_access_block]

  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "${path.module}/build/index.html"
  etag         = filemd5("${path.module}/build/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "error.html"
  source       = "${path.module}/build/error.html"
  etag         = filemd5("${path.module}/build/error.html")
  content_type = "text/html"
}
