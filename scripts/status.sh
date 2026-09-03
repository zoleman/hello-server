#!/usr/bin/env bash
set -e

ENVIRONMENT="${1:-default}"

case "$ENVIRONMENT" in
  default)
    NAMESPACE="hello-server"
    ;;
  dev|qa|prod)
    NAMESPACE="hello-server-${ENVIRONMENT}"
    ;;
  *)
    echo "Usage: $0 [default|dev|qa|prod]"
    exit 1
    ;;
esac

echo "==> Environment: $ENVIRONMENT"
echo "==> Namespace:   $NAMESPACE"
echo

echo "==> Pods"
kubectl get pods -n "$NAMESPACE"

echo
echo "==> Services"
kubectl get services -n "$NAMESPACE"

echo
echo "==> Deployments"
kubectl get deployments -n "$NAMESPACE"

echo
echo "==> HPA"
kubectl get hpa -n "$NAMESPACE"

echo
echo "==> Pod Disruption Budget"
kubectl get pdb -n "$NAMESPACE"

echo
echo "==> Resource Usage"
kubectl top pods -n "$NAMESPACE"