# API Dash Architecture Overview

This document provides an overview of the API Dash project architecture for developers and contributors.

## Technology Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter (Dart) |
| **State Management** | Riverpod |
| **Local Storage** | Hive (NoSQL embedded database) |
| **Code Generation (models)** | Freezed, json_serializable, build_runner |
| **Code Generation (API)** | Jinja templates |
| **Monorepo Management** | Melos |
| **Platforms** | macOS, Windows, Linux, iOS, Android, Web |

## Project Structure

```
apidash/
├── lib/                          # Main application code
│   ├── main.dart                 # Entry point
│   ├── app.dart                  # App widget & window lifecycle
│   ├── consts.dart               # Constants, enums, defaults
│   ├── codegen/                  # Code generation for 30+ languages
│   ├── dashbot/                  # AI assistant (Dashbot)
│   ├── importer/                 # Import from cURL, Postman, etc.
│   ├── models/                   # Data models (Freezed)
│   ├── providers/                # Riverpod state management
│   ├── screens/                  # UI screens and pages
│   ├── services/                 # Business logic & persistence
│   ├── utils/                    # Utility functions
│   └── widgets/                  # Reusable UI components
├── packages/                     # Shared packages (monorepo)
│   ├── apidash_core/             # Core business logic
│   ├── apidash_design_system/    # Design tokens & UI components
│   ├── curl_parser/              # cURL command parser
│   ├── postman/                  # Postman collection parser
│   ├── insomnia_collection/      # Insomnia file parser
│   ├── har/                      # HAR file parser
│   ├── genai/                    # AI provider integration
│   ├── json_explorer/            # JSON viewer widget
│   ├── json_field_editor/        # JSON field editor widget
│   ├── better_networking/        # Enhanced HTTP client
│   ├── multi_trigger_autocomplete_plus/  # Autocomplete widget
│   └── seed/                     # Seed/utility package
├── test/                         # Unit & widget tests
├── integration_test/             # Integration tests
└── doc/                          # Documentation
```

## Application Initialization

The app starts in `lib/main.dart` and follows this initialization sequence:

1. **Analytics setup** — Initialize telemetry (Stac).
2. **AI model loading** — Load available AI models via `ModelManager`.
3. **Settings loading** — Read user preferences from `SharedPreferences`.
4. **Hive initialization** — Open persistent storage boxes for requests, environments, history, and Dashbot data.
5. **Window configuration** — Restore window size and position on desktop platforms.
6. **Provider injection** — Wrap the app in Riverpod `ProviderScope` with initial settings.
7. **Run app** — Launch `DashApp`.

## Widget Hierarchy

```
DashApp (ConsumerWidget)
  └── MaterialApp
      └── App (ConsumerStatefulWidget — manages window lifecycle)
          └── Dashboard (Desktop) or MobileDashboard (Mobile)
              ├── Navigation Rail (left sidebar)
              │   ├── Requests tab     → HomePage
              │   ├── Variables tab    → EnvironmentPage
              │   ├── History tab      → HistoryPage
              │   └── Logs tab         → TerminalPage
              └── Content Area
                  └── HomePage
                      └── DashboardSplitView (resizable)
                          ├── CollectionPane (request list)
                          └── RequestEditorPane (request editor + response)
```

## State Management (Riverpod)

All application state is managed through Riverpod providers. Providers are organized by domain:

### Provider Files

| File | Purpose |
|------|---------|
| `collection_providers.dart` | Request collection CRUD, selection, ordering |
| `ui_providers.dart` | UI state (navigation, edit mode, search, visibility) |
| `settings_providers.dart` | Theme, window, codegen language, SSL, workspace |
| `environment_providers.dart` | Environment variables and active environment |
| `history_providers.dart` | Request history management |
| `ai_providers.dart` | AI/Dashbot integration |
| `terminal_providers.dart` | Debug console and network logs |

### Key Providers

```dart
// Currently selected request
final selectedIdStateProvider = StateProvider<String?>((ref) => null);

// Collection of all requests (Map<String, RequestModel>)
final collectionStateNotifierProvider = StateNotifierProvider<CollectionStateNotifier, Map<String, RequestModel>?>(...)

// Request ordering
final requestSequenceProvider = StateProvider<List<String>>((ref) => []);

// App settings (theme, workspace, etc.)
final settingsProvider = StateNotifierProvider<ThemeStateNotifier, SettingsModel>(...)

// Navigation
final navRailIndexStateProvider = StateProvider<int>((ref) => 0);
```

### Data Flow Example

```
User clicks Send →
  collectionStateNotifierProvider sends HTTP request →
    Response stored in RequestModel →
      selectedRequestModelProvider reactively updates →
        Response pane UI rebuilds with new data
```

## Data Models

Models are defined using **Freezed** for immutability and **json_serializable** for JSON conversion.

| Model | File | Purpose |
|-------|------|---------|
| `RequestModel` | `lib/models/request_model.dart` | Full request with URL, headers, body, auth, scripts, and cached response |
| `HistoryRequestModel` | `lib/models/history_request_model.dart` | Snapshot of a sent request for history |
| `HistoryMetaModel` | `lib/models/history_meta_model.dart` | Metadata for history entries (timestamp, status) |
| `SettingsModel` | `lib/models/settings_model.dart` | App preferences (theme, window, defaults) |

The core HTTP request/response models (`HttpRequestModel`, `HttpResponseModel`) are defined in the `apidash_core` package.

## Persistent Storage (Hive)

API Dash uses Hive, a lightweight NoSQL database optimized for Flutter.

### Storage Boxes

| Box Name | Type | Content |
|----------|------|---------|
| `apidash-data` | Normal | Request models (full request data) |
| `apidash-environments` | Normal | Environment variable sets |
| `apidash-history-meta` | Normal | History metadata (dates, status codes) |
| `apidash-history-lazy` | Lazy | Full history request data (loaded on demand) |
| `apidash-dashbot-data` | Lazy | Dashbot AI conversation data |

### HiveHandler API

The `HiveHandler` class in `lib/services/hive_services.dart` provides all data access:

```dart
class HiveHandler {
  // Request CRUD
  dynamic getIds();
  void setIds(List<String> ids);
  dynamic getRequestModel(String id);
  void setRequestModel(String id, Map<String, dynamic> data);
  void removeRequestModel(String id);

  // Environment CRUD
  dynamic getEnvironmentIds();
  dynamic getEnvironment(String id);

  // History (lazy-loaded)
  dynamic getHistoryIds();
  dynamic getHistoryMeta(String id);
  dynamic getHistoryRequest(String id);
}
```

### Data Location

- **Desktop:** User-selected workspace folder.
- **Mobile:** App documents directory (managed by OS).
- **Web:** Browser localStorage (via `apidash_core`).

## Code Generation System

The code generation module at `lib/codegen/` converts request configurations into runnable code. See [Adding a New Code Generator](./adding_codegen.md) for instructions on extending this system.

### Architecture

```
Codegen class (lib/codegen/codegen.dart)
  ├── getCode(CodegenLanguage, HttpRequestModel) → String
  └── Switch on language enum → delegate to language-specific class
      ├── PythonRequests (lib/codegen/python/requests.dart)
      ├── DartHttpCodeGen (lib/codegen/dart/http.dart)
      ├── ... (30+ implementations)
      └── Each class uses Jinja templates for code output
```

### Template Pattern

Each language generator uses **Jinja templates** (via `package:jinja`) with conditional blocks:

```dart
final String kTemplateStart = """import requests
{% if hasFormData %}from requests_toolbelt import MultipartEncoder
{% endif %}
url = '{{url}}'
""";
```

## Import System

The import module at `lib/importer/` supports Postman, cURL, Insomnia, and HAR formats. Parsing is delegated to dedicated packages under `packages/`:

```
User selects file → Import dialog →
  Importer.getHttpRequestModelList(format, content) →
    Format-specific parser (curl_parser, postman, insomnia_collection, har) →
      List<HttpRequestModel> →
        Added to collection via CollectionStateNotifier
```

## Packages Overview

The monorepo contains reusable packages managed by Melos:

| Package | Purpose |
|---------|---------|
| `apidash_core` | Core models, HTTP client, utilities shared across the app |
| `apidash_design_system` | Material 3 design tokens, reusable UI components |
| `curl_parser` | Parse cURL commands into request models |
| `postman` | Parse Postman Collection v2.1 files |
| `insomnia_collection` | Parse Insomnia v4 exports |
| `har` | Parse HTTP Archive v1.2 files |
| `genai` | AI provider integration (model management, API calls) |
| `better_networking` | Enhanced HTTP client with interceptors |
| `json_explorer` | Interactive JSON viewer widget |
| `json_field_editor` | JSON field editor widget |
| `multi_trigger_autocomplete_plus` | Multi-trigger autocomplete for env variables |
| `seed` | Seed utilities |

## Desktop vs. Mobile

API Dash adapts its layout based on screen size:

```dart
if (context.isMediumWindow) {
  // Mobile layout — stacked tabs, touch-friendly
} else {
  // Desktop layout — split panes, keyboard shortcuts
}
```

Key differences:
- **Desktop:** Resizable split pane with collection sidebar and editor side-by-side. Drag handles for reordering.
- **Mobile:** Tab-based navigation with full-screen views. Long-press for drag-to-reorder with a delay for scroll disambiguation.

## Key Patterns

### UUID Generation
All requests, environments, and history entries use UUIDs as identifiers:
```dart
final id = getNewUuid(); // From lib/utils/utils.dart
```

### Immutable State Updates
Riverpod state is always replaced, never mutated:
```dart
// Correct: create a new map
state = {...state!, id: updatedModel};

// Incorrect: mutating in place
// state![id] = updatedModel;
```

### Platform Checks
```dart
// From lib/consts.dart
final kIsWindows = !kIsWeb && Platform.isWindows;
final kIsMacOS = !kIsWeb && Platform.isMacOS;
final kIsLinux = !kIsWeb && Platform.isLinux;
final kIsMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
final kIsDesktop = !kIsWeb && (kIsWindows || kIsMacOS || kIsLinux);
```

## Further Reading

- [How to Run API Dash Locally](./setup_run.md)
- [How to Run Tests](./testing.md)
- [Adding a New Code Generator](./adding_codegen.md)
- [Platform-Specific Instructions](./platform_specific_instructions.md)
- [OAuth Authentication Limitations](./oauth_authentication_limitations.md)
