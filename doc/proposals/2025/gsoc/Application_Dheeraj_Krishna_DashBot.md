# GSoC 2025 Proposal: DashBot – AI Assistant for API Dash (#621) and New Feature Requests

## Personal Information

- **Name:** Dheeraj Krishna Gedda
- **Email:** dheerajdheeru64@gmail.com
- **Resume:** [Drive Link](https://drive.google.com/file/d/1Ug2jdta9M9YdmsP6Uik62ifLqzdwf0KB/view?usp=sharing)
- **GitHub:** [dheerxj](https://github.com/dheerxj)  
- **LinkedIn:** [linkedin.com/in/dheeraj](https://www.linkedin.com/in/dheeraj-krishna-115499238/)  
- **University:** Institute of Aeronautical Engineering  
- **Degree Program:** B.Tech in Computer Science Engineering (AI and ML)  
- **Current Year:** 4th Year  

---

## 🧠 Synopsis

**Project:** DashBot – AI Assistant for API Dash (#621)  
DashBot is an AI-powered assistant for API Dash, designed to assist developers in debugging, testing, documenting, and visualizing APIs using natural language. It will support modular plug-ins, LLM benchmarking, and developer productivity tools — transforming API Dash into a smarter, AI-first platform.

---

## 🌍 Benefits to the Community

- Simplifies API debugging and understanding
- Accelerates code generation and documentation tasks
- Helps beginners write and understand test cases
- Adds smarter productivity features (e.g., numbering, zoom, 2D scroll)
- Enables LLM benchmarking, valuable for enterprise adoption
- Makes API Dash a more developer-friendly tool

---

## ✅ Deliverables

- [ ] Feature of Numbering and 2D scrolling for authentic view of response
- [ ] Response explanation and discrepancy identification
- [ ] Request debugging using status codes and error traces  
- [ ] API documentation generator (from OpenAPI specs or raw endpoints)  
- [ ] API test generation using LLMs  
- [ ] Visualization module for response data  
- [ ] Frontend code generation (Dart-Flutter)  
- [ ] Benchmark evaluation module for different LLMs

---

## 📅 Timeline (175 Hours)

| Week(s) | Dates              | Phase                    | Hours | Tasks                                                                 |
|---------|--------------------|--------------------------|--------|------------------------------------------------------------------------|
| 1–4     | May 20 – June 16   |  Community Bonding       | 10     | Engage with mentors and community, finalize specs, understand codebase |
| 5       | June 17 – June 23  |   Phase 1 Begins         | 15     | Set up project structure, basic utilities                             |
| 6–7     | June 24 – July 7   | Response Explanation     | 25     | Implement response explanation and discrepancy detection               |
| 8       | July 8 – July 14   | Debugging Module         | 20     | Implement debugging support for status codes and errors               |
|         |                    |  Testing + Docs          | 5      | Add unit tests and documentation for features                         |
| 9       | July 15            |  Midterm Evaluation      | —      | Submit midterm eval, share demo and progress                          |
| 10      | July 16 – July 22  | Flutter Code Generator   | 20     | Build API integration generator for Flutter                           |
| 11      | July 23 – July 29  | Test Case Generation     | 15     | Create test cases from API data                                       |
| 12      | July 30 – Aug 5    | Visualization Support    | 20     | Implement customizable charts & plots                                 |
| 13      | Aug 6 – Aug 12     | 📄 Documentation          | 10     | Write docs for all new modules                                        |
| 14      | Aug 13 – Aug 19    | ✅ Final Submission       | 35     | Benchmark LLMs, polish code, testing, final report + blog + PRs       |

---

## ⚙️ Implementation Plan & Workflow

### 🛠️ High-Level Architecture

DashBot is a modular system that includes:
- Natural Language Understanding (NLU)
- Intent classification
- Task execution modules (debug, test, doc, viz, codegen)
- LLM benchmarking engine
- Customizable frontend options for code and visualization

---

### 🔄 Workflow Steps

1. **User Input Interface**
   - Developer types natural language queries
   - Select LLM (OpenAI, Llama3, Mistral, etc.)
   - Select output format (text, chart, Flutter code, etc.)

2. **Intent Classification**
   - Classify query: Is it about debugging, generating docs, or something else?
   - Route to the right module

3. **Module Execution**
   - Debug Module → Analyze response, error codes
   - CodeGen Module → Generate integration code (Flutter/Dart)
   - TestGen Module → Generate test cases based on request/response
   - DocGen Module → Generate OpenAPI-style docs
   - Viz Module → Build dynamic charts from response data

4. **LLM Orchestration**
   - Prompt-Template system to guide LLM output
   - Benchmark multiple LLMs (accuracy/time/consistency)
   - YAML-based log format for outputs

5. **Response UI Layer**
   - Frontend displays code, charts, test cases
   - 2D scroll, numbering, and zoom support for large outputs

---

## 👨‍💻 Technical Approach

- Use OpenAI, Claude, Mistral, LLaMA 3 via API
- LangChain or custom Python logic for modular prompt routing
- Code generation via templates + OpenAPI + Flutter
- Chart rendering via Plotly.js or ECharts
- Test generation with schema-based prompt inference
- YAML-based benchmarking logs (response accuracy, latency, etc.)

---

## 🙋 Why Me?

- 4x National Hackathon Winner (T-Hub, Hackfest, etc.)
- Experience in AI + Flutter + Firebase + Python
- Built production-level apps listed on Play Store
- Built NLP bots with Sentiment/NER + Telegram bots
- Actively contribute to open-source and issue discussions

---

## 🛠️ Prior Contributions

- PR #805: Fix for horizontal scroll bug (#672)
- PR for Feature #675: 2D scrolling feature
- Discussions around better visualization and LLM integration
- UI/UX suggestions to improve API Dash code experience

---

## 🚀 Post-GSoC Plans

I plan to stay active in API Dash even after GSoC by:
- Maintaining and improving DashBot
- Adding chatbot-like interaction UX
- Improving LLM benchmarking UI
- Assisting new contributors

---

## 📂 Additional Links

- **Past Projects:**
  - [Chatbot-NLP](https://github.com/dheerxj/chatbot-nlp): Rule-based + NER + Sentiment Chatbot
  - [Building Guardian](https://github.com/dheerxj/building-guardian): Full-stack building management app (Flutter + Firebase)

---

## 🔖 Tags

`Flutter` `Python` `AI` `LLM` `Open Source` `GSoC 2025` `API Dash` `DashBot`

---

## 🧭 Flowchart: DashBot Development Process
![image](https://github.com/user-attachments/assets/e820ccb1-d356-4bc4-8237-ff2c20fb4fb8)


![image](https://github.com/user-attachments/assets/d3fe38a4-981d-4a0b-94f8-14896336adf0)

