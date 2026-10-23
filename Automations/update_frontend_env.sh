
#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_DIR/frontend/.env.docker"

PUBLIC_IP="$(terraform -chdir="$PROJECT_DIR/terraform" output -raw master_public_ip)"

if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then
    echo "ERROR: Could not retrieve the Master EC2 public IP."
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    echo "ERROR: Frontend environment file not found: $ENV_FILE"
    exit 1
fi

if grep -q '^VITE_API_PATH=' "$ENV_FILE"; then
    sed -i "s|^VITE_API_PATH=.*|VITE_API_PATH=\"http://${PUBLIC_IP}:8080\"|" "$ENV_FILE"
else
    echo 'VITE_API_PATH="http://'"${PUBLIC_IP}"':8080"' >> "$ENV_FILE"
fi

echo "Frontend API URL updated to http://${PUBLIC_IP}:8080"