#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

docker compose ps
echo

if docker compose exec -T hermes /opt/hermes/.venv/bin/hermes version >/tmp/hermes-version.out 2>/tmp/hermes-version.err; then
  cat /tmp/hermes-version.out
else
  cat /tmp/hermes-version.err >&2
  exit 1
fi

echo
if command -v curl >/dev/null 2>&1; then
  curl -fsS http://127.0.0.1:8642/health || true
  echo
  curl -fsS http://127.0.0.1:9119/ | sed -n '1,8p' || true
  echo
fi

echo
docker compose logs --tail=80 hermes
