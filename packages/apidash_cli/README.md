# API Dash CLI

`apidash_cli` is the terminal companion for API Dash. It lets you create a HIS workspace, inspect saved collections and requests, run stored requests, and fire off ad hoc HTTP requests from the terminal.

## What It Provides

- `init` creates a new HIS workspace on disk.
- `list` prints collections, folders, or requests from the current workspace.
- `run` executes a saved request by collection and request id.
- `exec` sends a direct HTTP request from the terminal and can optionally save it into the workspace.

## Prerequisites

- `apidash_storage` dependencies fetched with `dart pub get`.
- A workspace path set in `APIDASH_WORKSPACE_PATH` before using commands that read or write workspace data.

## Install Dependencies

From the repository root:

```bash
cd packages/apidash_storage
dart pub get

cd ../apidash_cli
dart pub get
```

## Running The CLI

You can run the package directly or activate it as a global command.

### Local run

From `packages/apidash_cli`:

```bash
dart run bin/apidash_cli.dart --help
```

Example:

```bash
dart run bin/apidash_cli.dart init /Users/<name>/apidash-workspace
```

### Global run

From the repository root:

```bash
dart pub global activate --source path packages/apidash_cli
```

Then use:

```bash
apidash --version
apidash init /Users/<name>/apidash-workspace
```

## Workspace Setup for now

The CLI stores and reads saved requests from the workspace pointed to by `APIDASH_WORKSPACE_PATH`.

```bash
export APIDASH_WORKSPACE_PATH=/Users/<name>/apidash-workspace
```

If you use `init`, the command creates the workspace structure for you and prints a shell export command you can reuse.

## Workspace Layout

The workspace uses a `collections` folder with collection, folder, and request files under it.

Typical structure:

```text
collections/
	col_001/
		collection.json
		req_001.json
		folder_001/
			folder.json
			req_002.json
```

## Commands

### `init`

Creates a HIS workspace at path if not present.

Usage:

```bash
apidash init <path>
```

Example:

```bash
apidash init /Users/<name>/apidash-workspace
```

What it does:

- Creates the workspace directories and metadata files.
- Prints a success message when the workspace is ready.
- Prints a shell export command for `APIDASH_WORKSPACE_PATH`.

### `list`

Lists collections, folders, or requests from the active workspace.

Usage:

```bash
apidash list <collection-id> [--folder=<folder-id>] [--request=<request-id>]
```

Behavior:

- With no collection id, it prints all collections in the workspace.
- With a collection id, it prints that collection summary, including folders and requests.
- With `--folder`, it lists requests within a folder.
- With `--request`, it prints the full request details for the selected request.

Examples:

```bash
apidash list
apidash list col_001
apidash list col_001 --folder=folder_001
apidash list col_001 --request=req_001
```


### `run`

Executes a saved request from the workspace.

Usage:

```bash
apidash run <collection-id> --request=<request-id> [--folder=<folder-id>]
```

Examples:

```bash
apidash run col_001 --request=req_001
apidash run col_001 --folder=folder_001 --request=req_002
```

What it does:

- Loads the request JSON from the workspace.
- Sends the request over HTTP.
- Prints the response as formatted JSON.

You must set `APIDASH_WORKSPACE_PATH` before using `run`.

### `exec`

Executes a direct HTTP request from the terminal.

Usage:

```bash
apidash exec --url=<url> [--method=GET] [--save]
```

Save-related options are only valid when `--save` is present:

```bash
apidash exec --url=<url> --method=GET --save [--collection=col_001] [--folder=folder_001] [--request-id=req_001] [--name="My request"]
```

Examples:

```bash
apidash exec --url=https://httpbin.org/get --method=GET
apidash exec --url=https://httpbin.org/get --method=GET --save
apidash exec --url=https://httpbin.org/get --method=GET --save --collection=col_002 --name="HTTPBin GET"
```

What it does:

- Sends a request immediately using the selected method and URL.
- Prints the response as formatted JSON.
- Saves the request to the workspace when `--save` is provided.

Defaults and rules:

- `--method` defaults to `GET`.
- `--collection` defaults to `col_001` when saving.
- `--request-id` is generated automatically if not provided while saving.
- `--name` defaults to `<METHOD> <URL>` when saving.
- `--collection`, `--folder`, `--name`, and `--request-id` are rejected unless `--save` is set.

## Global Flags

### `--version`

Prints the CLI version.

```bash
apidash --version
```

## Common Workflows

Create a workspace, point the CLI at it, then save and reuse requests:

```bash
apidash init /Users/<name>/apidash-workspace
export APIDASH_WORKSPACE_PATH=/Users/<name>/apidash-workspace
apidash exec --url=https://httpbin.org/get --method=GET --save
apidash list
```

## Troubleshooting

- If `list` or `run` reports that `APIDASH_WORKSPACE_PATH` is missing, export the workspace path in the shell before running the command.
- If `exec --save` does not persist data, confirm that the workspace path exists and that the process can write to it.
- If you activate the package globally and the command looks stale, re-run the global activation from the repository root.