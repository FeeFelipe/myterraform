variable "region" {
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  type        = string
  default     = "http://localstack:4566"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
}

variable "sqs_queues" {
  type = map(map(string))
}

variable "bucket_name" {
  type        = string
}

variable "user_name" {
  type        = string
}

variable "s3_buckets" {
  type = map(map(string))
}

