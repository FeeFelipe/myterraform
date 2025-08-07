variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region (usada com LocalStack)"
}

variable "localstack_endpoint" {
  type        = string
  default     = "http://localstack:4566"
  description = "Endpoint do LocalStack para os serviços AWS simulados"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Tags padrão aplicadas a todos os recursos"
}

variable "sqs_queues" {
  type = map(map(string))
  description = "Mapeia nome da fila => tags adicionais (vazias se não houver)"
}

variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3"
}

variable "user_name" {
  type        = string
  description = "Nome do usuário IAM"
}
