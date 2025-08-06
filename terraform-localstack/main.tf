terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    localmeta = {
      source  = "local/localmeta"
    }
  }
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  tags        = var.default_tags
}

module "sqs" {
  source     = "./modules/sqs"
  queue_name = var.queue_name
  tags       = var.default_tags
}

module "iam_user" {
  source    = "./modules/iam-user"
  user_name = var.user_name
  tags      = var.default_tags
}

# --------------------------
# Custom Provider: Local Metadata
# --------------------------

provider "localmeta" {}

resource "localmeta_bucket" "metadata" {
  bucket_name = module.s3.bucket_name
  tags        = var.default_tags
}
