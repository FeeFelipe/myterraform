terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    localmeta = {
      source  = "local/localmeta"
      version = "1.0.0"
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

provider "localmeta" {
  output_dir = "./output"
}

resource "localmeta_bucket" "example" {
  bucket_name = "my-bucket"
  tags = {
    team = "infra"
    env  = "dev"
  }
}