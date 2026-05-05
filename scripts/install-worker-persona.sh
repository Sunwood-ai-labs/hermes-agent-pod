#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

kubectl --context kind-sandbox-hermes -n sandbox-hermes exec -i hermes-agent -- sh -lc 'cat > /opt/data/SOUL.md' < prompts/hermes-worker-system.md
kubectl --context kind-sandbox-hermes -n sandbox-hermes exec hermes-agent -- sh -lc 'grep -n "^You are Hermes" /opt/data/SOUL.md'
