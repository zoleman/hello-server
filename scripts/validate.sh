#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

REQUIRED_TOOLS=("go" "terraform" "kubectl" "minikube")

echo "==> Checking dependencies"

for TOOL in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$TOOL" >/dev/null 2>&1; then
    echo "ERROR: '$TOOL' is required but not installed or not in PATH."
    exit 1
  fi
done

echo "==> Running Go tests"
cd "$ROOT_DIR"
go test ./...

echo "==> Checking Terraform formatting"
cd "$ROOT_DIR/terraform"
terraform fmt -check -recursive

echo "==> Initializing Terraform"
terraform init -backend=false

echo "==> Validating Terraform"
terraform validate

echo "==> Validating Kubernetes manifests"

if ! minikube status >/dev/null 2>&1; then
  echo "ERROR: Minikube is not running."
  exit 1
fi

kubectl apply \
  --dry-run=server \
  -f "$ROOT_DIR/k8s/"

echo
echo "All validation checks passed."