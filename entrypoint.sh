#!/bin/sh

set -e

cleanup() {
  echo "Cleaning up .terraform/ and terraform.lock.hcl..."
  rm -rf .terraform terraform.lock.hcl || true
}

trap cleanup INT TERM EXIT

if [ "$#" -eq 0 ]; then
  echo "Container started. Use 'docker exec -it terraform sh' to enter."
  tail -f /dev/null
else
  echo "Running: $@"
  exec "$@"
fi
