terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  aws_cloudfront_oai = module.cloudfront.aws_cloudfront_oai
}

module "cloudfront" {
  source = "./modules/cloudfront"
  aws_bucket_name = module.s3.aws_s3_bucket_name
  aws_s3_bucket_regional_domain_name = module.s3.aws_s3_bucket_domain_name
  environment = var.environment
  custom_error_responses = var.custom_error_responses
}
resource "null_resource" "upload_react" {
    depends_on = [module.s3]

    provisioner "local-exec" {
        command = "aws s3 sync ${path.module}/../build s3://${module.s3.aws_s3_bucket_name} --delete"
    }
}