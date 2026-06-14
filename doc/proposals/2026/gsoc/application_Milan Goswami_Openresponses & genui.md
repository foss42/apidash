## Structured OpenResponses & Generative UI Rendering in API Dash

1. **Full Name** Milan Goswami

2. **Contact info (public email)** milangoswami879@gmail.com

3. **Discord handle** `pro_milan07`

4. **GitHub profile link** https://github.com/Milan-Goswami

5. **LinkedIn** https://www.linkedin.com/in/milan-goswami01/

6. **Time zone** IST (UTC +5:30)

9. **Resume** [Link](https://drive.google.com/file/d/1jTqh3D1l08OvUqCHE_NCufvbQdtE3ONK/view?usp=sharing)


## University Info

1. **University name** Dr. D. Y. Patil Vidyapeeth, Pimpri, Pune

2. **Program** Master of Computer Applications (MCA)

3. **Year** First Year

4. **Expected graduation date** 2027


## Motivation & Past Experience

### 1. Have you worked on or contributed to a FOSS project before?

=>I have worked on large codebases but not direct experience with contribution but I have been exploring the API Dash codebase and trying to understand how things are working internally.


### 2. What is your one project/achievement that you are most proud of? Why?

=>I think i am proud of my Flutter-based Fitness App project because apart from track excercise and calories and all i built an basic AI feature in it which detects the user’s body posture in real-time and gives feedback like “keep your back straight”. It was my first time combining AI with Flutter and it was a challenging feature that required creative problem-solving, and successfully implementing it taught me a lot.


### 3. What kind of problems motivate you the most?

=>I like solving problems where things are complicated and we can make them simple for users especially problems related to UI/UX and developer tools. I enjoy building features that address real pain points for end users.

### 4. Will you be working on GSoC full-time?

=>Yes, i will primarily be working full-time on GSoC. Occasionally, I may have exams, course projects, or job/internship responsibilities, but they will not impact my commitment to GSoC.


### 5. Do you mind regularly syncing up with the project mentors?

=>No, i dont mind but there are might be a exams or some work but i am usually available after 5PM IST and can get on calls when its needed


### 6. What interests you the most about API Dash?

=>It has a clean and minimalist design and main reason is that it is built using Flutter so it also work in IOS and window and anywhere so its helps a lot and Plus, Flutter and Dart hold a special place for me since i build my first project in flutter


### 7. Can you mention some areas where the project can be improved?

=>Based on my exploration currently when we use AI APIs, the response is mostly raw JSON and it is not easy to understand developers have to manually read everything. I think improving the visualization of responses and showing them in a structured way can make things easier for developer.


### 8. Have you interacted with and helped API Dash community?

=>Yes, i attended weekly meetings and also active on the discord server where i follow discussions and updates.


## Project Proposal Information

- **Project Title:** Structured OpenResponses & Generative UI Rendering in API Dash

- **Issue Description:**
Currently, when developers use AI APIs in API Dash, the response is show as an raw json this makes it difficult to understand what the model actually did and to understand it developer needs to read all the json which is time consuming, especially when there are multiple outputs like messages, reasoning, or tool calls. Developers have to manually read and figure out everything, which takes time and it is not very user-friendly and its very time consuming also.

### 2. Abstract

In this project, I propose to improve this by adding a structured visualization layer based on the OpenResponses format. Instead of showing raw json, the response will be displayed in a more readable way using cards for messages, reasoning, function calls, and outputs. Along with this, A2UI/GenUI-based components will be rendered as actual UI widgets, so developers can directly see  how the response looks visually.
i have already built a working proof of concept where:

OpenResponses JSON is parsed and shown in a structured tab
A2UI components are rendered as Flutter widgets
Basic support for AI responses is added using JSON extraction

This feature will help developers understand API responses quickly without reading large JSON data. It improves clarity, saves time, and makes API Dash more useful when working with modern AI APIs.


### 3. Detailed Description

### Implementation Overview

The project extends the existing response rendering system by introducing a structured interpretation layer.

Instead of modifying how requests are executed, the focus is on improving how responses are processed and visualized.

The system will follow a simple pipeline:

`Response → Detection → Parsing → Rendering → Fallback`

### Response Processing Flow
API response is received
Check if response is JSON
Detect OpenResponses format
Parse `output[]` array
Identify item types
Render structured UI or fallback

- This ensures the system remains aligned with current API Dash architecture.

### Structured Rendering Layer

Each item in `output[]` will be handled independently using a type-based approach:

message → rendered as readable text
reasoning → displayed as separate block
function_call → shows function name + arguments
function_call_output → linked using `call_id`
a2ui → passed to UI renderer

- Unknown types will be safely handled using fallback cards
- This ensures no data loss and avoids crashes

### A2UI / GenUI Rendering

A lightweight registry-based renderer will be introduced:

Maps JSON → Flutter widgets
Supports nested layouts
Provides fallback for unsupported components

Initial supported components:

text
card
button
row / column

- Focus is on usable MVP, not full spec coverage

### AI Mode Handling

AI responses are often not clean JSON.

To handle this:

Extract JSON from response text
Attempt structured parsing
Fallback to raw view if extraction fails

- This ensures stability across different providers

### Integration Strategy

The implementation will:

Extend existing `ResponseBody` logic
Add a structured view option
Keep existing views (Raw / Preview) unchanged
Avoid breaking current features



### Demo Video[POC] : [Link](https://drive.google.com/file/d/1AdDqRp5puBQCJc9ZTA9kJaFX7E_6TtZt/view?usp=drive_link)

### Screenshots:

**A2UI Before & After:**
![A2UI Before After](./images/a2ui_before_after.png)

**Combine Before & After:**
![Combine Before After](./images/combine_before_after.png)

- My focus on this project is to build a minimal and practical implementation that integrates well with the existing API Dash   architecture.


## 4. Weekly Timeline


### Week 1 — Detection & Base Pipeline (15h)

Work:

- Analyze response rendering flow
- Add structured view option
- Implement OpenResponses detection
- Add safe JSON parsing

Build:
- System identifies structured responses

Outcome:
- Entry layer for structured processing ready

### Week 2 — Parser & Core Rendering (15h)

Work:
- Build parser for output[]
- Implement type dispatch system
- Render message + reasoning

Build:
- Basic structured viewer

Outcome:
- Readable AI response output

### Week 3 — Function Call Handling (15h)

Work:
- Parse function_call
- Extract arguments
- Build UI block for calls

Build:
- Tool execution visible

Outcome:
- Clear understanding of AI actions

### Week 4 — Output Linking & Full Flow (15h)

Work:
- Implement function_call_output
- Link using call_id
- Improve UI grouping

Build:
- Complete OpenResponses flow

Outcome:
- End-to-end structured visualization

### Week 5 — A2UI Renderer (15h)

Work:
- Build component registry
- Implement text + card
- Handle nested UI

Build:
- Basic UI rendering

Outcome:
- Generative UI visible

### Week 6 — Final Integration & Stability (15h)

Work:
- Add button, row, column
- Improve AI mode handling
- Fix edge cases
- Optimize UI

Build:
- Full system working

Outcome:
- Production-ready feature


### Deliverables
- Structured OpenResponses viewer
- A2UI / GenUI renderer
- JSON extraction system
- Integrated response visualization
- Stable fallback handling
- Add fallback handling (non-supported formats → normal view)
- Ensure no break in existing API Dash features
- Fix edge cases (invalid JSON, missing fields, unknown types)

- By end: Production-safe implementation
