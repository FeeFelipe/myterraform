output "sqs_queue_urls" {
  value = {
    for name, mod in module.sqs :
    name => mod.queue_url
  }
}

output "local_metadata_file" {
  value = "${localmeta_bucket.example.bucket_name}.json"
}

output "s3_bucket_names" {
  value = [for name, mod in module.s3 : mod.bucket_name]
}

output "s3_buckets" {
  value = {
    for name, mod in module.s3 :
    name => mod.bucket_name
  }
}

output "myengine_bucket_suffix" {
  value = data.vault_generic_secret.myengine_config.data["bucket_suffix"]
}

output "myengine_access_key" {
  value     = data.vault_generic_secret.myengine_creds.data["access_key"]
  sensitive = true
}
