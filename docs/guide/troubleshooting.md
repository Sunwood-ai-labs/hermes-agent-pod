# Troubleshooting

Use these checks when the local Hermes runtime does not come up cleanly.

## Port Already in Use

Both runtimes bind `127.0.0.1:8642` and `127.0.0.1:9119`.

Stop the Compose runtime:

```bash
./scripts/down.sh
```

Or delete the kind cluster:

```bash
./scripts/kind-down.sh
```

## Missing GLM Key

`scripts/kind-verify.sh` prints whether `GLM_API_KEY`, `ZAI_API_KEY`, or `Z_AI_API_KEY` are present inside the Pod.

Set the GLM Coding Plan key with:

```bash
GLM_API_KEY="..." ./scripts/set-glm-key.sh
```

If the Pod is already running, restart it after updating the Secret:

```bash
kubectl --context kind-sandbox-hermes -n sandbox-hermes delete pod hermes-agent
./scripts/kind-up.sh
```

## kind Image Load Fails

`scripts/kind-up.sh` attempts to load `nousresearch/hermes-agent:latest` into the cluster. If that load fails, the script continues and Kubernetes pulls the image from the registry.

Check Pod events with:

```bash
kubectl --context kind-sandbox-hermes -n sandbox-hermes describe pod hermes-agent
```

## Dashboard Is Blank or Unreachable

Confirm the Pod or Compose service is running:

```bash
./scripts/kind-verify.sh
```

or:

```bash
./scripts/verify.sh
```

Then check the dashboard endpoint:

```bash
curl -fsS http://127.0.0.1:9119/ | sed -n '1,8p'
```

## Worker Wrapper Cannot Connect

Confirm the gateway health endpoint:

```bash
curl -fsS http://127.0.0.1:8642/health
```

If the API key was changed in the runtime, pass the same value to the wrapper:

```bash
HERMES_API_KEY="..." ./scripts/hermes-worker "Say hello from Hermes."
```

## Pages Deployment Fails

The docs workflow builds VitePress from `docs/` and deploys `docs/.vitepress/dist`. The VitePress `base` is set to `/hermes-agent-pod/`, which matches the repository name. If the repository is renamed, update:

- `docs/.vitepress/config.ts`
- README documentation links
- GitHub repository homepage
