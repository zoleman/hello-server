#!/usr/bin/env bash
set -e

ENVIRONMENT="${1:-}"

if [[ -z "$ENVIRONMENT" ]]; then
  echo "Usage: $0 <dev|qa|prod>"
  exit 1
fi

case "$ENVIRONMENT" in
  dev|qa|prod) ;;
  *)
    echo "Invalid environment: $ENVIRONMENT"
    exit 1
    ;;
esac

cd "$(dirname "$0")/../terraform"

terraform init
terraform workspace select "$ENVIRONMENT" || terraform workspace new "$ENVIRONMENT"
terraform apply -var-file="environments/${ENVIRONMENT}.tfvars"