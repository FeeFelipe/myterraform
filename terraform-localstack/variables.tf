variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "my-local-bucket"
}

variable "queue_name" {
  default = "my-local-queue"
}

variable "user_name" {
  default = "local-user"
}

variable "localstack_endpoint" {
  default = "http://localhost:4566"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "local"
    Project     = "localstack-demo"
    ManagedBy   = "Terraform"
  }
}
