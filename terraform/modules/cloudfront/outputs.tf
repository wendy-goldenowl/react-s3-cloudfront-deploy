output "aws_distribution_id" {
  value = aws_cloudfront_distribution.spa_distribution.id
}

output "aws_cloudfront_domain_name" {
  value = aws_cloudfront_distribution.spa_distribution.domain_name
}

output "aws_cloudfront_oai" {
  value = aws_cloudfront_origin_access_identity.oai.iam_arn
}