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
For Compose-only tests, override the host bindings when those ports are already occupied:

```bash
HERMES_GATEWAY_BIND=127.0.0.1:18642 \
HERMES_DASHBOARD_BIND=127.0.0.1:19119 \
./scripts/up.sh
```

## Kanban Dashboard

Recent Hermes Agent images include a Kanban board in the web dashboard. The board is backed by the Hermes Kanban SQLite database, so CLI, dashboard, and worker-tool changes show up in the same place.

![Hermes Kanban dashboard](/hermes-kanban-dashboard.png)

To view the dashboard from another PC on the same trusted LAN, add these local `.env` entries. Keep the gateway API on localhost and expose only the dashboard:

```dotenv
HERMES_GATEWAY_BIND=127.0.0.1:18642
HERMES_DASHBOARD_BIND=192.168.11.200:19119
```

```bash
docker compose up -d --force-recreate hermes
```

Open `http://192.168.11.200:19119` from the other PC, replacing the IP address with this machine's LAN address. Avoid binding the gateway API to a public interface unless you add real authentication and network controls.

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

- `GLM_API_KEY="..." ./scripts/set-glm-key.sh` for Compose `data/.env` and the kind Secret when kind is available
- `data/.env` and `data/config.yaml` for the Compose runtime created by Hermes setup
- `k8s/hermes-secret.local.yaml` for local Kubernetes overrides

`k8s/hermes-secret.example.yaml` is intentionally placeholder-only.
