terraform {
  required_version = "= 1.9.5"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.3"
    }
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