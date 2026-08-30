#!/bin/bash
set -e

IMAGE="ghcr.io/singhtanya05/reference-platform:${1:-latest}"

echo "Deploying image: $IMAGE"

kubectl set image deployment/reference-platform \
  reference-platform="$IMAGE" \
  -n reference-platform

kubectl rollout status deployment/reference-platform \
  -n reference-platform \
  --timeout=180s

echo ""
echo "===== DEPLOYED IMAGE ====="

kubectl get deployment reference-platform \
  -n reference-platform \
  -o jsonpath='{.spec.template.spec.containers[0].image}'

echo
