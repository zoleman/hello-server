#!/usr/bin/env bash
set -e

echo "Starting HPA load generator..."

kubectl run load-generator \
  --namespace hello-server \
  --image=busybox:1.36 \
  --restart=Never \
  -- /bin/sh -c \
  "while true; do wget -q -O- http://hello-server > /dev/null; done"

echo "Load generator started."
echo "Monitor with:"
echo "kubectl get hpa -n hello-server -w"