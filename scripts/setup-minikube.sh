#!/usr/bin/env bash
set -e

echo "==> Checking dependencies"

for TOOL in minikube kubectl docker; do
  if ! command -v "$TOOL" >/dev/null 2>&1; then
    echo "ERROR: '$TOOL' is required but not installed or not in PATH."
    exit 1
  fi
done

echo "==> Checking Minikube status"

if minikube status >/dev/null 2>&1; then
  echo "Minikube is already running."
else
  echo "Minikube is not running. Starting..."
  minikube start \
    --driver=docker \
    --memory=4096
fi

echo "==> Checking Metrics Server"

if minikube addons list | grep -E 'metrics-server.*enabled' >/dev/null 2>&1; then
  echo "Metrics Server is already enabled."
else
  echo "Enabling Metrics Server..."
  minikube addons enable metrics-server
fi

echo "==> Checking Kubernetes node"

kubectl wait \
  --for=condition=Ready \
  nodes \
  --all \
  --timeout=120s

echo
echo "Minikube is ready."
kubectl get nodes