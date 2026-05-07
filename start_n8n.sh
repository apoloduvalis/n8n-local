#!/bin/bash
set -euo pipefail

cd "$HOME/Documents/n8n-local"
echo "Starting n8n ..."
docker-compose up -d

set -a
source .env
set +a

# Persist token into ngrok's own config
ngrok config add-authtoken "$NGROK_AUTHTOKEN"

# Start using BOTH the system config (auth) and your project config (tunnel definition)
ngrok start n8n \
  --config="$HOME/Library/Application Support/ngrok/ngrok.yml" \
  --config="$HOME/Documents/n8n-local/ngrok.yml"