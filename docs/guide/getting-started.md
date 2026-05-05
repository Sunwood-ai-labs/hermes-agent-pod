# Getting Started

Use this guide to bring up Hermes Agent locally and confirm that the gateway and dashboard are reachable.

## Prerequisites

- Docker with Compose support
- `kubectl`
- `curl`
- `kind`, available at `tools/kind`
- A Gemini or Google AI Studio API key when you want live model calls

The repository keeps generated runtime state out of Git. Compose data is written to `data/`, and the kind helper binary is expected at `tools/kind`.

## Clone and Prepare

```bash
git clone https://github.com/Sunwood-ai-labs/hermes-agent-pod.git
cd hermes-agent-pod
```

For interactive Hermes setup through Docker:

```bash
./scripts/setup.sh
```

## Start the kind Pod

```bash
./scripts/kind-up.sh
```

The script creates or reuses the `sandbox-hermes` kind cluster, applies the `sandbox-hermes` namespace, preserves an existing `hermes-secrets` Secret when present, and waits for the `hermes-agent` Pod to become ready.

To configure a Gemini key before or after starting the Pod:

```bash
GEMINI_API_KEY="..." ./scripts/set-gemini-key.sh
```

Then verify the Pod:

```bash
./scripts/kind-verify.sh
```

## Start with Docker Compose

Use Compose when you want the quickest fallback without a Kubernetes Pod:

```bash
./scripts/up.sh
./scripts/verify.sh
```

Stop the Compose service with:

```bash
./scripts/down.sh
```

## Stop the kind Runtime

```bash
./scripts/kind-down.sh
```

This deletes the `sandbox-hermes` kind cluster. Because the Pod data lives in a cluster PVC, deleting the cluster also removes that Pod-side state.
