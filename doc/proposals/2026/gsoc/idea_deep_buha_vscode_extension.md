### Initial Idea Submission

Full Name: Deep Buha  
University name: Indian Institute of Technology, Gandhinagar  
Program you are enrolled in (Degree & Major/Minor): B.Tech, Computer Science and Engineering  
Year: 2nd Year  
Expected graduation date: 2028

Project Title: VS Code Extension for API Dash (with Dart → TypeScript Converter Tool)
Relevant issues: No existing GitHub issue, this is a new idea proposal.

Idea description:

API Dash is an open-source API client with 30+ code generators, environment variables, multi-format import, and AI features - but it only exists as a standalone Flutter desktop app. Developers must leave their editor every time they need to test an API.

This project has **two deliverables**:

1. **Dart2Ts** - An AST-based Dart-to-TypeScript converter tool (written in Dart using the `analyzer` package) that automates ~70% of the code conversion from the API Dash codebase to TypeScript
2. **VS Code Extension** - The actual extension, built using the converter's output + manually written VS Code-specific code for the remaining ~30%

#### Deliverable 1: Dart2Ts Converter Tool

The converter is a **Dart program** that reads `.dart` files using Dart's official `analyzer` package, walks the AST (Abstract Syntax Tree), and outputs equivalent `.ts` files.

**7 Converter Modules:**

| Module | What It Converts | How it works |
|---|---|---|
| Type Converter | `String` → `string`, `List<T>` → `T[]`, `Map<K,V>` → `Record<K,V>`, `Future` → `Promise` | lookup table, ~20 entries |
| Enum Converter | Dart enums → TypeScript string enums | AST `EnumDeclaration` |
| Freezed Model Converter | `@freezed` classes → TS classes with `copyWith()`, `toJson()`, `fromJson()` + all computed getters | AST detects `@freezed`, reads factory params, converts getters using 7 mapping tables |
| Extension Method Converter | Dart extensions → standalone TS utility functions + rewrites ALL call sites across codebase | AST `ExtensionDeclaration` + call site resolution |
| Function Converter | Named params, return types, body expressions | AST + mapping tables for `.isNotEmpty`, `.contains()`, `.any()`, etc. |
| Template String Converter | `"""..."""` / `'''...'''` / `r'...'` → JS template literals | syntax swap |
| Import Remapper | `package:jinja` → `nunjucks`, `package:http` → `axios`, skip `dart:io`, etc. | YAML config file |

**The converter's intelligence comes from 7 mapping tables (~65 entries total):**
- Type mappings (`String` → `string`, 20 entries)
- Std lib mappings (`utf8.encode()` → `new TextEncoder().encode()`, 15 entries)
- Property mappings (`.isNotEmpty` → `.length > 0`, 6 entries)
- Method mappings (`.any()` → `.some()`, `.contains()` → `.includes()`, 8 entries)
- Operator mappings (`==` → `===`, `..` cascade → separate statements, 3 entries)
- Extension method call sites (built dynamically by Module 4)
- Package API mappings (`jj.Template(x).render(y)` → `nunjucks.renderString(x, y)`, 10 entries)

**Converter architecture:**

```
Dart2Ts/
├── bin/convert.dart              ← Entry point
├── lib/
│   ├── ast_visitor.dart          ← Walks Dart AST nodes
│   ├── converters/
│   │   ├── type_converter.dart   ← Module 1
│   │   ├── enum_converter.dart   ← Module 2
│   │   ├── model_converter.dart  ← Module 3 (Freezed → Classes)
│   │   ├── extension_converter.dart ← Module 4
│   │   ├── function_converter.dart  ← Module 5
│   │   ├── string_converter.dart    ← Module 6
│   │   └── import_converter.dart    ← Module 7
│   ├── config.dart
│   └── ts_emitter.dart           ← Generates formatted TypeScript
├── config/import_mapping.yaml
└── pubspec.yaml                  ← depends on `analyzer` package
```

**How it runs:**
```bash
dart run bin/convert.dart --input ../apidash/packages/seed/lib/ --output ../extension/src/models/
dart run bin/convert.dart --input ../apidash/lib/codegen/ --output ../extension/src/codegen/
```

**Key value: when the main API Dash repo changes** (new codegen language added, model updated), you just re-run the converter — no manual porting needed.

#### Deliverable 2: VS Code Extension

```
VS Code Extension
├── Extension Host (TypeScript/Node.js)
│   ├── Models/Enums/Utils (AUTO-CONVERTED by Dart2Ts from seed, apidash_core, better_networking)
│   ├── Code Generators (AUTO-CONVERTED — 30+ language templates via Nunjucks, identical {{ }} syntax)
│   ├── HTTP Client (MANUAL — axios, because dart:http has different API shape)
│   ├── Storage (MANUAL — JSON files + globalState, replacing Hive)
│   ├── State Management (MANUAL — vscode.EventEmitter, replacing Riverpod)
│   ├── TreeView Providers (MANUAL — VS Code sidebar API)
│   └── Extension Entry Point (MANUAL — activate/deactivate lifecycle)
└── Webview (HTML/CSS/JS) — MANUAL
    ├── Request Editor (method, URL, params, headers, body)
    ├── Response Viewer (status, timing, headers, body)
    └── Code Generation Panel (language picker, copy button)
```

#### What I've done so far

- Forked the repo, set up dev environment, run the app on Windows, explored the entire codebase
- Studied the monorepo structure and how `seed`, `apidash_core`, `better_networking`, `curl_parser` interact
- Traced every computed getter in `HttpRequestModel` (20 getters) to verify 100% can be handled by converter
- Researched all technology alternatives with pros/cons
- Built detailed understanding of AST-based conversion, Freezed model handling, and extension method call site rewriting
