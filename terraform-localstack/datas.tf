data "vault_generic_secret" "myengine_config" {
  path       = "myengine/config"

  depends_on = [vault_generic_endpoint.myengine_config_seed]
}

data "vault_generic_secret" "myengine_creds" {
  path       = "myengine/creds"

  depends_on = [
    vault_mount.myengine,
    vault_generic_endpoint.myengine_config_seed
  ]
}