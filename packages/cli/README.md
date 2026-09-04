# apidash_cli

Pure-Dart command line interface for API Dash. Reuses API Dash's own
`better_networking` send engine and shares the desktop app's workspace. **No
Flutter at runtime.**

End-user docs: [`doc/user_guide/cli_user_guide.md`](../../doc/user_guide/cli_user_guide.md).

## Dev quickstart

This package is a member of the repo's pub workspace. Resolve deps from the
**repo root** (Flutter is the workspace root):

```bash
flutter pub get
```

Run:

```bash
dart run packages/cli/bin/apidash.dart --help
dart run packages/cli/bin/apidash.dart send GET https://api.apidash.dev
dart run packages/cli/bin/apidash.dart send GET https://api.apidash.dev --stream
dart run packages/cli/bin/apidash.dart --json send GET https://api.apidash.dev
dart run packages/cli/bin/apidash.dart graphql https://countries.trevorblades.com/ \
  --query "{ countries { code name } }"
dart run packages/cli/bin/apidash.dart ai --provider openai --model gpt-4o-mini \
  -m "One-line summary of HTTP" --key "$OPENAI_API_KEY"
dart run packages/cli/bin/apidash.dart list
dart run packages/cli/bin/apidash.dart run <name|id>
dart run packages/cli/bin/apidash.dart env list
dart run packages/cli/bin/apidash.dart tui   # interactive; or just run with no args
```

Commands: `send`, `graphql`, `ai`, `run`, `list`, `env`, `tui`. Global flags:
`--json`, `-w/--workspace <path>`, `--env <name|id>`. `send`/`run` take
`--stream` for SSE/streaming responses.

### Interactive mode (TUI)

Run `apidash` with **no arguments** on a terminal (or `apidash tui`) to launch
an interactive "pick and run" loop over your saved requests — no flags to
remember. Pick a request, then choose an action: **Run**, **Edit URL**, **Edit
Method**, **Edit Headers**, **Edit Body/Params**, **Generate curl**, or
**Back**. Edits are **in-memory only** (the workspace is opened read-only, so
they are not saved back — write-back is a future feature); "Run" executes the
edited request through the same engine as `run`. `--env`/`--workspace` apply.
Terminal-only (needs raw keyboard input); with no args and no TTY it prints
usage and exits 64.

Build a standalone binary (git-ignored):

```bash
dart compile exe packages/cli/bin/apidash.dart -o packages/cli/apidash
```

Test:

```bash
cd packages/cli && dart test
```

## Layout

| Path | Purpose |
| :--- | :--- |
| `bin/apidash.dart` | Entry point: `CommandRunner`, global `--json`/`--workspace`/`--env` flags, exit codes. |
| `lib/src/commands/send.dart` | Ad-hoc request → builds `HttpRequestModel`, sends via `sendHttpRequest` (or streams via `streamHttpRequest` with `--stream`). |
| `lib/src/commands/graphql.dart` | Ad-hoc GraphQL query (`APIType.graphql`; `--variables` uses a direct JSON POST). |
| `lib/src/commands/ai.dart` | Ad-hoc AI prompt + `runAiRequest` helper (provider `createRequest` → send → response parser). |
| `lib/src/commands/run.dart` | Loads a saved request and runs it via the shared `executeSavedRequest`. |
| `lib/src/commands/list.dart` | Lists saved requests. |
| `lib/src/commands/env.dart` | Lists/shows environments; resolves the global `--env`. |
| `lib/src/executor.dart` | `executeSavedRequest` — single execution path (routes by `apiType`) shared by `run` and the TUI. |
| `lib/src/tui.dart` | Interactive "pick and run" loop (`mason_logger` only), request-display formatters, curl builder, inline field editor. |
| `lib/src/storage/storage.dart` | Read-only shadow copy of the desktop `apidash-data` Hive box. |
| `lib/src/output.dart` | Shared response formatting: `printResponse` (human + `--json`) and `printStream` (live/JSONL). |
| `lib/src/utils/workspace.dart` | Workspace auto-detection / resolution. |

The HTTP engine + models come from `better_networking`; the AI request model
and provider adapters come from `genai` (Flutter-free subpaths only). The CLI
does not reimplement HTTP, GraphQL, AI, or models.
