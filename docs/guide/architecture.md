# Architecture

Hermes Agent Pod keeps Codex in charge while a local Hermes runtime handles bounded delegated work.

## Components

| Component | File | Responsibility |
| --- | --- | --- |
| Compose runtime | `compose.yaml` | Runs `nousresearch/hermes-agent:latest` with persistent `data/` mounted at `/opt/data` |
| kind cluster | `kind-config.yaml` | Maps NodePorts back to localhost on `8642` and `9119` |
| Kubernetes Pod | `k8s/hermes-pod.yaml` | Defines ConfigMaps, PVC, Pod, and Service for the Hermes runtime |
| Secret template | `k8s/hermes-secret.example.yaml` | Documents the API key and bot token keys without storing real values |
| Worker persona | `prompts/hermes-worker-system.md` | Defines Hermes as a focused worker delegated by Codex |
| Worker wrapper | `scripts/hermes-worker.py` | Sends chat completion requests and optional file context to Hermes |

## Kubernetes Flow

`scripts/kind-up.sh` performs the local Pod path:

1. Stops the Compose service when it is already running.
2. Creates the `sandbox-hermes` kind cluster if missing.
3. Attempts to load `nousresearch/hermes-agent:latest` into kind.
4. Applies the namespace, Secret, ConfigMaps, PVC, Pod, and Service.
5. Waits for `pod/hermes-agent` to become ready.

The Service exposes NodePorts `30642` and `30119`, and `kind-config.yaml` maps them back to `127.0.0.1:8642` and `127.0.0.1:9119`.

## Compose Flow

`scripts/up.sh` creates `data/` and starts the `hermes` service from `compose.yaml`. The container runs:

```bash
gateway run
```

The Compose service also binds the gateway and dashboard to localhost and stores runtime data under `data/`.

## Delegation Boundary

Hermes can use tools available inside its container or Pod, but it cannot directly edit host files unless Codex provides a deliberate bridge. Use `--file` to pass text context into a worker task and keep host file changes under Codex control.
