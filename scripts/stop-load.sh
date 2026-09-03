#!/usr/bin/env bash
set -e

echo "Stopping HPA load generator..."

kubectl delete pod load-generator \
  --namespace hello-server \
  --ignore-not-found=true

echo "Load generator stopped."
echo "Monitor scale-down with:"
echo "kubectl get hpa -n hello-server -w"