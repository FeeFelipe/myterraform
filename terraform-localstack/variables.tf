variable "region" {
  type        = string
  description = "AWS (or LocalStack) region."
  default     = "us-east-1"

  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d)$", var.region))
    error_message = "Invalid AWS region format (example: us-east-1)."
  }
}

variable "localstack_endpoint" {
  type        = string
  description = "LocalStack endpoint (only used if LocalStack is enabled)."
  default     = "http://localstack:4566"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags applied to all resources."
  default     = {}
}

variable "sqs_queues" {
  type        = map(map(string))
  description = "Map of SQS queues => additional tags for each queue."
  default     = {}
}

variable "s3_buckets" {
  type        = map(map(string))
  description = "Map of S3 buckets => additional tags for each bucket."
  default     = {}
}

variable "vault_addr" {
  type        = string
  description = "Vault address (with myengine secrets engine enabled)."
  default     = "http://vault:8200"
}

variable "vault_token" {
  type        = string
  description = "Vault token (use environment variables in production)."
  default     = "root"
  sensitive   = true
}

variable "bucket_suffix" {
  type        = string
  description = "Suffix used by myengine for bucket naming."
  default     = "my-bucket"
}
