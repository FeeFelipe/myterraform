region      = "us-east-1"
vault_addr  = "http://vault:8200"
vault_token = "root"

localstack_endpoint = "http://localstack:4566"

default_tags = {
  Environment = "dev"
  Project     = "infra"
}

sqs_queues = {
  queue1 = {}
  queue2 = { team = "payments" }
  queue3 = { feature = "async" }
}

s3_buckets = {
  my-app-bucket = {}
  logs-bucket   = { team = "platform" }
  media-bucket  = { purpose = "cdn" }
}

bucket_suffix = "my-bucket"