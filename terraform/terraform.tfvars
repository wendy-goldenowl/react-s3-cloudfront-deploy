aws_region = "us-east-1"
environment = "dev"
bucket_name = "spa-bucket-wendy"
aws_s3_force_destroy = true
custom_error_responses = [
  {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  },
  {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
]