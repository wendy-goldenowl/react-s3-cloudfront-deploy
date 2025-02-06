variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  default     = "spa-bucket-wendy"
}

variable "custom_error_responses" {
  description = "Custom error responses for the CloudFront distribution"
  default     = []
}