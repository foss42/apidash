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
dart run packages/cli/bin/apidash.dart --json send GET https://api.apidash.dev
dart run packages/cli/bin/apidash.dart list
dart run packages/cli/bin/apidash.dart run <name|id>
```

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
| `bin/apidash.dart` | Entry point: `CommandRunner`, global `--json`/`--workspace` flags, exit codes. |
| `lib/src/commands/send.dart` | Ad-hoc request → builds `HttpRequestModel`, sends via `sendHttpRequest`. |
| `lib/src/commands/run.dart` | Loads a saved request from the workspace and sends it. |
| `lib/src/commands/list.dart` | Lists saved requests. |
| `lib/src/storage/storage.dart` | Read-only shadow copy of the desktop `apidash-data` Hive box. |
| `lib/src/output.dart` | Shared response formatting (human + `--json`). |
| `lib/src/utils/workspace.dart` | Workspace auto-detection / resolution. |

The models and the HTTP engine come from `apidash_core` (which re-exports
`better_networking`) — the CLI does not reimplement HTTP, models, or codegen.
