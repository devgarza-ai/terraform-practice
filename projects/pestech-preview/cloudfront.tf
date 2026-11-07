# HTTPS entry point for the temporary Pestech preview.
# The browser uses HTTPS to CloudFront; CloudFront uses HTTP to the existing EC2 origin.
resource "aws_cloudfront_distribution" "preview" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Temporary Pestech website preview"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  wait_for_deployment = true

  origin {
    domain_name = aws_instance.preview.public_dns
    origin_id   = "pestech-preview-ec2"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "pestech-preview-ec2"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    # AWS-managed CachingDisabled policy: useful while reviewing site revisions.
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "pestech-preview-https"
  }
}

output "https_preview_url" {
  description = "HTTPS address for the Pestech preview."
  value       = "https://${aws_cloudfront_distribution.preview.domain_name}"
}
