![Hermes Agent Pod v0.1.0 release header](https://sunwood-ai-labs.github.io/hermes-agent-pod/release-header-v0.1.0.svg)

[Release notes](https://sunwood-ai-labs.github.io/hermes-agent-pod/guide/releases/v0.1.0) · [Walkthrough](https://sunwood-ai-labs.github.io/hermes-agent-pod/guide/articles/v0-1-0-local-hermes-runtime) · [日本語リリースノート](https://sunwood-ai-labs.github.io/hermes-agent-pod/ja/guide/releases/v0.1.0) · [日本語ウォークスルー](https://sunwood-ai-labs.github.io/hermes-agent-pod/ja/guide/articles/v0-1-0-local-hermes-runtime)

## Summary

`v0.1.0` is the first public release of Hermes Agent Pod. It packages `nousresearch/hermes-agent:latest` as a local runtime kit for Codex worker experiments, with kind and Docker Compose startup paths, localhost gateway and dashboard surfaces, and a small OpenAI-compatible wrapper for bounded delegation.

## Highlights

- Added a `sandbox-hermes` kind runtime and a Docker Compose fallback for running Hermes locally.
- Exposed the gateway at `127.0.0.1:8642` and the dashboard at `127.0.0.1:9119`, including Kanban dashboard documentation and LAN-only dashboard guidance.
- Added `scripts/hermes-worker` for Codex-style delegation through `/v1/chat/completions`, with file attachments, session continuation, JSON output, and connection overrides.
- Aligned the shipped runtime defaults to Z.AI GLM Coding Plan: provider `zai`, model `glm-5.1`, and base URL `https://api.z.ai/api/coding/paas/v4`.
- Added `scripts/set-glm-key.sh` to configure Compose `data/.env` and patch the kind Secret when a cluster is available.
- Published bilingual VitePress docs, GitHub Pages deployment, a release header, and dashboard screenshot assets.

## Operator Notes

- Runtime data and real secrets remain local-only under ignored files such as `data/`, `.env*`, and `k8s/hermes-secret.local.yaml`.
- The gateway is intentionally localhost-first. Add authentication, network controls, and a reverse proxy before exposing it outside the host.
- Run either kind or Compose at one time because both default to the same host ports.

## Validation

- Collected release context for `v0.1.0` with `collect-release-context.ps1`; no previous tag was present, so this is treated as an initial release.
- Validated `docs/public/hermes-agent-pod-icon.svg` and `docs/public/release-header-v0.1.0.svg` with `verify-svg-assets.ps1`.
- Built the VitePress docs with `npm run docs:build`.

Runtime smoke tests that require Docker, kind, and live API keys should still be run in the target operator environment before using the gateway for production-like delegation.
