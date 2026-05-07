#!/bin/bash
set -euo pipefail

cd /Users/apoloduvalis/Documents/n8n-local
echo "Starting n8n ..."
docker-compose up -d

set -a
source .env
set +a

# Persist token into ngrok's own config
ngrok config add-authtoken "$NGROK_AUTHTOKEN"

# Start using BOTH the system config (auth) and your project config (tunnel definition)
ngrok start n8n \
  --config="/Users/apoloduvalis/Library/Application Support/ngrok/ngrok.yml" \
  --config="/Users/apoloduvalis/Documents/n8n-local/ngrok.yml"