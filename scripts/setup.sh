#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p data

docker run -it --rm \
  -v "$PWD/data:/opt/data" \
  nousresearch/hermes-agent:latest setup
