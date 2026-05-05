# トラブルシュート

ローカル Hermes runtime がきれいに起動しない時の確認項目です。

## Port Already in Use

どちらの runtime も `127.0.0.1:8642` と `127.0.0.1:9119` を使います。

Compose runtime を止めます。

```bash
./scripts/down.sh
```

または kind cluster を削除します。

```bash
./scripts/kind-down.sh
```

## Missing Gemini Key

`scripts/kind-verify.sh` は Pod 内の `GOOGLE_API_KEY` と `GEMINI_API_KEY` の有無を表示します。

両方の Secret key を設定します。

```bash
GEMINI_API_KEY="..." ./scripts/set-gemini-key.sh
```

Pod 起動後に Secret を更新した場合は、Pod を再作成します。

```bash
kubectl --context kind-sandbox-hermes -n sandbox-hermes delete pod hermes-agent
./scripts/kind-up.sh
```

## kind Image Load Fails

`scripts/kind-up.sh` は `nousresearch/hermes-agent:latest` を cluster に load しようとします。失敗した場合も script は続行し、Kubernetes が registry から image を pull します。

Pod events を確認します。

```bash
kubectl --context kind-sandbox-hermes -n sandbox-hermes describe pod hermes-agent
```

## Dashboard Is Blank or Unreachable

Pod または Compose service が動いているか確認します。

```bash
./scripts/kind-verify.sh
```

または:

```bash
./scripts/verify.sh
```

Dashboard endpoint を確認します。

```bash
curl -fsS http://127.0.0.1:9119/ | sed -n '1,8p'
```

## Worker Wrapper Cannot Connect

Gateway health endpoint を確認します。

```bash
curl -fsS http://127.0.0.1:8642/health
```

Runtime 側の API key を変更した場合は、wrapper にも同じ値を渡します。

```bash
HERMES_API_KEY="..." ./scripts/hermes-worker "Hermes から hello と返して"
```

## Pages Deployment Fails

Docs workflow は `docs/` から VitePress を build し、`docs/.vitepress/dist` を deploy します。VitePress `base` は repo name に合わせて `/hermes-agent-pod/` にしています。Repo を rename した場合は次を更新してください。

- `docs/.vitepress/config.ts`
- README の docs links
- GitHub repository homepage
