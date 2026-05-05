---
layout: home
title: Hermes Agent Pod
titleTemplate: false

hero:
  name: Hermes Agent Pod
  text: Codex worker 実験向けのローカル Hermes Agent gateway
  tagline: Nous Research Hermes Agent を kind Pod または Docker Compose service として起動し、localhost の OpenAI-compatible API 経由で小さな委譲タスクを実行します。
  image:
    src: /hermes-agent-pod-icon.svg
    alt: Hermes Agent Pod icon
  actions:
    - theme: brand
      text: はじめる
      link: /ja/guide/getting-started
    - theme: alt
      text: GitHub
      link: https://github.com/Sunwood-ai-labs/hermes-agent-pod

features:
  - title: "2 つのローカル実行経路"
    details: "sandbox 用 kind cluster か、Kubernetes が不要な場合の Docker Compose fallback で Hermes を起動できます。"
  - title: localhost 前提の公開面
    details: "gateway と dashboard は開発用に 127.0.0.1 へ bind されます。"
  - title: Codex worker wrapper
    details: "scripts/hermes-worker からローカル Hermes gateway を呼び出し、必要な text file を限定 context として添付できます。"
---

## 何が入っているか

Hermes Agent Pod は `nousresearch/hermes-agent:latest` を再現しやすいローカル runtime として包む検証キットです。
Codex が主担当のまま、Hermes に小さく区切った worker task を localhost API 経由で依頼する用途を想定しています。

## Runtime Surfaces

| Surface | Address | Purpose |
| --- | --- | --- |
| Gateway API | `http://127.0.0.1:8642` | OpenAI-compatible chat completions endpoint |
| Dashboard | `http://127.0.0.1:9119` | Hermes dashboard と TUI surface |
| kind namespace | `sandbox-hermes` | Pod runtime 用 Kubernetes resources |
| Compose service | `sandbox-hermes-agent` | Docker fallback runtime |

## 次に読むもの

まず [はじめに](/ja/guide/getting-started) で起動し、[使い方](/ja/guide/usage) で worker 委譲パターンを確認します。
