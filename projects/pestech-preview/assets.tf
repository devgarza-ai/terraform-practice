resource "aws_s3_bucket" "preview_assets" {
  bucket_prefix = "pestech-preview-assets-"

  tags = {
    Name = "pestech-preview-assets"
  }
}

resource "aws_s3_bucket_public_access_block" "preview_assets" {
  bucket = aws_s3_bucket.preview_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "website_bundle" {
  bucket = aws_s3_bucket.preview_assets.id
  key    = "releases/pestech-site.tar.gz"
  source = "${path.module}/pestech-site.tar.gz"

  source_hash            = filesha256("${path.module}/pestech-site.tar.gz")
  server_side_encryption = "AES256"
  content_type           = "application/gzip"

  depends_on = [aws_s3_bucket_public_access_block.preview_assets]
}

resource "aws_iam_role_policy" "preview_assets" {
  name = "pestech-preview-read-site"
  role = aws_iam_role.preview.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.preview_assets.arn}/${aws_s3_object.website_bundle.key}"
      }
    ]
  })
}

output "assets_bucket" {
  value = aws_s3_bucket.preview_assets.bucket
}

output "website_bundle_key" {
  value = aws_s3_object.website_bundle.key
}

output "website_bundle_sha256" {
  value = filesha256("${path.module}/pestech-site.tar.gz")
}
