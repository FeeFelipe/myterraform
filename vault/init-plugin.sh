e!/bin/sh
set -e

: "${VAULT_ADDR:?VAULT_ADDR is required}"
: "${VAULT_TOKEN:?VAULT_TOKEN is required}"
: "${VAULT_PLUGIN_NAME:?VAULT_PLUGIN_NAME is required}"
: "${VAULT_PLUGIN_PATH:?VAULT_PLUGIN_PATH is required}"

VAULT_MOUNT_PATH="${VAULT_MOUNT_PATH:-myengine}"
BUCKET_SUFFIX="${BUCKET_SUFFIX:-mybucket}"
WAIT_MAX_SECS="${WAIT_MAX_SECS:-60}"

vault_status() {
  curl -sf "$VAULT_ADDR/v1/sys/health"
}

vault_get() {
  curl -sf \
    -H "X-Vault-Token: $VAULT_TOKEN" \
    "$VAULT_ADDR/v1/$1"
}

vault_post() {
  curl -sf \
    -H "X-Vault-Token: $VAULT_TOKEN" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$2" \
    "$VAULT_ADDR/v1/$1"
}

echo "Waiting for Vault API at $VAULT_ADDR ..."
t0=$SECONDS
until vault_status | grep -q '"initialized":true'; do
  [ $((SECONDS - t0)) -ge "$WAIT_MAX_SECS" ] && { echo "ERROR: Vault not initialized after ${WAIT_MAX_SECS}s"; exit 1; }
  sleep 2
done
t1=$SECONDS
until vault_status | grep -q '"sealed":false'; do
  [ $((SECONDS - t1)) -ge "$WAIT_MAX_SECS" ] && { echo "ERROR: Vault still sealed after ${WAIT_MAX_SECS}s"; exit 1; }
  sleep 1
done
echo "Vault is ready."

if [ ! -f "$VAULT_PLUGIN_PATH" ]; then
  echo "ERROR: Plugin binary not found at $VAULT_PLUGIN_PATH"; exit 1
fi
chmod +x "$VAULT_PLUGIN_PATH" || true

echo "Calculating plugin SHA256..."
if command -v sha256sum >/dev/null 2>&1; then
  SHA="$(sha256sum "$VAULT_PLUGIN_PATH" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  SHA="$(shasum -a 256 "$VAULT_PLUGIN_PATH" | awk '{print $1}')"
else
  echo "ERROR: sha256sum/shasum not found." >&2
  exit 1
fi
echo "SHA256: $SHA"

if ! vault plugin list -format=json 2>/dev/null | grep -q "\"$VAULT_PLUGIN_NAME\""; then
  echo "Registering plugin: $VAULT_PLUGIN_NAME"
  if vault plugin register -sha256="$SHA" secret "$VAULT_PLUGIN_NAME" 2>/dev/null; then
    :
  else
    vault plugin register -sha256="$SHA" -command="$VAULT_PLUGIN_NAME" secret "$VAULT_PLUGIN_NAME"
  fi
else
  echo "Plugin $VAULT_PLUGIN_NAME already registered. Skipping."
fi

if ! vault secrets list -format=json | grep -q "\"$VAULT_MOUNT_PATH/\""; then
  echo "Enabling plugin secrets engine at path '$VAULT_MOUNT_PATH/'..."
  vault secrets enable -path="$VAULT_MOUNT_PATH" -plugin-name="$VAULT_PLUGIN_NAME" plugin
else
  echo "Secrets engine '$VAULT_MOUNT_PATH/' already enabled. Skipping."
fi

echo "Seeding $VAULT_MOUNT_PATH/config ..."
if vault_post "$VAULT_MOUNT_PATH/config" "{\"bucket_suffix\":\"$BUCKET_SUFFIX\"}" >/dev/null 2>&1; then
  echo "Config written."
else
  echo "WARNING: failed to write $VAULT_MOUNT_PATH/config (check plugin handler)." >&2
fi

echo "Validating READ at $VAULT_MOUNT_PATH/config ..."
if vault_get "$VAULT_MOUNT_PATH/config" >/dev/null 2>&1; then
  echo "Config READ ok."
else
  echo "ERROR: READ $VAULT_MOUNT_PATH/config failed. Terraform data source will fail." >&2
  exit 1
fi

if vault_get "$VAULT_MOUNT_PATH/creds" >/dev/null 2>&1; then
  echo "Creds READ ok at $VAULT_MOUNT_PATH/creds."
else
  echo "NOTE: $VAULT_MOUNT_PATH/creds does not support READ (or not ready). If Terraform reads 'myengine/creds', it will fail." >&2
fi

echo "All set. Plugin '$VAULT_PLUGIN_NAME' enabled at path '$VAULT_MOUNT_PATH/', config seeded with bucket_suffix='$BUCKET_SUFFIX'."
