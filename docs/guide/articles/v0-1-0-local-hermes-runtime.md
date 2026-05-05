# Building A Local Hermes Worker Surface In v0.1.0

![Hermes Agent Pod v0.1.0 release header](/release-header-v0.1.0.svg)

Hermes Agent Pod v0.1.0 packages the first usable version of the local worker surface: a Hermes runtime on localhost, a dashboard for inspection, and a small wrapper that lets Codex delegate bounded tasks without handing over host-side control.

## The Shape Of The Release

The release is intentionally small and operational. It provides two ways to boot Hermes: a kind Pod for Kubernetes-shaped experiments, and Docker Compose for a fast fallback. Both expose the same two surfaces, the gateway on `127.0.0.1:8642` and the dashboard on `127.0.0.1:9119`.

That shared shape keeps the operator workflow simple. Start one runtime, verify the health endpoint and dashboard, then call `scripts/hermes-worker` when Codex needs a second opinion or a bounded draft.

## Why The Wrapper Matters

The wrapper in `scripts/hermes-worker.py` is deliberately plain. It sends a standard chat-completions request, adds the worker system prompt, and can attach text files as explicit context. This keeps delegation visible: Codex chooses the files, Hermes reads the bounded context, and the final host-side edit still belongs to Codex.

That separation is the core of the release. Hermes can help think, review, or draft, but it does not silently become the owner of the workspace.

## Runtime Defaults

v0.1.0 aligns the shipped runtime around Z.AI GLM Coding Plan defaults. Compose, kind, and helper scripts all point at provider `zai`, model `glm-5.1`, and `https://api.z.ai/api/coding/paas/v4`. The release also adds `scripts/set-glm-key.sh` so operators can put the key in the right local places without committing it.

The Secret template remains placeholder-only, and ignored local files hold real keys and runtime state.

## Docs And Dashboard

The VitePress docs are part of the release, not an afterthought. They document setup, usage, architecture, troubleshooting, and the dashboard workflow in English and Japanese. The dashboard screenshot in `docs/public/hermes-kanban-dashboard.png` gives readers a concrete target for what the runtime should expose after startup.

## Recommended First Run

1. Clone the repository and run `./scripts/setup.sh` if you want Hermes to create Compose config under `data/`.
2. Start either `./scripts/kind-up.sh` or `./scripts/up.sh`.
3. Verify with `./scripts/kind-verify.sh` or `./scripts/verify.sh`.
4. Delegate a small check with `./scripts/hermes-worker "Summarize the current Hermes Pod status."`.

Read the canonical [v0.1.0 release notes](/guide/releases/v0.1.0) for the full release summary.
