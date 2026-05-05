# 使い方

Hermes Agent Pod は Hermes gateway を localhost に公開し、Codex-style delegation 用の小さな wrapper を提供します。

## Gateway and Dashboard

いずれかの runtime 起動後:

```bash
curl -fsS http://127.0.0.1:8642/health
open http://127.0.0.1:9119
```

Kubernetes と Compose のどちらも同じ host ports を使います。

- `8642`: gateway API
- `9119`: dashboard

同時起動は避けてください。`scripts/kind-up.sh` は Compose service が動いていれば停止します。

## Hermes に委譲する

`scripts/hermes-worker` を使うと、OpenAI-compatible `/v1/chat/completions` endpoint に小さな task を送れます。

```bash
./scripts/hermes-worker "Hermes Pod の状態を短く要約して"
```

Text file を context として添付できます。

```bash
./scripts/hermes-worker \
  --file README.md \
  --file k8s/hermes-pod.yaml \
  "runtime 手順に抜けがないか確認して"
```

Wrapper は既定で `prompts/hermes-worker-system.md` を system prompt として読み込みます。接続先は必要に応じて環境変数で上書きできます。

| Variable | Default |
| --- | --- |
| `HERMES_API_BASE_URL` | `http://127.0.0.1:8642/v1` |
| `HERMES_API_KEY` | `local-hermes-dev-change-me` |
| `HERMES_API_MODEL` | `hermes-agent` |
| `HERMES_WORKER_TIMEOUT` | `180` |

## Session Continuity

Hermes session を継続する場合:

```bash
./scripts/hermes-worker --show-session "短い調査を始めて"
HERMES_SESSION_ID="..." ./scripts/hermes-worker "前回の結果から続けて"
```

`--show-session` を付けると、返された session ID が stderr に出力されます。

## Local Secrets

実 API keys や bot tokens は commit しません。用途に応じて次を使います。

- kind Secret には `GEMINI_API_KEY="..." ./scripts/set-gemini-key.sh`
- Compose runtime には Hermes setup が作る `data/.env` と `data/config.yaml`
- Kubernetes local override には `k8s/hermes-secret.local.yaml`

`k8s/hermes-secret.example.yaml` は placeholder-only です。
