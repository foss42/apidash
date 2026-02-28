# GSoC Proposal: Dashbot For APIDash
 ##  About
- FULL NAME:PRASHANT NAYAK
 - EMAIL : hydraprashant8@gmail.com
-  PHONE:+917394060751
- Discord Handle : prashant_1n_80322
- Github Profile : https://github.com/Prashant1git
- Time zone : Asia /Jhansi ( IST)
- Resume Link :
 https://drive.google.com/file/d/1Dt08bxtUQdnUL9UxTiOSt74zE1iwaAxg/view?usp=drivesdk
 ## University Info
 - University Name: Bundelkhad university
  -Program: information and technology
   -Year: 2nd Year (2025 Batch)
  -Expected Graduation Date: 2027
  -Motivation & Past Experience
## 1. FOSS Contributions
 I haven't contributed to FOSS projects yet, but I recently downloaded the APIDash codebase to
 mylocal machine and started exploring it to understand its structure and functionality.
## 2. Proud Achievement
 One of myproudest achievements was winning a university-level hackathon where I built a fully
 functional Ai supported mobile application within just 24 hours. The event challenged
 participants to solve real-world problems under intense time pressure, and I took it as an
 opportunity to push my limits. Using Python, Flutter and Dart ,I developed a complete app—from
 UI design to backend integration—that impressed the judges with its functionality, performance,
GSoCProposal: DashbotForAPIDash
 and user experience. This experience not only boosted my confidence as a developer but also
 reinforced my ability to work efficiently under pressure, think creatively, and deliver high-quality
 results within tight deadlines.
## 3. Challenges that Motivate Me
 Challenges that push me to step out of my comfort zone and learn something new are what
 truly motivate me. Whether it's solving a complex coding bug, building a feature I've never tried
 before, or working under tight deadlines—I see these situations as opportunities to grow. I enjoy
 the process of breaking down problems, finding solutions, and seeing the impact of my work.
 The feeling of overcoming a tough challenge and turning it into a success keeps me driven and
 passionate about what I do as a developer.
## 4. GSoC Commitment
 I will be working part-time on GSoC, as I am a 2nd-year student and need to balance my studies
 alongside the project.
## 5. Syncing with Mentors
 Yes, I am open to regular sync-ups with project mentors to ensure steady progress.
## 6. Interest in APIDash
 APIDash stands out because of its lightweight, Flutter-based architecture, making it a
 highly efficient alternative to tools like Postman. I am particularly excited about the
 potential of expanding its modular design, enhancing API discovery, and integrating AI
based automation for better API management.
## 7. Project Improvements
 While APIDash provides a great developer experience, some areas for improvement include:
 Improving UI responsiveness on lower-end devices.
 Expanding API import/export options for better interoperability.
 Enhancing API security validation and error handling mechanisms.
##GSoCProposal: DashbotForAPIDash
 Project Proposal Information
 Proposal Title: Dashbot for APIDash
## Conceptual ;
 DashBot is an intelligent assistant built for API Dash that helps developers save time and boost
 productivity by handling common API tasks through natural language. From explaining
 responses and debugging errors to generating documentation, tests, visualizations, and
 frontend integration code (like React or Flutter), DashBot is designed to be both powerful and
 flexible. It features a modular architecture and includes benchmarking tools to help users
 choose the best-performing LLM backend for their needs. The project brings together AI, Python,
 Dart, and Flutter to create a seamless, developer-friendly experience
# Weekly Timeline ;



### 4.Weekly Timeline


| Week | Goals/Activities                                           | Deliverables                                                    |
|------|-------------------------------------------------------------|-----------------------------------------------------------------|
| 1    |   Planning & Setup.| Set up project structure & repo integration Create evaluation metrics for LLM benchmarking. |
| 2    | Natural Language Input Parsing. |  Design prompt engineering systemCreate evaluation dataset for parsing accuracy. |
| 3    |Explain & Identify Discrepancie. | Implement module to explain API responses Add detection for discrepancies between response & expected schemaBenchmark explanation accuracy across LLMs. |
| 4    |  Debug Based on Status/Error. |Build module to debug based on response codes & messages Integrate context (headers, payload, previous requests)Evaluate LLMs on debugging accuracy with predefined errorsGSoCProposal: DashbotForAPIDash. |
| 5    |  Generate API Documentation. |  Design prompt & output template for docs Support OpenAPI + natural descriptions Compare LLMoutput with real-world. |
| 6    |  Generate Tests from API . | Build functionality to create tests (e.g., unit/integration tests)Target frameworks: Postman, pytest, etc.Validate test coverage & LLM consistency. |
| 7    |Visualizations of API Responses . | Implement module to convert JSON to charts (Bar, Line, Pie)Use plotting libraries like Plotly, Chart.jsd options for user customization. |
| 8    |Generate Frontend Integration Code . | Generate API integration snippets (React, Flutter Include authentication, headers, error handlingEvaluate code quality and syntactic correctness. |
| 9    |Modular Agent & Plugin System. |Design modular architecture for DashBot (plug-and-play Each module works independently with shared context/state Add agent loop with memory/context switchingLLMEvaluation FrameworkBuild evaluation UI/CLI to compare model outputs . |
| 10   |LLMEvaluation Framework. | Build evaluation UI/CLI to compare model outputs Define metrics: accuracy, coherence, latency, token usageDocument how to test with different backends. |
| 11   | Testing & Documentation. | Unit + integration testing across modules Create usage guide for developers Document each module’s LLM prompt structure. |
| 12   |Polish, Deploy & Community Feedback . | Polish UI/UX Create demo videos & example use cases Gather feedback from community & iterate TechnicalFlowchart. |
;


#FlowChart

 - USERINTERFACE 
 Flutter (Desktop)|
###
-
  NATURALLANGUAGEINPUT│
  (Flutter ➜ Python API)



  COREPYTHONBACKEND(AGENTSYSTEM) │
-Intent Parser (LangChain/OpenAI) │
 -Context Manager & Memory
 -TaskRouter (Decides module)

 
 

 -EXPLAIN -DEBUGMODULE -DOCGEN 
 │RESPONSE -Status/Error -OpenAPI/NL


 -
 TESTGEN  PLOTS/VIS FRONTEND
 (pytest)   (Plotly)   SNIPPETS 

 
 - LLMINTEGRATIONLAYER
 -
 -OpenAI / Claude / Local (via LangChain) 
 -Prompts + Output Parsers + Benchmarks 
 
  -EVALUATIONFRAMEWORK 
 - Accuracy, Speed, Cost 
 - Compare LLMBackends 
 - CLI/GUI Benchmarks

 

 
 -TESTING LAYER
 
 - Unit + Integration Tests │
 - Test LLMdeterminism
 - CI/CD Integration
 

## Key Technologies by Layer
 Frontend (Flutter/Dart): UI to input natural language and display results.
 Backend (Python): Handles AI agent logic, modular routing, and LLM
 interaction.
 Agent System: Parses intent, routes to correct module (e.g., debugging, doc
 gen).
 LLMs: Handles understanding, generation, explanation tasks.
 Evaluation Framework: Benchmarks LLM outputs across different
 providers.
GSoCProposal: DashbotForAPIDash
 Testing: Ensures correctness of outputs, stability of agents/modules.
## Conclusion
 DashBot makes API Dash smarter by using AI to help developers with tasks like
 debugging, writing docs, and generating code using natural language. It's built with
 Python and Flutter, and designed to be flexible and easy to improve. It also helps
 compare different AI models, making it a helpful open-source tool for developers.
 Thisprojectaligns
 wellwithmyskillsandinterests,andIa
 meagertocontributetothe
 APIDashecosyste
 mthroughthisproject
