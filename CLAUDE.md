# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

API Dash is a cross-platform API client built with Flutter. It supports HTTP/GraphQL requests, SSE/streaming, AI requests, code generation for 30+ languages, and importing from Postman/cURL/Insomnia/HAR.

## Technology Stack

- **Framework:** Flutter (Dart)
- **State Management:** Riverpod
- **Local Storage:** Hive (NoSQL)
- **Code Generation:** Freezed, json_serializable, Jinja templates
- **Monorepo:** Melos

## Common Commands

```bash
# Setup (after cloning)
flutter create --platforms=<platform> .  # e.g., windows, macos, linux
dart pub global activate melos
melos bootstrap
melos pub-get
flutter pub get

# Development
flutter run

# Testing
flutter test --coverage              # Main app tests
melos test                            # All package tests
flutter test <file_path>.dart         # Single test file

# Code generation
melos build-gen                       # Run build_runner for all packages

# Linting
melos analyze                         # Analyze all packages
```

## Architecture

### Main Entry Points
- `lib/main.dart` - App initialization sequence (analytics → AI models → settings → Hive → window config → providers → run)
- `lib/app.dart` - App widget with window lifecycle management

### Directory Structure
- `lib/codegen/` - Code generation for 30+ languages (each in subdirectory)
- `lib/dashbot/` - AI assistant (Dashbot) with chat, prompts, services
- `lib/importer/` - Import from cURL, Postman, Insomnia, HAR
- `lib/models/` - Data models (Freezed)
- `lib/providers/` - Riverpod state management
- `lib/screens/` - UI screens
- `lib/services/` - Business logic & persistence
- `lib/widgets/` - Reusable UI components
- `packages/` - Shared packages (apidash_core, apidash_design_system, curl_parser, postman, etc.)

### State Management (Riverpod)

Providers are organized by domain in `lib/providers/`:
- `collection_providers.dart` - Request collection CRUD
- `ui_providers.dart` - Navigation, edit mode, search
- `settings_providers.dart` - Theme, window, codegen defaults
- `environment_providers.dart` - Environment variables
- `history_providers.dart` - Request history
- `ai_providers.dart` - AI/Dashbot integration

### Data Flow
```
User clicks Send → collectionStateNotifierProvider sends HTTP request →
Response stored in RequestModel → selectedRequestModelProvider rebuilds UI
```

### Key Patterns

- **UUIDs:** All entities use UUIDs - use `getNewUuid()` from `lib/utils/utils.dart`
- **Immutable State:** Always replace state, never mutate in place:
  ```dart
  state = {...state!, id: updatedModel};
  ```
- **Platform Checks:** Use from `lib/consts.dart`:
  ```dart
  kIsWindows, kIsMacOS, kIsLinux, kIsMobile, kIsDesktop
  ```

### Storage (Hive)

Boxes: `apidash-data`, `apidash-environments`, `apidash-history-meta`, `apidash-history-lazy`, `apidash-dashbot-data`

Access via `HiveHandler` in `lib/services/hive_services.dart`.

### Code Generation System

`lib/codegen/codegen.dart` delegates to language-specific classes in subdirectories. Each uses Jinja templates. See `doc/dev_guide/adding_codegen.md` for adding new generators.

## Adding Features

1. Open an issue first for discussion
2. Fork and create branch: `add-feature-xyz` or `resolve-issue-xyz`
3. Add tests in `test/` folder
4. PRs should be focused (not massive refactors)
5. Don't bump dependency versions in PRs

## Key Files

- `lib/consts.dart` - Constants, enums, platform checks
- `lib/models/request_model.dart` - Request data model
- `doc/dev_guide/architecture.md` - Detailed architecture documentation
- `doc/dev_guide/setup_run.md` - Full setup instructions
- `doc/dev_guide/testing.md` - Testing details
