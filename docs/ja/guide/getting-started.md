# はじめに

Hermes Agent をローカルで起動し、gateway と dashboard に到達できることを確認します。

## 前提

- Docker と Compose support
- `kubectl`
- `curl`
- `tools/kind` に配置された `kind`
- 実際に model call する場合は Z.AI GLM Coding Plan API key

生成される runtime state は Git に入れません。Compose の data は `data/` に作られ、kind helper binary は `tools/kind` を使います。

## Clone and Prepare

```bash
git clone https://github.com/Sunwood-ai-labs/hermes-agent-pod.git
cd hermes-agent-pod
```

Docker 経由で Hermes の対話 setup を行う場合:

```bash
./scripts/setup.sh
```

## kind Pod を起動

```bash
./scripts/kind-up.sh
```

この script は `sandbox-hermes` kind cluster を作成または再利用し、`sandbox-hermes` namespace を適用します。既存の `hermes-secrets` Secret があれば保持し、`hermes-agent` Pod が Ready になるまで待ちます。

GLM Coding Plan key を設定する場合:

```bash
GLM_API_KEY="..." ./scripts/set-glm-key.sh
```

Pod を確認します:

```bash
./scripts/kind-verify.sh
```

## Docker Compose で起動

Kubernetes Pod が不要な場合は Compose fallback を使います。

```bash
./scripts/up.sh
./scripts/verify.sh
```

Compose service の停止:

```bash
./scripts/down.sh
```

## kind Runtime を止める

```bash
./scripts/kind-down.sh
```

`sandbox-hermes` kind cluster を削除します。Pod 側の data は cluster PVC にあるため、cluster を削除すると Pod 側の状態も消えます。
