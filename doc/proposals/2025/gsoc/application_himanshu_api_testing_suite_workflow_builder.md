
---

### GSoC 2025 Proposal: Visual Workflow Builder & API Testing Suite for APIDash

---

### Personal Information

- **Full Name:** Himanshu Rajput
- **Email:** himanshu011raj@gmail.com
- **Phone:** +91 6378432331
- **GitHub:** [maiHydrogen](https://github.com/maiHydrogen)
- **LinkedIn:** [himanshu-rajput](https://www.linkedin.com/in/himanshu-rajput-02980429a)
- **Discord:** @maiHydrogen
- **Time Zone:** GMT+5:30 (India)

### University Information

- **Institution:** Indian Institute of Technology Guwahati
- **Program:** B.Tech in Civil Engineering
- **Year of Study:** 2nd Year (2023)
- **Expected Graduation:** June 2027

---
### Motivation & Past Experience 

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?
- I kicked off my open-source journey with Hacktoberfest ’24, landing 4 merged PRs across 3 repos (2 Flutter, 1 Python Flask)—my first taste of community coding! See,
the relevant PRs as follows – 
[Flask 1]( https://github.com/Namit2111/bible-verse-finder/pull/50) [Flutter 1]( https://github.com/lugnitdgp/Aerocart/pull/11) [Flutter 2]( https://github.com/SankethBK/diaryvault/pull/258) [Flask 2]( https://github.com/Namit2111/bible-verse-finder/pull/54) 

- I discovered APIDash recently and have already made multiple contributions, which demonstrate both my willingness to learn and my technical initiative:

[#589](https://github.com/foss42/apidash/pull/589): Added Android-specific troubleshooting documentation. 

[#680]( https://github.com/foss42/apidash/pull/680): Attempted implementation of Basic Auth (closed with valuable feedback). 

[#689](https://github.com/foss42/apidash/pull/689): Implemented API Key and Bearer Token authorization (closed with valuable feedback) 

2. What is your one project/achievement that you are most proud of? Why?

- The project that I can mention here is one named as [“USay”]( https://github.com/maiHydrogen/USay). a real-time chat app I built solo as a rookie. Starting from scratch, I sketched the UI, coded the frontend, and wired Firebase for auth and messaging—culminating in a 2 a.m. triumph over a stubborn Google Sign-In bug to ship it, all while learning Dart on the fly. Now, it’s ready to have its own chatbot, video/voice call and most importantly end to end encryption very soon.USay taught me resilience—let’s build a tool that empowers developers worldwide!

3. What kind of problems or challenges motivate you the most to solve them?

- I thrive on challenges that push me off my limits like being 2nd-year B.Tech Civil Engineering student at IIT Guwahati, where I’ve carved my own path into software through sheer curiosity and mastering Dart’s async for USay or tackling APIDash’s Riverpod. The steeper the curve, the more I dig in—sure, I stumble (like my first auth PR), but each miss sharpens my next shot. Solving real dev pain points with tools like this suite keeps me hooked.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?
- I’m all in for GSoC—full-time, 35+ hours/week, May to August 2025, thanks to summer break. I’ll tinker with ML and Dart extras on the side, but APIDash gets my prime focus.

6. Do you mind regularly syncing up with the project mentors?

- Absolutely not, I will be available for and absolutely love to syncing up with the project mentors for regular updates and guidance related to the project.
7. What interests you the most about API Dash?

- What excites me about APIDash is its innovative use of Flutter and Dart for end-to-end API management. The project’s emphasis on native tooling (Riverpod, Melos, etc.) and unique monorepo structure presents a unique opportunity to innovate and push the boundaries of what's possible with Dart. Riverpod’s elegance and the maintainers’ positive behaviour make it a learning playground. Crafting a Figma prototype for this suite felt like joining the party early—can’t wait to build it!

8. Can you mention some areas where the project can be improved?

- API Dash is on a promising way. I have seen the **Roadmap** as well as other interesting ideas in the pipeline for GSoC.
- I would like to add that API Dash should be more present in the open-source events like Hacktoberfest and all so that it can gain ample amount of contributors which is most important thing to get the project rolling.
- It could shine brighter with tighter CI/CD hooks (e.g., GitHub Actions for test automation) 

---

## Project Title

Visual Workflow Builder & API Testing Suite for APIDash

### Abstract:  
This project aims to integrate a robust, visual API testing suite directly into APIDash. By enabling users to design, run, and monitor API test flows entirely through a drag-and-drop interface, enhanced version of drawing from my Figma prototypes—[Workflow Canvas](images/Dashflow.png),[Monitor Setup](images/Monitors.png), [Runner Interface](Runner.png) and [Collection](images/collections.png). The solution will provide native support for request chaining (with variable injection), modular test suites, parallel execution, and real-time monitoring. With a focus on performance and usability, the suite will leverage Flutter’s UI capabilities and Dart’s asynchronous programming to offer an intuitive, high-performance alternative to existing API testing tools.

#### Vision and Objectives
My goal is to weave a seamless API testing experience into APIDash, tailored to real-world needs:
- **Testing Suite**: A robust system for validation (custom assertions), integration, security scans, performance benchmarks, and scalability checks—organizable into nested, reorderable suites (#96).
- **Workflow Builder**: A drag-and-drop canvas (more refined version of design provided for reference above) to chain requests with dynamic variables (#120).
- **Collection Runner**: A flexible engine for async or parallel test execution with adjustable timeouts (#100).
- **Monitoring Dashboard**: A sleek sidebar with live latency charts and exportable JSON logs (#96, #120).

### Technical Approach

**Architecture Overview:**
- **Frontend:**  
  - Built in Flutter, the UI will use custom widgets and gesture detectors to implement an intuitive drag-and-drop system.
  - Construct the workflow builder by leveraging Flutter’s `Draggable` for my Figma design, integrate Riverpod for state
  - The Workflow Builder will render a directed acyclic graph (DAG) where each node corresponds to an API request, and edges represent the flow of execution.
- **State Management:**  
  - Riverpod will be utilized to manage application state, ensuring that node data, variable contexts, and test statuses are efficiently updated and propagated.
- **Async Execution:**  
  - Dart's asynchronous programming features (e.g., `Future.wait`, isolates) will power the test runner, enabling parallel API calls and real-time feedback.
- **Assertion DSL:**  
  - A domain-specific language (DSL) for assertions will be developed to allow users to define custom validations using simple syntax (e.g., `status == 200 && body.contains("success")`).
- **Functional test suite with sample assertions :**
  - Build the testing suite’s foundation—design assertion logic, add security checks, and write unit tests. 
  ```dart
  class TestValidator {
    final String field, expectedValue;
    TestValidator(this.field, this.expectedValue);
    bool validate(dynamic response) {
      var data = response is String ? jsonDecode(response) : response;
      return data[field] == expectedValue; // Extensible for status, headers
    }
  }
  ``` 
- **Data Persistence:**  
  - Local storage (using Hive or SharedPreferences) will support saving and loading of test workflows and results, with a lightweight JSON schema for interoperability.

**Innovative Technical Elements:**
- **Dynamic Variable Injection:**  
  - Implement a templating engine that processes variables in API requests, enabling dynamic chaining of requests and responses.
- **Optimized Parallelism:**  
  - Utilize Dart's `Future.wait` for concurrent request execution, and explore isolates for heavy computational tasks (like processing large datasets or extensive test suites).
- **Custom Visualization:**  
  - Develop interactive graphs within the monitoring dashboard to display latency metrics and test outcomes in real time, using packages like `fl_chart`.
- **Extensibility:**  
  - Design the architecture with modularity in mind, allowing for future integration with CI/CD pipelines and scheduled test automation.

### Timeline

| Period | Goals |
|--------|-------|
| **May 8 – June 1**<br>(Community Bonding) | - Engage with mentors and the APIDash community<br>- Thoroughly review APIDash's architecture and codebase<br>- Finalize detailed design, technical stack, and project scope<br>- Prototype Flutter drag-and-drop UI patterns and assess Riverpod usage <br>- Research DSLs and Flutter DAGsa and  Mock UI for assertion engine & monitor|
| **June 2 – June 8**<br>(Week 1) | -Build base of testing engine (node model, assertion evaluator)<br>-Scaffold assertion DSL parser and basic validations
 <br>-Unit test core validator module |
| **June 9 – June 15**<br>(Week 2) | - Integrate variable support and request chaining<br>- variable injection + chaining logic to engine (e.g., highlighting placeholders)<br>-Enable JSON schema-based API response validation,CLI for running test plans|
| **June 16 – June 22**<br>(Week 3) | - Build the initial Test Runner to execute chained requests<br>- Support both sequential and parallel execution using Dart's async features<br>- Display raw output logs for debugging purposes Build simple Collection Runner (sequential + parallel)|
| **June 23 – June 29**<br>(Week 4) | - Perform internal testing of request execution logic<br>- Polish UI interactions and refine drag-and-drop experience<br>- Add timeout & stop-on-failure logic Save/load test plans from local storage<br>
| **June 30 – July 6**<br>(Week 5) | -  UI components for assertion configuration<br>- Begin integrating basic validations (status, header, body)<br>-Start Workflow Builder UI Create node editor (drag/drop, reorder, editable requests)<br>-Connect UI to test engine |
| **July 7 – July 13**<br>(Week 6) | - Extend the UI to support Test Suite organization (grouping, nesting, reordering) <br>-Add visual chaining of requests (edges, sequence)<br>-Enable configuring assertions visually|
| **July 14 – July 18**<br>(Week 7) | -Midterm Evaluation (should include test engine + basic workflow UI + variable chaining)
| **July 19 – July 25**<br>(Week 8) | - Implement advanced controls: asynchronous execution, timeouts, and stop-on-failure options <br>-Integrate a real-time Monitoring Dashboard displaying pass/fail status and latency charts | 
| **July 26 - August 2**<br>(Week 9) | - Implement export functionality for test suites and results as JSON <br>Implement UI for suite grouping, toggling, solo-run|
| **August 2 - August 8**<br>(Week 10) | -Sync all UI states with Riverpod <br> -Conduct full integration testing, debugging, and performance optimizations<br>- Full serialization of workflows and test results for easy sharing and version control. |
| **August 9 - August 15**<br>(Week 11) | -  Polish UI and ensure responsiveness/accessibility<br>- Detailed user and developer guides covering installation, usage, and contribution guidelines|
| **August 16 - August 22**<br>(Week 12) | - Buffer Week |
| **August 25 - September 1**<br>(Final) | - Final polish, mentor review, and submission |


### Benefits to the Community

APIDash currently focuses on sending requests and inspecting responses. By integrating a testing and automation layer, we unlock powerful use cases:
- **Automated Regression & Integration Testing:** Simplify continuous testing of API endpoints.
- **Collaborative Test Suite Sharing:** Enable teams to share workflows via .json import/export.
- **Native Assertion Engine:** Validate APIs with built-in assertions, eliminating the need for external tools.
- This ecosystem will slash testing time, foster collaboration, and position APIDash as a go-to platform. I’ll support new contributors and enhance features like detailed logs beyond GSoC.



### Future Scope (Beyond GSoC)

- **Scheduled Test Automation:**  
  Add support for cron-like scheduled tests for continuous monitoring.
- **Historical Logging:**  
  Implement a detailed history of test results with trend analytics.
- **CI/CD Integration:**  
  Explore integration with GitHub Actions or other CI tools for automated testing pipelines.


### Final Notes

I am excited to contribute meaningfully to APIDash by introducing a native, high-performance API testing suite that not only addresses current issues but also lays the groundwork for future enhancements. With full-time commitment, a detailed technical roadmap, and a focus on innovation, I am confident that this project will add significant value to the community and the APIDash ecosystem.

Looking forward to your feedback and suggestions!
