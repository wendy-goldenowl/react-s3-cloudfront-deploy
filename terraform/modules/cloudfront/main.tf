resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${terraform.workspace}-${var.aws_bucket_name}"
}

resource "aws_cloudfront_distribution" "spa_distribution" {
  origin {
    domain_name = var.aws_s3_bucket_regional_domain_name
    origin_id   = "S3-${terraform.workspace}-${var.aws_bucket_name}-Origin"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "S3-${terraform.workspace}-${var.aws_bucket_name}-Origin"

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl     = var.aws_cloudfront_min_ttl
    default_ttl = var.aws_cloudfront_default_ttl
    max_ttl     = var.aws_cloudfront_max_ttl
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
    Environment = var.environment
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code           = custom_error_response.value.error_code
      response_code        = custom_error_response.value.response_code
      response_page_path   = custom_error_response.value.response_page_path
    }
  }
}