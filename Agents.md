# API Dash Agent Guide

This is the operating guide for agents working in the API Dash repository. Treat it as a working contract, not a static note. If you change behavior, architecture, commands, generated models, storage, package boundaries, or test strategy, update this file and `architecture.md` in the same change.

Scope note: this guide describes the `main` branch architecture. If you are on a feature branch, verify whether the feature is merged before documenting it here. Do not describe branch-only work as mainline behavior.

## First Rules

1. Preserve user work. Check `git status --short` before edits and do not revert unrelated modified or untracked files.
2. Read before changing. Inspect the touched source, nearby tests, root docs, and relevant developer docs before implementing.
3. Prefer the existing architecture. API Dash is a Flutter/Melos monorepo using Riverpod, Hive, Freezed/json_serializable, Jinja templates, and modular packages. Do not introduce another state, storage, routing, networking, or codegen pattern unless the task explicitly requires it.
4. Keep root docs current. Working agents must update `AGENTS.md` and `architecture.md` whenever their changes alter how future agents should understand, test, or extend the system.
5. Keep mainline docs honest. GSoC proposals, local branch files, and unmerged experiments are useful references, but they are not source-of-truth architecture for these root docs.
6. Generated Dart files are build outputs. Edit source model files, then run generation. Do not manually patch `.freezed.dart` or `.g.dart` as the primary fix.
7. Tests should be focused and offline by default. Use in-memory mocks and provider overrides unless the production component specifically requires a scoped loopback server, such as OAuth callback handling.

## Mainline Feature Baseline

The current `main` branch supports:

| Area | Mainline status |
| --- | --- |
| HTTP/REST requests | Supported |
| GraphQL requests | Supported through HTTP POST body construction |
| SSE and streaming HTTP responses | Supported through streaming MIME detection |
| AI requests | Supported through `genai` and `better_networking` |
| Dashbot assistant | Supported |
| cURL, Postman, Insomnia, HAR import | Supported |
| OpenAPI-assisted import | Supported through Dashbot services |
| Code generation | Supported for cURL, HAR, C, C#, Dart, Go, JS, Java, Julia, Kotlin, PHP, Python, Ruby, Rust, Swift |
| Environment Variables | Supported |
| Request History | Supported |

## Repository Map

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Startup: Stac init, model discovery, settings load, Hive init, desktop window init, provider overrides |
| `lib/app.dart` | App shell, theme, workspace selector, desktop/mobile routing, close/save behavior |
| `lib/consts.dart` | App constants, feature labels, codegen language enum, import format enum, response view routing |
| `lib/models/` | App-level Freezed models: request, history, settings |
| `lib/providers/` | Riverpod state for requests, environments, history, settings, UI, terminal, JS runtime |
| `lib/services/` | Hive, shared preferences, history retention, window services, agentic helper calls |
| `lib/screens/` | Feature pages and responsive desktop/mobile page composition |
| `lib/widgets/` | Reusable app widgets and response preview widgets |
| `lib/codegen/` | Request-to-code generation router and language implementations |
| `lib/importer/` | Import dialog and facade over cURL/Postman/Insomnia/HAR parsers |
| `lib/dashbot/` | Dashbot UI, chat state, prompts, actions, OpenAPI/cURL apply flows |
| `lib/terminal/` | Terminal/log data models and terminal widgets |
| `packages/` | Workspace packages shared by the app |
| `test/` | Root app unit and widget tests |
| `integration_test/` | Desktop/mobile integration tests |
| `doc/dev_guide/` | Contributor-facing setup, testing, architecture, and extension guides |
| `doc/proposals/` | Proposal material; not implementation source of truth |

## Package Map

API Dash uses a Melos workspace with the root app plus 12 packages.

| Package | Responsibility |
| --- | --- |
| `packages/seed` | Shared low-level models such as `NameValueModel` and `FormDataModel` |
| `packages/better_networking` | HTTP/GraphQL/SSE execution, auth, request/response models, cancellation, OAuth callback server |
| `packages/genai` | Unified AI request model, provider adapters, model manager, agentic engine |
| `packages/apidash_core` | Import/export adapters, environment model, shared core utilities |
| `packages/apidash_design_system` | Design tokens, typography, themes, context extensions, base widgets |
| `packages/curl_parser` | cURL parsing and Dart-to-cURL conversion helpers |
| `packages/postman` | Postman collection models and parsing utilities |
| `packages/insomnia_collection` | Insomnia export models and parsing utilities |
| `packages/har` | HAR 1.2 models and utilities |
| `packages/json_explorer` | Interactive JSON explorer widget |
| `packages/json_field_editor` | JSON editing, validation, and highlighting widget |
| `packages/multi_trigger_autocomplete_plus` | Multi-trigger autocomplete used for variable entry patterns |

## Standard Commands

Run commands from the repository root unless noted.

Setup:

```bash
dart pub global activate melos
melos bootstrap
melos pub-get
flutter pub get
```

Format and Analyze:

```bash
dart format .
melos analyze
```

Root app tests:

```bash
flutter test --coverage
flutter test test/path/to_test.dart
```

Workspace package tests:

```bash
melos test
melos exec --scope=<package_name> -- flutter test
```

Code generation:

```bash
melos build-gen
dart run build_runner build --delete-conflicting-outputs
```

Run locally:

```bash
flutter run
flutter run -d linux
flutter run -d macos
flutter run -d windows
```

Coverage HTML, when `lcov` is installed:

```bash
genhtml coverage/lcov.info -o coverage/html
```

## Agent Workflow

Start every task with this sequence:

1. Check the active branch and worktree.
2. Identify whether the user wants current branch behavior or `main` branch behavior.
3. Read the current docs and the source files around the target behavior.
4. Find existing tests for the same layer before adding new test patterns.
5. Make the narrowest code/doc change that solves the request.
6. Run the smallest meaningful verification first; broaden when the blast radius is shared or architectural.
7. Update `AGENTS.md` and `architecture.md` if the change affects agent guidance or architecture.
8. Report what changed and which verification ran.

Use `main` as a reference when requested:

```bash
git show main:path/to/file.dart
git ls-tree -r --name-only main
git grep -n "pattern" main -- lib packages test
```

## Git and PR Workflow

When creating branches or opening pull requests on behalf of the user, follow these project conventions based on `CONTRIBUTING.md`:

- **Branch Naming**: Use `add-feature-<name>`, `resolve-issue-<name>`, or `add-test-<name>`.
- **PR Scope**: Prefer precise changes (e.g., adding a single test or resolving one issue) over massive PRs with many unrelated file changes.
- **PR Description**: Include a clear title and description, and reference the corresponding issue (e.g., `#issue-number`).
- **AI Policy**: Mention in the PR description if the contribution is AI-assisted, especially for large or complex changes.

## Local Agent Notes and Subagent Logs

Root docs must stay concise enough to guide future work. They should describe current mainline architecture, commands, decisions that affect many files, and rules agents must follow.

Detailed implementation diaries are allowed, but keep them separate from the root docs:

- Use local task notes for line-by-line reasoning, rejected approaches, subagent findings, temporary hypotheses, command transcripts, and detailed decision trails.
- Prefer a task-scoped path such as `doc/agent_notes/<topic>.md` or another user-specified local note path.
- Mark local notes with branch, date, author/agent, scope, and whether the notes are mainline, branch-only, or scratch.
- Do not cite local notes as source-of-truth architecture unless their content has been promoted into `architecture.md` or relevant developer docs.
- Do not put every line-level change in `architecture.md`; summarize the stable design impact there and put granular logs in local notes.
- If a subagent produces findings, the main agent must review them before converting them into root docs or code changes.

Suggested local note shape:

```markdown
# Agent Note: <topic>

- Branch: <branch>
- Date: YYYY-MM-DD
- Scope: mainline | branch-only | scratch
- Related files: `path/a.dart`, `path/b.dart`

## Decisions

- Decision: ...
  Reason: ...
  Alternatives considered: ...

## Change Log

- `path/file.dart`: changed X because Y.

## Verification

- Command: `flutter test ...`
  Result: pass/fail and relevant details.
```

## Architecture Rules

### State Management

- Riverpod is the state boundary. Providers live in `lib/providers/`.
- Do not mutate Riverpod state in place. Replace maps and lists with copied values.
- Request collection state is a `Map<String, RequestModel>?` owned by `CollectionStateNotifier`.
- Request ordering is separate in `requestSequenceProvider`.
- Selection is separate in `selectedIdStateProvider`.
- UI widgets should read providers and dispatch intent to notifiers. Keep persistence and network work out of widgets.

Correct update pattern:

```dart
state = {...state!, id: updatedModel};
ref.read(requestSequenceProvider.notifier).state = [...updatedIds];
```

Avoid:

```dart
state![id] = updatedModel;
ref.read(requestSequenceProvider).add(id);
```

### Models and Generated Files

- App models live in `lib/models/`.
- Core HTTP, auth, and response models live in `packages/better_networking/`.
- Environment models live in `packages/apidash_core/`.
- AI request models live in `packages/genai/`.
- Models use Freezed/json_serializable unless there is an established local exception, such as `SettingsModel`.
- After changing a Freezed/json_serializable source model, run generation and include the generated files.
- Keep JSON backwards-compatible for persisted Hive data. Add nullable/defaulted fields and migration-safe parsing.

### Persistence

- Hive is the collection, environment, history, and Dashbot persistence layer.
- Use `HiveHandler` from `lib/services/hive_services.dart`.
- Do not write request, environment, history, or Dashbot state directly through raw files or ad hoc storage.
- Root settings live in shared preferences through `lib/services/shared_preferences_services.dart`.
- Desktop workspaces use a user-selected Hive directory. Mobile uses `Hive.initFlutter()`.
- `CollectionStateNotifier.saveData()` controls whether responses are stored, based on `SettingsModel.saveResponses`.

Hive boxes:

| Box | Content |
| --- | --- |
| `apidash-data` | Request collection and request ids |
| `apidash-environments` | Environment models and environment ids |
| `apidash-history-meta` | History metadata and history ids |
| `apidash-history-lazy` | Full history request snapshots |
| `apidash-dashbot-data` | Dashbot conversation data |

### Request Execution

- `CollectionStateNotifier.sendRequest()` is the app-level request execution coordinator.
- It runs pre-request scripts, substitutes environment variables, validates the request, starts terminal logging, calls `streamHttpRequest`, updates request state, writes history, then runs post-response scripts.
- `packages/better_networking/lib/services/http_service.dart` owns HTTP, GraphQL, multipart, auth application, cancellation, and streaming response handling.
- `cancelHttpRequest(id)` delegates to `HttpClientManager`.
- Streaming is MIME-driven through `kStreamingResponseTypes`; do not add protocol-specific behavior in UI widgets.

### Environment Variables

- Environment state is owned by `EnvironmentsStateNotifier`.
- Global variables use `kGlobalEnvironmentId`.
- Active variables are computed by `availableEnvironmentVariablesStateProvider`.
- Substitution should go through `substituteHttpRequestModel`, `substituteVariables`, or related helpers in `lib/utils/envvar_utils.dart`.
- Scripts may update active environment values through the notifier callback.

### Scripts and Terminal

- Pre-request and post-response scripts are JavaScript executed by `JsRuntimeNotifier`.
- The JS runtime injects request, response, and environment data, then sanitizes results before turning them back into typed models.
- Script logs and errors go to `terminalStateProvider`.
- Terminal entries are append-only UI state with structured network, JS, and system payloads.

### UI and Design

- Desktop uses `Dashboard` with a navigation rail and `IndexedStack`.
- Mobile uses `MobileDashboard`, `PageBranch`, bottom navigation, and mobile-specific request/response pages.
- `HomePage` switches between `DashboardSplitView` and mobile `RequestResponsePage` using `context.isMediumWindow`.
- Reusable design primitives belong in `packages/apidash_design_system`.
- Feature widgets belong near their feature under `lib/screens/` or in `lib/widgets/` when they are truly reusable.
- Preserve desktop and mobile behavior unless the task is explicitly platform-scoped.

### Imports

- `lib/importer/importer.dart` is the root import facade for cURL, Postman, Insomnia, and HAR.
- Format-specific parsing belongs in the corresponding package or `packages/apidash_core/lib/import_export/`.
- Importers should return `HttpRequestModel` data and leave collection insertion to app-level state notifiers.
- OpenAPI import assistance currently lives in Dashbot services, not in the generic `ImportFormat` enum.

### Code Generation

- `CodegenLanguage` in `lib/consts.dart` is the enum source of truth.
- `lib/codegen/codegen.dart` is the router.
- Language implementations live under `lib/codegen/<language>/`.
- Most generators use templates and shared codegen utilities.
- Adding a generator requires enum entry, router registration, implementation, UI/dropdown availability if needed, and tests under `test/codegen/`.
- Codegen is for HTTP requests. AI and GraphQL codegen have explicit UI messages that say they are unavailable.

### AI and Dashbot

- AI request execution flows through `packages/genai`.
- `AIRequestModel.httpRequestModel` converts provider-specific AI requests into HTTP requests through provider adapters.
- `executeGenAIRequest` and `streamGenAIRequest` reuse `better_networking`.
- Dashbot chat state lives in `lib/dashbot/providers/chat_viewmodel.dart`.
- Dashbot action application must go through services/notifiers, not directly mutate request maps.
- Prompt construction belongs in `lib/dashbot/services/agent/prompt_builder.dart` and prompt files under `lib/dashbot/prompts/`.

## Testing Rules

General:

- Prefer local, deterministic tests.
- Use existing fixtures in `test/models/` and package test fixture folders.
- Put reusable sample models in dedicated fixture files instead of recreating large objects inline.
- Use `mocktail` and provider overrides for external dependencies.
- Dispose `ProviderContainer` instances in teardown.
- Avoid external network. A scoped loopback server is acceptable only for code whose production contract is loopback-based, and it must bind to loopback, use ephemeral ports when possible, and close in teardown.

Model tests:

- Test `copyWith`, `toJson`, `fromJson`, getters, and immutability assumptions.
- Keep expected JSON in fixture constants.
- Run build generation before asserting generated serialization behavior.

Provider tests:

- Override dependencies with fakes/mocks.
- Verify state replacement, selected ids, sequence providers, unsaved flags, and persistence calls.
- Avoid testing a provider through a full widget tree when a provider container test can isolate the behavior.

Widget tests:

- Match existing widget test style in `test/widgets/` and `test/screens/`.
- Pump with the providers/theme helpers already used in the repo.
- Check desktop and mobile branches when changing responsive layout.

Codegen tests:

- Use existing request fixture models.
- Group by method or language family.
- Compare generated strings exactly with raw multiline expected strings.
- Keep deterministic boundaries where a generator needs multipart boundaries.

Networking tests:

- Test request construction, auth handling, cancellation, streaming, and response conversion at the package layer when possible.
- Keep production HTTP abstractions injectable or mockable.

Dashbot and AI tests:

- Mock `ChatRemoteRepository` or GenAI-facing services.
- Assert actions and request updates rather than relying on real model calls.
- Keep prompt-shape tests focused on the produced context and task text.

## Documentation Maintenance Contract

Every working agent must update docs when a change affects future work. Use this checklist before finishing:

- Did command usage change? Update `AGENTS.md`.
- Did source layout, package responsibility, data flow, model ownership, persistence, or app lifecycle change? Update `architecture.md`.
- Did a feature move from proposal/branch-only to mainline? Update both docs and remove any "not mainline" note that is no longer true.
- Did a generated model add/remove fields? Update architecture model and storage notes if it affects persisted JSON or request flow.
- Did tests establish a new pattern? Add it to this guide.
- Did you rely on a branch-only file? Do not document it as mainline unless the task explicitly asks for branch docs.
- Did you need granular reasoning, every-line change notes, or subagent findings? Put them in local agent notes and summarize only the stable impact in root docs.

Docs should be specific, short enough to stay useful, and tied to real source paths. Avoid broad claims such as "complete rewrite" or "new architecture" unless the repository actually changed that way.

## Common Pitfalls

- Running only `flutter test` and assuming package tests ran. Use `melos test` for packages.
- Editing generated files without updating source models.
- Mutating Riverpod maps/lists in place.
- Saving request data outside `HiveHandler`.
- Adding UI that works on desktop but breaks `context.isMediumWindow` branches.
- Treating GSoC proposal docs as implementation.
- Documenting local branch files as `main`.
- Forgetting `CodegenLanguage` or `Codegen.getCode` when adding a codegen target.

## Completion Checklist

Before handing work back:

1. `git status --short` reviewed.
2. Only intended files changed.
3. Generated files updated when source models changed.
4. Relevant tests/analyze run, or a clear reason recorded.
5. `AGENTS.md` and `architecture.md` updated when architecture or agent workflow changed.
6. Mainline docs do not include branch-only implementation details.
7. Detailed local decision logs, if created, are clearly labeled as local notes and are not presented as mainline architecture.
