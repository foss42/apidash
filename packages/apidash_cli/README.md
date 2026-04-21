# apidash_cli

High-level command line interface for API Dash.

This package lets you run API requests from terminal using the same local data and history that the API Dash desktop app uses.

## What This CLI Does

- Run saved requests from API Dash by name or id
- Run direct URL requests without saving them first
- Search saved requests
- View request history
- Use an interactive options mode for guided command navigation

## High-Level Architecture

The CLI has five core layers:

1. Entry point
- File: `bin/apidash.dart`
- Initializes Hive storage
- Registers commands: `run`, `search`, `log`, `options`
- If no args are passed:
  - Interactive terminal: opens `options` mode
  - Non-interactive terminal: prints help

2. Storage layer
- File: `lib/storage/cli_storage.dart`
- Opens shared Hive boxes:
  - `apidash-data`
  - `apidash-history-meta`
  - `apidash-history-lazy`
- Reads saved requests from data box
- Persists execution results to history boxes

3. Command layer
- `lib/commands/run_command.dart`
- `lib/commands/search_command.dart`
- `lib/commands/log_command.dart`
- `lib/commands/options_command.dart`

4. Request execution layer
- File: `lib/services/request_executor.dart`
- Uses `package:http` to send requests
- Supports REST and GraphQL request execution paths
- Supports multipart for form-data requests

5. Output formatting
- File: `lib/formatters/response_formatter.dart`
- Prints response summary, headers, and body

## Storage Path Resolution

Hive path is resolved in this order:

1. `APIDASH_WORKSPACE_PATH` environment variable (if set)
2. On Windows: workspace path from API Dash shared preferences
3. Platform fallback path

This allows CLI and GUI to read/write the same request and history data.

## Command Overview

### options

Interactive menu for guided usage.

Example:

```bash
apidash options
```

Or simply:

```bash
apidash
```

On interactive terminals, this opens options mode directly.

### run

Runs a saved request or a direct URL request.

Saved request examples:

```bash
apidash run --name "Get Users"
apidash run --id <request-id>
```

Direct URL examples:

```bash
apidash run --url https://httpbin.org/get
apidash run --url https://httpbin.org/post --method POST --data '{"name":"Alice"}'
apidash run --url https://httpbin.org/get --header "Authorization: Bearer token"
```

### search

Searches saved requests by name or URL. Optional method filter.

Examples:

```bash
apidash search "users"
apidash search --method POST
apidash search "auth" --method GET
```

### log

Shows request history stored in Hive.

Examples:

```bash
apidash log
apidash log --last 5
apidash log --id <history-id> --details
```

## Options Mode Experience

The options command provides a numbered menu for users who do not want to remember flags.

Main menu actions:

1) Run a saved request
2) Run a direct URL
3) Search saved requests
4) View history list
5) View history details by id
6) Enter custom command
7) Show CLI help
0) Exit

This is intended to make CLI usage easy for first-time users.

## Running From This Monorepo

From repo root:

```bash
dart run packages/apidash_cli/bin/apidash.dart --help
```

If you have an `apidash` shell function or globally activated executable, use:

```bash
apidash --help
```

## GUI and CLI Concurrency Notes

On Windows, Hive files are process-locked. If API Dash GUI is already open and has the same Hive boxes open, CLI can fail with a lock error.

When that happens, CLI prints a friendly guidance message and exits with code 1.

Recommended flow when lock occurs:

1. Close API Dash GUI
2. Run CLI command
3. Reopen GUI to inspect history updates

## Current Limitations

- AI request execution is not supported in the current CLI runner
- The `--env` option is currently accepted by `run` but not yet applied to request resolution
- No dedicated command yet for editing a historical request in-place

## Suggested Next Enhancements

- `history search` and `history rerun` commands
- Edit-and-rerun workflow for history entries
- Environment override wiring for `--env`
- Export/import command helpers for automation
