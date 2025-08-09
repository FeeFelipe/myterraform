resource "localmeta_bucket" "example" {
  bucket_name = "${data.vault_generic_secret.myengine_config.data["bucket_suffix"]}-meta"
  tags        = var.default_tags

  depends_on = [
    vault_generic_endpoint.myengine_config_seed
  ]
}

resource "vault_mount" "myengine" {
  path        = "myengine"
  type        = "myengine"
  description = "My custom secrets engine"
}

resource "vault_generic_endpoint" "myengine_config_seed" {
  path                   = "myengine/config"
  ignore_absent_fields   = true
  disable_read           = true
  disable_delete         = false

  data_json = jsonencode({
    bucket_suffix = var.bucket_suffix
  })

  depends_on = [vault_mount.myengine]
}