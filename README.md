# Hermes Agent Pod

Nous Research の Hermes Agent を、この sandbox 内の Kubernetes Pod または Docker container で実行するための検証フォルダです。

## What This Builds

- `sandbox-hermes` という kind cluster を作り、`sandbox-hermes` namespace の `hermes-agent` Pod で Hermes gateway を起動します。
- Docker Compose fallback として `sandbox-hermes-agent` container でも起動できます。
- Compose 版の永続データは `data/` に置きます。
- 既定の inference provider は `gemini`、既定モデルは `gemma-4-31b-it`、base URL は Google AI Studio native endpoint です。
- Gateway/API は `http://127.0.0.1:8642` に公開します。
- Dashboard は `http://127.0.0.1:9119` に公開します。

## Files

```text
hermes-agent-pod/
  compose.yaml
  kind-config.yaml
  k8s/
    hermes-pod.yaml
    hermes-secret.example.yaml
  scripts/
    kind-up.sh
    kind-verify.sh
    kind-down.sh
    set-gemini-key.sh
    hermes-worker
    hermes-worker.py
    install-worker-persona.sh
    setup.sh
    up.sh
    down.sh
    verify.sh
  tools/
```

## Quick Commands

```bash
cd hermes-agent-pod

# API key や連携先を対話セットアップする場合
./scripts/setup.sh

# Kubernetes Pod として gateway + dashboard を起動
./scripts/kind-up.sh

# Gemini / Google AI Studio key を Secret に入れる場合
GEMINI_API_KEY="..." ./scripts/set-gemini-key.sh

# Pod 起動確認
./scripts/kind-verify.sh

# kind cluster ごと停止・削除
./scripts/kind-down.sh

# Docker Compose fallback で gateway + dashboard を起動
./scripts/up.sh

# Compose 版の起動確認
./scripts/verify.sh

# Compose 版の停止
./scripts/down.sh
```

Pod 版と Compose 版はどちらも host の `8642/9119` を使うため、同時には起動しないでください。`scripts/kind-up.sh` は必要に応じて Compose 版を止めます。

## Configuration

Docker Compose 版の Hermes 設定や secret は `data/` に作られます。主なファイルは次の通りです。

- `data/.env`: API keys, bot tokens, API server settings
- `data/config.yaml`: model, tools, terminal backend settings
- `data/SOUL.md`: Hermes の人格・ふるまい
- `data/memories/`, `data/skills/`, `data/sessions/`: 実行中に育つデータ

`data/` と `tools/kind` は、この concept folder の `.gitignore` で除外しています。

この検証では dashboard と API server を localhost にだけ公開しています。外部公開する場合は reverse proxy と認証を別途足してください。

## Kubernetes Pod

`scripts/kind-up.sh` は sandbox 専用の kind cluster を作って、Pod/Service を適用します。cluster 内には PVC が作られるため、`scripts/kind-down.sh` で cluster を削除すると Pod 側の状態も消えます。

```bash
cd hermes-agent-pod
./scripts/kind-up.sh
```

`k8s/hermes-secret.example.yaml` は Secret テンプレートです。実運用では API key や bot token を入れた Secret を作ってから使います。

`scripts/kind-up.sh` は既存 Secret を保持するため、再実行しても key を空の example で上書きしません。

## Codex Worker Usage

Codex から部下エージェントとして使う時は、次の wrapper を使います。

```bash
cd hermes-agent-pod

./scripts/hermes-worker "このPodの状態を短く確認して"

./scripts/hermes-worker \
  --file README.md \
  "READMEの運用手順に抜けがないかレビューして"
```

この wrapper は `http://127.0.0.1:8642/v1/chat/completions` を使い、OpenAI-compatible API 経由で Hermes に依頼します。Hermes は Pod 内では tools を使えますが、host のファイルを直接編集できるわけではありません。host file を見せたい時は `--file` で添付してください。

`prompts/hermes-worker-system.md` が部下エージェント用の system prompt です。Pod 起動時には同じ内容が `/opt/data/SOUL.md` に反映されます。

## Public Repo Notes

実 API keys, bot tokens, local runtime data は repository に入れません。

- `data/`, `.env*`, `*.local`, `k8s/hermes-secret.local.yaml` は `.gitignore` で除外しています。
- `k8s/hermes-secret.example.yaml` は空値または placeholder だけを置く example です。
- `compose.yaml` と example secret の `local-hermes-dev-change-me` は localhost 検証用 placeholder です。外部公開や共有環境では必ず別の値に置き換えてください。

## References

- Docker image: `nousresearch/hermes-agent:latest`
- Official docs: https://hermes-agent.nousresearch.com/docs
- Docker guide: https://hermes-agent.nousresearch.com/docs/user-guide/docker
