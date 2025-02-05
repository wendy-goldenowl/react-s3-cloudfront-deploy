terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "spa_bucket" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "spa_bucket_website" {
    bucket = aws_s3_bucket.spa_bucket.bucket
    index_document = "index.html"
    error_document = "index.html"
}

resource "aws_s3_bucket_policy" "spa_bucket_policy" {
    bucket = aws_s3_bucket.spa_bucket.bucket
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "PublicReadGetObject",
                Effect = "Allow",
                Principal = {
                    AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
                },
                Action = "s3:GetObject",
                Resource = "${aws_s3_bucket.spa_bucket.arn}/*"
            }
        ]
    })
}

resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "OAI for ${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "spa_distribution" {
    origin {
        domain_name = aws_s3_bucket.spa_bucket.bucket_regional_domain_name
        origin_id   = "S3-${var.bucket_name}-Origin"
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
}

resource "null_resource" "upload_react" {
    depends_on = [aws_s3_bucket.spa_bucket]

    provisioner "local-exec" {
        command = "aws s3 sync /Users/hoaiphuongdg26/github/testing-react-apps/build s3://${aws_s3_bucket.spa_bucket.bucket} --delete"
    }
}