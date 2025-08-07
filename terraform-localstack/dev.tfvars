sqs_queues = {
  queue1 = {}
  queue2 = {
    team = "payments"
  }
  queue3 = {
    feature = "async"
  }
}

default_tags = {
  Environment = "dev"
  Project     = "infra"
}

bucket_name = "my-bucket"
user_name   = "dev-user"
