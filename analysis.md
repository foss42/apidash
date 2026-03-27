## 1. Full Repository Architecture (Top‑Level Structure)

At the root (`d:\apidash`) you effectively have a **Flutter monorepo**:

- **`lib/`**  
  Main Flutter application code. This is the heart of API Dash: UI, state management, request/response workflow, DashBot, codegen, agentic tools, storage integration, etc.

- **`packages/`**  
  A set of reusable Dart/Flutter packages, used both by the app and (potentially) externally:
  - **`apidash_core/`**: Core shared types and utilities (HTTP models, environment model, import/export helpers, curl/OpenAPI/Postman/Insomnia, genai re‑exports, etc.).
  - **`apidash_design_system/`**: Design system tokens and widgets (buttons, dropdowns, textfields, etc.) used throughout the main app.
  - **`better_networking/`**: HTTP abstraction over `package:http` with:
    - `HttpRequestModel` / `HttpResponseModel` (freezed data models)
    - Auth models (basic, bearer, API key, digest, OAuth1/2, JWT)
    - Streaming support, GraphQL helpers, an `HttpClientManager` and `sendHttpRequest` / `streamHttpRequest`.
  - **`genai/`**: General AI/LLM abstraction layer and agentic engine:
    - `AIRequestModel` and model config types.
    - Provider implementations for **OpenAI, Azure OpenAI, Gemini, Anthropic, Ollama**.
    - Utilities (`executeGenAIRequest`, streaming, model discovery, etc.).
  - **`json_explorer/`**: JSON tree viewer (used for the JSON response viewer).
  - **`json_field_editor/`**: JSON text field/editor utilities (syntax highlighting, editing).
  - **`curl_parser/`**: Parse cURL commands into structured models.
  - **`har/`**: HAR format models & utilities.
  - **`postman/`**: Postman collection models & import.
  - **`insomnia_collection/`**: Insomnia v4 collection import models/utils.
  - **`seed/`**: Small support models like `NameValueModel`, `FormDataModel`.

- **`test/`**  
  Extensive unit and widget tests for main app (requests, history, widgets, DashBot, providers, codegen, utils, terminal, etc.) plus some tests for integration with sub‑packages.

- **`integration_test/`**  
  Flutter integration tests, e.g. `integration_test/mobile/env_manager_test.dart` for environment handling on mobile.

- **`assets/`**  
  Static assets referenced in `pubspec.yaml`:
  - `assets/intro.md` – intro content.
  - Plus at runtime: GIF/Lottie animations (`sending.json`, `saving.json`, etc.), dashbot assets, icons, etc., all under `assets/` and `assets/dashbot/` (paths declared in `pubspec.yaml`).

- **`doc/`**  
  Project documentation:
  - `dev_guide/`: architecture, testing, packaging, codegen extension guides, OAuth limitations, etc.
  - `user_guide/`: request guide, codegen guide, environment guide, history, dashbot, scripting, importing, instructions to run generated code, SSL docs.
  - `security/`: SBOM, incident response, commands.
  - `gsoc/`, `proposals/`: GSoC/FOSSHack ideas and applications.

- **Platform directories (`android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`)**  
  These **do not exist in this snapshot** (glob returned 0). The app targets desktop/mobile/web via Flutter, but this repo either:
  - delegates platform scaffolding to another location, or
  - is focused on desktop/mobile where platform scaffolding is managed elsewhere.
  The runtime platform behavior is still handled in Dart via `window_size`, `window_manager`, `video_player`, etc.

- **Misc root files**
  - `pubspec.yaml` / `pubspec.lock` – project manifest and lockfile.
  - `CHANGELOG.md`, `CODE_OF_CONDUCT.md`, `flutter_launcher_icons.yaml`, etc.

---

## 2. `pubspec.yaml` – Dependencies & Architectural Patterns

Key points from `pubspec.yaml`:

```12:107:pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  apidash_core:
    path: packages/apidash_core
  apidash_design_system:
    path: packages/apidash_design_system
  ...
  flutter_riverpod: ^2.5.1
  hooks_riverpod: ^2.5.2
  provider: ^6.1.2
  hive_ce_flutter: ^2.3.3
  shared_preferences: ^2.5.2
  better_networking (via apidash_core/genai -> path dep)
  genai (via apidash_core)
  curl_parser, json_explorer, json_field_editor, har, postman, insomnia_collection
  jinja, code_builder, dart_style  (templating / code generation)
  flutter_js, printing, just_audio, video_player, lottie, flex_color_scheme, ...
```
`
### Architectural implications

- **State management**
  - **Primary:** `flutter_riverpod` / `hooks_riverpod`.
  - `provider` is used in isolated spots (e.g., `JsonPreviewer` uses plain `Provider`/`ChangeNotifier` internally).
  - State is organized into **feature‑centric Riverpod providers** under `lib/providers/` and `lib/dashbot/providers/`.

- **Networking**
  - `better_networking` is the main **HTTP engine**, providing:
    - `HttpRequestModel` / `HttpResponseModel`
    - `sendHttpRequest` / `streamHttpRequest`
    - auth handling, GraphQL helpers, SSE streaming, etc.
  - Used both for **API requests** and **LLM calls** (in `genai`).

- **Serialization & models**
  - `freezed` + `json_serializable` + `json_annotation` for data classes and JSON.
  - Many models coded `@freezed` in core packages and app models.

- **Persistence**
  - `hive_ce_flutter` – local DB for:
    - requests/collections
    - environments
    - history meta+lazy body storage
    - DashBot chat history
  - `shared_preferences` – user settings and onboarding flag.

- **AI / LLM abstraction**
  - `genai` + `ollama_dart` + `better_networking`:
    - Multi‑provider LLM abstraction over OpenAI, Azure, Gemini, Anthropic, Ollama.
    - Central `AIRequestModel` and `ModelProvider` implementations.
  - `stac` – used by “agentic services” for UI generation / API tooling.

- **Code generation**
  - `code_builder`, `dart_style`, `jinja` – used to build language‑specific code templates for request codegen and specialized agents (APITool templates etc.).

- **UI toolkit**
  - `apidash_design_system` – custom design system (tokens & widgets).
  - `flex_color_scheme` – theming.
  - `flutter_code_editor`, `flutter_highlight` / `highlighter` – code editors & syntax highlighting.
  - `multi_split_view`, `data_table_2`, etc. – layout and tables.
  - `json_explorer`, `json_field_editor` – JSON viewers/editors.
  - `desktop_drop`, `file_selector`, `window_manager`, `window_size` – desktop UX.

Overall patterns:

- **Riverpod‑driven, provider‑based architecture** with a clear split between:
  - `models` (pure data)
  - `providers` (state + mutations)
  - `services` (I/O, persistence, platform)
  - `widgets` and `screens` (UI)
  - `dashbot`, `codegen`, `apitoolgen`, `agentic_services` (higher‑level features on top).

---

## 3. `lib/` Directory – Folder‑by‑Folder and File‑by‑File (Key App Code)

### 3.1 Root `lib/` files

- **`main.dart`**  
  Application entrypoint:

```12:43:lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Stac.initialize();

  //Load all LLMs
  await ModelManager.fetchAvailableModels();

  var settingsModel = await getSettingsFromSharedPrefs();
  var onboardingStatus = await getOnboardingStatusFromSharedPrefs();
  final initStatus = await initApp(
    kIsDesktop,
    settingsModel: settingsModel,
  );
  if (kIsDesktop) {
    await initWindow(settingsModel: settingsModel);
  }
  if (!initStatus) {
    settingsModel = settingsModel?.copyWithPath(workspaceFolderPath: null);
  }

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(settingsModel: settingsModel),
        ),
        userOnboardedProvider.overrideWith((ref) => onboardingStatus),
      ],
      child: const DashApp(),
    ),
  );
}
```

  - Initializes Flutter, Stac (agent framework), model discovery via `ModelManager.fetchAvailableModels()` (Ollama discovery).
  - Pulls settings and onboarding status from `SharedPreferences`.
  - Calls `initApp` to open Hive boxes and auto‑clear history.
  - Initializes desktop window if relevant.
  - Boots **Riverpod** `ProviderScope` with overridden `settingsProvider` and `userOnboardedProvider`.
  - `DashApp` (in `app.dart`) is the top‑level `MaterialApp`.

  Helper functions:
  - `initApp` – configures GoogleFonts, opens Hive boxes, runs history retention cleanup.
  - `initWindow` – sets up the desktop window via `window_services.dart`.

- **`app.dart`**  
  Contains two central widgets:

  - **`App`** (desktop window aware shell):
    - A `ConsumerStatefulWidget` that implements `WindowListener`.
    - On init: sets `windowManager.setPreventClose(true)` so closing goes through custom UX (prompt to save unsaved changes).
    - `onWindowResized`/`onWindowMoved` update `SettingsModel` in `settingsProvider` with window size & position.
    - `onWindowClose`:
      - If `settings.promptBeforeClosing` and `hasUnsavedChangesProvider` are true, shows a dialog to save or discard.
      - On save, calls `collectionStateNotifierProvider.notifier.saveData()`.
    - `build` chooses between `MobileDashboard` or `Dashboard` based on `context.isMediumWindow`.

  - **`DashApp`**:
    - Builds `MaterialApp` with light/dark themes from design system.
    - Decides **home**:
      - If `kIsDesktop` and `workspaceFolderPath == null` → `WorkspaceSelector`, which on continue calls `initHiveBoxes` with path and updates `SettingsModel.workspaceFolderPath`.  
      - Else:
        - On non‑Linux desktop: `App` (desktop dashboard).
        - On mobile: optionally show `OnboardingScreen`, then `MobileDashboard`.

- **`consts.dart`**  
  Core constants and config:

  - URLs (`kDiscordUrl`, `kGitUrl`, `kLearnScriptingUrl`).
  - Asset keys (`kAssetIntroMd`, `kAssetSendingLottie`, etc.).
  - Platform flags: `kIsMacOS`, `kIsWindows`, `kIsLinux`, `kIsMobile`, etc.
  - Window/layout constants & global `GlobalKey<ScaffoldState>` for home/env/history.
  - `HistoryRetentionPeriod` enum and label/icon metadata.
  - `CodegenLanguage` enum (full list of supported languages; label, highlight language, file extension).
  - `ImportFormat` enum (curl, Postman, Insomnia, HAR).
  - `ResponseBodyView` enum and sets of allowed views per MIME type.
  - `kResponseBodyViewOptions` map: content-type → `ResponseBodyView` options.
  - `kCodeHighlighterMap` mapping subtypes to syntax languages.
  - `kResponseCodeReasons`: HTTP status code → reason phrase.

  **This file is central to response visualization: it encodes the policy for which views are shown based on MIME type**.

- **`models/models.dart`**  
  Barrel export for app‑specific models:
  - `history_meta_model.dart`, `history_request_model.dart`, `request_model.dart`, `settings_model.dart`.

- **`providers/providers.dart`**  
  Barrel export of the core Riverpod providers:
  - `ai_providers.dart` (currently commented), `collection_providers.dart`,
    `environment_providers.dart`, `history_providers.dart`,
    `terminal_providers.dart`, `settings_providers.dart`, `ui_providers.dart`,
    `js_runtime_notifier.dart`.

- **`services/services.dart`**
  - Barrel export:
    - `hive_services.dart` – Hive init, box management, `HiveHandler`.
    - `history_service.dart` – automated history cleanup.
    - `window_services.dart` – desktop window initialization and reset.
    - `shared_preferences_services.dart` – settings & onboarding persistence.

- **Other root files**
  - `dashboard.dart` – desktop layout container (`Dashboard`).
  - `screens/`, `widgets/`, `dashbot/`, `terminal/`, `codegen/`, `apitoolgen/`, `templates/`, `utils/` – see below.

---

### 3.2 `lib/models/` – App Models

- **`request_model.dart`**  
  `@freezed` `RequestModel` that wraps the core `HttpRequestModel`/`HttpResponseModel` for the UI:
  - Fields: `id`, `APIType apiType` (rest/graphql/ai), `name`, `description`,
    `requestTabIndex`, `HttpRequestModel? httpRequestModel`, `responseStatus`,
    `message`, `HttpResponseModel? httpResponseModel`, `isWorking`,
    `sendingTime`, `isStreaming`, pre/post scripts, and `AIRequestModel? aiRequestModel`.
  - Used as the **primary unit of work in the collection**.

- **`history_meta_model.dart`**  
  `HistoryMetaModel` with basic metadata for a past response:
  - `historyId`, `requestId`, `APIType`, `name`, `url`, `HTTPVerb method`,
    `responseStatus`, `DateTime timeStamp`.

- **`history_request_model.dart`**  
  `HistoryRequestModel` ties history metadata to actual request/response bodies:
  - `metaData` (`HistoryMetaModel`), `HttpRequestModel?`, `AIRequestModel?`,
    `HttpResponseModel`, pre/post scripts, `AuthModel?`.

- **`settings_model.dart`**  
  Immutable class modeling user settings:
  - Theme (dark), layout (window size/offset, alwaysShowCollectionPaneScrollbar),
    default URI scheme, default codegen language, history retention period,
    active environment, workspace folder path, SSL disabled flag, DashBot flag,
    default AI model (`Map<String, Object?>` persisted).
  - `fromJson`/`toJson` for SharedPreferences; equality and `hashCode` override.

**Interaction:**  
`SettingsModel` is stored in SharedPreferences via `shared_preferences_services.dart` and exposed to UI via `settingsProvider`.

---

### 3.3 `lib/providers/` – Core State Management

All of these use **Riverpod**.

#### 3.3.1 `collection_providers.dart` – Collections & Requests

- `selectedIdStateProvider` – the currently selected request ID.
- `selectedRequestModelProvider` – computes the selected `RequestModel` from `collectionStateNotifierProvider` based on `selectedId`.
- `selectedSubstitutedHttpRequestModelProvider` – returns an `HttpRequestModel` with environment variables substituted (via `substituteHttpRequestModel` and `availableEnvironmentVariablesStateProvider`).
- `requestSequenceProvider` – ordered list of request IDs (for sidebar and ordering).

- **`CollectionStateNotifier`** (`StateNotifier<Map<String, RequestModel>?>`):
  - Constructed with `Ref` and `HiveHandler`.
  - On init:
    - `loadData()` loads all requests from `Hive`:
      - If none -> create a single `RequestModel` with a new id and empty `HttpRequestModel`.
      - Else -> decode each JSON RequestModel, ensuring `httpRequestModel` is non‑null.
    - After load, sets `requestSequenceProvider` and `selectedIdStateProvider` to first ID.
  - Core responsibilities:
    - `add`, `addRequestModel` (e.g., from code or imports).
    - `reorder` (drag‑and‑drop),
    - `remove`, `duplicate`, `duplicateFromHistory`.
    - `clearResponse` (reset response fields).
    - `update` – central mutation method (update HTTP fields, AI fields, scripts, status, etc.).
    - `sendRequest()` – **end‑to‑end HTTP (and AI) execution flow** (detailed in Step 5).
    - `cancelRequest()` – cancels via `cancelHttpRequest`.
    - `clearData()` – resets hive data and state.
    - `loadData()`, `saveData()` – persistence of collection to Hive.
    - `exportDataToHAR()` – uses core’s `collectionToHAR`.
    - `getSubstitutedHttpRequestModel()` – convenience substitution.

This file is the **central orchestrator** for sending requests, streaming responses, writing to history, and feeding terminal logs.

#### 3.3.2 `environment_providers.dart` – Environments & Variables

- `selectedEnvironmentIdStateProvider`, `selectedEnvironmentModelProvider`.
- `activeEnvironmentModelProvider` – the environment currently active in settings + environment state.
- `availableEnvironmentVariablesStateProvider`:
  - Builds `Map<envId, List<EnvironmentVariableModel>>` for active env + global env (id `kGlobalEnvironmentId`).
  - Used in:
    - `selectedSubstitutedHttpRequestModelProvider`
    - request substitution functions
    - agentic/URL env service.

- `environmentSequenceProvider` – ordered environment IDs.

- **`EnvironmentsStateNotifier`**:
  - On init: `loadEnvironments()` from `Hive`.
    - If none → create a default `Global` environment.
  - Methods:
    - `addEnvironment`, `updateEnvironment`, `duplicateEnvironment`, `removeEnvironment`, `reorder`.
    - `saveEnvironments()` – writes env ids and JSON to Hive.

#### 3.3.3 `history_providers.dart` – Request History

- `selectedHistoryIdStateProvider`, `selectedRequestGroupIdStateProvider`.
- `selectedHistoryRequestModelProvider` – currently viewed history request.
- `historySequenceProvider` – groups `HistoryMetaModel` by date (`getTemporalGroups`).

- **`HistoryMetaStateNotifier`**:
  - On init: `loadHistoryMetas()` from Hive; then pick latest request via `getLatestRequestId` and `loadHistoryRequest`.
  - `addHistoryRequest` / `editHistoryRequest` – persist new/updated history requests to lazy Hive box and meta box.
  - `clearAllHistory` – clears and reloads.

#### 3.3.4 `terminal_providers.dart` – In‑App Terminal / Network Logs

- `terminalStateProvider` – `TerminalController` state.

- `TerminalController`:
  - Maintains `TerminalState` with `entries` and index map.
  - Creates `TerminalEntry`s for:
    - `startNetwork` (phase started, with request info & streaming flag).
    - `addNetworkChunk` – SSE/stream body chunks.
    - `completeNetwork` – final status, headers, body preview, duration.
    - `failNetwork` – error messages.
    - `logJs` – logs from JS runtime for user scripts.
    - `logSystem` – system logs for provider errors, etc.
  - `serializeAll` – textual dump of all terminal entries.

#### 3.3.5 `settings_providers.dart` – User Settings & Codegen Defaults

- `codegenLanguageStateProvider` – current UI codegen language (`CodegenLanguage`), default from `SettingsModel`.
- `activeEnvironmentIdStateProvider` – mirrored from `SettingsModel.activeEnvironmentId`.
- `settingsProvider` – `StateNotifierProvider<ThemeStateNotifier, SettingsModel>`.

- **`ThemeStateNotifier`**:
  - Accepts initial `SettingsModel` from main.
  - `update(...)` updates `SettingsModel` and persists it to SharedPreferences via `setSettingsToSharedPrefs`.

#### 3.3.6 `ui_providers.dart` – UI State & Toggles

- Scaffold keys, drawer toggles, nav rail index, “edit mode” IDs (`selectedIdEditStateProvider`), code pane visibility flags, save/clear flags, unsaved changes, terminal badge, search query fields, import format, onboarding status, and `dashbotShowMobileProvider`.

These drive small portions of layout and user interactions.

#### 3.3.7 `js_runtime_notifier.dart` – Scripting Engine

- Wraps **`flutter_js`** runtime and bridges logs to `TerminalController`.
- Supports:
  - Pre‑request script execution:
    - Injects request/environment JSON into JS.
    - Runs user script + core `kJSSetupScript`.
    - Expects `{ request, environment }` JSON from the IIFE.
    - Returns updated `HttpRequestModel` and possibly mutated environment map, which is persisted into environment entities.
  - Post‑response script execution:
    - Injects request, response, environment JSON.
    - Expects `{ response, environment }`.
    - Sanitizes JSON into an `HttpResponseModel` (see `_sanitizeResponseJson`).
- Exposes:
  - `executePreRequestScript`, `executePostResponseScript`.
  - `handlePreRequestScript`, `handlePostResponseScript` that apply env & request/response updates via callbacks.
- Bridges console logs/fatal errors via `_setupJsBridge`, `_handleConsole`, `_handleFatal`.

This is the **scripting subsystem** used in `CollectionStateNotifier.sendRequest()`.

---

### 3.4 `lib/services/` – Persistence & Window

- **`hive_services.dart`**  
  - Defines box names & types (normal/lazy).
  - `initHiveBoxes(initializeUsingPath, workspaceFolderPath)`:
    - If `initializeUsingPath` (desktop + configured workspace), calls `Hive.init(path)` with a workspace‐specific directory.
    - Else uses `Hive.initFlutter()`.
    - Calls `openHiveBoxes()` to open:
      - `kDataBox` – requests/collections and ids.
      - `kEnvironmentBox` – environments and env ids.
      - `kHistoryMetaBox` – history meta info and history ids.
      - `kHistoryLazyBox` – lazy storage of full `HistoryRequestModel`s.
      - `kDashBotBox` – lazy storage for DashBot chat messages.
  - `HiveHandler` – thin wrapper providing high‑level getters/putters for these boxes and `removeUnused()` cleanup.

- **`history_service.dart`**  
  - `autoClearHistory({SettingsModel?})` uses `HistoryRetentionPeriod` to compute a retention date and deletes older history entries from meta + lazy boxes; updates `historyIds` accordingly.

- **`shared_preferences_services.dart`**  
  - Get/set `SettingsModel` JSON (string stored as `settingsModel.toString()` which is JSON).
  - Get/set onboarding completion flag.
  - `clearSharedPrefs()`.

- **`window_services.dart`**  
  - `setupInitialWindow` – center window with size logic based on screen visible frame.
  - `setupWindow` – more general; used on main when `settingsModel` provides stored size/offset.
  - `resetWindowSize` – resets to a centered default.

These services plus the providers define the **persistence and platform behavior** of the app.

---

### 3.5 `lib/widgets/` – Shared UI Widgets

Barrel file `widgets/widgets.dart` re‑exports ~70 widgets. Key groupings:

- **Buttons**
  - `button_send.dart` – send request button, wired to `CollectionStateNotifier.sendRequest()`.
  - `button_clear_response.dart` – calls `clearResponse()` on collection.
  - `button_save_download.dart`, `button_share.dart` – saving/sharing code/response.
  - `button_copy.dart` – generic clipboard copy.
  - `button_repo.dart`, `button_discord.dart`, `button_learn.dart` – open repo/Discord/docs via `url_launcher`.
  - `button_group_filled.dart`, `button_form_data_file.dart` – specialized design‑system buttons.

- **Cards**
  - `card_sidebar_request.dart` – request entry card in sidebar.
  - `card_sidebar_history.dart` – history entry card.
  - `card_sidebar_environment.dart` – environment card in env pane.
  - `card_request_details.dart`, `card_history_request.dart` – details views.

- **Dialogs**
  - `dialog_about.dart` – about app.
  - `dialog_import.dart` – import dialog for cURL, Postman, Insomnia, HAR.
  - `dialog_history_retention.dart`, `dialog_ok_cancel.dart`, `dialog_rename.dart`, `dialog_text.dart`.

- **Menus / dropdowns**
  - `dropdown_http_method.dart`, `dropdown_content_type.dart`, `dropdown_import_format.dart`, `dropdown_codegen.dart`.
  - `popup_menu_api_type.dart`, `popup_menu_uri.dart`, `popup_menu_env.dart`, `popup_menu_history.dart`.
  - `menu_header_suggestions.dart`, `menu_item_card.dart`, `menu_sidebar_top.dart`.

- **Editors & text**
  - `editor.dart` – general text editor aggregated across parts.
  - `editor_json.dart` – JSON editor.
  - `editor_code.dart` – code editor using `flutter_code_editor`.
  - `markdown.dart` – Markdown rendering via `flutter_markdown`.
  - `text_simple.dart`, `texts.dart`, `text_highlighted_selectable.dart`.

- **Tables**
  - `table_request.dart`, `table_request_form.dart` – main request header/param/form data table views using `DataTable`/`data_table_2`.
  - `table_map.dart` – generic key/value table.

- **Previewers (core of response visualization)**
  - `previewer.dart` – central pass‑through:
    - For JSON (`application/json`), uses `JsonPreviewer` (from `json_explorer`).
    - For images, renders `Image.memory` or `SvgPicture`.
    - For `application/pdf`, uses `PdfPreview` (`printing`).
    - For audio, uses `Uint8AudioPlayer`.
    - For text/csv, uses `CsvPreviewer`.
    - For `video/*`, uses `VideoPreviewer`.
    - Else, shows an `ErrorMessage` with “raise issue” template.
  - `previewer_json.dart` – JSON tree viewer built on `json_explorer` with:
    - search, highlight, expand/collapse, copy actions, link recognition.
  - `previewer_code.dart` – syntax-highlighted code view with `highlighter`.
  - `previewer_video.dart` – video playback via `video_player` and `fvp`.
  - `previewer_csv.dart` – CSV to `DataTable` in nested scrolls.

- **Response widgets**
  - `response_body.dart`:
    - Accepts `RequestModel` and ensures response exists.
    - Derives `MediaType` from `HttpResponseModel.mediaType` or `text/plain`.
    - Determines allowed `ResponseBodyView`s via `getResponseBodyViewOptions(mediaType)` or special case for `APIType.ai`.
    - Handles SSE by flattening `sseOutput` into multiline string and sets `formattedBody`.
    - Creates `ResponseBodySuccess` with bytes, body, `formattedBody`, highlight language, SSE output, and `aiRequestModel`/flags.
  - `response_body_success.dart`:
    - Handles segmentation between Preview / Code / Raw / Answer / SSE.
    - Contains buttons for copy/share/save, and uses `Previewer`, `CodePreviewer`, `SSEDisplay`.
  - `sse_display.dart`:
    - Special SSE viewer:
      - When `aiRequestModel` non‑null: parse SSE JSON fragments and decode via `AIRequestModel.getFormattedStreamOutput`, concatenating text.
      - Otherwise: show per‑chunk JSON or raw string in cards.
  - `response_headers.dart`:
    - Renders response + request headers in tables (`MapTable`) with copy support.

- **Layout / split views**
  - `splitview_dashboard.dart`, `splitview_history.dart`, `splitview_drawer.dart`, `splitview_equal.dart` – different multi‑pane layouts.

- **Other**
  - `workspace_selector.dart` – used in desktop mode to choose workspace path.
  - `widget_not_sent.dart` / `widget_sending.dart` – states for pre/post send.
  - `tabbar_segmented.dart`, `tab_label.dart`.
  - `drag_and_drop_area.dart` – generic DnD area used for import and file‑based inputs.

> **Interaction**: Widgets are mostly **presentational** and rely on Riverpod providers for data/state; e.g. `CopyButton` uses `Clipboard`, `ResponseBodySuccess` introspects `MediaType` and uses specialized previewers.

---

### 3.6 `lib/screens/` – Application Screens

Key structure (from `lib/screens/screens.dart`):

- **`dashboard.dart`** (already seen): root desktop layout with:
  - Nav rail (Requests, Variables, History, Logs, Settings).
  - `IndexedStack` with:
    - `HomePage()` – requests UI.
    - `EnvironmentPage()` – environment variables manager.
    - `HistoryPage()` – history.
    - `TerminalPage()` – terminal/logs.
    - `SettingsPage()` – UI for `SettingsModel`.
  - DashBot FAB: if DashBot is enabled, not active but popped, shows floating button which launches overlay (`showDashbotWindow`).

- **`home_page/`**
  - `home_page.dart`:
    - On desktop: `DashboardSplitView(sidebarWidget: CollectionPane, mainWidget: RequestEditorPane)`.
    - On mobile: full‑screen `RequestResponsePage`.
  - `collection_pane.dart`:
    - Left sidebar listing collection of `RequestModel`s.
    - Uses `collectionStateNotifierProvider` and `requestSequenceProvider`.
  - `editor_pane/`:
    - `editor_pane.dart` → `RequestEditor`.
    - `request_editor_top_bar.dart` – top controls (send, save, DashBot toggle, etc.).
    - `url_card.dart` – input for URL and method via `DropdownHttpMethod` & `FieldUrl`.
    - `details_card/details_card.dart` – wraps `EditRequestPane`.
    - `details_card/request_pane/` – main editor for request details:
      - `request_pane.dart` – orchestrates layout between Request/Response/Code tabs when DashBot floating vs pinned.
      - `request_pane_rest.dart`, `request_pane_graphql.dart`, `request_pane_ai.dart` – specialized for each `APIType`.

  - **REST editor** (`EditRestRequestPane`):
    - Reads `selectedId`, `codePaneVisible`, `requestTabIndex`, header/param/body counts, pre/post script lengths and auth presence from `selectedRequestModelProvider`.
    - Renders a `RequestPane` with tab labels and per‑tab widgets:
      - `EditRequestURLParams` (headers, query params).
      - `EditAuthType` (Auth UI).
      - `EditRequestHeaders`.
      - `EditRequestBody`.
      - `EditRequestScripts` (pre/post JS script editors).
    - Handles toggling code pane visibility and storing `requestTabIndex` via `CollectionStateNotifier.update`.

  - **GraphQL editor** (`EditGraphQLRequestPane`):
    - Similar but tabs: Headers, Auth, Query, Scripts, using `hasQuery` flag.

  - **AI editor** (`EditAIRequestPane`):
    - Tabs: Prompt, Authorization, Configurations.
      - `AIRequestPromptSection()` – user/system prompt editing.
      - `AIRequestAuthorizationSection()` – API key & endpoint configuration for `AIRequestModel`.
      - `AIRequestConfigSection()` – slider/field UI for temperature, top‑p, max tokens, etc., via genai widgets.

- **`envvar/`**
  - `environment_page.dart` plus:
    - `environments_pane.dart` – environment list.
    - `environment_editor.dart` – edit env name and values.
    - `editor_pane/variables_pane.dart` & `variables_tabs.dart` – UI around variable lists.
    - `editor_pane/secrets_pane.dart` – separate secrets handling.

- **`history/`**
  - `history_page.dart` – similar split layout as requests view but for history.
  - `history_sidebar.dart` – groups `HistoryMetaModel`s by date for navigation.
  - `history_viewer.dart`, `history_requests.dart`, `history_details.dart` – main history view.
  - `history_widgets/` – common widgets (`his_sidebar_header`, `his_url_card`, `his_response_pane`, `his_request_pane`, `his_scripts_tab`, `his_bottombar`) for history detail.

- **`terminal/terminal_page.dart`**
  - UI over `terminalStateProvider` to display network/JS/system logs and filter levels (`terminal/widgets/terminal_tiles.dart`, `terminal_level_filter_menu.dart`).

- **`settings_page.dart`**
  - Configures theme, retention, workspace, SSL, DashBot, default codegen, default AI model, etc., via `settingsProvider`.

- **`common_widgets/`**
  - AI:
    - `ai/ai.dart`, `ai_model_selector.dart`, `ai_model_selector_button.dart`, `ai_model_selector_dialog.dart`.
    - `AIModelSelector` uses `AIModelSelectorButton` to open a dialog for selecting provider/model and editing AI configs. On change, updates `RequestModel.aiRequestModel` or `SettingsModel.defaultAIModel`.
  - Auth:
    - `auth/` – subwidgets for Basic, Bearer, API Key, OAuth1, OAuth2, JWT fields with a shared `auth_page.dart` and `consts.dart`/`utils.dart`.
  - Environment:
    - `envfield_*` widgets to embed env variable triggers into URL/auth headers.
    - `envvar_indicator`, `envvar_popover`, `env_trigger_field`, `env_trigger_options`, `env_regexp_span_builder`, `envvar_span` – dynamic inline env highlighting & editing.
  - Shared:
    - `editor_title`, `editor_title_actions`, `button_navbar`, `sidebar_header`, `sidebar_save_button`, `code_pane.dart` (view code panel), `api_type_dropdown.dart`, `envvar_indicator`, `envvar_popover`, etc.
  - Agentic UI:
    - `agentic_ui_features/ai_ui_designer` (framework selector, SDUI renderer, generate UI dialog).
    - `agentic_ui_features/tool_generation` (generate tool dialog, generated tool code copy).

- **`mobile/`**
  - `mobile.dart` – `MobileDashboard` wrapper.
  - `dashboard.dart` – mobile layout.
  - `navbar.dart` – bottom nav bar.
  - `widgets/page_base.dart`.
  - `requests_page/` – `RequestResponsePage`, `request_tabs`, bottom bar.

- **`screens/common_widgets/ai/ai.dart`** is **also imported by DashBot** to reuse `AIModelSelectorButton` for DashBot’s header.

---

### 3.7 `lib/terminal/` – Terminal Models and Widgets

- `enums.dart` – `TerminalSource` (network/js/system), `TerminalLevel` (info/warn/error).
- `models/models.dart`:
  - `TerminalEntry` – one log entry with `source`, `level`, `NetworkLogData`, `JsLogData`, `SystemLogData`.
  - `NetworkLogData` – phase (started, progress, completed, failed), request/response info, SSE chunks.
  - `BodyChunk` – streaming response fragment.
  - `SystemLogData`, `JsLogData` – associated details.

- `widgets/widgets.dart` – exports:
  - `terminal_tiles.dart` – list tiles for logs.
  - `terminal_level_filter_menu.dart` – level filter.

Terminal is a **first‐class observability component** for requests, JS scripts, and system messages.

---

### 3.8 `lib/codegen/` – Multi‑Language Code Generation

Files under `lib/codegen/`:

- `codegen.dart` – central router:

```36:124:lib/codegen/codegen.dart
class Codegen {
  String? getCode(
    CodegenLanguage codegenLanguage,
    RequestModel requestModel,
    SupportedUriSchemes defaultUriScheme, {
    String? boundary,
  }) {
    var httpRequestModel = requestModel.httpRequestModel;
    ...
    // coerce URL with scheme
    var rM = httpRequestModel.copyWith(url: url);

    switch (codegenLanguage) {
      case CodegenLanguage.curl:
        return cURLCodeGen().getCode(rM);
      case CodegenLanguage.har:
        return HARCodeGen().getCode(rM, boundary: boundary);
      ...
      case CodegenLanguage.swiftUrlSession:
        return SwiftURLSessionCodeGen().getCode(rM);
    }
  }
}
```

- For each language / HTTP client there is a Dart file (`c/curl.dart`, `dart/http.dart`, `python/requests.dart`, `rust/reqwest.dart`, etc.) implementing a `getCode(HttpRequestModel)` method.

- `codegen_utils.dart` – utility `jsonToPyDict` to convert JSON string into Python dict syntax with `None`/`True`/`False`.

- **UI integration**:
  - `screens/common_widgets/code_pane.dart`:
    - Reads selected `RequestModel` (current or from history).
    - Substitutes env variables.
    - Calls `codegen.getCode` and passes result to `ViewCodePane`.
    - Shows error if codegen for AI or GraphQL is requested (currently not supported).
  - `widgets/previewer_codegen.dart`:
    - `ViewCodePane` – top row with `DropdownButtonCodegenLanguage`, copy/share/save buttons.
    - `CodeGenPreviewer` uses `highlighter` to syntax‑highlight the code.

**Templates live in the Dart code itself** (string builders in these files) rather than external template files.

---

### 3.9 `lib/dashbot/` – DashBot AI System

Structure:

- **`dashbot.dart`** – barrel: exports `dashbot_dashboard.dart`, `dashbot_tab.dart`, `providers/providers.dart`, `utils/utils.dart`.

- **UI overlay: `dashbot_dashboard.dart`**
  - `DashbotWindow` – an overlay window that:
    - Listens to `dashbotWindowNotifierProvider` for state (position, size, hidden/active/popped).
    - When `isHidden == false`, shows a draggable and resizable floating window with:
      - Header bar:
        - DashBot icon (`DashbotIcons`).
        - Title.
        - **AI model selector** (via `AIModelSelectorButton` over `SettingsModel.defaultAIModel`):
          - `onModelUpdated` saves to `SettingsModel.defaultAIModel` (with some fields cleared).
        - Buttons to “pop out” DashBot (`togglePopped`) and close overlay (which also toggles active).
      - Content:
        - A nested `Navigator` keyed by `_dashbotNavigatorKey` and routes generated by `dashbot_router.dart`.
        - Routes:
          - `dashbotDefault` – default info landing / tasks view.
          - `dashbotHome` – main home view with task tiles.
          - `dashbotChat` – full chat (`ChatScreen`), optionally with initial task.

  - `showDashbotWindow` in `dashbot/utils/show_dashbot.dart`:
    - Ensures not already active/popped.
    - Inserts `DashbotWindow` into `Overlay` wrapped in a fresh `ProviderScope`.
    - Toggles active state in `dashbotWindowNotifierProvider`.

- **Routing: `dashbot/routes/dashbot_router.dart` & `dashbot_routes.dart`**
  - `generateRoute(RouteSettings)` maps named routes to pages: `DashbotHomePage`, `DashbotDefaultPage`, `ChatScreen`.
  - `dashbot_active_route_provider.dart` + `dashbot_route_utils.dart` track and change the current route; `DashbotWindow` listens to this provider and navigates `Navigator` accordingly.

- **Models: `lib/dashbot/models/`**
  - `chat_message.dart` – message content (id, text, role, type, optional `List<ChatAction>`).
  - `chat_state.dart` – global chat state:
    - `chatSessions: Map<requestId, List<ChatMessage>>` – chat is scoped per request (or `global`).
    - `isGenerating`, `currentStreamingResponse`, `currentRequestId`, `lastError`.
  - `chat_action.dart` – strongly typed representation of actions the AI can propose:
    - `ChatActionType` (update_field, add_header, apply_curl, apply_openapi, show_languages, download_doc, upload_asset, etc.).
    - `ChatActionTarget` (httpRequestModel, codegen, test, code, attachment, documentation).
    - The action schema is documented in `dashbot_prompts.dart`.
  - `dashbot_window_model.dart` – overlay window position/size/pop state.
  - `chat_attachment.dart` – attachments (e.g., OpenAPI specs).
  - `chat_response.dart` – potentially structured agentic responses (used in tests and additional features).

- **Providers: `dashbot/providers/`**
  - `chat_viewmodel.dart` – main state machine for chat (detailed in Step 7).
  - `dashbot_window_notifier.dart` (+ `g.dart`) – manages overlay window size/position, popped/hidden/active flags.
  - `dashbot_active_route_provider.dart` – tracks top tab / view within DashBot.
  - `attachments_provider.dart` – manages file attachments to chat (OpenAPI uploads).
  - `service_providers.dart` – wires `ChatRemoteRepository`, `UrlEnvService`, `AutoFixService`, `RequestApplyService`.

- **Repository: `dashbot/repository/chat_remote_repository.dart`**

```1:26:lib/dashbot/repository/chat_remote_repository.dart
abstract class ChatRemoteRepository {
  Future<String?> sendChat({required AIRequestModel request});
}
class ChatRemoteRepositoryImpl implements ChatRemoteRepository {
  @override
  Future<String?> sendChat({required AIRequestModel request}) async {
    final result = await executeGenAIRequest(request);
    if (result == null || result.isEmpty) return null;
    return result;
  }
}
```

  - Thin wrapper around `genai.executeGenAIRequest()`.
  - **All DashBot text completions go through this**.

- **Prompts: `dashbot/prompts/` + `dashbot_prompts.dart`**
  - `debug_api_error.dart`, `explain_api_response.dart`, `generate_code.dart`, `generate_test_cases.dart`, `generate_documentation.dart`, `curl_insights.dart`, `openapi_insights.dart`, `codegen_intro.dart`, `general_interaction.dart`.
  - `DashbotPrompts` exposes methods to build these prompts and clearly defines the **action schema**:
    - Output must be strictly JSON:
      ```json
      {
        "explanation": "...",
        "actions": [
          {
            "action": "update_field" | "add_header" | ...,
            "target": "httpRequestModel" | "codegen" | "test" | "code" | "attachment",
            "field": "...",
            "path": "...",
            "value": ...
          }
        ]
      }
      ```
  - These prompts instruct the LLM to **propose actions instead of directly editing state**.

- **Action services: `dashbot/services/actions/*.dart`**
  - `request_apply_service.dart` – maps **curl/openapi action payloads** to actual `HttpRequestModel` modifications or new requests.
    - Contains all the logic to:
      - Convert LLM‑produced JSON payload into `HttpRequestModel`.
      - Decide whether to **apply to selected** or **create new** request.
      - Use `UrlEnvService` to infer and substitute base URLs into environment variables for reuse.
  - `auto_fix_service.dart` – general action applier:
    - Accepts `ChatAction` and delegates to:
      - `_applyFieldUpdate` (url/method/params).
      - `_applyHeaderUpdate` / `_applyHeaderDelete`.
      - `_applyBodyUpdate` / `_applyUrlUpdate` / `_applyMethodUpdate`.
      - `RequestApplyService.applyCurl` / `.applyOpenApi` for more complex flows.

- **Agent / base services: `dashbot/services/base/url_env_service.dart`**
  - Encapsulates logic to:
    - Infer base URLs from full URLs.
    - Map base URLs into environment variables (e.g., `{{BASE_URL}}`), updating `EnvironmentModel`s as needed.

- **DashBot UI widgets: `dashbot/widgets/`**
  - `chat_bubble.dart` – renders user/system chat bubbles and actions.
  - `dashbot_task_buttons.dart` + `home_screen_task_button.dart` – suggestion buttons for tasks (debug, test generation, etc.).
  - `dashbot_action.dart` + `DashbotActionWidgetFactory` – maps `ChatAction` instances to concrete buttons/widgets:
    - `DashbotAutoFixButton`
    - `DashbotApplyCurlButton`
    - `DashbotApplyOpenApiButton` / `DashbotImportNowButton`
    - `DashbotSelectOperationButton`
    - `DashbotGenerateLanguagePicker` (for codegen languages)
    - `DashbotGeneratedCodeBlock` (code block copy UI)
    - `DashbotAddTestButton` (test code).
    - `DashbotUploadRequestButton` (upload OpenAPI, etc.).
  - `openapi_operation_picker_dialog.dart` – UI to pick OpenAPI operations.
  - `dashbot_action_buttons/*.dart` – specialized buttons implementing above.

- **ChatScreen UI: `dashbot/pages/dashbot_chat_page.dart`**
  - `ChatScreen` `ConsumerStatefulWidget`:
    - Maintains text field and scroll controller.
    - Listens to `chatViewmodelProvider` to:
      - Update `_showTaskSuggestions` when generating.
      - Scroll to bottom when streaming or after completion.
    - Renders:
      - List of `ChatBubble`s for `currentMessages`.
      - A streaming bubble when `state.isGenerating` and `state.currentStreamingResponse` not empty.
      - Optionally `DashbotTaskButtons` below messages.
      - Input area with:
        - help button (show/hide tasks),
        - clear chat button,
        - text input (`Ask anything`),
        - send button.
    - On submit:
      - Calls `chatViewmodel.sendMessage(text: ..., type: ChatMessageType.general)`.

- **Core state machine: `dashbot/providers/chat_viewmodel.dart`**

This is the **brain of DashBot**. Highlights:

- Holds reference to Riverpod `Ref`, current request & substituted request, `ChatRemoteRepository`, `PromptBuilder` and `UrlEnvService`.
- `currentMessages` returns session messages keyed by request id (or `global`).
- `sendMessage`:
  - Optionally appends a user message (`countAsUser`).
  - If default AI model not configured and not in import flows → logs system message: `AI model is not configured. Please set one.` and returns.
  - Handles **two special flows** before regular chat:
    - **cURL import flow**:
      - Recognizes `Text` starting with `curl ` and `ChatMessageType.importCurl` or if last system import message is `importCurl`.
      - Calls `handlePotentialCurlPaste(text)` which:
        - Parses the cURL via `Curl.tryParse`.
        - Converts to `HttpRequestModel` using `convertCurlToHttpRequestModel`.
        - Builds a JSON response with actions using `CurlImportService.buildResponseFromParsed`.
        - Optionally asks AI for insights via `DashbotPrompts().curlInsightsPrompt` and `executeGenAIRequest`.
        - Appends a system `ChatMessage` containing the JSON and `actions` list.
    - **OpenAPI import flow**:
      - Uses `_looksLikeOpenApi` and `_looksLikeUrl` to detect:
        - Pasted OpenAPI spec (JSON/YAML).
        - URL referencing a spec.
      - `handlePotentialOpenApiPaste`:
        - Uses `OpenApiImportService.tryParseSpec` to parse.
        - Summarizes spec and meta with `summaryForSpec`, `extractSpecMeta`.
        - Asks AI for insights via `DashbotPrompts().openApiInsightsPrompt`.
        - Builds `picker` JSON with operations, insights, actions via `OpenApiImportService.buildOperationPicker`.
        - Adds system `ChatMessage` with actions for operation selection or apply.
      - `handlePotentialOpenApiUrl`:
        - Fetches via `better_networking.sendHttpRequest` and then same parsing + picker.

  - For **general tasks** (`explainResponse`, `debugError`, `generateTest`, `generateDoc`, `generateCode`, `general`):
    - Builds a **system prompt** via `PromptBuilder.buildSystemPrompt`, including request context and history.
    - Optionally detects language for codegen intros.
    - Clones `AIRequestModel` with system prompt and user prompt and sets `stream` to `false`.
    - Calls `_repo.sendChat` (→ `executeGenAIRequest`).
    - On successful response:
      - Tries to parse JSON via `MessageJson.safeParse`.
      - Extracts `actions` list (if any) and decodes to `List<ChatAction>`.
      - Appends system message with text (raw JSON or explanation) + actions.
    - On null/empty response:
      - `_appendSystem('No response received from the AI.', type);`.
    - On exception: `_appendSystem('Error: $e', type);`.

- `sendTaskMessage` – seeds the chat with a user message generated from `PromptBuilder.getUserMessageForTask(type)` and then calls `sendMessage` with an empty user text (only system prompt).

- `applyAutoFix` – applies `ChatAction`:
  - If `applyOpenApi` or `applyCurl` → call specialized private methods.
  - Else delegate to `autoFixServiceProvider` to apply updates to request model, post‑script, etc.

- `handleOpenApiAttachment` – parse an attached OpenAPI file and call `handlePotentialOpenApiPaste`.

Overall: **DashBot interacts with LLMs via `genai` and translates structured actions into edits on `RequestModel`s and environment models via `AutoFixService`, `RequestApplyService`, and `UrlEnvService`.**

---

### 3.10 `lib/apitoolgen/` & `lib/services/agentic_services/` – Agentic Tool / UI Generation

- **`apitoolgen/request_consolidator.dart`**
  - Defines `APIDashRequestDescription` which:
    - Contains endpoint, method, query params, form data, headers, body (as text or JSON), and response info.
    - `generateREQDATA` returns a **structured textual representation** of a request + response, including typed annotations for JSON/form data.

  This is used to **feed LLM agents** (via `genai` + `stac` + templates) with a concise but fully annotated representation of an API interaction.

- **`services/agentic_services/`**
  - `agents/agents.dart` – barrel for specialized agents:
    - `ApiToolBodyGen` – uses system prompt template `kPromptAPIToolBodyGen` to generate **tool body code** (client function + tool definition).
      - After validation, strips code fences and returns map `{ 'TOOL': validatedResponse }`.
    - `StacToFlutterBot` – uses `kPromptStacToFlutter` to convert STAC specification to Flutter UI code.
    - `ResponseSemanticAnalyser` – uses `kPromptSemanticAnalyser` to provide semantic analysis of responses.
    - `stacgen`, `stacmodifier`, `intermediate_rep_gen`, `apitool_funcgen` – other specialized agents to generate STAC, modify UI, or build intermediate representations.
  - `agent_caller.dart`, `apidash_agent_calls.dart` – orchestrate calling genai agents from the UI features (e.g. AI UI designer, agentic tool generation features shown in `screens/common_widgets/agentic_ui_features`).

- **`templates/templates.dart` + `templates/system_prompt_templates/*`**
  - `system_prompt_templates/apitool_bodygen_prompt.dart` – the text shown earlier:
    - Defines how to fill `TOOL_NAME`, `TOOL_DESCRIPTION`, `TOOL_PARAMS`, `REQUIRED_PARAM_NAMES`, and optionally `INPUT_SCHEMA` for the tool.
  - Additional templates:
    - `apitool_funcgen_prompt.dart`, `intermediate_rep_gen_prompt.dart`, `semantic_analyser_prompt.dart`, `stac_to_flutter_prompt.dart`, `stac_gen_prompt.dart`, `stac_modifier_prompt.dart`, plus `tool_templates.dart` (per‑language tool code skeletons).

**This subsystem is the foundation for “Generate tool” and “AI UI designer” features, and runs on top of genai’s multi‑provider AI abstraction.**

---

## 4. Main Application Entry Flow

Step‑by‑step:

1. **`main()` in `lib/main.dart`**
   - Initializes Flutter bindings.
   - `await Stac.initialize();` – sets up STAC environment for agentic UI features.
   - Loads available LLM models (Ollama) via `ModelManager.fetchAvailableModels()` (genai).
   - Loads `SettingsModel` and onboarding status from SharedPreferences.
   - Calls `initApp(kIsDesktop, settingsModel)`:
     - Disables runtime Google font fetching.
     - Runs `initHiveBoxes` with or without workspace path.
     - If Hive opens successfully:
       - Runs `autoClearHistory` based on `HistoryRetentionPeriod`.
     - Returns bool openBoxesStatus.
   - Desktop: calls `initWindow` with settingsModel’s stored size/offset.
   - If `initApp` failed:
     - Resets `SettingsModel.workspaceFolderPath` to null (forcing workspace selection on next startup).

2. **Run app inside Riverpod `ProviderScope`**
   - Overrides `settingsProvider` to use a `ThemeStateNotifier` seeded with loaded `SettingsModel`.
   - Overrides `userOnboardedProvider` from stored onboarding flag.

3. **`DashApp` in `app.dart`**
   - Builds `MaterialApp`:
     - `theme`/`darkTheme` from `apidash_design_system`.
     - `themeMode` from `SettingsModel.isDark`.
   - Home logic:
     - If desktop and `workspaceFolderPath == null` → `WorkspaceSelector`:
       - On continue:
         - `initHiveBoxes(true, path)`.
         - Update `SettingsModel.workspaceFolderPath`.
       - On cancel: call `windowManager.destroy()`.
     - Else:
       - If not Linux and not mobile: `App` (desktop scaffold).
       - If mobile:
         - If not onboarded: `OnboardingScreen`, on complete: set onboarding flag & provider.
         - Else: `MobileDashboard`.
       - On Linux: uses context size to pick between `MobileDashboard` and `Dashboard`.

4. **`App` (desktop shell)**
   - Listens to window events to store size/position in settings.
   - On close:
     - If `promptBeforeClosing` and `hasUnsavedChanges`:
       - Show dialog “Save Changes”.
       - On Save: `collectionStateNotifierProvider.saveData()` then `windowManager.destroy()`.
       - On No: `windowManager.destroy()`.
     - Else: `windowManager.destroy()`.
   - `build` chooses `MobileDashboard` for small windows or `Dashboard` for larger ones.

5. **`Dashboard` & `HomePage`**
   - `Dashboard`:
     - Nav buttons to Requests/Variables/History/Logs/Settings.
     - Floating DashBot FAB if:
       - DashBot is enabled in settings (`isDashBotEnabled`).
       - DashBot window is *popped* but not currently active.
       - FAB calls `showDashbotWindow`, toggling `dashbotWindowNotifierProvider.isActive` and inserting overlay.
   - `HomePage`:
     - On desktop: `DashboardSplitView(CollectionPane, RequestEditorPane)`.
     - On mobile: `RequestResponsePage`.

6. **`RequestEditor` & `EditRequestPane`**
   - `RequestEditor` chooses layout depending on window size.
   - `EditRequestPane` chooses appropriate editor:
     - `EditRestRequestPane` for REST.
     - `EditGraphQLRequestPane` for GraphQL.
     - `EditAIRequestPane` for AI.
   - For compact layout (when DashBot window pinned), `EditRequestPane` uses `DefaultTabController` with three top tabs: Request / Response / Code.

**DI & state management init:**  
Everything flows from the top `ProviderScope` and `settingsProvider` overrides in `main.dart`, then Riverpod providers (collection/env/history/terminal/settings/ui) are consumed throughout widgets, with no global singletons except:

- `HiveHandler` – global instance created in `hive_services.dart` after boxes opened.
- `httpClientManager` – top in `better_networking`.
- `ModelManager` – static methods for model discovery.

---

## 5. HTTP Request Workflow (REST/GraphQL & AI HTTP Execution)

### 5.1 From User Input to `RequestModel`

1. **User creates/selects a request**
   - Sidebar `CollectionPane` draws from `collectionStateNotifierProvider` and `requestSequenceProvider`.
   - `CollectionStateNotifier.add()` or `.addRequestModel(...)` creates new `RequestModel` with default `HttpRequestModel` (for REST) and adds it to `state` and `requestSequenceProvider`.

2. **User edits request**
   - `EditRestRequestPane` / `EditGraphQLRequestPane` / `EditAIRequestPane`:
     - Each uses `RequestPane` with tabs, and under each tab specialized widgets:
       - URL & params, headers, body, auth, scripts (REST/GraphQL).
       - Prompt, authorization, configurations (AI).
     - These widgets, on user interaction, call `CollectionStateNotifier.update()` to mutate the relevant fields in the `RequestModel.httpRequestModel` or `RequestModel.aiRequestModel`.

3. **Environment substitution (prior to send)**
   - `availableEnvironmentVariablesStateProvider` provides active + global env variables, filtered by `enabled`.
   - `CollectionStateNotifier.getSubstitutedHttpRequestModel` uses `substituteHttpRequestModel` to apply `{{ENV_VAR}}` substitution everywhere.

### 5.2 Send Request: `CollectionStateNotifier.sendRequest()`

The central flow in `collection_providers.dart`:

1. **Pre‑request setup**
   - Get `requestId` from `selectedIdStateProvider`.
   - Hide code pane (`codePaneVisibleStateProvider = false`).
   - Guard: if no request/AI model, return.
   - Copy `RequestModel` to `executionRequestModel`.
   - Determine default URI scheme from `SettingsModel.defaultUriScheme`.
   - Get `EnvironmentModel` for active environment.

2. **Run pre‑request JS script, if any**
   - If `preRequestScript` non‑empty:
     - Calls `jsRuntimeNotifierProvider.handlePreRequestScript` with:
       - `executionRequestModel`,
       - `originalEnvironmentModel`,
       - callback to update environment values in `environmentsStateNotifierProvider`.
     - Receives potentially updated `RequestModel` with modified `HttpRequestModel` and env variables.

3. **Determine API type and HTTP request model**
   - `APIType apiType = executionRequestModel.apiType`.
   - `bool noSSL = SettingsModel.isSSLDisabled`.
   - Compute `HttpRequestModel substitutedHttpRequestModel`:
     - If `APIType.ai`:
       - Use `executionRequestModel.aiRequestModel!.httpRequestModel!` (via genai provider’s `createRequest`).
     - Else:
       - Use `executionRequestModel.httpRequestModel!`.
     - In both, call `getSubstitutedHttpRequestModel` which uses env substitution.

4. **Validation & terminal logging**
   - Validate request via `getValidationResult(substitutedHttpRequestModel)`.
   - If invalid:
     - Log error to terminal (`terminal.logSystem(category: 'validation')`).
     - Set `showTerminalBadgeProvider` true.

   - Start network log entry in terminal:
     - `terminal.startNetwork(apiType, method, url, requestId, headers, body, isStreaming: true)` returns `logId`.

5. **Mark request as working & streaming**
   - Set `RequestModel.isWorking = true` and `sendingTime = now`.
   - `streamingMode = true` (default: streaming first).
   - Call `streamHttpRequest(requestId, apiType, substitutedHttpRequestModel, defaultUriScheme, noSSL)` from `better_networking`.

6. **Process streamed HTTP response**
   - `stream` is a `Stream<(bool? streamOutput, HttpResponse?, Duration?, String?)?>`.
   - For each `rec` from stream:
     - `isStreamingResponse = rec.$1 ?? false`.
     - `response = rec.$2`, `duration = rec.$3`, `errorMessage = rec.$4`.
   - If `isStreamingResponse`:
     - Append chunk body to `HttpResponseModel.sseOutput` and update `time`.
     - Update `RequestModel.httpResponseModel` and `isStreaming = true`.
     - Write `BodyChunk` to `terminal.addNetworkChunk(logId, BodyChunk(...))`.
     - If `historyModel != null`, update history’s `httpResponseModel` in Hive via `historyMetaStateNotifier.editHistoryRequest`.
   - If not streaming → set `streamingMode = false`.

   - `completer` completes with the first `(response, duration, error)` so we can build final summary.

   - On `stream.onDone`, cancel subscription and set `isStreaming` false, mark unsaved.

7. **Finalize response (once stream completes)**
   - Await `final (response, duration, errorMessage) = completer.future`.
   - If `response == null`:
     - Set `RequestModel.responseStatus = -1`, `message = errorMessage`, `isWorking=false`, `isStreaming=false`.
     - `terminal.failNetwork(logId, errorMessage)`.

   - Else:
     - `statusCode = response.statusCode`.
     - Build `HttpResponseModel.fromResponse(response, time, isStreamingResponse)` via `baseHttpResponseModel`.
     - If non‑streaming and `APIType.ai` and status 200:
       - Parse body as JSON (`kJsonDecoder`).
       - Use `executionRequestModel.aiRequestModel?.getFormattedOutput(parsed)` to compute formatted text.
       - Set `HttpResponseModel.formattedBody` to that.
     - Update `RequestModel` with `responseStatus`, `message = kResponseCodeReasons[statusCode]`, `httpResponseModel`, `isWorking = false`.
     - `terminal.completeNetwork(logId, statusCode, headers, bodyPreview, duration)`.

   - Build `HistoryRequestModel` and store:
     - `historyId = getNewUuid()`.
     - `HistoryMetaModel` with method, url, status, timestamp.
     - Full `HttpRequestModel`, `AIRequestModel` (if AI), `HttpResponseModel`, scripts, auth.
     - Use `historyMetaStateNotifier.addHistoryRequest` to persist.

8. **Run post‑response JS script, if any**
   - If `postRequestScript` is non‑empty:
     - Calls `jsRuntimeNotifierProvider.handlePostResponseScript`.
     - May update `HttpResponseModel` and environment variables via callback.

9. **Final state update**
   - Writes new `RequestModel` with final `httpResponseModel` and `responseStatus` into `CollectionStateNotifier.state`.
   - Marks unsaved changes.

**GraphQL requests** use `APIType.graphql` and use specialized GraphQL helpers in `better_networking` (building body with `getGraphQLBody`, content type json, etc.). The rest of the flow is equal.

---

## 6. Response Visualization System

The visualization pipeline flows as:

**HttpResponseModel**  
→ `ResponseBody`  
→ `ResponseBodySuccess`  
→ `Previewer` / `CodePreviewer` / `SSEDisplay` / `AI answer view` / raw text  
→ JSON, media, or textual UI.

### 6.1 Resolving view options

- `ResponseBody`:

```21:79:lib/widgets/response_body.dart
final responseModel = selectedRequestModel?.httpResponseModel;
...
final mediaType = responseModel.mediaType ?? MediaType(kTypeText, kSubTypePlain);

var responseBodyView = selectedRequestModel?.apiType == APIType.ai
    ? (kAnswerRawBodyViewOptions, kSubTypePlain)
    : getResponseBodyViewOptions(mediaType);
var options = responseBodyView.$1;
var highlightLanguage = responseBodyView.$2;

final isSSE = responseModel.sseOutput?.isNotEmpty ?? false;
var formattedBody = isSSE
    ? responseModel.sseOutput!.join('\n')
    : responseModel.formattedBody;
...
return ResponseBodySuccess(
  key: Key("${selectedRequestModel!.id}-response"),
  mediaType: mediaType,
  options: options,
  bytes: responseModel.bodyBytes!,
  body: body,
  formattedBody: formattedBody,
  highlightLanguage: highlightLanguage,
  sseOutput: responseModel.sseOutput,
  isAIResponse: selectedRequestModel?.apiType == APIType.ai,
  aiRequestModel: selectedRequestModel?.aiRequestModel,
  isPartOfHistory: isPartOfHistory,
);
```

- For **AI** responses:
  - Always uses `kAnswerRawBodyViewOptions = [ResponseBodyView.answer, ResponseBodyView.raw]`.
  - `formattedBody` is from `AIRequestModel.getFormattedOutput` or streaming SSE.

- For regular responses:
  - `getResponseBodyViewOptions(mediaType)` uses the large `kResponseBodyViewOptions` map in `consts.dart`:
    - `application/json` → Preview + Raw (with JSON viewer).
    - SSE content types (e.g., `application/x-ndjson`, `text/event-stream`) → SSE + Raw.
    - `image/*` → Preview, sometimes with Raw.
    - `text/*` with special subtypes (csv, html, css, yaml, xml, etc.) choose between Code/Raw/Preview.

### 6.2 Rendering different views

- **`ResponseBodySuccess`** uses `SegmentedButton<ResponseBodyView>` to let user select view.

- When `ResponseBodyView.preview`:
  - Renders `Previewer` with:
    - `type` = `mediaType.type`, `subtype` = `mediaType.subtype`.
    - `hasRaw = options.contains(ResponseBodyView.raw)`.

- **`Previewer`**:
  - If `application/json`:
    - `JsonPreviewer(code: jsonDecode(body))` → uses `JsonExplorer` with search, highlighting, copy.
  - If `image/svg+xml`:
    - Validates via `parseWithoutOptimizers`, shows `SvgPicture.string`.
  - Other images: `Image.memory(bytes)`.
  - PDF: `PdfPreview(build: (_) => bytes, useActions: false)`.
  - Audio: `Uint8AudioPlayer`.
  - CSV: `CsvPreviewer` (DataTable).
  - Video: `VideoPreviewer` (temp file + `video_player`).
  - Else: `ErrorMessage` using `kMimeTypeRaiseIssue` template, optionally showing raw.

- **`ResponseBodyView.code`**:
  - `CodePreviewer` with `formattedBody ?? body`:
    - Uses `highlighter.parse` and `convert` to highlight based on `highlightLanguage`.
    - Truncates long outputs to `kCodePreviewLinesLimit` and suggests raw view for full result.

- **`ResponseBodyView.answer`** (AI only):
  - `SelectableText(formattedBody ?? body)` using `kCodeStyle`.

- **`ResponseBodyView.raw`**:
  - `SelectableText` for raw body or AI body.

- **`ResponseBodyView.sse`**:
  - `SSEDisplay`:
    - For `aiRequestModel != null`:
      - Parses each SSE chunk as JSON; uses `aiRequestModel.getFormattedStreamOutput` to get text; concatenates into a single `Text` scroll view.
    - For non‑AI SSE:
      - For each non‑blank chunk:
        - Try JSON decode; if success, render key/value pairs with styling.
        - Else, show raw text.

### 6.3 Headers & metadata

- `ResponsePaneHeader`:
  - Shows status line `<status>: <reason>`, colored via `getResponseStatusCodeColor`.
  - Shows duration via `humanizeDuration`.
  - Optionally `ClearResponseButton` to clear.

- `ResponseHeaders`:
  - Two sections: Response Headers and Request Headers.
  - Each with `ResponseHeadersHeader` which uses `CopyButton` to copy JSON representation of headers, plus `MapTable` for display.

**Mime type handling and which view is shown is entirely configured via `consts.dart` and `Previewer`.** This is the likely place to integrate additional response types (e.g., new JSON‑based or AI‑specific visualizations).

---

## 7. DashBot AI Workflow (Full Pipeline)

**End‑to‑end:**

User prompt  
→ DashBot UI (`ChatScreen`)  
→ `ChatViewmodel.sendMessage()`  
→ Build `AIRequestModel` (with system prompt & user prompt)  
→ `ChatRemoteRepository.sendChat()` → `genai.executeGenAIRequest()`  
→ HTTP request to LLM (`better_networking`)  
→ `AIRequestModel.getFormattedOutput` using provider’s `outputFormatter`  
→ `ChatViewmodel` wraps response as message (possibly JSON actions)  
→ `ChatBubble` + `DashbotActionWidgetFactory` render UI & actionable buttons  
→ On click: `ChatViewmodel.applyAutoFix()` + `AutoFixService` + `RequestApplyService` modify collection/env/state.

### 7.1 LLM Provider Config & API Keys

- In `genai`:

  - `AIRequestModel`:

```11:53:packages/genai/lib/models/ai_request_model.dart
@freezed
class AIRequestModel with _$AIRequestModel {
  const AIRequestModel._();
  const factory AIRequestModel({
    ModelAPIProvider? modelApiProvider,
    @Default("") String url,
    @Default(null) String? model,
    @Default(null) String? apiKey,
    @JsonKey(name: "system_prompt") @Default("") String systemPrompt,
    @JsonKey(name: "user_prompt") @Default("") String userPrompt,
    @JsonKey(name: "model_configs") @Default(<ModelConfig>[]) List<ModelConfig> modelConfigs,
    @Default(null) bool? stream,
  }) = _AIRequestModel;
  ...
  HttpRequestModel? get httpRequestModel =>
      kModelProvidersMap[modelApiProvider]?.createRequest(this);

  String? getFormattedOutput(Map x) =>
      kModelProvidersMap[modelApiProvider]?.outputFormatter(x);

  String? getFormattedStreamOutput(Map x) =>
      kModelProvidersMap[modelApiProvider]?.streamOutputFormatter(x);
}
```

  - Each **`ModelProvider`** (e.g., `OpenAIModel`, `GeminiModel`, `AnthropicModel`, `AzureOpenAIModel`, `OllamaModel`) has:
    - `defaultAIRequestModel` – default url, default configs.
    - `createRequest(AIRequestModel)` – builds a `HttpRequestModel`:
      - Sets `url` to provider‑specific endpoint.
      - Configures headers and auth:
        - OpenAI/Azure: Bearer or API key header.
        - Gemini: API key as query param.
        - Anthropic: `anthropic-version` header + API key.
        - Ollama: uses `ollama_dart` or HTTP with disabling SSL as needed.
      - Builds JSON body with system prompt and user prompt in provider‑specific schema.
    - `outputFormatter` and `streamOutputFormatter` – parse provider response JSON into plain text.

- **API key handling**:
  - `AIRequestModel.apiKey` holds the current key; set via UI in:
    - AI Request editor (`EditAIRequestPane` + `AIRequestAuthorizationSection`).
    - Possibly persisted in `SettingsModel.defaultAIModel` (depending on what UI exposes; but keys are more commonly request‑level).
  - `ModelProviders` embed key into `HttpRequestModel.authModel` or into query parameters.

- **Model selection**:
  - `AIModelSelector` and `AIModelSelectorButton` UI:
    - Present available models discovered via `ModelManager.fetchAvailableModels()` (Ollama) plus static defaults for others.
    - Allow user to select provider, model, configs (temperature, max tokens, etc.).
    - For the request editor: updates `RequestModel.aiRequestModel`.
    - For DashBot header: updates `SettingsModel.defaultAIModel`.

- **Model discovery**:
  - `ModelManager.fetchAvailableModels`:
    - Fetches installed Ollama models via `sendHttpRequest('OLLAMA_FETCH', APIType.rest, HttpRequestModel(url: '${ollamaUrl}/api/ps', method: GET), noSSL: true)`.
    - Merges Ollama models into `kAvailableModels` static list and returns.

### 7.2 Chat Execution

- `executeGenAIRequest` in `genai`:

```8:26:packages/genai/lib/utils/ai_request_utils.dart
Future<String?> executeGenAIRequest(AIRequestModel? aiRequestModel) async {
  final httpRequestModel = aiRequestModel?.httpRequestModel;
  if (httpRequestModel == null) {
    debugPrint("executeGenAIRequest -> httpRequestModel is null");
    return null;
  }
  final (response, _, _) = await sendHttpRequest(
    nanoid(),
    APIType.rest,
    httpRequestModel,
  );
  if (response == null) return null;
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return aiRequestModel?.getFormattedOutput(data);
  } else {
    debugPrint('LLM_EXCEPTION: ${response.statusCode}\n${response.body}');
    return null;
  }
}
```

- `ChatRemoteRepositoryImpl.sendChat` just forwards to this; `ChatViewmodel` catches null/empty to show “No response received from the AI.”

- `streamGenAIRequest` uses `streamHttpRequest` and SSE decoding for streaming models:
  - Splits SSE `data:` lines.
  - For each data JSON:
    - Calls `aiRequestModel.getFormattedStreamOutput`.
  - `processGenAIStreamOutput` then splits streaming text into words and emits them.

### 7.3 DashBot Chat Logic (`ChatViewmodel`)

- Pre‑send:
  - Appends user message (if `countAsUser`).
  - Branches for `importCurl`/`importOpenApi` flows.
  - Builds `systemPrompt` from `PromptBuilder` for other types.

- Send:
  - If the AI model is not configured, logs: `AI model is not configured. Please set one.` and returns.
  - Clones AI request with prompts and `stream=false`.
  - Marks `isGenerating=true`.
  - Calls `ChatRemoteRepository.sendChat`.
  - On non‑null result:
    - Try `MessageJson.safeParse` (to handle JSON plus extra Markdown fences or text).
    - Extract `actions` array, parse each to `ChatAction`.
    - Append system message with original string (`response`) and actions.
  - On null or empty:
    - `_appendSystem('No response received from the AI.', type);`.
  - On exception: `_appendSystem('Error: $e', type);`.

- Actions:
  - `applyAutoFix` uses `AutoFixService` or specialized `_applyCurl`, `_applyOpenApi`, `_applyTestToPostScript`.

- Clear chat resets `chatSessions[requestId]` and resets DashBot route to base.

### 7.4 Why “No response received from the AI” appears

Because `executeGenAIRequest` **returns `null`** when:

- `aiRequestModel.httpRequestModel` is null (e.g. misconfigured provider or no URL/model).
- HTTP request fails (`response == null`) or non‑200 statuses.

`ChatRemoteRepositoryImpl` carries through that `null` to `ChatViewmodel`, which then prints:

```216:244:lib/dashbot/providers/chat_viewmodel.dart
if (response != null && response.isNotEmpty) {
  ...
} else {
  _appendSystem('No response received from the AI.', type);
}
```

So typical reasons:

- Missing / invalid API key.
- Invalid endpoint/model causing non‑200 response.
- Networking error.

The actual status/body is logged in debug logs (`LLM_EXCEPTION`) and may be visible in the terminal if `sendHttpRequest` produced a network error.

---

## 8. Code Generation System (HTTP Client Code, Tests, Docs)

### 8.1 Request‑based codegen

Already covered: `lib/codegen/` + `Codegen`, `CodePane`, UI in `CodeGenPreviewer`.

- **Where templates live**:
  - Each language file constructs code using string templates and `HttpRequestModel` fields (method, URL, headers, body, form data, auth).
  - Additional transforms (like `jsonToPyDict` for Python).

- **How request data is read**:
  - `CodePane`:
    - Uses `selectedRequestModelProvider` or `selectedHistoryRequestModelProvider` for history mode.
    - Substitutes environment variables via `substituteHttpRequestModel`.
    - Uses `codegen.getCode()` with:
      - `CodegenLanguage` from `codegenLanguageStateProvider`.
      - `defaultUriScheme` from `SettingsModel`.
  - When user switches codegen language, `codegenLanguageStateProvider` is updated and code is regenerated.

### 8.2 Test and documentation generation via DashBot

Although tests/docs are not generated as code from static templates, they are generated via **DashBot actions**:

- `DashbotPrompts.generateTestCasesPrompt`:
  - LLM generates test code (often JS/TypeScript/Python) and returns structured `ChatAction` with:
    - `target: "test"`
    - `value`: code string.

- `ChatViewmodel._applyTestToPostScript`:
  - Takes `ChatAction` with test code (`action.value`).
  - Appends it to `RequestModel.postRequestScript`, preceded by `// Generated Test`.
  - That script can later run in the JS runtime post‑response to assert things.

- `DashbotPrompts.generateDocumentationPrompt`:
  - LLM generates documentation text and possibly `downloadDoc` actions.
  - `DashbotDownloadDocButton` widgets handle storing/triggering doc downloads.

So **code for tests and docs** lives either:

- In JS scripts (post‑response script) or
- In downloaded files generated from action payloads.

---

## 9. Data Storage & Persistence

### 9.1 Collections & requests

- Stored in Hive `kDataBox`:
  - IDs list in `kKeyDataBoxIds`.
  - Each `RequestModel` stored as JSON under its ID.

- Controlled by `HiveHandler` methods:
  - `getIds`, `setIds`.
  - `getRequestModel(id)`, `setRequestModel(id, Map)`.

- `CollectionStateNotifier.saveData()`:
  - Reads `requestSequenceProvider` for ordering.
  - Saves IDs.
  - For each ID:
    - If `SettingsModel.saveResponses` is true → store full `RequestModel.toJson()`.
    - Else → store model with `httpResponseModel` set to null.
  - Invokes `hiveHandler.removeUnused()` to prune orphan keys.

### 9.2 History

- `kHistoryMetaBox`:
  - `kHistoryBoxIds` holds list of history IDs.
  - Each ID maps to `HistoryMetaModel` JSON.

- `kHistoryLazyBox`:
  - Holds full `HistoryRequestModel` JSON keyed by `historyId`.

- `HistoryMetaStateNotifier` handles load, add, edit, clear.

- `autoClearHistory` (on app start):
  - Uses retention period from `SettingsModel.historyRetentionPeriod`.
  - Deletes old history entries from meta & lazy boxes and updates IDs list.

### 9.3 Environments & variables

- `kEnvironmentBox`:
  - `kKeyEnvironmentBoxIds` for environment IDs order.
  - Each environment ID stores `EnvironmentModel` JSON.

- `EnvironmentsStateNotifier`:
  - `loadEnvironments()`, `addEnvironment`, `updateEnvironment`, `duplicateEnvironment`, `removeEnvironment`, `reorder`, `saveEnvironments()`.

### 9.4 DashBot messages

- `kDashBotBox` (lazy box):
  - Stores a JSON string under `kKeyDashBotBoxIds` with past DashBot messages (currently not heavily used in the shown code; may be used by other parts of DashBot/agentic features).

### 9.5 Settings & onboarding

- SharedPreferences keys:
  - `kSharedPrefSettingsKey` – string with JSON from `SettingsModel.toString()`.
  - `kSharedPrefOnboardingKey` – boolean.

Functions:

- `getSettingsFromSharedPrefs()` → `SettingsModel?`
- `setSettingsToSharedPrefs(SettingsModel)`
- `getOnboardingStatusFromSharedPrefs()`, `setOnboardingStatusToSharedPrefs`.

---

## 10. UI Architecture Summary

### 10.1 Main layout (desktop)

- **`DashApp`**:
  - Top‑level `MaterialApp` with theming.

- **`Dashboard`**:
  - Left column nav rail with icons/labels:
    - Requests / Variables / History / Logs / Settings.
  - Right side: `IndexedStack` for each screen.

- **HomePage**:
  - On desktop: split view: left `CollectionPane` (list of requests), right `RequestEditorPane`.
  - On mobile: `RequestResponsePage` combines request editor and response viewer stacked vertically.

- **Request Editor**:
  - For large windows with DashBot popped:
    - Top bar with send & code view toggles.
    - URL card row (method dropdown + URL field).
    - Request details card:
      - For REST:
        - Tabbed editor for Params / Auth / Headers / Body / Scripts.
      - For GraphQL:
        - Headers / Auth / Query / Scripts.
      - For AI:
        - Prompt / Authorization / Configurations.
    - Response pane below: `ResponsePaneHeader` + `ResponseTabView(ResponseBody, ResponseHeaders)`.

  - For small windows or when DashBot pinned:
    - Segmented TabBar (Request / Response / Code) above details.
    - `EditRequestPane` uses a `DefaultTabController` to toggle between them.

### 10.2 Mobile layout

- **`MobileDashboard`** (`lib/screens/mobile`) organizes:
  - Requests/Responses, environments, history in separate pages or bottom navigation.
  - `RequestResponsePage` combines request editor and response viewer stacked vertically.
  - `navbar.dart` provides bottom navigation between sections.

### 10.3 DashBot overlay

- Presented either as:

  - Floating **overlay window** (`DashbotWindow` via `showDashbotWindow`), draggable/resizable on top of `Dashboard`.
  - Or **popped** to full page/side by toggling `dashbotWindowNotifier`.

- Contains its own `Navigator` and routes:
  - A home/task selection view.
  - A `ChatScreen` view with message list and input.

---

## 11. State Management Overview

- **Global state**:
  - **Riverpod** is the primary mechanism:
    - `StateProvider` for simple booleans, ints, IDs.
    - `StateNotifierProvider` for complex state:
      - `CollectionStateNotifier` – request collection.
      - `EnvironmentsStateNotifier` – env collection.
      - `HistoryMetaStateNotifier` – history meta.
      - `TerminalController` – logs.
      - `ThemeStateNotifier` – settings.
      - `JsRuntimeNotifier` – JS runtime & script execution.
      - DashBot:
        - `ChatViewmodel` – chat sessions.
        - `DashbotWindowNotifier` – overlay window state.
        - `AttachmentsProvider`, `DashbotActiveRouteProvider`.

- **State flows**:
  - UI widgets:

    - `ref.watch` to derive data (with `.select` for fine‑grained rebuild avoidance).
    - User interactions call `ref.read(...notifier).method()` to mutate.

  - **Requests**:
    - `Edit*RequestPane` uses Riverpod selectors to compute counters and booleans (e.g. param count).
    - Taps on `TabBar` call `CollectionStateNotifier.update` with `requestTabIndex`.

  - **DashBot**:
    - `ChatScreen` listens to `chatViewmodelProvider` and automatically scrolls on new messages or streaming updates.
    - `ChatViewmodel` uses `ChatRemoteRepository` + `genai` to communicate with external LLMs.

- There is **no global BLoC** or `InheritedWidget` pattern; **Riverpod** covers all.

---

## 12. External API Integrations

Primary external network consumers:

1. **User API Requests**
   - Through `better_networking` → `sendHttpRequest`/`streamHttpRequest`.
   - No specific vendor; user’s target APIs.

2. **LLM Providers (via `genai`)**
   - **OpenAI** – `OpenAIModel`:
     - API: standard OpenAI Chat Completions.
     - HTTP:
       - `url: kOpenAIUrl`.
       - `AuthModel` : type `APIAuthType.bearer`.
       - Body:
         ```json
         {
           "model": "<model>",
           "messages": [
             {"role": "system", "content": "<systemPrompt>"},
             {"role": "user", "content": "<userPrompt or 'Generate'>"}
           ],
           ...modelConfigs,
           "stream": true/false
         }
         ```
       - `outputFormatter` picks `choices[0].message.content`.

   - **Azure OpenAI** – `AzureOpenAIModel`:
     - Similar to OpenAI but endpoint given by user; API key as `api-key` header.

   - **Google Gemini** – `GeminiModel`:
     - API URLs like `kGeminiUrl`.
     - For streaming endpoints: uses `streamGenerateContent` with `alt=sse`.
     - Body with `contents` (user prompts) and `systemInstruction`.
     - `outputFormatter` reads `candidates[0].content.parts[0].text`.

   - **Anthropic** – `AnthropicModel`:
     - `anthropic-version` header, API key.
     - Body with `messages` containing system and user.

   - **Ollama** – `OllamaModel` (not shown but referenced via `ModelManager`):
     - LLM running locally; uses `ollama_dart` or raw HTTP to `kBaseOllamaUrl`.
     - `ModelManager.fetchInstalledOllamaModels` calls `/api/ps` with `noSSL=true`.

3. **Model Discovery**
   - `ModelManager.fetchModelsFromRemote`:
     - Generic `sendHttpRequest('FETCH_MODELS', APIType.rest, HttpRequestModel(url: remoteURL, method: GET))` – remote list of models.

4. **OpenAPI fetch / general HTTP for DashBot**
   - `ChatViewmodel.handlePotentialOpenApiUrl`:
     - Builds an HTTP GET to the spec URL, using `sendHttpRequest` with an `Accept` header for json/yaml.

5. **Windowing and OS utilities**:
   - `window_manager`, `window_size`, `video_player`, `just_audio`, `url_launcher`, etc. – these call external OS services but not remote APIs.

---

## 13. Complete Architecture Diagram (Textual)

**User Interface (Desktop/Mobile – `Dashboard`, `HomePage`, `CollectionPane`, `RequestEditor`, `ResponsePane`, `DashBotWindow`)**  
  ↓ (via buttons, text fields, dropdowns, tabs using `widgets/` and `screens/`)  
**State Management (Riverpod Providers)**  
 - `collection_providers` (requests), `environment_providers`,  
  `history_providers`, `terminal_providers`, `settings_providers`,  
  `ui_providers`, `js_runtime_notifier`, DashBot providers  
  ↓  
**Request Builder & Scripts**  
 - `RequestModel` + `HttpRequestModel` + `AIRequestModel`  
 - Pre‑request JS scripts (via `JsRuntimeNotifier.handlePreRequestScript`)  
  ↓  
**Environment Substitution & Validation**  
 - `substituteHttpRequestModel`, `getValidationResult`,  
  `availableEnvironmentVariablesStateProvider`  
  ↓  
**HTTP Client (better_networking)**  
 - `sendHttpRequest` / `streamHttpRequest`  
 - Auth handling & content type logic  
  ↓  
**Response Parsing & Storage**  
 - `HttpResponseModel.fromResponse`  
 - SSE streaming handling (`sseOutput`)  
 - History creation (`HistoryRequestModel` in Hive)  
 - Post‑response JS scripts (`JsRuntimeNotifier.handlePostResponseScript`)  
  ↓  
**Response Visualization Layer**  
 - `ResponsePaneHeader`  
 - `ResponseBody` → `ResponseBodySuccess`  
 - `Previewer` (JSON, image, audio, video, PDF, CSV)  
 - `CodePreviewer` / `SSEDisplay` / AI answer view + `ResponseHeaders`.  
  ↓  
**Code Generation Layer**  
 - `CodePane` → `Codegen` → language‑specific generators  
  ↓  
**DashBot AI Layer (genai + DashBot)**  
 - `AIModelSelector` & `SettingsModel.defaultAIModel`  
 - `ChatViewmodel` + `ChatRemoteRepository` → `executeGenAIRequest` → LLM  
 - Prompts from `DashbotPrompts`  
 - Parsed `ChatAction`s (using `MessageJson.safeParse`)  
 - `AutoFixService` / `RequestApplyService` / `UrlEnvService`  
  ↓  
**Agentic Tool & UI Generation Layer**  
 - `apitoolgen/APIDashRequestDescription.generateREQDATA`  
 - `agentic_services` agents (`ApiToolBodyGen`, `StacToFlutterBot`, `ResponseSemanticAnalyser`, etc.)  
 - Templates from `templates/*`  
  ↓  
**Persistence Layer**  
 - Hive boxes for requests, environments, history, DashBot  
 - SharedPreferences for settings & onboarding  

---

## 14. Extension Points – Where to Integrate an “OpenResponses Parser”

Assuming **OpenResponses** is a specialized parser/format for AI model responses, you want to integrate it where AI responses are currently parsed and/or formatted.

### 14.1 Current AI response parsing points

1. **LLM provider layer (`genai`)**
   - Each `ModelProvider` defines:
     - `outputFormatter(Map x)` – for non-streaming.
     - `streamOutputFormatter(Map x)` – for streaming (SSE).

2. **`AIRequestModel`**
   - Provides:
     - `getFormattedOutput(Map)` → delegated to provider’s `outputFormatter`.
     - `getFormattedStreamOutput(Map)` → delegated to `streamOutputFormatter`.

3. **General AI requests (Request editor)**  
   - For `APIType.ai` in `CollectionStateNotifier.sendRequest()`:
     - After non‑streaming response:
       ```dart
       final fb = executionRequestModel.aiRequestModel?.getFormattedOutput(
         kJsonDecoder.convert(httpResponseModel?.body ?? "Error parsing body"),
       );
       httpResponseModel = httpResponseModel?.copyWith(formattedBody: fb);
       ```
     - For streaming SSE: `SSEDisplay` uses `getFormattedStreamOutput`.

4. **DashBot structured responses**
   - `ChatViewmodel.sendMessage`:
     - Calls `ChatRemoteRepository.sendChat` (→ `executeGenAIRequest`).
     - Expects a **string** `response`. Then:
       ```dart
       final Map<String, dynamic> parsed = MessageJson.safeParse(response);
       if (parsed.containsKey('actions') && parsed['actions'] is List) {
         actions = ...
       }
       ```
     - `MessageJson.safeParse` uses `jsonDecode` and trims to first `{`..`}` block if the string contains extra Markdown or plain text.

5. **Streaming AI** for DashBot  
   - (Currently, DashBot uses non‑streamed responses, but streaming support is available in `genai` and `SSEDisplay` for AI requests.)

### 14.2 Where to plug an OpenResponses parser

You have **two natural layers**:

#### Option A – Provider-level parsing (genai)

- **Goal:** Treat OpenResponses as the canonical format of AI tool outputs.

- **Changes:**
  - Implement an `OpenResponsesParser` (possibly new package or local util) that:
    - Accepts provider‑specific raw JSON.
    - Returns normalized `OpenResponses` structure, e.g.:

      ```dart
      class OpenResponse {
        final String answer;
        final Map<String, dynamic>? meta;
        final List<OpenAction>? actions; // if needed
        ...
      }
      ```

  - Update `ModelProvider.outputFormatter` and `.streamOutputFormatter` implementations to:
    - Parse provider JSON into `OpenResponse` (instead of plain string).
    - If `AIRequestModel` is extended to hold `bool useOpenResponses`, you can:
      - Return `OpenResponse.toJson()` string or `answer` only depending on UI.

  - Update `AIRequestModel.getFormattedOutput` to expect either:
    - Raw `OpenResponse` JSON (converted to text for display), or
    - The `answer` field from `OpenResponse`.

- **Pros:**
  - Centralizes all LLM parsing in one place.
  - Works for both DashBot and generic AI requests.
- **Cons:**
  - Requires altering genai’s type expectations (`String?` vs structured type),
  - Might break existing tests relying on plain string.

#### Option B – DashBot‑level adapter

- **Goal:** Keep genai’s `executeGenAIRequest` as is, but **post‑process DashBot responses** using OpenResponses.

- **Changes:**
  - Add a new adapter in `ChatViewmodel.sendMessage` after:

    ```dart
    final response = await _repo.sendChat(request: enriched);
    ...
    ```

  - Introduce an `OpenResponsesParser.parse(String response)` that:
    - Attempts to parse `response` into OpenResponses structure:
      - For example, maybe the LLM already returns:

        ```json
        {"answer": "...", "actions": [...], "openresponses": {...}}
        ```

    - Or uses heuristics to find standard OpenResponses keys.

  - Use the parser to:
    - Normalize the **actions** list into `ChatAction`s.
    - Normalize the **answer** string for `ChatBubble`.
    - Optionally store meta data in `ChatMessage` or `ChatState`.

- **Extension points:**
  - `MessageJson.safeParse` is already a generic helper to:
    - Find JSON object in Markdown or raw text.
    - Having an OpenResponses parser call `MessageJson.safeParse` first is natural.

  - After parsing:
    - Build `ChatAction`s out of `openresponses.actions`.
    - Possibly unify `DashbotPrompts` to instruct LLMs to reply in OpenResponses format.

- **Pros:**
  - Does **not** require changing genai or providers.
  - Keeps provider‑specific `outputFormatter` for non‑DashBot usage.
  - Naturally coexists with existing prompts that already enforce JSON structures.

- **Cons:**
  - Only affects DashBot flows; general AI requests remain using current formatting.

Given the architecture, a good approach is:

- **Implement OpenResponses normalization as a standalone Dart module** in `lib/dashbot/utils/` or `packages/genai/lib/utils/`.
- In DashBot:
  - Replace direct usage of `MessageJson.safeParse` in `ChatViewmodel.sendMessage` with:

    ```dart
    final parsed = OpenResponsesParser.tryParse(response);
    if (parsed != null) {
      actions = parsed.toChatActions();
      // message content can be parsed.answer or full JSON
    } else {
      // fallback: MessageJson.safeParse(response) to maintain compatibility
    }
    ```

- For **AI Requests in the Request Editor** (non‑DashBot):
  - After computing `formattedBody` in `CollectionStateNotifier.sendRequest`:
    - Optionally run `OpenResponsesParser.tryParse` on parsed JSON if `apiType == APIType.ai`.
    - Use it to set `HttpResponseModel.formattedBody` to `parsed.answer` or render it differently in `ResponseBodySuccess`.

### 14.3 Files likely to change for OpenResponses integration

- **Core parsing logic**
  - New file: e.g. `lib/dashbot/utils/openresponses_parser.dart` or in `genai`.
  - Update:
    - `lib/dashbot/providers/chat_viewmodel.dart` (`sendMessage` for non‑streaming, plus streaming if you enable `stream=true`).
    - `lib/widgets/sse_display.dart` (if you want streaming AI outputs parsed through OpenResponses instead of provider‑specific formatters).

- **Prompts**
  - `lib/dashbot/prompts/general_interaction.dart` and others to instruct the LLM to output using OpenResponses schema.

- **AI Requests (non‑DashBot)**
  - `lib/providers/collection_providers.dart` in `sendRequest()` for AI branch:
    - Where `formattedBody` is built from `getFormattedOutput`: you’d optionally re-parse.

**Adapters vs providers:**  
- If OpenResponses is provider‑agnostic, **DashBot‑level adapter is the least invasive** and matches the current design where DashBot already expects structured JSON with explanation + actions.  
- If OpenResponses should be used everywhere, implement it at the `ModelProvider.outputFormatter` level and adjust `AIRequestModel` to return an `OpenResponse` (or JSON string representation of it).

---

## Final Consolidated View

**1. Full repository architecture**  
- Flutter app in `lib/` using Riverpod + Hive + SharedPreferences + `better_networking` + `genai`.
- Supporting packages under `packages/` for HTTP, AI, JSON viewing, curl/HAR/Postman/Insomnia, etc.
- Tests in `test/` and `integration_test/`, documentation in `doc/`, assets in `assets/`.

**2. Folder-by-folder & file-by-file**  
- `lib/models/` – Request, History, Settings.
- `lib/providers/` – Riverpod state for collections, environments, history, terminal, settings, UI, JS runtime.
- `lib/services/` – Hive, SharedPreferences, window, history retention.
- `lib/widgets/` – shared UI: buttons, tables, editors, previewers, response widgets, splitviews, workspace selector.
- `lib/screens/` – pages for desktop & mobile (Requests, Variables, History, Terminal, Settings), plus common widgets and agentic UI features.
- `lib/terminal/` – terminal models & UI.
- `lib/codegen/` – language-specific code generators + `Codegen` router.
- `lib/dashbot/` – DashBot overlay, chat, actions, prompts, repositories, services.
- `lib/apitoolgen/` + `lib/services/agentic_services/` + `lib/templates/` – agentic request description, AI tools & STAC UI generation.
- `packages/*` – core infrastructure packages (see section 1 & 2).

**3. Request workflow**  
- Request editor (per API type) → `RequestModel` → env substitution → optional JS pre-script → `better_networking` stream → `HttpResponseModel` & history → optional JS post‑response script.

**4. Response workflow**  
- `HttpResponseModel` → `ResponseBody` → `ResponseBodySuccess` → `Previewer` / `CodePreviewer` / `SSEDisplay` / AI answer view + `ResponseHeaders`.

**5. DashBot AI workflow**  
- Chat UI → `ChatViewmodel` → `ChatRemoteRepository` → `genai.executeGenAIRequest` → provider‑specific `HttpRequestModel` → `better_networking` → raw JSON → `AIRequestModel.getFormattedOutput` → string to DashBot → `MessageJson.safeParse` and `ChatAction` extraction → `AutoFixService` and `RequestApplyService` to modify requests/environments; specialized flows for cURL and OpenAPI imports.

**6. State management**  
- Purely Riverpod with `StateNotifier`s; no BLoC. Providers orchestrate models, services, and UI.

**7. Code generation system**  
- `CodePane` + `Codegen` + per-language generator classes using `HttpRequestModel` templates; agentic tool generation in `agentic_services` using jinja templates and AI.

**8. Data persistence**  
- Hive for collections, environments, history, DashBot stored under workspace path on desktop; SharedPreferences for settings and onboarding.

**9. Extension points**  
- For an **OpenResponses parser**, the most natural integration points are:
  - DashBot’s `ChatViewmodel.sendMessage` (post‑LLM, pre‑`ChatAction` parsing), using `MessageJson.safeParse` as a first step.
  - Optionally, provider `outputFormatter` methods in `genai` and AI branch in `CollectionStateNotifier.sendRequest` for general AI requests and streaming SSE outputs.

