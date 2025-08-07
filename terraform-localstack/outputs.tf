output "sqs_queue_urls" {
  description = "URLs das filas SQS criadas"
  value = {
    for name, mod in module.sqs :
    name => mod.queue_url
  }
}

output "local_metadata_file" {
  description = "Nome do arquivo de metadados local"
  value       = "${localmeta_bucket.example.bucket_name}.json"
}
