### About

1. Full Name - Jugal Mahida
2. Contact info - jugal.mahida.work@gmail.com
3. Discord handle - jugalmahida
4. Portfoilo - https://jugalmahida.com
5. Blog - N/A
6. GitHub Profile - https://github.com/jugalmahida
7. Socials
   - X (Twitter) - [JugalMahida07](https://x.com/JugalMahida07)
   - LinkedIn - [jugal-mahida](https://www.linkedin.com/in/jugal-mahida/)
8. Time zone - IST
9. Resume - [Resume-Jugal-Mahida](https://drive.google.com/file/d/1R_qr7yzPG71-g-szEhkBQigU2m5YQBaP/view)

### University Info

1. Gujarat University, Centre For Professorial Courses
2. Program - M.Sc.IT (Integrated) in Software Development ( CGPA : 9.2 )
3. Post-Graduate Year - 2025

### Motivation & Past Experience

Short answers to the following questions:

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

- No

2. What is your one project/achievement that you are most proud of? Why?

- [GUCPC](https://gucpc.in/), My final year project, crafted my college's official website, its helped to apply skills into real world application.

3. What kind of problems or challenges motivate you the most to solve them?

- Real-world challenges, especially real-time & ERP systems.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

- I will be contributing to GSoC 2026 part-time alongside my job.

5. Do you mind regularly syncing up with the project mentors?

- Nope

6. What interests you the most about API Dash?

- My interest in Dart, one of my preferred programming languages

7. Can you mention some areas where the project can be improved?

- APIDASH Should have the feature of intercept the request, it help to develop more secure APIs.

8. Have you interacted with and helped API Dash community?

- Yes, I join the APIDASH's Discord & Reading new announcements.

### Project Proposal Information

1. Proposal Title :- Open Responses & Generative UI -Rich API Response Visualization in APIDASH.
[Project Link](https://github.com/foss42/apidash/discussions/1227)
2. Abstract:

- When integrating with AI APIs in real world applications, the hard part
  is handling AI responses like user & system content, tool calls, and
  reasoning traces. Currently, API Dash shows AI responses as raw JSON.
  That's fine for simple REST APIs, but modern AI APIs like OpenAI,
  Anthropic, and Gemini return something much more complex.
- To overcome this, I'll build an **Open Responses Viewer** that
  automatically detects which AI provider a response came from, understands
  its structure, and renders each part — text, tool calls, images, and token
  usage — as clean, readable widgets.
- Second, I'll build a **Generative UI Preview** that takes
  [A2UI](https://developers.googleblog.com/introducing-a2ui-an-open-project-for-agent-driven-interfaces/)
  or [GenUI SDK for Flutter](https://docs.flutter.dev/ai/genui) compatible
  JSON and shows a live Flutter or React preview of exactly how that UI will
  look in a real app.

3. Detailed Description

#### 3.1 Problem :- When a developer calls an AI API from API Dash today, they receive a response like this:

```json
{
  "id": "resp-xyz456",
  "object": "response",
  "created": 1710000000,
  "model": "gpt-5.3",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "tool_calls": [
          {
            "id": "call_1",
            "type": "function",
            "function": {
              "name": "get_weather",
              "arguments": "{\"city\": \"Ahmedabad\"}"
            }
          }
        ]
      },
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 25,
    "completion_tokens": 10,
    "total_tokens": 35
  }
}
```

| This is shown as a flat JSON tree, The developer cannot immediately see:

- Token usage at a glance
- What the tool was called with
- Which part is the text response vs. a tool call
- Whether the response conforms to a known schema

#### **3.2 Open Responses Viewer**

The parser handles:

- OpenAI Responses API format
- Anthropic Messages API format
- Gemini GenerateContent format
- Generic fallback for unknown schemas

Here example of **OpenAI API Response** converted into **Open Response Specification**

```
{
  "id": "resp-xyz456",
  "object": "response",
  "created": 1710000000,
  "model": "gpt-5.3",
  "status": "completed",
  "output": [
    {
      "type": "function_call",
      "id": "call_1",
      "status": "completed",
      "name": "get_weather",
      "call_id": "call_1",
      "arguments": "{\"city\": \"Ahmedabad\"}"
    }
  ],
  "usage": {
    "input_tokens": 25,
    "output_tokens": 10,
    "total_tokens": 35
  }
}
```


#### **3.3 Generative UI (A2UI or GenUI SDK for Flutter)**

It shows developers how that response will look as a 
real native UI component in their Flutter or Web app.

When an AI API returns A2UI or GenUI SDK compatible JSON inside 
the `output` blocks (alongside or instead of `function_call` or 
text), the preview pane automatically activates.

**Example A2UI output that would appear in the `output` block:**
```
{
  "type": "card",
  "children": [
    { "type": "text", "value": "Weather in Ahmedabad", "style": "heading" },
    { "type": "badge", "label": "32°C · Sunny", "color": "amber" },
    { "type": "button", "label": "View Forecast", "action": "open_url" }
  ]
}
```
This is a natural extension of the `get_weather` function call 
from 3.2 — the function runs, returns structured data, and the 
AI describes the UI to display it.

**What the GenUI Preview widget does:**

- **Detects** A2UI or GenUI SDK compatible JSON inside the response
- **Renders** it as real native Flutter widgets in a side-by-side 
  preview pane.
  the right
- **Supports** core A2UI components: text, card, badge, button, 
  image, column, row
- **Exports** ready-to-paste Dart code via a "Copy Widget Code" 
  button so developers can drop it directly into their Flutter app
- **React version** — a mirrored TypeScript component renders the 
  same A2UI JSON as HTML/CSS for web developers

#### 4. Weekly Timeline

| Week | Description | Outcomes |
|---|---|---|
| **Week 1** | Study Open Responses specifications, AI API responses formats of OpenAI, Gemini & Anthropic | Understanding of Open Response, AI API Responses & its structures and How to use Open Responses |
| **Week 2** | Build  parser to support OpenAI, Anthropic and Gemini formats using open response, build SchemaDetector that auto-identifies the provider from response structure | Parser handles all 3 providers, auto-detection working |
| **Week 3**  | Build `FunctionCallWidget` — expandable card showing function name, parsed arguments as key→value list, status chip and copy button | `FunctionCallWidget` integrated into response panel |
| **Week 4**  | Build `UsageWidget` (token pills), `ResponseHeaderWidget` (model, status, timestamp), wire all widgets into the **Rendered** tab | Full Rendered tab visible in API Dash with real responses |
| **Week 5**  | Add SSE / streaming support — progressive rendering as chunks arrive, token-by-token text display, partial tool call handling | Streaming responses render live inside the Rendered tab |
| **Week 6** | Buffer week — fix bugs from weeks 1–5, improve edge case handling, write integration tests, mentor review | Stable, tested Open Responses Viewer ready for midterm |
| **Week 7** | Study A2UI spec and GenUI SDK for Flutter, Build a working prototype | Understanding A2UI & GenUI libraries & A Working Prototype |
| **Week 8**  | Build `GenUIPreviewWidget` — renders A2UI or GenUI JSON as real Flutter widgets, | Live Flutter widget preview working inside API Dash |
| **Week 9**  | Build `CodeExportWidget` — generates ready-to-paste Dart code | One-click Dart code export working |
| **Week 10** | Build React / TypeScript `GenUIPreview` component that renders the same A2UI JSON as HTML/CSS/React for web developers | Web version of GenUI Preview working and tested |
| **Week 11**| End-to-end testing across all providers and A2UI components, fix edge cases, performance check on large responses | All features stable and tested end-to-end |
| **Week 12** | Write documentation, add code comments, record a short demo video, clean up all PRs | Docs merged, demo video ready |

5. Architecture Overview

The following diagram illustrates the complete flow of the 
Open Responses & Generative UI feature inside API Dash:
![Architecture Diagram](/doc\proposals\2026\gsoc\images\architecture_jugal_mahida.png)
