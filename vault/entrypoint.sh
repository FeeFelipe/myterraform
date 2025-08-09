#!/usr/bin/env sh
set -e

VAULT_DEV_ROOT_TOKEN_ID="${VAULT_DEV_ROOT_TOKEN_ID:-root}"
VAULT_DEV_LISTEN_ADDRESS="${VAULT_DEV_LISTEN_ADDRESS:-0.0.0.0:8200}"
VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_ADDR VAULT_TOKEN="$VAULT_DEV_ROOT_TOKEN_ID"

echo "[entrypoint] starting vault server -dev..."
vault server -dev -dev-root-token-id="$VAULT_DEV_ROOT_TOKEN_ID" -dev-listen-address="$VAULT_DEV_LISTEN_ADDRESS" &
VAULT_PID=$!

echo "[entrypoint] waiting vault health..."
for i in $(seq 1 60); do
  if curl -sf "$VAULT_ADDR/v1/sys/health" | grep -q '"sealed":false'; then
    echo "[entrypoint] vault is ready."
    break
  fi
  sleep 1
done

echo "[entrypoint] running init-plugin.sh..."
/vault/init-plugin.sh

wait $VAULT_PID
