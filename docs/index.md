---
layout: home
title: Hermes Agent Pod
titleTemplate: false

hero:
  name: Hermes Agent Pod
  text: Local Hermes Agent gateway for Codex worker experiments
  tagline: Run Nous Research Hermes Agent as a kind Pod or Docker Compose service, expose the gateway on localhost, and delegate bounded tasks through an OpenAI-compatible wrapper.
  image:
    src: /hermes-agent-pod-icon.svg
    alt: Hermes Agent Pod icon
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: GitHub
      link: https://github.com/Sunwood-ai-labs/hermes-agent-pod

features:
  - title: Two local runtimes
    details: "Start Hermes in a sandboxed kind cluster or use the Docker Compose fallback when Kubernetes is not needed."
  - title: Local-first surfaces
    details: "Gateway and dashboard ports are bound to 127.0.0.1 for development-only access."
  - title: Codex worker wrapper
    details: "Call the local Hermes gateway from scripts/hermes-worker and attach text files as bounded task context."
---

## What You Get

Hermes Agent Pod packages a reproducible local runtime around `nousresearch/hermes-agent:latest`.
It is meant for development and delegation experiments where Codex remains the lead agent and Hermes answers bounded worker tasks through a localhost API.

## Runtime Surfaces

| Surface | Address | Purpose |
| --- | --- | --- |
| Gateway API | `http://127.0.0.1:8642` | OpenAI-compatible chat completions endpoint |
| Dashboard | `http://127.0.0.1:9119` | Hermes dashboard and TUI surface |
| kind namespace | `sandbox-hermes` | Kubernetes resources for the Pod runtime |
| Compose service | `sandbox-hermes-agent` | Docker fallback runtime |

## Next Steps

Start with [Getting Started](/guide/getting-started), then review [Usage](/guide/usage) for worker delegation patterns.
