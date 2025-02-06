variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  default     = "spa-bucket-wendy"
}

variable "aws_cloudfront_oai" {
  description = "The OAI of the CloudFront distribution"
}