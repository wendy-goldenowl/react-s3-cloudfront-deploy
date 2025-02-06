variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
  default     = "spa-bucket-wendy"
}

variable "aws_cloudfront_oai" {
  type        = string
  description = "The OAI of the CloudFront distribution"
}

variable "aws_s3_force_destroy" {
    type        = bool
    description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
    default     = false
}