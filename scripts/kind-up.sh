#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if docker compose ps --services --filter status=running | grep -qx hermes; then
  docker compose down
fi

if ! ./tools/kind get clusters | grep -qx sandbox-hermes; then
  ./tools/kind create cluster --name sandbox-hermes --config kind-config.yaml
fi

if ! ./tools/kind load docker-image nousresearch/hermes-agent:latest --name sandbox-hermes; then
  echo "kind image load failed; Kubernetes will pull nousresearch/hermes-agent:latest from the registry." >&2
fi

kubectl --context kind-sandbox-hermes create namespace sandbox-hermes --dry-run=client -o yaml | kubectl --context kind-sandbox-hermes apply -f -

if [ -f k8s/hermes-secret.local.yaml ]; then
  kubectl --context kind-sandbox-hermes apply -f k8s/hermes-secret.local.yaml
elif kubectl --context kind-sandbox-hermes -n sandbox-hermes get secret hermes-secrets >/dev/null 2>&1; then
  echo "Preserving existing sandbox-hermes/hermes-secrets."
else
  kubectl --context kind-sandbox-hermes apply -f k8s/hermes-secret.example.yaml
fi

kubectl --context kind-sandbox-hermes apply -f k8s/hermes-pod.yaml
kubectl --context kind-sandbox-hermes -n sandbox-hermes wait --for=condition=Ready pod/hermes-agent --timeout=240s
kubectl --context kind-sandbox-hermes -n sandbox-hermes get pod,svc -o wide
