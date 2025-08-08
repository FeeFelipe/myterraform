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

module "s3" {
  source      = "./modules/s3"
  for_each    = var.s3_buckets
  bucket_name = each.key
  tags        = merge(var.default_tags, each.value)
}

module "sqs" {
  source     = "./modules/sqs"
  for_each   = var.sqs_queues
  queue_name = each.key
  tags       = merge(var.default_tags, each.value)
}

resource "localmeta_bucket" "example" {
  bucket_name = "${var.bucket_name}-meta"
  tags        = var.default_tags
}
