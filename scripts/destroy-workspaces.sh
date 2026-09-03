#!/usr/bin/env bash
set -e

ENVIRONMENTS=("dev" "qa" "prod")

cd "$(dirname "$0")/../terraform"

terraform init
terraform workspace select default

for ENVIRONMENT in "${ENVIRONMENTS[@]}"; do
  echo "Deleting workspace '${ENVIRONMENT}'..."
  terraform workspace delete "$ENVIRONMENT"
done

echo "Remaining workspaces:"
terraform workspace list