output "bucket_name" {
  value = module.s3.bucket_name
}

output "queue_url" {
  value = module.sqs.queue_url
}

output "user_name" {
  value = module.iam_user.user_name
}

output "local_metadata_file" {
  value = "${module.s3.bucket_name}.json"
}
