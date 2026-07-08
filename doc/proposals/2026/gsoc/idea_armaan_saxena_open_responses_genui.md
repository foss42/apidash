# GSoC 2026 Proposal — Open Responses & Generative UI in API Dash
**Idea #5 | Armaan Saxena | armaansaxena704@gmail.com**
**GitHub: github.com/Armaansaxena | PR: #1238**

---

## 1. About Me

Hi, I'm Armaan Saxena, a third-year Computer Science student. I've been building projects with Flutter, Dart, JavaScript, and Node.js for the past year. I got into API Dash because I use it regularly to test APIs, and I wanted to contribute to something I actually use day to day.

My recent contributions to API Dash:
- **PR #1238** — Added real-time JSON validation with an animated error bar in the request body editor. This closed issue #1232 and used `dart:convert` with no new dependencies.

I've also built a few projects using OpenAI and Gemini APIs, so I understand how different providers return responses in different formats. That's actually one of the reasons Idea #5 caught my attention.

---

## 2. The Problem

Right now in API Dash, when you call an LLM API (like OpenAI, Gemini, or Anthropic), the response just shows up as raw JSON text in the response pane. You have to manually look through the JSON to find the actual text output, token counts, or tool call results.

Every provider also structures their response differently:

**OpenAI response looks like this:**
```json
{
  "choices": [{ "message": { "content": "Hello!" } }],
  "usage": { "prompt_tokens": 10, "completion_tokens": 5 }
}
```

**Gemini response looks like this:**
```json
{
  "candidates": [{ "content": { "parts": [{ "text": "Hello!" }] } }],
  "usageMetadata": { "promptTokenCount": 10 }
}
```

Same idea, completely different structure. If you're testing multiple LLM providers in API Dash, you have to mentally map each one separately. There's no unified view.

On top of that, the **Open Responses spec** exists to solve exactly this — it defines one common schema that works across providers. And **Flutter's GenUI SDK** (which I ran locally this week) lets you render dynamic UI components directly from AI output. Neither of these are connected to API Dash yet.

I actually ran the GenUI travel app sample and noticed a few things:
- The widget catalog has 15+ components (InformationCard, TravelCarousel, ListingsBooker, TabbedSections, etc.)
- Some markdown in responses was rendering as raw `**text**` instead of formatted bold
- A few UI components were misaligned on web

These are real things I want to fix and build on in API Dash.

---

## 3. What I'll Build

I'll add a new **"Generative UI"** tab inside the API Dash response pane that does three things:

### 3.1 — Unified LLM Response Parser

A Dart class that reads responses from OpenAI, Gemini, and Anthropic and maps them to one common structure, based on the Open Responses spec.

```
How it works:

User sends API request to OpenAI / Gemini / Anthropic
                        |
                        v
          +--------------------------------+
          |      OpenResponsesParser       |
          |                                |
          |  detects provider from URL     |
          |  maps response to common format|
          |                                |
          |  .text   → actual output       |
          |  .tokens → usage counts        |
          |  .tools  → tool calls          |
          +--------------------------------+
                        |
                        v
             Unified ParsedResponse
                        |
            ┌───────────┴───────────┐
            v                       v
        GenUI Tab           Raw JSON Tab
         (new)                (existing)
```

The parser checks the request URL to figure out which provider it is, then normalizes the response. No new dependencies — just Dart.

### 3.2 — GenUI Response Tab

A new tab in the response pane that renders the AI response using Flutter's GenUI SDK widgets. Instead of showing raw JSON, it shows formatted cards, text with proper markdown rendering, and any structured output like tool calls.

```
Response Pane Tabs:

[ Pretty ]  [ Raw ]  [ Headers ]  [ Generative UI ✨ ]  ← new tab
                                          |
                          ┌───────────────┴───────────────┐
                          │                               │
               +--------------------+         +----------------------+
               |  LLM Response Text |         |  Token Usage Card    |
               |  (markdown render) |         |  prompt + completion |
               +--------------------+         +----------------------+
                          │
               +--------------------+
               |   Tool Calls       |
               |  (if present in    |
               |    response)       |
               +--------------------+
```

### 3.3 — Widget Catalog Viewer (Developer Tab)

A small catalog tab (similar to what GenUI's travel app has) that shows all available GenUI widgets with live previews. This helps developers quickly understand what GenUI components are available and how each one looks before integrating them into their own projects.

---

## 4. How It Connects to the Existing Codebase

I read through the API Dash codebase and PR #1238 helped me understand the widget structure. Here's where my changes fit:

```
lib/
├── widgets/
│   ├── editor_json.dart          ← I already contributed here (PR #1238)
│   └── response_pane.dart        ← I'll add the GenUI tab here
│
├── services/
│   └── open_responses_parser.dart  ← New file I'll create
│
├── genui/
│   ├── catalog.dart              ← Widget catalog definitions
│   └── renderer.dart             ← Maps parsed response to GenUI widgets
│
└── models/
    └── parsed_response.dart      ← Common response model
```

The GenUI SDK goes into `pubspec.yaml` as a dependency. Everything else is pure Dart/Flutter — no backend needed.

---

## 5. Timeline (90 Hours)

**Community Bonding (Before June 2)**
- Read the Open Responses spec fully and map out all field differences between OpenAI, Gemini, and Anthropic responses
- Explore GenUI SDK source code to understand how `Conversation` and `SurfaceController` work
- Discuss architecture with mentor and finalize scope

---

**Phase 1 — Core Parser (Weeks 1–3, ~30 hrs)**

| Week | Goal | Deliverable |
|------|------|-------------|
| 1 | Set up `ParsedResponse` model | Dart model with text, tokens, toolCalls fields |
| 2 | Write parser for OpenAI + Gemini | Handles both response formats correctly |
| 3 | Add Anthropic support + write tests | Parser works for all 3 providers |

By end of Phase 1: a Dart class that takes any LLM response body and gives back a clean, unified object.

---

**Phase 2 — GenUI Tab (Weeks 4–7, ~40 hrs)**

| Week | Goal | Deliverable |
|------|------|-------------|
| 4 | Add GenUI SDK to pubspec, set up tab structure | New tab visible in response pane |
| 5 | Render text response with proper markdown | No more `**bold**` showing as raw text |
| 6 | Add token usage card, tool calls section | Visual display of usage and tool outputs |
| 7 | Fix alignment issues, polish for web + desktop | Consistent layout across platforms |

By end of Phase 2: the GenUI tab works for all 3 providers and shows a clean, formatted view.

---

**Phase 3 — Widget Catalog + Final Polish (Weeks 8–10, ~20 hrs)**

| Week | Goal | Deliverable |
|------|------|-------------|
| 8 | Build widget catalog viewer | Developers can browse available components |
| 9 | Write docs + add tests | README updated, tests passing |
| 10 | Final review, mentor feedback, cleanup | PR ready to merge |

---

## 6. What Changes for Developers

**Before (today):**
A developer testing the Gemini API in API Dash sees a wall of JSON. They have to dig through `candidates[0].content.parts[0].text` to find the actual output. Token counts are buried under `usageMetadata`.

**After (my project):**
The same request shows a clean card with the response text properly rendered, token usage at a glance, and any tool calls displayed in a readable format. They can also click the Widget Catalog tab to see what GenUI components are available and how each one looks.

---

## 7. Why I'm the Right Person for This

I've personally tested OpenAI and Gemini APIs and dealt with the response format differences myself — that's why this problem feels real to me, not just a feature on a list.

My PR #1238 shows I can work with the API Dash widget structure, handle state management in Dart, and write clean code with no unnecessary dependencies.

I ran the GenUI travel app locally this week, went through the entire widget catalog, and noted real issues (markdown not rendering, misaligned components on web). That gives me a clear picture of what needs to be fixed.

I'm available full-time during the GSoC period and have no other major commitments. I plan to stay active in the API Dash Discord and attend the Weekly Connect calls throughout the project.

---

## 8. Open Questions for Mentor

1. Should the parser live in a separate Dart package or inside the API Dash lib folder?
2. Is there a preference on which GenUI widgets to prioritize — text rendering first, or tool calls?
3. Should the widget catalog be a developer-only tab (hidden by default) or visible to all users?

---

*Proposal by Armaan Saxena — GitHub: Armaansaxena — Open to feedback on any section*