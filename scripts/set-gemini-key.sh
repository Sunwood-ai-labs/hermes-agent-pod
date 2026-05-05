#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

key="${GEMINI_API_KEY:-${GOOGLE_API_KEY:-}}"
if [ -z "$key" ]; then
  read -r -s -p "Gemini / Google AI Studio API key: " key
  echo
fi

if [ -z "$key" ]; then
  echo "No Gemini API key provided." >&2
  exit 1
fi

kubectl --context kind-sandbox-hermes create namespace sandbox-hermes --dry-run=client -o yaml | kubectl --context kind-sandbox-hermes apply -f -

if kubectl --context kind-sandbox-hermes -n sandbox-hermes get secret hermes-secrets >/dev/null 2>&1; then
  encoded="$(printf '%s' "$key" | base64 | tr -d '\n')"
  kubectl --context kind-sandbox-hermes -n sandbox-hermes patch secret hermes-secrets --type=merge \
    -p "{\"data\":{\"GOOGLE_API_KEY\":\"${encoded}\",\"GEMINI_API_KEY\":\"${encoded}\"}}"
else
  kubectl --context kind-sandbox-hermes -n sandbox-hermes create secret generic hermes-secrets \
    --from-literal=API_SERVER_KEY="${API_SERVER_KEY:-local-hermes-dev-change-me}" \
    --from-literal=GOOGLE_API_KEY="$key" \
    --from-literal=GEMINI_API_KEY="$key"
fi

echo "Gemini API key is configured in sandbox-hermes/hermes-secrets."
