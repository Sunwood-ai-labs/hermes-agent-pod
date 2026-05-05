#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

key="${GLM_API_KEY:-${ZAI_API_KEY:-${Z_AI_API_KEY:-}}}"
base_url="${GLM_BASE_URL:-https://api.z.ai/api/coding/paas/v4}"

if [ -z "$key" ]; then
  read -r -s -p "Z.AI / GLM Coding Plan API key: " key
  echo
fi

if [ -z "$key" ]; then
  echo "No Z.AI / GLM API key provided." >&2
  exit 1
fi

mkdir -p data
touch data/.env
tmp="$(mktemp)"
grep -vE '^(GLM_API_KEY|ZAI_API_KEY|Z_AI_API_KEY|GLM_BASE_URL)=' data/.env > "$tmp" || true
{
  cat "$tmp"
  printf 'GLM_API_KEY=%s\n' "$key"
  printf 'ZAI_API_KEY=%s\n' "$key"
  printf 'Z_AI_API_KEY=%s\n' "$key"
  printf 'GLM_BASE_URL=%s\n' "$base_url"
} > data/.env
rm -f "$tmp"
chmod 600 data/.env

echo "GLM Coding Plan key is configured in data/.env for the Compose runtime."

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is not available; skipped the kind Secret."
  exit 0
fi

if ! kubectl --context kind-sandbox-hermes cluster-info >/dev/null 2>&1; then
  echo "kind-sandbox-hermes is not reachable; skipped the kind Secret."
  exit 0
fi

kubectl --context kind-sandbox-hermes create namespace sandbox-hermes --dry-run=client -o yaml | kubectl --context kind-sandbox-hermes apply -f -

if kubectl --context kind-sandbox-hermes -n sandbox-hermes get secret hermes-secrets >/dev/null 2>&1; then
  encoded_key="$(printf '%s' "$key" | base64 | tr -d '\n')"
  encoded_base_url="$(printf '%s' "$base_url" | base64 | tr -d '\n')"
  kubectl --context kind-sandbox-hermes -n sandbox-hermes patch secret hermes-secrets --type=merge \
    -p "{\"data\":{\"GLM_API_KEY\":\"${encoded_key}\",\"ZAI_API_KEY\":\"${encoded_key}\",\"Z_AI_API_KEY\":\"${encoded_key}\",\"GLM_BASE_URL\":\"${encoded_base_url}\"}}"
else
  kubectl --context kind-sandbox-hermes -n sandbox-hermes create secret generic hermes-secrets \
    --from-literal=API_SERVER_KEY="${API_SERVER_KEY:-local-hermes-dev-change-me}" \
    --from-literal=GLM_API_KEY="$key" \
    --from-literal=ZAI_API_KEY="$key" \
    --from-literal=Z_AI_API_KEY="$key" \
    --from-literal=GLM_BASE_URL="$base_url"
fi

echo "GLM Coding Plan key is configured in sandbox-hermes/hermes-secrets."
