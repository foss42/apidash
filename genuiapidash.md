# Implementation Plan: Open Responses & Generative UI Integration

## Discussion Reference
- **GitHub Discussion**: [#1227 - Open Responses & Generative UI](https://github.com/foss42/apidash/discussions/1227)
- **Started by**: animator
- **Summary**: Open Responses is an open-source specification for vendor-neutral AI interfaces. A2UI provides guidelines for building Generative UIs with Flutter's GenUI SDK. Task is to build rich API response UI visualization in API Dash.

---

## 1. Executive Summary

This document outlines the implementation plan to integrate **Open Responses** specification and **Google A2UI (Generative UI)** into API Dash. The goal is to enable rich, interactive API response visualization that developers can use in their Flutter/Web applications.

**Key Technologies:**
- **Open Responses**: Vendor-neutral AI API specification for multi-provider compatibility
- **Google A2UI/GenUI SDK**: Declarative JSON-based UI protocol for generative interfaces

---

## 2. Technology Overview

### 2.1 Open Responses Specification

[Specification](https://www.openresponses.org/specification) | [Reference](https://www.openresponses.org/reference) | [Governance](https://www.openresponses.org/governance)

Open Responses is an open-source, vendor-neutral specification for building interoperable LLM interfaces. It enables:
- Multi-provider compatibility (OpenAI, Anthropic, Gemini, local models)
- Standardized schemas for AI requests/responses
- Unified streaming via semantic events
- Reasoning items with optional summaries

**Core Concepts:**
| Concept | Description |
|---------|-------------|
| **Items** | Fundamental unit of context - atomic model output, tool invocations, reasoning |
| **Semantic Events** | Streaming modeled as state transitions (`response.in_progress`, `response.completed`) |
| **State Machines** | Objects have finite states: `in_progress`, `completed`, `incomplete`, `failed` |
| **Reasoning Items** | Expose model's internal thought process with optional summary/content |

### 2.2 Google A2UI / GenUI SDK

[GenUI Documentation](https://docs.flutter.dev/ai/genui) | [A2UI Specification](https://a2ui.org/specification/v0.9-a2ui/) | [GitHub](https://github.com/google/A2UI)

A2UI is a declarative JSON format enabling AI agents to generate rich UIs. The Flutter GenUI SDK orchestrates the generative UI process.

**Key Components:**
| Component | Purpose |
|-----------|---------|
| `GenUiConversation` | Primary facade managing conversation and orchestration |
| `Catalog` | Collection of trusted UI widgets the AI can use |
| `DataModel` | Centralized observable store for dynamic UI state |
| `A2uiMessageProcessor` | Processes AI messages and manages UI surfaces |

**A2UI Message Types (v0.9):**
- `createSurface` - Initialize new UI surface
- `updateComponents` - Add/update components (flat list with IDs)
- `updateDataModel` - Update data bindings
- `deleteSurface` - Remove surface

**Supported Renderers:** Flutter, React, Lit, Angular (SwiftUI/Compose planned Q2)

---

## 3. Implementation Goals

### 3.1 Primary Objectives

1. **Open Responses Parser**: Parse and validate Open Responses format in API responses
2. **A2UI Renderer**: Render A2UI JSON messages as native Flutter widgets
3. **GenUI Integration**: Integrate GenUI SDK for interactive AI-driven UI generation
4. **Preview Panel**: Display generative UI previews in API Dash response pane

### 3.2 User Experience

- Users send API requests to AI providers (OpenAI, Anthropic, Gemini)
- Responses in Open Responses format are detected automatically
- If response contains A2UI payloads, render interactive UI components
- Users can copy A2UI JSON for use in their own applications

---

## 4. Architecture Design

### 4.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      API Dash                                │
├─────────────────────────────────────────────────────────────┤
│  Request Panel          │  Response Panel                   │
│  ┌─────────────┐       │  ┌─────────────────────────────┐  │
│  │ HTTP/GraphQL│       │  │ Standard View               │  │
│  │ AI Request  │──────▶│  │ ┌─────────────────────────┐ │  │
│  └─────────────┘       │  │ │ Open Responses Parser   │ │  │
│                        │  │ └─────────────────────────┘ │  │
│                        │  │ ┌─────────────────────────┐ │  │
│                        │  │ │ A2UI Renderer           │ │  │
│                        │  │ └─────────────────────────┘ │  │
│                        │  └─────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Module Structure

```
lib/
├── core/
│   └── open_responses/
│       ├── models/
│       │   ├── open_responses_item.dart      # Item model (message, function_call, reasoning)
│       │   ├── open_responses_event.dart     # Semantic events
│       │   └── open_responses_response.dart  # Full response model
│       ├── parser/
│       │   └── open_responses_parser.dart    # Parse JSON to models
│       └── validator/
│           └── open_responses_validator.dart # Validate against spec
│
├── a2ui/
│   ├── models/
│   │   ├── a2ui_message.dart                 # Message types
│   │   ├── a2ui_component.dart              # Component definition
│   │   ├── a2ui_data_binding.dart           # Data binding model
│   │   └── a2ui_surface.dart                # UI surface model
│   ├── renderer/
│   │   ├── a2ui_renderer.dart               # Main renderer orchestrator
│   │   ├── catalog/
│   │   │   ├── catalog.dart                 # Catalog definition
│   │   │   ├── catalog_item.dart            # Widget catalog entry
│   │   │   └── default_catalog.dart         # Default A2UI components
│   │   └── widgets/
│   │       ├── a2ui_text.dart
│   │       ├── a2ui_button.dart
│   │       ├── a2ui_text_field.dart
│   │       ├── a2ui_card.dart
│   │       ├── a2ui_row.dart
│   │       ├── a2ui_column.dart
│   │       └── ... (other A2UI components)
│   └── processor/
│       └── a2ui_message_processor.dart      # Process incoming messages
│
└── genui/
    └── genui_integration.dart                # GenUI SDK integration
```

### 4.3 Key Classes Design

#### Open Responses Models

```dart
// lib/core/open_responses/models/open_responses_item.dart
enum ItemType { message, functionCall, reasoning, toolCall }

class OpenResponsesItem {
  final String id;
  final ItemType type;
  final ItemStatus status; // in_progress, completed, incomplete
  final dynamic content;
}

// lib/core/open_responses/models/open_responses_response.dart
class OpenResponsesResponse {
  final String id;
  final String model;
  final ResponseStatus status;
  final List<OpenResponsesItem> items;
  final List<SemanticEvent> events;
}
```

#### A2UI Models

```dart
// lib/a2ui/models/a2ui_component.dart
class A2uiComponent {
  final String id;
  final String type; // text, button, textField, card, etc.
  final Map<String, dynamic> properties;
  final List<String> children;
  final Map<String, String> dataBindings;
}

// lib/a2ui/models/a2ui_surface.dart
class A2uiSurface {
  final String id;
  final String catalogId;
  final Map<String, A2uiComponent> components;
  final Map<String, dynamic> dataModel;
}
```

---

## 5. Implementation Phases

### Phase 1: Core Infrastructure (Week 1-2)

#### 1.1 Open Responses Parser
- [ ] Create `open_responses_item.dart` - Item model with types (message, function_call, reasoning, tool_call)
- [ ] Create `open_responses_response.dart` - Full response model
- [ ] Create `open_responses_parser.dart` - JSON parsing with validation
- [ ] Add unit tests for parser

#### 1.2 Open Responses Validator
- [ ] Create `open_responses_validator.dart` - Validate against spec
- [ ] Implement state machine validation (in_progress, completed, incomplete, failed)
- [ ] Validate item types and content schemas

### Phase 2: A2UI Core (Week 2-3)

#### 2.1 A2UI Models
- [ ] Create `a2ui_message.dart` - Message types (createSurface, updateComponents, updateDataModel, deleteSurface)
- [ ] Create `a2ui_component.dart` - Component definition with properties, children, bindings
- [ ] Create `a2ui_data_binding.dart` - JSON Pointer bindings
- [ ] Create `a2ui_surface.dart` - Surface management

#### 2.2 A2UI Renderer
- [ ] Create `a2ui_renderer.dart` - Main renderer orchestrator
- [ ] Create `catalog.dart` - Widget catalog system
- [ ] Create `catalog_item.dart` - Individual catalog entries with schema

#### 2.3 Default Component Library
Implement the A2UI Basic Catalog components:

**Layout:**
- [ ] Row, Column, Card, List
- [ ] Tabs, Modal

**Input:**
- [ ] TextField, CheckBox, Slider
- [ ] DateTimeInput, ChoicePicker

**Content:**
- [ ] Text, Image, Icon
- [ ] Video, AudioPlayer, Divider

**Interactive:**
- [ ] Button

### Phase 3: Integration (Week 3-4)

#### 3.1 Response Panel Integration
- [ ] Add Open Responses detection in `response_body.dart`
- [ ] Add tab for "Open Responses" view
- [ ] Add tab for "A2UI Preview" view

#### 3.2 A2UI Preview Panel
- [ ] Create A2UI preview widget in response pane
- [ ] Implement live rendering of A2UI messages
- [ ] Add copy A2UI JSON button

#### 3.3 GenUI SDK Integration (Optional/Future)
- [ ] Add `genui` dependency
- [ ] Create GenUI conversation wrapper
- [ ] Allow users to test GenUI locally

### Phase 4: Polish & Testing (Week 4-5)

#### 4.1 Error Handling
- [ ] Graceful fallback for invalid Open Responses
- [ ] Fallback to standard JSON view
- [ ] Error messages for unsupported features

#### 4.2 UI Polish
- [ ] Theme support (light/dark)
- [ ] Responsive layout
- [ ] Loading states

#### 4.3 Testing
- [ ] Unit tests for all models
- [ ] Widget tests for A2UI components
- [ ] Integration tests for response parsing

---

## 6. Dependencies

```yaml
# pubspec.yaml additions
dependencies:
  # For GenUI integration (optional)
  genui: ^1.0.0
  genui_a2ui: ^1.0.0
  a2a: ^1.0.0

  # For JSON processing (already available)
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.8.0
```

---

## 7. API Considerations

### 7.1 Provider Support

Test with major AI providers:

| Provider | Open Responses Support | Notes |
|----------|----------------------|-------|
| OpenAI | Native | Based on Responses API |
| Anthropic | Via adapter | Requires transformation |
| Gemini | Via adapter | Requires transformation |
| Ollama | Via adapter | Local models |

### 7.2 Detection Strategy

Detect Open Responses format by:
1. Check `Content-Type: application/json`
2. Look for required fields: `items`, `model`, `status`
3. Validate item structure

Detect A2UI payload:
1. Look for `createSurface`, `updateComponents`, `updateDataModel` messages
2. Validate component types against catalog

---

## 8. Future Enhancements

### 8.1 Advanced Features
- **Custom Catalogs**: Allow users to define custom widget catalogs
- **Interactive Preview**: Full GenUI SDK integration for testing
- **Export Options**: Export as Flutter/React code

### 8.2 Provider Expansion
- Add more A2UI renderers (React, Angular)
- Support AG UI protocol
- MCP integration

---

## 9. Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| A2UI/GenUI SDK changes | Medium | Use stable API, version pinning |
| Open Responses spec evolution | Medium | Modular parser, easy updates |
| Performance with large responses | Low | Lazy rendering, pagination |
| Widget catalog completeness | Low | Extensible catalog system |

---

## 10. References

### Open Responses
- [Specification](https://www.openresponses.org/specification)
- [Reference](https://www.openresponses.org/reference)
- [Governance](https://www.openresponses.org/governance)
- [HuggingFace Blog](https://huggingface.co/blog/open_responses)

### Google A2UI / GenUI
- [GenUI Get Started](https://docs.flutter.dev/ai/genui/get-started)
- [GenUI Components](https://docs.flutter.dev/ai/genui/components)
- [A2UI Specification v0.9](https://a2ui.org/specification/v0.9-a2ui/)
- [A2UI Renderers](https://a2ui.org/renderers/)
- [GitHub Repository](https://github.com/google/A2UI)

### API Dash Codebase
- [Request Model](lib/models/request_model.dart)
- [Response Widgets](lib/widgets/response_body.dart)
- [Dashbot Integration](lib/dashbot/) - Similar AI integration pattern

---

## 11. Conclusion

This implementation plan provides a structured approach to integrating Open Responses and Generative UI into API Dash. The phased approach allows for incremental delivery:

1. **Phase 1**: Core Open Responses parsing
2. **Phase 2**: A2UI rendering infrastructure
3. **Phase 3**: UI integration
4. **Phase 4**: Polish and testing

The architecture is designed to be:
- **Extensible**: Easy to add new components to catalog
- **Maintainable**: Clear separation of concerns
- **Future-proof**: Modular design for spec evolution

---

*Document Version: 1.0*
*Created: 2026-03-10*
*Issue: #1227*
