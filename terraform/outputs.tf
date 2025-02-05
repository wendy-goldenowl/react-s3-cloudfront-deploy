output "cloudfront_domain" {
  value = aws_cloudfront_distribution.spa_distribution.domain_name
}