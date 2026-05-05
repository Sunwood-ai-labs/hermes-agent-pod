# v0.1.0 でローカル Hermes worker surface を作る

![Hermes Agent Pod v0.1.0 release header](/release-header-v0.1.0.svg)

Hermes Agent Pod v0.1.0 は、ローカル worker surface の最初に使える形をまとめた release です。localhost 上の Hermes runtime、状態を見る dashboard、そして Codex が host 側の control を持ったまま小さな task を委譲する wrapper を同梱しています。

## Release の形

この release は小さく、運用しやすい構成に寄せています。Hermes の起動経路は 2 つです。Kubernetes らしい検証には kind Pod、素早い fallback には Docker Compose を使います。どちらも gateway を `127.0.0.1:8642`、dashboard を `127.0.0.1:9119` に出します。

この形にそろえることで、operator の手順が単純になります。runtime を 1 つ起動し、health endpoint と dashboard を確認し、Codex が別視点や bounded draft を必要としたときだけ `scripts/hermes-worker` を呼びます。

## Wrapper が大事な理由

`scripts/hermes-worker.py` はあえて素朴な wrapper です。標準的な chat-completions request を送り、worker system prompt を付け、必要な text file だけを context として添付します。つまり、Codex が file を選び、Hermes は限定 context を読み、最終的な host 側 edit は Codex が持ちます。

この分離が release の中心です。Hermes は考える、レビューする、草稿を書くといった支援をしますが、workspace の owner にはなりません。

## Runtime Defaults

v0.1.0 では shipped runtime を Z.AI GLM Coding Plan の既定値にそろえました。Compose、kind、helper scripts は provider `zai`、model `glm-5.1`、`https://api.z.ai/api/coding/paas/v4` を使います。`scripts/set-glm-key.sh` も追加し、operator が key を local の正しい場所へ入れられるようにしています。

Secret template は placeholder-only のままです。実 key と runtime state は ignore 済みの local file に置きます。

## Docs And Dashboard

VitePress docs は release の一部です。setup、usage、architecture、troubleshooting、dashboard workflow を英語と日本語で説明しています。`docs/public/hermes-kanban-dashboard.png` の dashboard screenshot は、起動後にどの surface が見えるべきかを具体的に示します。

## Recommended First Run

1. repository を clone し、Compose config を `data/` に作りたい場合は `./scripts/setup.sh` を実行します。
2. `./scripts/kind-up.sh` または `./scripts/up.sh` のどちらかを起動します。
3. `./scripts/kind-verify.sh` または `./scripts/verify.sh` で確認します。
4. `./scripts/hermes-worker "Summarize the current Hermes Pod status."` で小さな確認を委譲します。

全体の要約は [v0.1.0 リリースノート](/ja/guide/releases/v0.1.0) を参照してください。
