# Usage

Hermes Agent Pod exposes the Hermes gateway on localhost and includes a small wrapper for Codex-style delegation.

## Gateway and Dashboard

After either runtime is up:

```bash
curl -fsS http://127.0.0.1:8642/health
open http://127.0.0.1:9119
```

Both the Kubernetes and Compose paths bind the same host ports:

- `8642` for the gateway API
- `9119` for the dashboard

Run only one runtime at a time. `scripts/kind-up.sh` stops the Compose service when it is running.

## Delegate to Hermes

Use `scripts/hermes-worker` to send a bounded task through the OpenAI-compatible `/v1/chat/completions` endpoint:

```bash
./scripts/hermes-worker "Summarize the current Hermes Pod status."
```

Attach text files as context:

```bash
./scripts/hermes-worker \
  --file README.md \
  --file k8s/hermes-pod.yaml \
  "Review the runtime instructions for missing operational caveats."
```

The wrapper reads `prompts/hermes-worker-system.md` by default and sends it as the system prompt. Override connection settings with environment variables when needed:

| Variable | Default |
| --- | --- |
| `HERMES_API_BASE_URL` | `http://127.0.0.1:8642/v1` |
| `HERMES_API_KEY` | `local-hermes-dev-change-me` |
| `HERMES_API_MODEL` | `hermes-agent` |
| `HERMES_WORKER_TIMEOUT` | `180` |

## Session Continuity

Continue a Hermes session with:

```bash
./scripts/hermes-worker --show-session "Start a short investigation."
HERMES_SESSION_ID="..." ./scripts/hermes-worker "Continue from the previous result."
```

The returned session ID is printed to stderr when `--show-session` is provided.

## Local Secrets

Do not commit real API keys or bot tokens. Use one of these paths instead:

- `GEMINI_API_KEY="..." ./scripts/set-gemini-key.sh` for the kind Secret
- `data/.env` and `data/config.yaml` for the Compose runtime created by Hermes setup
- `k8s/hermes-secret.local.yaml` for local Kubernetes overrides

`k8s/hermes-secret.example.yaml` is intentionally placeholder-only.
