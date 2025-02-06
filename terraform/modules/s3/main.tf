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
  bucket = var.bucket_name

  for_each = { for idx, policy in var.policies : policy.sid => policy }
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = each.value.sid
        Effect    = each.value.effect
        Principal = { AWS = each.value.principal }
        Action    = each.value.actions
        Resource  = "${each.value.resource}"
      }
    ]
  })
}
