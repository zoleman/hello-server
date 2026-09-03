#!/usr/bin/env bash
set -e

ENVIRONMENTS=("dev" "qa" "prod")

cd "$(dirname "$0")/../terraform"

terraform init

for ENVIRONMENT in "${ENVIRONMENTS[@]}"; do
  if terraform workspace list | grep -qE "^[* ]+${ENVIRONMENT}$"; then
    echo "Workspace '${ENVIRONMENT}' already exists."
  else
    echo "Creating workspace '${ENVIRONMENT}'..."
    terraform workspace new "$ENVIRONMENT"
  fi
done

echo "Workspaces ready:"
terraform workspace list