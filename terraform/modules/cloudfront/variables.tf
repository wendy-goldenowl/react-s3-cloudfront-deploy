variable "aws_bucket_name" {
    type = string
    description = "The name of the S3 bucket to create"
    default     = "spa-bucket-wendy"
}

variable "aws_s3_bucket_regional_domain_name" {
    type = string
    description = "The regional domain name of the S3 bucket"
}

variable "environment" {
    type = string
    description = "The environment to deploy to"
    default     = "dev"
}

variable "aws_cloudfront_min_ttl" {
    type = number
    description = "The minimum time to live for CloudFront cache"
    default     = 0
}

variable "aws_cloudfront_default_ttl" {
    type = number
    description = "The default time to live for CloudFront cache"
    default     = 3600
}

variable "aws_cloudfront_max_ttl" {
    type = number
    description = "The maximum time to live for CloudFront cache"
    default     = 86400
}

variable "custom_error_responses" {
    type = list(object({
        error_code           = number
        response_code        = number
        response_page_path   = string
    }))
    description = "Custom error responses for the CloudFront distribution"
    default     = []
}