resource "aws_s3_bucket" "spa_app_bucket" {
  bucket = var.bucket_name
  force_destroy = var.aws_s3_force_destroy
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
          AWS = var.aws_cloudfront_oai
        },
        Action = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.spa_app_bucket.arn}/*"
      }
    ]
  })
}
