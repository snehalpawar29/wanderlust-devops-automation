
#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_DIR/backend/.env.docker"

PUBLIC_IP="$(terraform -chdir="$PROJECT_DIR/terraform" output -raw master_public_ip)"

if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then
    echo "ERROR: Could not retrieve the Master EC2 public IP."
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    echo "ERROR: Backend environment file not found: $ENV_FILE"
    exit 1
fi

if grep -q '^FRONTEND_URL=' "$ENV_FILE"; then
    sed -i "s|^FRONTEND_URL=.*|FRONTEND_URL=http://${PUBLIC_IP}:5173|" "$ENV_FILE"
else
    echo "FRONTEND_URL=http://${PUBLIC_IP}:5173" >> "$ENV_FILE"
fi

echo "Backend frontend URL updated to http://${PUBLIC_IP}:5173"