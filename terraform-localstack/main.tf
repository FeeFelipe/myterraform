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

  required_version = ">= 1.5"
}

provider "localmeta" {
  output_dir = "./output"
}

module "sqs" {
  source     = "./modules/sqs"
  for_each   = var.sqs_queues
  queue_name = each.key
  tags       = merge(var.default_tags, each.value)
}

resource "localmeta_bucket" "example" {
  bucket_name = var.bucket_name
  tags        = var.default_tags
}
