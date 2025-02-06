variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "dev"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
  default     = "spa-bucket-wendy"
}

variable "custom_error_responses" {
  description = "Custom error responses for the CloudFront distribution"
  default     = []
}

variable "aws_s3_force_destroy"{
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  default     = false
}