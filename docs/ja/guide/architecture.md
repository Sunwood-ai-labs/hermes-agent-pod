# 構成

Hermes Agent Pod は、Codex が主担当として残り、ローカル Hermes runtime が小さく区切った委譲作業を受ける形にしています。

## Components

| Component | File | Responsibility |
| --- | --- | --- |
| Compose runtime | `compose.yaml` | `nousresearch/hermes-agent:latest` を起動し、永続 data を `data/` から `/opt/data` に mount |
| kind cluster | `kind-config.yaml` | NodePorts を localhost の `8642` と `9119` に map |
| Kubernetes Pod | `k8s/hermes-pod.yaml` | Hermes runtime の ConfigMaps, PVC, Pod, Service を定義 |
| Secret template | `k8s/hermes-secret.example.yaml` | 実値を入れずに API key と bot token の key 名だけを示す |
| Worker persona | `prompts/hermes-worker-system.md` | Hermes を Codex から委譲される focused worker として定義 |
| Worker wrapper | `scripts/hermes-worker.py` | chat completion request と optional file context を Hermes に送る |

## Kubernetes Flow

`scripts/kind-up.sh` は Pod path を次の順で実行します。

1. Compose service が動いていれば停止します。
2. `sandbox-hermes` kind cluster がなければ作成します。
3. `nousresearch/hermes-agent:latest` の kind load を試みます。
4. namespace, Secret, ConfigMaps, PVC, Pod, Service を適用します。
5. `pod/hermes-agent` が Ready になるまで待ちます。

Service は NodePorts `30642` と `30119` を公開し、`kind-config.yaml` が `127.0.0.1:8642` と `127.0.0.1:9119` に戻します。

## Compose Flow

`scripts/up.sh` は `data/` を作成し、`compose.yaml` の `hermes` service を起動します。Container は次の command で動きます。

```bash
gateway run
```

Compose service も gateway と dashboard を localhost に bind し、runtime data を `data/` に保存します。

## Delegation Boundary

Hermes は container または Pod 内で利用可能な tools を使えますが、Codex が明示的な bridge を渡さない限り host file を直接編集するわけではありません。Host 側の file change は Codex が管理し、Hermes には `--file` で必要な text context だけを渡します。
