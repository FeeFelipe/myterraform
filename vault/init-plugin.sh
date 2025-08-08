#!/bin/sh
set -e

echo "Waiting for Vault to be ready..."
until curl -s "$VAULT_ADDR/v1/sys/health" | grep '"initialized":true'; do
  sleep 2
done

echo "Vault is ready. Registering plugin..."

SHA=$(sha256sum "$VAULT_PLUGIN_PATH" | cut -d' ' -f1)

vault plugin register \
  -sha256="$SHA" \
  -command="$VAULT_PLUGIN_NAME"

vault secrets enable \
  -path=myengine \
  -plugin-name="$VAULT_PLUGIN_NAME" \
  plugin

echo "Plugin registered and enabled at path 'myengine/'"
