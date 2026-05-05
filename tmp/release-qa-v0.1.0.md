# Release QA Inventory

## Release Context

- repository: `Sunwood-ai-labs/hermes-agent-pod`
- release tag: `v0.1.0`
- compare range: initial release mode from root commit `db75e4f811ef49d2f6e72cd3c27ef811c03e86de` through tag target `a00ab2bce0c887b5584f2863cb63a4c3567c9664`
- requested outputs: GitHub release body, docs-backed release notes, companion walkthrough article, release header SVG, QA inventory
- validation commands run: `pwsh -NoProfile -ExecutionPolicy Bypass -File /tmp/codex-gh-release-notes-skill/collect-release-context.ps1 -Tag v0.1.0`, `python3 -m py_compile scripts/hermes-worker.py` in `/tmp/hermes-agent-pod-v010`, `bash -n scripts/*.sh` in `/tmp/hermes-agent-pod-v010`, `pwsh -NoProfile -ExecutionPolicy Bypass -File /tmp/codex-gh-release-notes-skill/verify-svg-assets.ps1 -RepoPath . -Path docs/public/hermes-agent-pod-icon.svg`, `pwsh -NoProfile -ExecutionPolicy Bypass -File /tmp/codex-gh-release-notes-skill/verify-svg-assets.ps1 -RepoPath . -Path docs/public/hermes-agent-pod-icon.svg,docs/public/release-header-v0.1.0.svg`, `cd docs && npm run docs:build`, `pwsh -NoProfile -ExecutionPolicy Bypass -File /tmp/codex-gh-release-notes-skill/verify-release-qa-inventory.ps1 -RepoPath . -Tag v0.1.0`
- release URLs: GitHub release `https://github.com/Sunwood-ai-labs/hermes-agent-pod/releases/tag/v0.1.0`; docs URLs listed in `tmp/release-notes-v0.1.0.md`

## Claim Matrix

| claim | code refs | validation refs | docs surfaces touched | scope |
| --- | --- | --- | --- | --- |
| v0.1.0 is the first public release covering full history through `a00ab2b` | `git rev-parse v0.1.0^{}`, `collect-release-context.ps1` output | `collect-release-context.ps1 -Tag v0.1.0` reported no previous base tag and `gh release exists: false` | `docs/guide/releases/v0.1.0.md`, `docs/ja/guide/releases/v0.1.0.md`, `tmp/release-notes-v0.1.0.md` | release_only |
| The release ships kind and Docker Compose local runtime paths | `compose.yaml`, `kind-config.yaml`, `k8s/hermes-pod.yaml`, `scripts/kind-up.sh`, `scripts/up.sh` | tag file inspection plus docs build | `docs/guide/releases/v0.1.0.md`, `docs/guide/articles/v0-1-0-local-hermes-runtime.md` | steady_state |
| Gateway and dashboard default to localhost ports `8642` and `9119` | `compose.yaml`, `k8s/hermes-pod.yaml`, `docs/guide/usage.md` | tag file inspection plus docs build | `docs/guide/releases/v0.1.0.md`, `docs/ja/guide/releases/v0.1.0.md` | steady_state |
| `scripts/hermes-worker` delegates through `/v1/chat/completions` with file attachments and session controls | `scripts/hermes-worker.py`, `prompts/hermes-worker-system.md`, `README.md` | `python3 -m py_compile scripts/hermes-worker.py` passed in tag worktree; docs build passed | `docs/guide/releases/v0.1.0.md`, `docs/guide/articles/v0-1-0-local-hermes-runtime.md` | steady_state |
| Runtime defaults are provider `zai`, model `glm-5.1`, and GLM base URL `https://api.z.ai/api/coding/paas/v4` | `compose.yaml`, `k8s/hermes-pod.yaml`, `scripts/up.sh`, `scripts/set-glm-key.sh` | tag file inspection plus docs build | `docs/guide/releases/v0.1.0.md`, `docs/ja/guide/releases/v0.1.0.md` | steady_state |
| Release docs are published through VitePress and GitHub Pages | `docs/.vitepress/config.ts`, `.github/workflows/deploy-docs.yml`, `docs/package.json` | `cd docs && npm run docs:build` | `docs/.vitepress/config.ts`, `docs/index.md`, `docs/ja/index.md` | docs_release |

## Steady-State Docs Review

| surface | status | evidence |
| --- | --- | --- |
| README.md | pass | Reviewed current working copy and tag version; v0.1.0 claims already describe kind, Compose, localhost gateway/dashboard, worker wrapper, GLM defaults, and docs. Current dirty README also contains post-tag vm200/Podman material, so release work did not rewrite it. |
| README.ja.md | pass | Reviewed current working copy and tag version; v0.1.0 Japanese README already covers shipped runtime, GLM key setup, dashboard, worker wrapper, and secret hygiene. Existing post-tag role content was not included as a v0.1.0 claim. |
| docs/guide/getting-started.md | pass | Reviewed tag and current docs; release notes point to canonical setup docs without broadening behavior beyond kind and Compose paths. |
| docs/ja/guide/getting-started.md | pass | Reviewed tag and current docs; Japanese release notes point to canonical setup docs without broadening behavior beyond kind and Compose paths. |
| docs/guide/usage.md | pass | Reviewed tag and current docs; release notes only claim the v0.1.0 worker wrapper and dashboard behavior. Post-tag role-worker text remains outside v0.1.0 scope. |
| docs/ja/guide/usage.md | pass | Reviewed tag and current docs; Japanese release notes only claim the v0.1.0 worker wrapper and dashboard behavior. Post-tag role-worker text remains outside v0.1.0 scope. |
| docs/.vitepress/config.ts | pass | Updated navigation/sidebar to expose release notes and walkthrough pages in both locales. |
| docs/index.md | pass | Added a release-notes pointer from the English docs landing page. |
| docs/ja/index.md | pass | Added a release-notes pointer from the Japanese docs landing page. |
| docs/guide/releases/v0.1.0.md | pass | Added English docs-backed release notes for v0.1.0. |
| docs/ja/guide/releases/v0.1.0.md | pass | Added Japanese docs-backed release notes for v0.1.0. |
| docs/guide/articles/v0-1-0-local-hermes-runtime.md | pass | Added English companion walkthrough for the v0.1.0 runtime workflow. |
| docs/ja/guide/articles/v0-1-0-local-hermes-runtime.md | pass | Added Japanese companion walkthrough for the v0.1.0 runtime workflow. |
| tmp/release-notes-v0.1.0.md | pass | Prepared the GitHub release body used by `gh release create`. |

## QA Inventory

| criterion_id | status | evidence |
| --- | --- | --- |
| compare_range | pass | `collect-release-context.ps1 -Tag v0.1.0` resolved target `a00ab2bce0c887b5584f2863cb63a4c3567c9664` and no previous tag, so initial release mode is used. |
| release_claims_backed | pass | Claim matrix maps release body claims to `compose.yaml`, `k8s/hermes-pod.yaml`, `scripts/hermes-worker.py`, `scripts/set-glm-key.sh`, docs, and workflow files. |
| docs_release_notes | pass | `docs/guide/releases/v0.1.0.md`, `docs/ja/guide/releases/v0.1.0.md` |
| companion_walkthrough | pass | `docs/guide/articles/v0-1-0-local-hermes-runtime.md`, `docs/ja/guide/articles/v0-1-0-local-hermes-runtime.md` |
| operator_claims_extracted | pass | Claim matrix extracts runtime paths, localhost ports, wrapper behavior, GLM defaults, and docs publishing claims. |
| impl_sensitive_claims_verified | pass | Implementation-sensitive claims were checked against tag files in `compose.yaml`, `k8s/hermes-pod.yaml`, `scripts/hermes-worker.py`, `scripts/set-glm-key.sh`, and `scripts/up.sh`. |
| steady_state_docs_reviewed | pass | README, Japanese README, getting-started docs, usage docs, and VitePress config are listed in the steady-state docs review table. |
| claim_scope_precise | pass | v0.1.0 claims exclude post-tag uncommitted role-worker and Podman remote changes visible in the current working tree. |
| latest_release_links_updated | pass | Added release notes and walkthrough links to `docs/.vitepress/config.ts`, `docs/index.md`, and `docs/ja/index.md`; README had no stable latest-release pointer to update without touching unrelated dirty content. |
| svg_assets_validated | pass | `verify-svg-assets.ps1 -RepoPath . -Path docs/public/hermes-agent-pod-icon.svg,docs/public/release-header-v0.1.0.svg` passed. |
| docs_assets_committed_before_tag | not_applicable | The tag `v0.1.0` already existed on the remote before this release-notes task. Release collateral is committed before GitHub release publication instead of rewriting the existing tag. |
| docs_deployed_live | pass | Pages workflow run `25390205901` succeeded, and `curl -fsSI` returned HTTP 200 for `https://sunwood-ai-labs.github.io/hermes-agent-pod/guide/releases/v0.1.0`, `https://sunwood-ai-labs.github.io/hermes-agent-pod/guide/articles/v0-1-0-local-hermes-runtime`, `https://sunwood-ai-labs.github.io/hermes-agent-pod/ja/guide/releases/v0.1.0`, `https://sunwood-ai-labs.github.io/hermes-agent-pod/ja/guide/articles/v0-1-0-local-hermes-runtime`, and `https://sunwood-ai-labs.github.io/hermes-agent-pod/release-header-v0.1.0.svg`. |
| tag_local_remote | pass | `git ls-remote --tags origin` shows `refs/tags/v0.1.0` and `refs/tags/v0.1.0^{}` pointing to `a00ab2bce0c887b5584f2863cb63a4c3567c9664`. |
| github_release_verified | pass | `gh release create v0.1.0 --title "v0.1.0" --notes-file tmp/release-notes-v0.1.0.md` created `https://github.com/Sunwood-ai-labs/hermes-agent-pod/releases/tag/v0.1.0`; `gh release view v0.1.0 --json url,name,body,tagName,isDraft,isPrerelease,publishedAt,targetCommitish` verified the final body and `publishedAt=2026-05-05T16:57:16Z`. |
| validation_commands_recorded | pass | Release Context records collector, SVG validation, and docs build commands. |
| publish_date_verified | not_applicable | Release body omits a hardcoded publish date. |

## Notes

- blockers: none
- waivers: `docs_assets_committed_before_tag` is not applicable because `v0.1.0` was already pushed before release-note publication work started.
- follow-up docs tasks: post-tag role-worker and Podman remote changes should receive their own release notes when they are tagged.
