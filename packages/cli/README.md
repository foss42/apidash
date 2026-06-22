# Apidash CLI

A lightweight, portable, and **Flutter-free** Command Line Interface for Apidash. Access, test, and run your saved API requests directly from your terminal.

## Key Features

-  **Zero Config**: Automatically detects your Apidash GUI workspace on Linux, macOS, and Windows.
-  **Concurrency Safe**: Uses a "Shadow Copy" mechanism to read your data even while the Apidash desktop app is open and locking the database.
-  **Interactive TUI**: A premium Terminal User Interface for selecting and editing requests.
-  **UX-Focused Editor**: Pre-filled interactive line editor for URLs and Parameters—edit individual letters instead of re-typing.
-  **Pure Dart**: Built as a standalone Dart package with no dependency on the Flutter SDK.


## Usage

### List & Interact
Browse your saved requests using the interactive TUI.
```bash
dart run bin/apidash.dart list
```
From the list, you can:
- **Run**: Execute the request and see beautifully formatted JSON responses.
- **Edit**: Temporarily modify the **URL**, **HTTP Method**, or **Query Parameters** before running.
- **Back**: Return to the list.

### Direct Run
Execute a specific request immediately if you know its ID.
```bash
dart run bin/apidash.dart run <request-id>
```

### Options
| Option | Abbr | Description |
| :--- | :--- | :--- |
| `--data-dir` | `-d` | Path to the directory containing `apidash-data.hive`. Overrides auto-detection. |
| `--help` | `-h` | Show usage information. |

