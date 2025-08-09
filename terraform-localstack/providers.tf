provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

provider "aws" {
  region                      = var.region
  access_key                  = data.vault_generic_secret.myengine_creds.data["access_key"]
  secret_key                  = data.vault_generic_secret.myengine_creds.data["secret_key"]
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    s3  = var.localstack_endpoint
    sqs = var.localstack_endpoint
    iam = var.localstack_endpoint
  }

  default_tags {
    tags = var.default_tags
  }
}

provider "localmeta" {
  output_dir = "./output"
}
