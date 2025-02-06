variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
  default     = "spa-bucket-wendy"
}

variable "aws_s3_force_destroy" {
    type        = bool
    description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
    default     = false
}

variable "policies" {
  description = "List of policies S3"
  type        = list(object({
    sid       = string
    effect    = string
    principal = string
    actions   = list(string)
    resource  = string
  }))
}
