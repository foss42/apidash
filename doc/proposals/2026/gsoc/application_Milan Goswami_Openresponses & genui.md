
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

The implementation will extend the current response rendering pipeline in API Dash to support structured visualization for OpenResponses and UI rendering for A2UI components. Instead of introducing a separate system, the idea is to plug into the existing flow where responses are already processed and displayed.

**Approached Solution:**


- **Response handling:** 

When a response is received, the system will first check if it is json. If the structure matches OpenResponses, it will process the output[] array.

Each item in the array will be handled based on its type.

->Messages will be rendered as readable text
->Reasoning will be separated from final output
->Function calls will be shown with their arguments
->Function outputs will be mapped using call_id
->A2UI items will be passed to the UI renderer

- **UI Rendering (A2UI / GenUI):** 

For UI-based responses, i will use small adapter layer to map json definitions to flutter widgets.
The renderer will support basic components like text, card, button, row / column
The goal is support the common components defined in the A2UI specification and render them inside the response panel.

- **AI Mode Handling:**
The one challenge is that AI responses are not always valid json, to handle this will add lightweight extraction step before parsing. this will extract the valid json part from the response and pass it to the existing pipeline.
this approach keeps the system stable without modifying how providers work. nothing will be change in request handling or provider


- **Current Implementation (POC):**

i have already implemented a working prototype:
-Structured tab added in response view
-OpenResponses parsing for `output[]`
-Basic A2UI component rendering
-HTTP testing using a mock server
-Initial support for AI mode


- **Deliverables:**
-Structured response viewer for OpenResponses
-A2UI component rendering support
-Integration with HTTP and AI mode
-Fallback to existing views when format is not detected

Demo Video : [Link](https://drive.google.com/file/d/1AdDqRp5puBQCJc9ZTA9kJaFX7E_6TtZt/view?usp=drive_link)

Screenshots :
![](.images/a2ui_before_after.png)

![](.images/combine_before_after.png)

The focus of this project is to build a minimal and practical implementation that integrates well with the existing API Dash architecture.

## 4. Weekly Timeline


### Week 1
Week 1
Clean and organize current POC code
Properly integrate Structured tab into existing UI (no breaking changes)
Improve OpenResponses detection logic
Start parsing output[] safely

->By end: Clean base setup + stable entry point for structured rendering

### Week 2
Implement full support for message type
Render text properly inside structured viewer
Add support for reasoning and display it separately
Handle cases where fields are missing or null

->By end: Basic structured viewer working (message + reasoning)

### Week 3
Implement function_call parsing
Extract function name and arguments
Design simple UI block for function call display
Ensure arguments are readable (formatted JSON)

->By end: Function call visualization working

### Week 4
Implement function_call_output support
Link output with function call using call_id
Improve overall UI layout of structured viewer
Test with complete OpenResponses examples

->By end: Full OpenResponses pipeline working end-to-end 

### Week 5
Start A2UI rendering implementation
Improve GenUI adapter structure
Implement rendering for:
text
card

->By end: Basic UI rendering working inside response panel

### Week 6
Add support for:
button
row
column
Handle nested children rendering properly
Fix layout issues inside card/containers

->By end: A2UI rendering usable for real UI responses

### Week 7
Integrate A2UI + OpenResponses together
Handle mixed responses (text + UI together)
Improve spacing and layout in response panel

->By end: Combined structured + UI rendering working

### Week 8
Improve AI mode support
Integrate JSON extraction properly
Handle different model outputs (inconsistent formats)
Add fallback if JSON extraction fails

->By end: AI mode working reliably with structured view

### Week 9
Optimize performance (large responses, nested UI)
Improve scrolling and rendering smoothness
Reduce unnecessary rebuilds

->By end: Smooth and stable UI experience

### Week 10
Add fallback handling (non-supported formats → normal view)
Ensure no break in existing API Dash features
Fix edge cases (invalid JSON, missing fields, unknown types)

->By end: Production-safe implementation