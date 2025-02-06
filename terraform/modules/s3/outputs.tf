output "aws_s3_bucket_name" {
    value = aws_s3_bucket.spa_app_bucket.bucket
}
output "aws_s3_bucket_domain_name" {
    value = aws_s3_bucket.spa_app_bucket.bucket_domain_name
}