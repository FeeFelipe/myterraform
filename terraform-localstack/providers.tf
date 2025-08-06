provider "aws" {
  region                      = var.region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true

  endpoints {
    s3  = var.localstack_endpoint
    sqs = var.localstack_endpoint
    iam = var.localstack_endpoint
  }

  default_tags {
    tags = var.default_tags
  }

  s3_use_path_style = true
}
