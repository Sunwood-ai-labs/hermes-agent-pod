#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

kubectl --context kind-sandbox-hermes -n sandbox-hermes get pod,svc -o wide
echo
kubectl --context kind-sandbox-hermes -n sandbox-hermes exec hermes-agent -- sh -lc '
printf "provider=%s\n" "$HERMES_INFERENCE_PROVIDER"
printf "model=%s\n" "$HERMES_INFERENCE_MODEL"
printf "glm_base=%s\n" "$GLM_BASE_URL"
for k in GLM_API_KEY ZAI_API_KEY Z_AI_API_KEY; do
  if [ -n "$(printenv "$k")" ]; then
    echo "$k=set"
  else
    echo "$k=missing"
  fi
done
grep -n "^model:" -A6 /opt/data/config.yaml
'
echo
curl -fsS http://127.0.0.1:8642/health
echo
curl -fsS http://127.0.0.1:9119/ | sed -n '1,8p'
echo
kubectl --context kind-sandbox-hermes -n sandbox-hermes logs pod/hermes-agent --tail=80
