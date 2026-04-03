### **GSoC 2026 Application: End-to-End Multimodal AI & Agent Evaluation Framework**

[cite_start]**Student:** Rana Awais Ahmad [cite: 7]
[cite_start]**GitHub:** [Awaisranahmad](https://github.com/Awaisranahmad) [cite: 9]
**Mentors:** @animator 

-----

### **About**

1.  [cite_start]**Full Name:** Rana Awais Ahmad [cite: 7]
2.  [cite_start]**Contact info (public email):** rawaisah124@gmail.com [cite: 8]
3.  [cite_start]**GitHub profile link:** [https://github.com/Awaisranahmad](https://github.com/Awaisranahmad) [cite: 9]
4.  [cite_start]**Time zone:** PKT (UTC+5) [cite: 9]

-----

### **University Info**

1.  [cite_start]**University name:** University of Education, Multan [cite: 9]
2.  [cite_start]**Program:** BS Information Technology [cite: 9]
3.  [cite_start]**Year:** 2nd Year (4th Semester) [cite: 9]
4.  **Expected graduation date:** 2028

-----

### **Motivation & Past Experience**

1.  **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**
    Yes. [cite_start]I am currently active in the **ilastik** community (Python Software Foundation)[cite: 4]. [cite_start]I successfully prototyped a context-aware documentation link system in `thresholdMaskingGui.py` (Issue \#2581), demonstrating my ability to navigate complex codebases and implement UI features in PyQt5[cite: 18, 109].

2.  **What is your one project/achievement that you are most proud of? Why?**
    My proudest project is **VibeCheck AI**—a real-time multimodal mood detection tool using MediaPipe and Groq API. It taught me how to handle real-world data (Video/Text) and integrate high-performance AI APIs, which is a core requirement for this evaluation framework.

3.  **What kind of problems or challenges motivate you the most to solve them?**
    I am driven by problems that bridge the gap between complex AI backend logic and intuitive user experiences. Making model evaluation accessible and reproducible for developers within a tool like API Dash is exactly the kind of challenge I enjoy.

4.  **Will you be working on GSoC full-time?**
    Yes, I will be dedicating 30-40 hours weekly to this project during the coding period. [cite_start]I have managed my academic schedule to ensure zero conflicts with GSoC milestones[cite: 110].

5.  **What interests you the most about API Dash?**
    API Dash’s vision of being a developer-centric, cross-platform tool for the AI era is inspiring. I am excited about the transition towards agentic AI and want to contribute to the core infrastructure that helps developers test these models.

-----

### **Project Proposal Information**

1.  **Proposal Title:** End-to-End Multimodal AI & Agent Evaluation Framework for API Dash

2.  **Abstract:**
    [cite_start]API Dash currently lacks a unified way to evaluate AI model performance across different modalities[cite: 13]. [cite_start]This project proposes a dedicated **Evaluation Tab** to support benchmarking of Text, Image, and Voice models[cite: 14]. [cite_start]By using a **Flutter UI** for configuration and a **Python/FastAPI** backend for execution, users can run benchmarks (like `lm-harness`) and see real-time performance metrics (Accuracy, Latency, Cost) via **SSE** without blocking the UI[cite: 23].

3.  **Detailed Description:**
    The implementation consists of:

      * [cite_start]**Core Logic:** Defining a standardized data contract for multimodal inputs (Local Files/URLs) and expected outputs[cite: 21].
      * [cite_start]**Backend Orchestration:** A lightweight FastAPI service to handle long-running evaluation jobs asynchronously[cite: 115].
      * [cite_start]**Real-time Feedback:** Implementing Server-Sent Events (SSE) to stream live execution logs and progress bars to the Flutter dashboard[cite: 23].

4.  **Weekly Timeline (350 Hours):**

| Week | Tasks |
| :--- | :--- |
| **1–2** | [cite_start]**Community Bonding:** Finalize UI/UX mockups; map API endpoints for `lm-harness` integration[cite: 112]. |
| **3–5** | [cite_start]**Backend Service:** Set up FastAPI; implement job execution and SSE logging mechanism[cite: 115]. |
| **6–8** | [cite_start]**Flutter UI:** Build the Evaluation Tab; implement multimodal file upload (Image/Audio)[cite: 116]. |
| **9–11** | [cite_start]**Analytics Dashboard:** Create result visualization (Charts/Tables) and implement cost/latency tracking[cite: 119]. |
| **12–14** | **Advanced Features:** Add support for AI Agent session traces and side-by-side model comparison. |
| **15–16** | [cite_start]**Final Delivery:** Unit testing, documentation (PEP8), and final PR preparation[cite: 121]. |

-----

[cite_start]**I confirm that I have read and agree to the API Dash AI Usage Policy and will abide by the community guidelines.** [cite: 110]
