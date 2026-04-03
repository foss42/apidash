### About

1. **Full Name**: Shridhar Panigrahi
2. **Contact info**: sridharpanigrahi2006@gmail.com
3. **GitHub profile**: [sridhar-panigrahi](https://github.com/sridhar-panigrahi)
4. **LinkedIn**: [shridhar-panigrahi](https://www.linkedin.com/in/shridhar-panigrahi/)
5. **Time zone**: IST (UTC+5:30)

### University Info

1. **University name**: Polaris School of Technology, Bangalore
2. **Program**: B.Tech in Computer Science and Engineering (Specialization in AI & ML)
3. **Year**: 1st Year
4. **Expected graduation date**: 2029

### Motivation & Past Experience

#### 1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

Yes. I have 11 merged PRs across 5 open-source projects. API Dash is the project I've been focused on for GSoC, but I've also contributed to large codebases in Python, Java, Go, and Rust:

**Other open-source contributions** (all merged):
- **[astropy](https://github.com/astropy/astropy)** — 3 merged PRs ([#19403](https://github.com/astropy/astropy/pull/19403), [#19404](https://github.com/astropy/astropy/pull/19404), [#19450](https://github.com/astropy/astropy/pull/19450)): Fixed an f-string bug, silent data corruption in FITS_rec, and table index corruption on failed row assignment. 500k+ line Python codebase.
- **[Hyperledger Besu](https://github.com/besu-eth/besu)** — 4 merged PRs ([#10020](https://github.com/besu-eth/besu/pull/10020), [#10042](https://github.com/besu-eth/besu/pull/10042), [#10051](https://github.com/besu-eth/besu/pull/10051), [#10060](https://github.com/besu-eth/besu/pull/10060)): Fixed a missing return in transaction pool, wrong hash in eth_estimateGas, a TOCTOU race, and unsigned underflow. Java/Ethereum client.
- **[Hyperledger Fabric](https://github.com/hyperledger/fabric)** — 3 merged PRs ([#5422](https://github.com/hyperledger/fabric/pull/5422), [#5424](https://github.com/hyperledger/fabric/pull/5424), [#5430](https://github.com/hyperledger/fabric/pull/5430)): Fixed gossip protocol error handling and iterator/resource leaks. Go codebase.
- **[LFDT-Lockness/generic-ec](https://github.com/LFDT-Lockness/generic-ec)** — 1 merged PR ([#59](https://github.com/LFDT-Lockness/generic-ec/pull/59)): Added secp384r1 (NIST P-384) curve support — first non-32-byte scalar curve. Rust, 180 tests passing.

**API Dash contributions**:

- **[PR #1279](https://github.com/foss42/apidash/pull/1279)** — Added input validation for empty API key and endpoint URL fields in the AI Model Selector dialog (fixes [#1183](https://github.com/foss42/apidash/issues/1183)). This was my first contribution and helped me understand the Riverpod state management layer and the dialog system used across the app.

- **[PR #1290](https://github.com/foss42/apidash/pull/1290)** — Added support for custom OpenAI-compatible LLM providers (implements [#1175](https://github.com/foss42/apidash/issues/1175)). This allows users to connect API Dash to services like Groq, OpenRouter, Mistral, and any provider offering an OpenAI-compatible endpoint. Building this gave me a thorough understanding of the `genai` package internals — specifically the `ModelProvider` interface, `kModelProvidersMap`, `AIRequestModel` serialization with Freezed, and how `outputFormatter` / `streamOutputFormatter` work in practice.

- **[Idea Doc PR #1321](https://github.com/foss42/apidash/pull/1321)** — Submitted a detailed initial idea document for Idea 5: Open Responses & Generative UI, including architecture overview, code examples, PoC screenshots, and video demos.

- **[PoC PR #1358](https://github.com/foss42/apidash/pull/1358)** (https://github.com/foss42/apidash/pull/1358) — Built a working proof-of-concept for Open Responses parsing and A2UI rendering (7 new files, 11 modified files, ~1,000 lines of code) with video demonstrations: [Open Responses Viewer](https://youtu.be/paN-KGIhNms) (https://youtu.be/paN-KGIhNms) | [A2UI Renderer](https://youtu.be/T2KbHth736U) (https://youtu.be/T2KbHth736U).

#### 2. What is your one project/achievement that you are most proud of? Why?

Honestly, the PoC I built for this project. I spent a couple of weeks just reading through the API Dash codebase before I wrote a single line — understanding how `ResponseBodyView` controls rendering, how `ModelProvider` abstracts different AI APIs, how `Previewer` decides what widget to show. Then I built the whole thing end-to-end: sealed classes for the data models, auto-detection logic, structured viewer widgets, A2UI component renderer, all wired into the existing response pipeline.

The part that took the longest wasn't writing the widgets — it was figuring out where each piece should live. Should the Open Responses models go in `packages/genai` or in the main app? (Answer: `genai`, because other packages might need them.) Should A2UI detection happen in `ResponseBody` or `ResponseBodySuccess`? (Answer: `ResponseBody._resolveViewOptions()`, because that's where all format detection already lives.) Getting these decisions right required actually understanding the architecture, not just grepping for keywords. That's what made it satisfying — the PoC works because I understood the codebase, not because I hacked around it.

#### 3. What kind of problems or challenges motivate you the most to solve them?

I'm drawn to problems where there's a clear gap between what tools currently do and what they should do. The gap I spotted here — every API testing tool showing AI responses as raw JSON walls — is exactly the kind of thing that motivates me. Millions of developers test AI APIs daily, and nobody has built a clean way to visualize structured AI outputs in a general-purpose API client. The tools exist for specific platforms (OpenAI Playground, Google AI Studio), but nothing works across providers.

I enjoy working on things where understanding the spec matters. Reading through the [Open Responses specification](https://www.openresponses.org/) (https://www.openresponses.org/), the [A2UI component model](https://github.com/google/A2UI) (https://github.com/google/A2UI), and mapping them to Flutter's widget system was genuinely interesting. These are emerging standards, and building tooling around them early means shaping how developers will interact with them.

#### 4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

I will be working on GSoC full-time during the summer. My university's summer break aligns with the GSoC coding period, so I have no classes or exams during that time. I can comfortably commit 15–20 hours per week throughout the project, and more during weeks with no other commitments.

#### 5. Do you mind regularly syncing up with the project mentors?

Not at all — I actively welcome it. I've already been engaging in the GSoC weekly calls and the [Discussion threads for Idea 5](https://github.com/foss42/apidash/discussions/1227). Regular sync-ups help me stay aligned with what the mentors expect and catch design mismatches early rather than after a week of coding in the wrong direction. I'm available on email and video calls.

#### 6. What interests you the most about API Dash?

Two things stand out. First, API Dash already handles an impressive range of response types — JSON, images, audio, video, PDF, CSV, SSE — and it does so through a clean, extensible rendering pipeline. That makes it realistic to add AI-specific rendering without building everything from scratch.

Second, the existing GenAI infrastructure is thoughtfully designed. The `ModelProvider` pattern, the way `outputFormatter` abstracts provider-specific parsing, and the Stac-based SDUI pipeline for AI-generated UIs show that the project already has a vision for AI-native features. What I want to build is a natural extension of that vision: rendering structured AI responses and agent-described UIs natively.

As a Flutter developer who spends a lot of time testing AI APIs, I use tools like this every day. Building features I personally need makes the work better — I'm not guessing at what users want, I'm fixing my own frustrations.

#### 7. Can you mention some areas where the project can be improved?

- **AI response visualization**: Right now, AI API responses from providers like OpenAI's Responses API, Google's Gemini, and similar services are displayed as raw JSON, just like any other API. Given that API Dash already has dedicated AI features (DashBot, AI Requests, custom providers), adding structured visualization for AI-specific response formats would be a natural and high-impact improvement.

- **Streaming response experience**: The current SSE/streaming view works well for text streams, but modern AI responses include typed events (tool calls starting, text deltas, reasoning updates). A stream-aware viewer that understands these event types would make debugging agentic workflows much easier.

- **Multi-turn conversation debugging**: When building agents that chain multiple API calls together (each referencing the previous via `previous_response_id`), there's no way to see the full conversation flow across requests. A timeline or thread view linking related requests would be very helpful.

- **Agent UI preview**: With specs like [A2UI](https://github.com/google/A2UI) and [Flutter's GenUI SDK](https://github.com/flutter/genui), agents can describe interactive UIs in their responses. Being able to preview what those UIs look like directly in the API client — without building a separate client app — would be a unique differentiator for API Dash.

#### 8. Have you interacted and helped API Dash community? (GitHub/Discord links)

Yes, I've been active in the community since I started working on Idea 5:

- **GitHub Discussions**: Participated in the [Idea 5 discussion (#1227)](https://github.com/foss42/apidash/discussions/1227), shared my approach, and engaged with other contributors and mentors
- **PRs and Reviews**: Submitted [PR #1279](https://github.com/foss42/apidash/pull/1279), [PR #1290](https://github.com/foss42/apidash/pull/1290), [Idea Doc PR #1321](https://github.com/foss42/apidash/pull/1321), and the PoC implementation
- **Weekly Calls**: Attending the GSoC weekly sync-up calls on [Luma](https://luma.com/embed/calendar/cal-ZTW02O2EsWRs6V4/events)
- **Discord**: Active in the #gsoc-foss-apidash channel, discussing design decisions and helping answer questions from other contributors

---

### Project Proposal Information

#### 1. Proposal Title

**Open Responses Protocol Support & Generative UI Rendering Engine for API Dash**

#### 2. Abstract

I've been testing AI APIs a lot recently, and every tool I've tried — Postman, Insomnia, Thunder Client — shows AI responses as raw JSON walls. When a model reasons, calls tools, and returns results all in one response, you're left scrolling through nested arrays trying to figure out what actually happened. Nobody has solved this for general-purpose API testing tools yet.

This project makes API Dash the first cross-platform API client with native support for the [Open Responses](https://www.openresponses.org/) protocol and [A2UI](https://github.com/google/A2UI) component rendering. Concretely, when API Dash detects an Open Responses format response, it will:

- **Auto-switch** to a structured view — reasoning traces get collapsible cards, tool calls get matched to their results via `call_id`, messages render with markdown and inline images
- **Stream progressively** — each output item appears as a card the moment the SSE event fires, text fills in as deltas arrive
- **Chain conversations** — multi-turn agentic loops linked via `previous_response_id` show up as a connected timeline instead of isolated requests
- **Render A2UI components** — when an agent returns UI descriptors (forms, tables, dashboards), API Dash builds real interactive Flutter widgets from them

**What the end result looks like**: A developer hits an Open Responses endpoint, and instead of a JSON blob, they see a clean conversation view — reasoning collapsed at the top, tool calls as blue cards showing function name/arguments/result side by side, and the final message rendered as formatted text at the bottom. For A2UI responses, they see a live interactive dashboard with buttons, inputs, tables, and charts — all rendered from the response JSON, no separate app needed.

I already built a working proof-of-concept (~1,000 lines across 7 new files and 11 modified files) with [video demos](https://youtu.be/paN-KGIhNms) (https://youtu.be/paN-KGIhNms). The GSoC project extends this to production quality with streaming, conversation chaining, DashBot integration, and a full test suite.

#### 3. Detailed Description

##### The Problem (and Why It Matters)

I'll be concrete about the problem. When you test an AI API that uses tool calling — say, asking a model to look up the weather — the response you get back looks something like this:

```json
{
  "id": "resp_abc123",
  "object": "response",
  "status": "completed",
  "output": [
    {
      "type": "reasoning",
      "id": "rs_001",
      "summary": [{"type": "summary_text", "text": "Deciding to call weather tool..."}]
    },
    {
      "type": "function_call",
      "id": "fc_001",
      "name": "get_weather",
      "call_id": "call_xyz",
      "arguments": "{\"city\": \"Tokyo\", \"units\": \"celsius\"}"
    },
    {
      "type": "function_call_output",
      "call_id": "call_xyz",
      "output": "{\"temp\": 22, \"condition\": \"partly cloudy\"}"
    },
    {
      "type": "message",
      "id": "msg_001",
      "content": [{"type": "output_text", "text": "It's currently 22°C and partly cloudy in Tokyo."}]
    }
  ],
  "usage": {"input_tokens": 150, "output_tokens": 45, "total_tokens": 195}
}
```

In every API testing tool I have tried — Postman, Insomnia, Thunder Client — this renders as a raw JSON tree. You have to mentally track which `function_call_output` matches which `function_call` by comparing `call_id` values, scroll past reasoning blocks to find the actual message, and somehow figure out the execution flow from a flat array.

This problem gets worse with multi-turn agentic workflows. Open Responses supports conversation chaining via `previous_response_id`, where each response references the previous one, building up a conversation history server-side. When debugging a workflow where the model calls three tools across two turns, you are switching between requests and mentally stitching them together.

The [Open Responses protocol](https://www.openresponses.org/) (https://www.openresponses.org/, originally from OpenAI's Responses API) is becoming a cross-provider standard. Google's [A2UI specification](https://github.com/google/A2UI) (https://github.com/google/A2UI) adds another dimension: agents can return structured UI component descriptors in their responses, describing interactive interfaces (forms, dashboards, data tables) that a client should render. There is currently no way to preview what those rendered UIs would look like without building a full client application.

API Dash is well-positioned to solve both problems. It already has a powerful response rendering pipeline (`Previewer` handles 60+ MIME types), a GenAI provider architecture in `packages/genai`, and a Stac-based SDUI pipeline for AI-generated UIs. The gap is connecting these newer AI response formats to that existing infrastructure.

##### What I've Already Built (Proof of Concept)

I didn't want to just write about what I'd do — I went ahead and built a working prototype first. The PoC is on the [`poc-open-responses-genui`](https://github.com/foss42/apidash/pull/1358) branch (https://github.com/foss42/apidash/pull/1358), and you can see it in action here: [Open Responses Viewer demo](https://youtu.be/paN-KGIhNms) (https://youtu.be/paN-KGIhNms) | [A2UI Renderer demo](https://youtu.be/T2KbHth736U) (https://youtu.be/T2KbHth736U)

Here's what's implemented and how each piece works:

**1. Open Responses Data Models** (`packages/genai/lib/models/open_responses.dart` — 269 lines)

Typed Dart sealed classes for the full Open Responses output schema:

```dart
sealed class OutputItem {
  const OutputItem();
  String get id;
  String get type;
  String get status;

  factory OutputItem.fromJson(Map<String, dynamic> json) {
    return switch (json['type'] as String? ?? '') {
      'message' => MessageOutputItem.fromJson(json),
      'function_call' => FunctionCallOutputItem.fromJson(json),
      'function_call_output' => FunctionCallResultItem.fromJson(json),
      'reasoning' => ReasoningOutputItem.fromJson(json),
      _ => UnknownOutputItem.fromJson(json),
    };
  }
}
```

Each output item type (`MessageOutputItem`, `FunctionCallOutputItem`, `FunctionCallResultItem`, `ReasoningOutputItem`) has its own class with a `fromJson` factory. `ContentPart` is another sealed class handling `output_text` and `refusal` content types. `OpenResponsesResult` wraps the full response with auto-detection via:

```dart
static bool isOpenResponsesFormat(Map<String, dynamic> json) {
  return json['object'] == 'response' &&
      json['output'] is List &&
      json.containsKey('id');
}
```

**2. Structured Response Viewer** (`lib/widgets/open_responses_viewer.dart` — 414 lines)

A full widget tree that renders each output item type as a distinct, themed card:

- `_MessageCard` — Role-labeled chat bubbles (user messages right-aligned with blue background, assistant messages left-aligned with an avatar)
- `_ReasoningCard` — Collapsible reasoning sections showing summary by default, expandable to show full chain-of-thought
- `_FunctionCallCard` — Tool call cards with function name, status chip (completed/in_progress/failed), and expandable pretty-printed JSON arguments
- `_FunctionResultCard` — Tool result cards linked back to the originating call via `call_id`
- `_UsageBar` — Token usage statistics (input/output/total) displayed at the bottom

All widgets use Material Design 3 theming and adapt to dark/light mode.

**3. A2UI Component Renderer** (`lib/widgets/a2ui_renderer.dart` — 248 lines)

A registry-based renderer that maps A2UI component type strings to Flutter widget builders. The `A2UIParser` class handles detection (`isA2UIPayload`) and parsing of A2UI JSONL payloads containing `createSurface`, `updateComponents`, and `updateDataModel` messages. The `A2UIRenderer` widget builds components recursively by ID reference, supporting:

- **Layout**: Card, Row, Column, List, Tabs
- **Display**: Text (with h1/h2/h3/caption variants), Image, Icon, Divider
- **Input**: Button (primary/outlined/text variants)
- **Data Binding**: JSON Pointer path resolution from the data model (e.g., `/user/name`)

Unknown component types fall back to an error card showing the type name, so the renderer degrades gracefully when encountering newer A2UI spec versions.

**4. Response Pipeline Integration** (`lib/widgets/response_body.dart`, `response_body_success.dart`)

Extended the existing response pipeline with:
- Two new `ResponseBodyView` options: `structured` (for Open Responses) and `genui` (for A2UI)
- Auto-detection logic in `_resolveViewOptions()` that checks for Open Responses format (`object == "response"` + `output[]` array) and A2UI format (`createSurface`/`updateComponents` keys)
- Routing to the appropriate viewer in `ResponseBodySuccess`

This integrates cleanly with the existing `ResponseBodyView` enum pattern — no new screens or navigation changes needed.

##### How I'll Build This — Technical Approach for GSoC

The PoC proves the concept works. But there's a meaningful gap between "it works on fixture data" and "it handles real-world streaming responses with edge cases." Here's exactly how I plan to close that gap, broken down by area:

**A. Streaming with Typed SSE Events**

The current SSE implementation in `packages/genai/lib/utils/ai_request_utils.dart` splits chunks on `data: ` and parses each as JSON. This works for Chat Completions where deltas are simple text appends.

Open Responses streaming uses typed events like `response.output_item.added`, `response.output_text.delta`, `response.function_call_arguments.delta`, and `response.output_item.done`. Each event targets a specific output item by index, so the parser needs to maintain a map of in-progress items and route deltas to the right place.

My approach:

```dart
class OpenResponsesStreamState {
  final List<OutputItem> items = [];
  final Map<int, StringBuffer> textBuffers = {};
  final Map<int, StringBuffer> argBuffers = {};

  void processEvent(String eventType, Map<String, dynamic> data) {
    switch (eventType) {
      case 'response.output_item.added':
        items.add(OutputItem.fromJson(data['item']));
      case 'response.output_text.delta':
        textBuffers[data['output_index']]?.write(data['delta']);
      case 'response.function_call_arguments.delta':
        argBuffers[data['output_index']]?.write(data['delta']);
      case 'response.output_item.done':
        _finalizeItem(data['output_index'], data['item']);
    }
  }
}
```

This state machine feeds the structured viewer progressively — each output item card appears as soon as `output_item.added` fires, and text/arguments fill in as deltas arrive. The viewer stays responsive because each item renders independently.

**B. Conversation Chaining (`previous_response_id`)**

Open Responses supports multi-turn conversations by referencing `previous_response_id`. This is how agentic loops work: model calls a tool → you send the tool result back referencing the previous response → model processes it and maybe calls another tool.

Implementation plan:
- Store `response.id` from each parsed response in the request model
- Wire the stored ID into subsequent requests as `previous_response_id`
- Build a timeline view that links related requests, showing the full conversation flow across multiple API calls
- Allow expanding/collapsing individual turns in the chain

This would be the first API testing tool I know of that visualizes multi-turn agentic workflows as a connected timeline rather than isolated requests.

**C. Extended A2UI Component Support**

The PoC handles 10 basic component types. The full implementation will expand this to cover the A2UI specification more completely:

- **Input components**: TextField, DatePicker, Slider, Checkbox, Radio, Dropdown
- **Data display**: Table (with sorting/filtering), Progress bar, Charts (using `fl_chart`)
- **Navigation**: Tabs, Accordion, Stepper
- **Local state management**: Form state tracking, user interaction event logging
- **Progressive rendering**: Components render as they stream in via A2UI's flat ID-referenced model

The component registry pattern makes this straightforward — each new type is a builder function registered by name:

```dart
final _builders = <String, Widget Function(Map<String, dynamic>, A2UIRenderer)>{
  'TextField': (node, r) => TextField(
    decoration: InputDecoration(labelText: r.resolve(node['label'])),
    onChanged: (v) => r.logEvent('change', node['id'], v),
  ),
  'Slider': (node, r) => Slider(
    value: (r.dataAt(node['value']?['path']) as num?)?.toDouble() ?? 0,
    min: (node['min'] as num?)?.toDouble() ?? 0,
    max: (node['max'] as num?)?.toDouble() ?? 100,
    onChanged: (v) => r.logEvent('change', node['id'], v),
  ),
  // ... more types
};
```

**D. DashBot Integration**

Currently, DashBot renders all responses through `MarkdownBody` in `ChatBubble`. When DashBot's underlying AI provider returns an Open Responses format response, the integration would:

- Parse the response using the same `OpenResponsesResult.fromJson` pipeline
- Render structured output items inline in the chat (reasoning collapsed, tool calls as cards, messages as formatted text)
- If the response contains A2UI components, render them as interactive widgets within the chat bubble

This means DashBot could respond with an interactive form or a data table instead of a text description of what to do — a significant UX improvement for the AI assistant.

##### Architecture Diagram

```
HTTP Response (JSON body)
        │
   ┌────┴────┐
   │ Detect  │  ResponseBody._resolveViewOptions()
   └────┬────┘
        │
   ┌────┴────────────────┬──────────────────┐
   │                     │                  │
   ▼                     ▼                  ▼
Regular JSON    Open Responses          A2UI Payload
(existing)      (object=="response")    (createSurface/updateComponents)
   │                     │                  │
   ▼                     ▼                  ▼
Previewer       OpenResponsesResult    A2UIParser.parse()
(unchanged)     .fromJson()                │
                     │                     ▼
                     ▼              A2UIRenderer
           OpenResponsesViewer      (component registry)
           (cards/bubbles)              │
                     │                  │
                     └────────┬─────────┘
                              ▼
                     ResponseBodySuccess
                     (existing widget tree)
```

##### What the End Result Will Look Like

When this project is done, here's what a developer using API Dash will experience:

**Scenario 1 — Testing an Open Responses endpoint (non-streaming)**:
You send a request to an endpoint that follows the Open Responses protocol. Instead of seeing a JSON blob, the response pane auto-switches to a structured view. You see the model's reasoning as a collapsed purple card at the top (click to expand the full chain-of-thought). Below that, tool calls show as blue cards — each one shows the function name, a pretty-printed version of the arguments, a status chip (completed/failed/in_progress), and the matching result right below it. The actual message text renders at the bottom as formatted markdown with inline images. A token usage bar at the bottom tells you how many tokens were used.

**Scenario 2 — Streaming an agentic workflow**:
You send a streaming request. Cards appear one by one as the model generates output. First, a reasoning card pops up and its summary text fills in progressively. Then a function call card appears — the function name shows immediately, and the arguments string grows character by character. When the tool result comes back, it slides in below the matching call. Finally, the message card appears and text streams into it. At no point do you see raw SSE events or JSON fragments.

**Scenario 3 — Previewing an A2UI agent response**:
You send a request to a Vertex AI agent that returns A2UI component descriptors. Instead of seeing the JSON describing buttons, forms, and tables, you see actual rendered Flutter widgets — interactive buttons you can tap, text fields you can type into, data tables with rows and columns. An event log panel shows what interactions the rendered UI generates, so you can verify your agent's UI behaves correctly.

**Scenario 4 — Debugging a multi-turn agentic loop**:
You make three chained requests (each using `previous_response_id`). API Dash links them in a conversation timeline. You can see the full flow: first request → model reasons → calls tool A → you send result → model reasons again → calls tool B → you send result → model gives final answer. All in one connected view, not scattered across separate request tabs.

**Scenario 5 — DashBot with structured responses**:
When you ask DashBot a question and the underlying AI returns structured output with reasoning and tool calls, DashBot renders those as visual cards inline in the chat instead of dumping raw text. If the AI returns A2UI components, you see an interactive widget right in the chat bubble.

##### What Could Go Wrong and How I'd Handle It

| Risk | Impact | Mitigation |
|------|--------|------------|
| **Extending `outputFormatter` breaks existing providers** | High | Add a parallel `structuredOutputFormatter` method that returns a richer type. Existing providers continue using the current `String?` return. No changes needed to `OpenAIModel`, `AnthropicModel`, etc. Will discuss the cleanest approach with mentors. |
| **A2UI spec changes mid-project** (currently v0.10) | Medium | Pin the component registry to a specific version. Unknown component types fall back to showing raw JSON in a card (already implemented in PoC). If the spec changes, update the registry without rewriting the renderer. |
| **Streaming takes longer than expected** | Medium | The non-streaming structured viewer from Phase 1 is fully functional on its own. If streaming takes extra time, the project still delivers a useful tool for non-streaming responses. Streaming complexity is isolated in the state machine — it does not affect the rendering layer. |
| **Multi-turn chaining across requests is complex to persist** | Medium | Start with in-session tracking (store response IDs in memory). Persistence to disk can be a follow-up if the basic chaining works well. |
| **Testing without real API keys** | Low | Already solved — the PoC includes fixture payloads for both Open Responses and A2UI formats. Real endpoint testing comes in Phase 4, and I can use my own API keys for that. |

---

#### 4. Weekly Timeline

**Project Size**: 175 hours over 12 weeks (~15 hours/week)

---

**Community Bonding Period (May 8 – June 1)**

- Attend weekly mentor sync-ups and get feedback on the PoC
- Address any review comments on [PR #1321](https://github.com/foss42/apidash/pull/1321) (idea doc) and the [PoC PR](https://github.com/foss42/apidash/pull/1358)
- Finalize design decisions with mentors: how to extend the provider interface for structured output, where to store conversation chain state, and the DashBot integration approach
- Set up test fixtures for all edge cases (malformed responses, partial data, unknown output types)

---

**Phase 1 — Open Responses Production Parser & Structured Viewer (Weeks 1–3)**

*Goal: Turn the PoC's parsing and rendering into production-quality code that handles edge cases and integrates cleanly with the existing response pipeline.*

- **Week 1 (June 2 – June 8)**
  - Finalize the `OpenResponsesResult` data models based on mentor feedback
  - Add handling for `output_image` and `output_file` content parts (PoC only handles `output_text` and `refusal`)
  - Implement robust format auto-detection with zero false positives on non-AI responses
  - Write unit tests for all `fromJson` factories using fixture payloads

  **Deliverable**: Production-ready Open Responses parser in `packages/genai` with full test coverage.

- **Week 2 (June 9 – June 15)**
  - Polish the Structured Response Viewer widgets (reasoning, function call, message cards)
  - Add markdown rendering for message text content (using existing `flutter_markdown` integration)
  - Implement inline image rendering for `output_image` parts (using existing `Image.memory` from `Previewer`)
  - Add a download button for `output_file` parts

  **Deliverable**: Complete structured viewer rendering all Open Responses output types with proper theming.

- **Week 3 (June 16 – June 22)**
  - Wire the `OpenResponsesModel` provider into `kModelProvidersMap`
  - Implement `createRequest()` for the Responses API format (`input` + `instructions` instead of `messages`)
  - Implement non-streaming `outputFormatter` and `structuredOutputFormatter`
  - Integration tests: send requests via UI, verify auto-detection triggers, verify structured view renders correctly

  **Deliverable**: Working end-to-end flow — user sends a request to an Open Responses endpoint and sees structured cards instead of raw JSON.

---

**Phase 2 — Streaming & Conversation Chaining (Weeks 4–6)**

*Goal: Handle real-time streaming responses and multi-turn agentic workflows.*

- **Week 4 (June 23 – June 29)**
  - Build the `OpenResponsesStreamState` machine for typed SSE events
  - Handle core event types: `response.output_item.added`, `response.output_text.delta`, `response.function_call_arguments.delta`, `response.output_item.done`
  - Wire stream state into `streamOutputFormatter` for the Open Responses provider

  **Deliverable**: Streaming parser that correctly routes typed deltas to the right output items.

- **Week 5 (June 30 – July 6)**
  - Connect the stream state machine to the structured viewer for progressive rendering
  - Each output item card appears as `output_item.added` fires; text and arguments fill in as deltas arrive
  - Handle edge cases: out-of-order events, partial data, connection drops
  - Write tests with recorded SSE fixtures

  **Deliverable**: Live streaming structured view — cards build up in real-time as the response streams in.

- **Week 6 (July 7 – July 13)**
  - Implement `previous_response_id` tracking in the request model
  - Build the conversation timeline view linking related requests
  - Allow expanding/collapsing individual turns in the chain
  - Mentor review before midterm evaluation

  **Deliverable**: Multi-turn conversation chaining with a connected timeline view.

---

**Midterm Evaluation (July 14 – July 18)**

*Expected state: Full Open Responses support (parsing, structured viewing, streaming, conversation chaining) working end-to-end.*

---

**Phase 3 — A2UI Component Renderer (Weeks 7–9)**

*Goal: Extend the PoC's A2UI renderer to cover the full spec with interactive state and event logging.*

- **Week 7 (July 21 – July 27)**
  - Expand the component registry to cover all core A2UI types: TextField, DatePicker, Slider, Checkbox, Radio, Dropdown, Table, Progress, Accordion, Stepper
  - Implement data binding resolution for all input types (reading from and writing to the data model)
  - Add local form state management

  **Deliverable**: A2UI renderer supporting 20+ component types with interactive state.

- **Week 8 (July 28 – August 3)**
  - Implement event logging system: user interactions with rendered components (button taps, form input, slider changes) are captured and displayed in a collapsible log panel
  - Add progressive rendering: components render as they stream in via A2UI's `updateComponents` messages
  - Handle component updates by ID (agents can update individual components without regenerating the whole UI)

  **Deliverable**: Interactive A2UI renderer with event logging and progressive rendering.

- **Week 9 (August 4 – August 10)**
  - Build the A2UI detection and routing pipeline (extending `_resolveViewOptions()`)
  - Add support for mixed responses (Open Responses output containing A2UI component descriptors)
  - Write comprehensive tests for component rendering with various payloads
  - Mentor review

  **Deliverable**: Full A2UI rendering pipeline integrated into the response viewer.

---

**Phase 4 — DashBot Integration & Polish (Weeks 10–12)**

*Goal: Bring structured AI responses into DashBot and polish everything for merge.*

- **Week 10 (August 11 – August 17)**
  - Extend `ChatBubble` in DashBot to render structured Open Responses output inline
  - When DashBot receives a response with reasoning/tool calls, render them as cards within the chat instead of raw text
  - Add A2UI component rendering within chat bubbles for interactive agent responses

  **Deliverable**: DashBot with rich structured response rendering.

- **Week 11 (August 18 – August 24)**
  - End-to-end testing with real API endpoints (OpenAI Responses API, compatible providers)
  - Edge case handling: malformed responses, partial streams, mixed content types, very large responses
  - Performance profiling: ensure structured rendering does not add noticeable latency compared to raw JSON view
  - Fix bugs identified during testing

  **Deliverable**: Battle-tested implementation passing all edge cases.

- **Week 12 (August 25 – September 1)**
  - Code cleanup, documentation, and final polish
  - Ensure all new code follows API Dash's existing patterns and conventions
  - Write developer documentation for extending the component registry and adding new output types
  - Final mentor review and project report

  **Deliverable**: Merge-ready code with documentation.

---

**Stretch Goals** (if time permits):

- **A2UI Live Playground**: A split-pane editor where you can edit A2UI JSON on the left and see rendered Flutter widgets update on the right in real-time. Useful for agent developers designing what their agent should return.
- **Visual Conversation Debugger**: An enhanced multi-turn view with collapsible branches, search/filter by output type, and export of full conversation chains as shareable reports.

---

### Contributions to API Dash

| PR | Description | Status |
|----|-------------|--------|
| [#1279](https://github.com/foss42/apidash/pull/1279) | Input validation for empty API key and endpoint URL in AI Model Selector dialog | Open |
| [#1290](https://github.com/foss42/apidash/pull/1290) | Custom OpenAI-compatible LLM provider support (Groq, OpenRouter, Mistral, etc.) | Open |
| [#1321](https://github.com/foss42/apidash/pull/1321) | GSoC 2026 idea doc — Open Responses & Generative UI | Merged |
| [#1358](https://github.com/foss42/apidash/pull/1358) | PoC — Open Responses structured viewer + A2UI component renderer | Open |

### Contributions to Other Open-Source Projects

**[astropy](https://github.com/astropy/astropy)** — Python, 500k+ lines, one of the most widely used astronomy libraries

| PR | Description | Status |
|----|-------------|--------|
| [#19403](https://github.com/astropy/astropy/pull/19403) | Fixed missing f-string prefix in `BaseAffineTransform._apply_transform` that caused error messages to show literal `{data.__class__}` instead of the actual class name. Backported to v7.2.x. | Merged |
| [#19404](https://github.com/astropy/astropy/pull/19404) | Fixed silent data corruption in `FITS_rec` slice assignment with negative indices — `data[-2:] = new_rows` was writing to wrong rows because `max(0, key.start or 0)` clamps negative indices to 0. | Merged |
| [#19450](https://github.com/astropy/astropy/pull/19450) | Fixed table index getting corrupted when a row assignment fails — index was being modified before validation, leaving it in an inconsistent state on error. | Merged |

**[Hyperledger Besu](https://github.com/besu-eth/besu)** — Java, Ethereum execution client

| PR | Description | Status |
|----|-------------|--------|
| [#10020](https://github.com/besu-eth/besu/pull/10020) | Fixed a critical bug where `serializeAndDedupOperation()` in the transaction pool created a `failedFuture` with a `TimeoutException` but never returned it — one missing `return` keyword. | Merged |
| [#10042](https://github.com/besu-eth/besu/pull/10042) | Fixed `eth_estimateGas` using the parent block's hash instead of the current block's hash for balance lookup, causing false `TRANSACTION_UPFRONT_COST_EXCEEDS_BALANCE` errors. | Merged |
| [#10051](https://github.com/besu-eth/besu/pull/10051) | Fixed a TOCTOU race condition in `eth_getBlockByNumber` where `latestResult` could change between the null check and the actual use. | Merged |
| [#10060](https://github.com/besu-eth/besu/pull/10060) | Fixed unsigned underflow in `eth_feeHistory` reward bounds calculation. | Merged |

**[Hyperledger Fabric](https://github.com/hyperledger/fabric)** — Go, enterprise blockchain platform

| PR | Description | Status |
|----|-------------|--------|
| [#5422](https://github.com/hyperledger/fabric/pull/5422) | Fixed gossip protocol not returning after sending NACK on private data store failure — execution continued into success path after error. | Merged |
| [#5424](https://github.com/hyperledger/fabric/pull/5424) | Fixed resource leak: `collItr` was not being closed before releasing `purgerLock` in `processCollElgEvents`. | Merged |
| [#5430](https://github.com/hyperledger/fabric/pull/5430) | Fixed iterator leak in `deleteDataMarkedForPurge` — iterators were not being released on all code paths. | Merged |

**[LFDT-Lockness/generic-ec](https://github.com/LFDT-Lockness/generic-ec)** — Rust, elliptic curve cryptography

| PR | Description | Status |
|----|-------------|--------|
| [#59](https://github.com/LFDT-Lockness/generic-ec/pull/59) | Added secp384r1 (NIST P-384) curve support — the first curve with a non-32-byte scalar size. Implemented `FromUniformBytes` per RFC 9380, scalar trait implementations, and instantiated all tests (180 tests passing). | Merged |

---

### Why Me

I'm a first-year student, but I have 11 merged PRs across 5 major open-source projects ([astropy](https://github.com/astropy/astropy), [Hyperledger Besu](https://github.com/besu-eth/besu), [Hyperledger Fabric](https://github.com/hyperledger/fabric), [LFDT-Lockness](https://github.com/LFDT-Lockness/generic-ec), [API Dash](https://github.com/foss42/apidash)) — including bug fixes in codebases with 500k+ lines of code in Python, Java, Go, and Rust. I can navigate unfamiliar code, find root causes, write targeted fixes, and pass existing test suites.

When I started, I didn't know how `ModelProvider` worked, or how `ResponseBodyView` controlled what gets rendered, or how the Stac pipeline turned JSON into widgets. I learned by reading the code, tracing the flow from HTTP response to rendered widget, and then building on top of it. The custom OpenAI provider [PR #1290](https://github.com/foss42/apidash/pull/1290) was my way of learning the genai package — I figured the best way to understand the provider pattern was to build a provider. The [PoC](https://github.com/foss42/apidash/pull/1358) was the same approach: I wanted to understand the response pipeline, so I extended it.

The reason I built the PoC before writing this proposal is simple — I wanted to know if I could actually do this, not just talk about it. The ~1,000 lines of working code across 7 new files and 11 modified files tell me the answer is yes. The hardest parts (streaming state machine, conversation chaining) are still ahead, but I have a solid foundation and I know exactly where each piece fits in the codebase.

I'm not coming into this project cold. I've been testing AI APIs for months, I know the pain this solves firsthand, and I've already written the code that proves the approach works.

**Links**:
- GitHub Profile: https://github.com/sridhar-panigrahi
- LinkedIn: https://www.linkedin.com/in/shridhar-panigrahi/
- PoC PR: https://github.com/foss42/apidash/pull/1358
- PoC Demo — Open Responses Viewer: https://youtu.be/paN-KGIhNms
- PoC Demo — A2UI Renderer: https://youtu.be/T2KbHth736U
- API Dash PR #1279 — Input Validation: https://github.com/foss42/apidash/pull/1279
- API Dash PR #1290 — Custom OpenAI Provider: https://github.com/foss42/apidash/pull/1290
- API Dash PR #1321 — Idea Doc (Merged): https://github.com/foss42/apidash/pull/1321
- Idea 5 Discussion: https://github.com/foss42/apidash/discussions/1227
- Open Responses Spec: https://www.openresponses.org/
- A2UI Spec: https://github.com/google/A2UI
- Flutter GenUI SDK: https://github.com/flutter/genui
- GSoC Weekly Calls: https://luma.com/embed/calendar/cal-ZTW02O2EsWRs6V4/events
- astropy PR #19403: https://github.com/astropy/astropy/pull/19403
- astropy PR #19404: https://github.com/astropy/astropy/pull/19404
- astropy PR #19450: https://github.com/astropy/astropy/pull/19450
- Besu PR #10020: https://github.com/besu-eth/besu/pull/10020
- Besu PR #10042: https://github.com/besu-eth/besu/pull/10042
- Besu PR #10051: https://github.com/besu-eth/besu/pull/10051
- Besu PR #10060: https://github.com/besu-eth/besu/pull/10060
- Fabric PR #5422: https://github.com/hyperledger/fabric/pull/5422
- Fabric PR #5424: https://github.com/hyperledger/fabric/pull/5424
- Fabric PR #5430: https://github.com/hyperledger/fabric/pull/5430
- generic-ec PR #59: https://github.com/LFDT-Lockness/generic-ec/pull/59
