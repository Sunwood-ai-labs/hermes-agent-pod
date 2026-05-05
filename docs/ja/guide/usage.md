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
Compose だけを試す場合、既定 port が使用中なら host 側の bind を変更できます。

```bash
HERMES_GATEWAY_BIND=127.0.0.1:18642 \
HERMES_DASHBOARD_BIND=127.0.0.1:19119 \
./scripts/up.sh
```

## Kanban Dashboard

最近の Hermes Agent image には web dashboard の Kanban board が入っています。Board は Hermes Kanban の SQLite database を使うため、CLI、dashboard、worker tool の変更が同じ場所に反映されます。

![Hermes Kanban dashboard](/hermes-kanban-dashboard.png)

同じ trusted LAN 上の別 PC から dashboard を見る場合は、local `.env` に次を追加します。Gateway API は localhost のままにして、dashboard だけを公開します。

```dotenv
HERMES_GATEWAY_BIND=127.0.0.1:18642
HERMES_DASHBOARD_BIND=192.168.11.200:19119
```

```bash
docker compose up -d --force-recreate hermes
```

別 PC から `http://192.168.11.200:19119` を開きます。IP address はこの machine の LAN address に置き換えてください。Gateway API を public interface に bind する場合は、先に実運用向けの認証と network control を追加してください。

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

- Compose `data/.env` と、kind が使える場合の kind Secret には `GLM_API_KEY="..." ./scripts/set-glm-key.sh`
- Compose runtime には Hermes setup が作る `data/.env` と `data/config.yaml`
- Kubernetes local override には `k8s/hermes-secret.local.yaml`

`k8s/hermes-secret.example.yaml` は placeholder-only です。
