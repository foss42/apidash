# GSoC 2025 Proposal: AI UI Designer for APIs

## About

**Full Name**: Ning Wei  
**Contact Info**: Allenwei0503@gmail.com 
**Discord Handle**: @allen_wn  
**GitHub Profile**: [https://github.com/AllenWn](https://github.com/AllenWn)  
**LinkedIn**: [https://www.linkedin.com/in/ning-wei-allen0503](https://www.linkedin.com/in/ning-wei-allen0503)  
**Time Zone**: UTC+8  
**Resume**: https://drive.google.com/file/d/1Zvf1IhKju3rFfnDsBW1WmV40lz0ZMNrD/view?usp=sharing

## University Info

**University**: University of Illinois at Urbana-Champaign  
**Program**: B.S. in Computer Engineering  
**Year**: 2nd year undergraduate  
**Expected Graduation**: May 2027

---

## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?**  
Not yet officially, but I’ve been actively exploring open source projects like API Dash and contributing via discussion and design planning. I am currently studying the API Dash repository and developer guide to prepare for my first PR.

2. **What is your one project/achievement that you are most proud of? Why?**  
I'm proud of building an AI-assisted email management app using Flutter and Go, which automatically categorized and responded to emails using ChatGPT API. It gave me end-to-end experience in integrating APIs, generating dynamic UIs, and designing developer-friendly tools.

3. **What kind of problems or challenges motivate you the most to solve them?**  
I enjoy solving problems that eliminate repetitive work for developers and improve workflow productivity — especially through automation and AI integration.

4. **Will you be working on GSoC full-time?**  
Yes. I will be dedicating full-time to this project during the summer.

5. **Do you mind regularly syncing up with the project mentors?**  
Not at all — I look forward to regular syncs and feedback to align with the project vision.

6. **What interests you the most about API Dash?**  
API Dash is focused on improving the developer experience around APIs, which is something I care deeply about. I love the vision of combining UI tools with AI assistance in a privacy-first, extensible way.

7. **Can you mention some areas where the project can be improved?**  
- More intelligent code generation from API response types  
- Drag-and-drop UI workflow  
- Visual previews and theming customization  
- Integration with modern LLMs for field-level naming and layout suggestions

---

## Project Proposal Information

### Proposal Title

AI UI Designer for APIs

# Relevant Issues: [#617]  

### Abstract

This project aims to develop an AI-powered assistant within API Dash that automatically generates dynamic user interfaces (UI) based on API responses (JSON/XML). The goal is to allow developers to instantly visualize, customize, and export usable Flutter UI code from raw API data. The generated UI should adapt to the structure of the API response and be interactive, with features like sorting, filtering, and layout tweaking. This tool will streamline frontend prototyping and improve developer productivity.

---

### Detailed Description

The AI UI Designer will be a new feature integrated into the API Dash interface, triggered by a button after an API response is received. It will analyze the data and suggest corresponding UI layouts using Dart/Flutter widgets such as `DataTable`, `Card`, or `Form`.

#### Step 1: Parse API Response Structure

- Focus initially on JSON (XML can be added later)
- Build a recursive parser to convert the API response into a schema-like tree
- Extract field types, array/object structure, nesting depth
- Identify patterns (e.g., timestamps, prices, lists)

#### Step 2: Design AI Agent Logic

- Use a rule-based system to map schema to UI components
    - List of objects → Table
    - Simple object → Card/Form
    - Number over time → Line Chart (optional)
- Integrate LLM backend (e.g., Ollama, GPT API) to enhance:
    - Field labeling
    - Layout suggestion
    - Component naming

#### Step 3: Generate UI in Flutter

- Dynamically generate:
    - `DataTable`, `Card`, `TextField`, `Dropdown`, etc.
    - Optional chart widgets (e.g., `fl_chart`)
- Support:
    - Layout rearrangement (form-based or drag-drop)
    - Field visibility toggles
    - Previewing final UI

#### Step 4: Export UI Code

- Export generated layout as Dart code
- Allow download or copy-to-clipboard
- Support JSON config export (optional for renderer-based architecture)

#### Step 5: Integrate into API Dash

- Add AI UI Designer button in the API response view
- Launch UI editing pane inside app
- Ensure local-only, privacy-friendly execution
- Write tests, docs, and polish UX

---

## Weekly Timeline (Tentative)

| Week | Milestone |
|------|-----------|
| Community Bonding | Join Discord, interact with mentors, finalize approach, get feedback |
| Week 1–2 | Build and test JSON parser → generate basic schema |
| Week 3–4 | Implement rule-based UI mapper; generate simple widgets |
| Week 5–6 | Integrate initial Flutter component generator; allow basic UI previews |
| Week 7 | Midterm Evaluation |
| Week 8–9 | Add customization options (visibility, layout) |
| Week 10 | Integrate AI backend (e.g., Ollama/GPT) for suggestions |
| Week 11–12 | Add export functions (code, JSON config) |
| Week 13 | Final polish, tests, docs |
| Week 14 | Final Evaluation, feedback, and delivery |

---

Thanks again for your time and guidance. I’ve already started studying the API Dash codebase and developer guide, and I’d love your feedback on this plan — does it align with your vision?  
If selected, I’m excited to implement this project. If this idea is already taken, I’m open to switching to another API Dash project that fits my background.
