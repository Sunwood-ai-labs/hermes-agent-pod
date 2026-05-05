#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
import textwrap
import urllib.error
import urllib.request
from pathlib import Path
from typing import Iterable


DEFAULT_BASE_URL = "http://127.0.0.1:8642/v1"
DEFAULT_MODEL = "hermes-agent"
DEFAULT_API_KEY = "local-hermes-dev-change-me"
DEFAULT_SYSTEM_PROMPT = Path(__file__).resolve().parents[1] / "prompts" / "hermes-worker-system.md"


def read_prompt(args: argparse.Namespace) -> str:
    prompt = " ".join(args.prompt).strip()
    if prompt:
        return prompt
    if not sys.stdin.isatty():
        return sys.stdin.read().strip()
    return ""


def read_text_file(path: Path, max_chars: int) -> str:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except Exception as exc:
        return f"[failed to read {path}: {exc}]"
    if len(text) <= max_chars:
        return text
    return text[:max_chars] + f"\n\n[truncated at {max_chars} chars]"


def build_file_context(paths: Iterable[str], per_file_limit: int) -> str:
    chunks: list[str] = []
    for raw in paths:
        path = Path(raw).expanduser()
        label = str(path)
        if not path.is_absolute():
            path = Path.cwd() / path
        if path.is_dir():
            chunks.append(f"## {label}\n\n[skipped: directory]")
            continue
        chunks.append(
            "## "
            + label
            + "\n\n```text\n"
            + read_text_file(path, per_file_limit)
            + "\n```"
        )
    return "\n\n".join(chunks)


def load_system_prompt(path: str | None) -> str:
    prompt_path = Path(path).expanduser() if path else DEFAULT_SYSTEM_PROMPT
    return prompt_path.read_text(encoding="utf-8")


def request_hermes(
    *,
    base_url: str,
    api_key: str,
    model: str,
    system_prompt: str,
    user_prompt: str,
    session_id: str | None,
    timeout: int,
) -> tuple[dict, str | None]:
    payload = {
        "model": model,
        "stream": False,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt},
        ],
    }
    data = json.dumps(payload).encode("utf-8")
    url = base_url.rstrip("/") + "/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    if session_id:
        headers["X-Hermes-Session-Id"] = session_id
    req = urllib.request.Request(url, data=data, headers=headers, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read().decode("utf-8")
            next_session = resp.headers.get("X-Hermes-Session-Id")
            return json.loads(body), next_session
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"Hermes API error {exc.code}: {body}") from exc
    except urllib.error.URLError as exc:
        raise SystemExit(f"Hermes API connection failed: {exc}") from exc


def extract_text(response: dict) -> str:
    try:
        content = response["choices"][0]["message"]["content"]
    except Exception:
        return json.dumps(response, ensure_ascii=False, indent=2)
    return str(content or "").strip()


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Delegate a bounded task to the Hermes worker running in the local Pod."
    )
    parser.add_argument("prompt", nargs="*", help="Task prompt. If omitted, stdin is used.")
    parser.add_argument("--file", action="append", default=[], help="Attach a local text file as context.")
    parser.add_argument("--per-file-limit", type=int, default=30_000, help="Max chars per attached file.")
    parser.add_argument("--session-id", default=os.getenv("HERMES_SESSION_ID", ""), help="Continue a Hermes session.")
    parser.add_argument("--show-session", action="store_true", help="Print returned session id to stderr.")
    parser.add_argument("--json", action="store_true", help="Print raw JSON response.")
    parser.add_argument("--timeout", type=int, default=int(os.getenv("HERMES_WORKER_TIMEOUT", "180")))
    parser.add_argument("--base-url", default=os.getenv("HERMES_API_BASE_URL", DEFAULT_BASE_URL))
    parser.add_argument("--api-key", default=os.getenv("HERMES_API_KEY", DEFAULT_API_KEY))
    parser.add_argument("--model", default=os.getenv("HERMES_API_MODEL", DEFAULT_MODEL))
    parser.add_argument("--system-prompt", help="Override the worker system prompt file.")
    args = parser.parse_args()

    prompt = read_prompt(args)
    if not prompt:
        parser.error("prompt is required via args or stdin")

    file_context = build_file_context(args.file, args.per_file_limit)
    if file_context:
        prompt = prompt + "\n\n# Context Files\n\n" + file_context

    response, session_id = request_hermes(
        base_url=args.base_url,
        api_key=args.api_key,
        model=args.model,
        system_prompt=load_system_prompt(args.system_prompt),
        user_prompt=prompt,
        session_id=args.session_id or None,
        timeout=args.timeout,
    )

    if args.show_session and session_id:
        print(f"HERMES_SESSION_ID={session_id}", file=sys.stderr)

    if args.json:
        print(json.dumps(response, ensure_ascii=False, indent=2))
    else:
        print(textwrap.dedent(extract_text(response)).strip())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
