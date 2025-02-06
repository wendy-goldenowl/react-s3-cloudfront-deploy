terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "spa_app_bucket" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "spa_bucket_website" {
    bucket = aws_s3_bucket.spa_app_bucket.bucket
    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "index.html"
    }
}

resource "aws_s3_bucket_policy" "spa_bucket_policy" {
    bucket = aws_s3_bucket.spa_app_bucket.bucket
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "PublicReadGetObject",
                Effect = "Allow",
                Principal = {
                    AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
                },
                Action = [
                    "s3:GetObject"
                ],
                Resource = "${aws_s3_bucket.spa_app_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "OAI for ${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "spa_distribution" {
    origin {
        domain_name = aws_s3_bucket.spa_app_bucket.bucket_regional_domain_name
        origin_id   = "S3-${var.bucket_name}-Origin"
        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
    }

    enabled             = true
    default_root_object = "index.html"

    default_cache_behavior {
        target_origin_id = "S3-${var.bucket_name}-Origin"

        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET", "HEAD", "OPTIONS"]
        cached_methods         = ["GET", "HEAD"]

        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
        min_ttl     = 0
        default_ttl = 3600    # 1 hour
        max_ttl     = 86400   # 24 hours
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

    custom_error_response {
        error_code = 404
        response_code = 200
        response_page_path = "/index.html"
    }
    custom_error_response {
        error_code = 403
        response_code = 200
        response_page_path = "/index.html"
    }
}

resource "null_resource" "upload_react" {
    depends_on = [aws_s3_bucket.spa_app_bucket]

    provisioner "local-exec" {
        command = "aws s3 sync ${path.module}/../build s3://${aws_s3_bucket.spa_app_bucket.bucket} --delete"
    }
}