variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-est-1"
}

variable "aws_profie" {
  description = "The AWS profile to use"
  default     = "default"
}

variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  default     = "spa_bucket"
}