# GSoC Proposal — Open Responses & Generative UI: From Raw JSON to Live UI

---

## About

| Field | Details |
|-------|---------|
| Full Name | Syed Abdullah |
| Email | syedabdullahcslab@gmail.com |
| Discord | syed.abdullah. |
| GitHub | https://github.com/Syed-Abdullah-G |
| LinkedIn | https://www.linkedin.com/in/syed-abd/ |
| Time Zone | IST (UTC +5:30) |
| Resume | https://drive.google.com/file/d/11UtTxVmlx2_h6w2TSpurqsIbsLhNJ03w/view?usp=sharing |

---

## University Info

| Field | Details |
|-------|---------|
| University | Aalim Muhammed Salegh College of Engineering |
| Program | B.E. Computer Science and Engineering |
| Year | 3rd Year |
| Expected Graduation | July 2027 |

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

This is my first time contributing to open source, and a big reason I applied to GSoC. I've built projects on my own, but I want to work on something real that people actually use and get feedback from experienced developers. API Dash feels like the perfect place to start that journey.

**2. What is your one project/achievement that you are most proud of?**

My proudest project is a "Swipe to Apply" job app — like Tinder for jobs — simplifying job search into a single swipe. I built swipe gestures, animations, and state management from scratch, learning a lot in the process. [View on App Store](https://apps.apple.com/in/app/applybee-ai-swipe-to-apply/id6757182350)

**3. What kind of problems or challenges motivate you the most?**

I enjoy turning complex systems into simple experiences. In my swipe app, I simplified job hunting and fine-tuned AI APIs to show relevant, scam-free posts. Similarly, transforming large AI JSON into a clean UI is a challenge I enjoy.

**4. Will you be working on GSoC full-time?**

Yes, full-time. I'm currently in college but can dedicate ~4 hours daily (≈30 hrs/week), with no other commitments during GSoC.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — I actually like regular check-ins. They help me stay on track and catch things early, and honestly that's why I'm here: to learn and get real guidance from experienced developers.

**6. What interests you the most about API Dash?**

API Dash combines AI and APIs, and I like how it simplifies complex responses into clean, usable output. It's also open source with strong developer support, making it a great place to learn and contribute.

**7. Can you mention some areas where the project can be improved?**

1. A sandbox mode to paste JSON and preview the UI would help a lot.
2. The response history could be more visual with a timeline view for easier debugging.

**8. Have you interacted with and helped the API Dash community?**

I haven't actively contributed yet, but I've gone through the documentation, explored the codebase, and regularly attended the weekly meet discussions to understand the project and community better.

---

## Project Proposal

### Abstract

Right now API Dash shows raw JSON for AI responses, making it hard to understand what actually happened. This project will convert those into clean visuals — like interactive UI components — with one-click export to Flutter or React code. It uses Open Responses and A2UI standards

---

![A2UI Flow](https://github.com/Syed-Abdullah-G/apidash/blob/20b7d6b06e7d8e6d7f41b92f0fdbb1c3b24daef2/doc/proposals/2026/gsoc/images/understanding-A2UI.png)

### The Problem in Plain English

Imagine you send a request to an AI API and it comes back with something like this:

```json
{
  "type": "response",
  "output": [
    {
      "type": "message",
      "content": [
        { "type": "text", "value": "Hello, user!" },
        { "type": "button", "label": "Click Me" }
      ]
    }
  ]
}
```

Instead of just showing this raw JSON, my project parses this and shows the respective "UI card" itself, which the end user can look and also export its code.

---
# Detailed Description
---

### How It Works — The Flow

**Step 1** — The user sends an AI API request from API Dash complying Open Responses format.

**Step 2** — The response comes back as JSON

**Step 3** — If the JSON contains A2UI format bindings/mapping, then GenUI SDK for Flutter is used to render the UI components

**Step 4** — The developer can switch between raw JSON view and visual view at any time.

**Step 5** — They can click Export Code to get clean Flutter/React code ready to use.

---

### The Five Pieces I Will Build

### Piece 1 — The Request Handler (Open Responses Integration)
Implements support for sending AI API requests using the Open Responses format, ensuring structured outputs (type, output[], content[]).
This guarantees compatibility with downstream parsing and UI rendering.

### Piece 2 — The Response Parser (Structured JSON → Internal Model)
Builds a parsing layer that converts raw JSON into strongly-typed internal models (e.g., Message, Reasoning, UIComponent).
Handles:
*nested content[] arrays*
*different type values (text, card, button, etc.)*
*streaming updates (incremental parsing)*

This acts as the core abstraction layer between raw API data and UI.

### Piece 3 — The A2UI Renderer (GenUI SDK Integration)

Detects A2UI-compatible structures (UI bindings/mappings in JSON) and renders them using the GenUI Flutter SDK.

*Maps JSON → widget tree using a registry pattern*
*Example: {"type": "button"} → Flutter ElevatedButton*
*Supports extensibility for new components*
*Reference (GenUI repo): https://github.com/flutter/genui*

### Piece 4 — The Dual View System (Inspector + Renderer)
Implements a split/toggle UI:

*Raw View → formatted JSON with syntax highlighting*
*Visual View → rendered widgets via GenUI*

### Piece 5 — The Code Exporter (UI → Source Code)
Generates production-ready UI code from the rendered structure.

*Converts internal UI tree → Flutter / React code*
*Maintains hierarchy, props, and layout*
*Output is copy-paste ready*

---

### Architecture Flow Diagram

![System Architecture Flow](https://github.com/Syed-Abdullah-G/apidash/blob/4a9cba934fc79eac6f97777e62dc4e211f20ba95/doc/proposals/2026/gsoc/images/system_architecture_updated_flow.svg)

---
My Research
---
For this case, I forked the official [genui flutter repo](https://github.com/flutter/genui) and did the following :

*1. Made requests to be made using Open Responses specification*

*2. Modified the internal code to support Open Responses Specification*

*3. Carefully Understood the full codebase and UI-component rendering process*

# AiClient()
This is the class that contains sendStream(prompt, history)

![AiClient](https://github.com/Syed-Abdullah-G/apidash/blob/6388d878dd7368511394ca003a00a10b1c1ab809/doc/proposals/2026/gsoc/images/ai_client.png)

# DartanticAiClient
This is the flutter/dart specific implementation present in the *genui* repo

![DartanticAiClient](https://github.com/Syed-Abdullah-G/apidash/blob/6388d878dd7368511394ca003a00a10b1c1ab809/doc/proposals/2026/gsoc/images/dart-based-ai-client.png)

which I have modified into using the *Open Responses* specification as below :

![OpenResponses](https://github.com/Syed-Abdullah-G/apidash/blob/6388d878dd7368511394ca003a00a10b1c1ab809/doc/proposals/2026/gsoc/images/open%20responses%20ai%20client.png)


This is how the AiClient() gets connected to the ChatSession class, it is done throught the AiClientTransport()

![ChatSession](https://github.com/Syed-Abdullah-G/apidash/blob/f29d1ee14ede1b48704d10351d8339f0be541d06/doc/proposals/2026/gsoc/images/chatsession%20and%20aiclient%20connection.png)

inside ChatSession there is _init() method, which specifies state and event management, it listens for incoming events and performs the respective operation.

![initmethod](https://github.com/Syed-Abdullah-G/apidash/blob/f29d1ee14ede1b48704d10351d8339f0be541d06/doc/proposals/2026/gsoc/images/initi%20method%20.png)

# The UI Side
On the app home screen there is a textcontroller and submit button at the bottom, in which prompt shall be given.

![submit_button](https://github.com/Syed-Abdullah-G/apidash/blob/f29d1ee14ede1b48704d10351d8339f0be541d06/doc/proposals/2026/gsoc/images/textfield%20submit%20button.png)

the _sendMessage() method calls the conversation.sendRequest(message), which send flow to the _init() method that checks the incoming response and performs the required operation


# How normal vs UI responses are rendered
This is done using the Surface() method, which looks if the respones has "surfaceId" then it uses the Surface() method to render those UI components, also for normal responses- the method just shows the message as a text.

![surface_rendering](https://github.com/Syed-Abdullah-G/apidash/blob/f29d1ee14ede1b48704d10351d8339f0be541d06/doc/proposals/2026/gsoc/images/surface%20message%20renderer.png)

## 📅 Weekly Timeline — 10 Weeks

| Week | Focus | What I Will Do | Deliverable |
|------|-------|----------------|-------------|
| 1 | Setup and Research | Study Open Responses format and A2UI UI-binding structure, explore API Dash codebase and response flow | Clear architecture plan and integration points |
| 2 | Open Responses Request Handler | Implement sending all AI API requests using Open Responses format in API Dash | Working Open Responses request pipeline |
| 3 | A2UI Detection Layer | Detect presence of A2UI UI bindings/mappings within Open Responses JSON | Reliable A2UI detection system |
| 4 | A2UI Mapping | Extract and normalize A2UI UI bindings into a format usable by the rendering layer | Structured A2UI mapping ready for rendering |
| 5 | GenUI Renderer (Basics) | Integrate GenUI Flutter SDK to convert A2UI mappings into basic interactive UI (text, button, card) | Basic real-time UI rendering |
| 6 | Advanced UI Rendering | Support complex UI components and layouts (lists, images, structured cards) via GenUI | Full interactive UI rendering support |
| 7 | Dual View System | Implement toggle between raw Open Responses JSON and rendered UI view | Seamless JSON ↔ UI switch |
| 8 | Code Exporter | Generate clean Flutter/React code from rendered UI (based on A2UI mappings) | Working export feature |
| 9 | Streaming / Real-time Updates | Show responses updating live as data arrives | Real-time UI updates |
| 10 | Testing and Refinement | Test full pipeline (Open Responses → A2UI → GenUI render → export), fix bugs | Stable and polished system |

> **Weeks 11–12:** Reserved for additional open-source best practices, documentation, cleanup, and final project polishing.
> I planned 12 weeks instead of 10 to allow extra time for testing and documentation, ensuring everything is stable and well-polished.

## My PoC Video
[![Watch the video](https://img.youtube.com/vi/Hs0ZgFOqBRk/0.jpg)](https://youtu.be/Hs0ZgFOqBRk)
