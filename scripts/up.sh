#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p data

export HERMES_UID="${HERMES_UID:-$(id -u)}"
export HERMES_GID="${HERMES_GID:-$(id -g)}"

docker run --rm \
  -e HERMES_UID="$HERMES_UID" \
  -e HERMES_GID="$HERMES_GID" \
  -v "$PWD/data:/opt/data" \
  nousresearch/hermes-agent:latest sh -lc '
    /opt/hermes/.venv/bin/hermes config set model.provider zai
    /opt/hermes/.venv/bin/hermes config set model.default glm-5.1
    /opt/hermes/.venv/bin/hermes config set model.base_url https://api.z.ai/api/coding/paas/v4
    /opt/hermes/.venv/bin/hermes config set agent.reasoning_effort medium
  '

docker compose up -d
docker compose ps
