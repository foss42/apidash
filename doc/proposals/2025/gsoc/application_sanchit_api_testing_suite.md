
About Me
Full Name: Sanchit Sharma
Contact:
Email: dev.sanchit955@gmail.com
Phone: +91 9559392232
Discord: sanchit955_01185
GitHub: github.com/sanchit955
LinkedIn: https://www.linkedin.com/in/sanchit-sharma-1b7a57327/
Time Zone: IST (GMT+5:30)

Education
– University: KIET Group of Institutions, Ghaziabad
Programme: B.Tech in Computer Science Information Technology
Year: 1st Year (Initiated 2023)
Class of Expected Graduation: June 2028


Skills -
Flutter & Dart:
Proficiency in Cross platform app development, Connectivity with API and state management (Provider, Riverpod)
Proficient in REST API processes, testing and automation (validation, security, performance).
Proficient on C++, Dart, Python; adaptable to pick new frameworks.
Solved more than 100+ LeetCode problems to improve on algorithms and optimisation.
Well versed in building basic UIs based on Flutter widgets.
Teamwork [Cooperation, Leadership]: Led a team in a hackathon
Well-versed in unit and integration tests using Dart’s test package.
We used Dart's Future and async/ await to run async workflows and runners implemented under Automation.
Comfort with open source policy and Git/GitHub.
Skilled at drafting clear, accessible manuals and respective READMEs. 
---


Motivation & Background

Open-Source Experience

I have yet to work on a FOSS project, but I have read through the codebase of APIDash and similar tools such as Postman. My hackathon projects and personal projects have prepared me to contribute and deliver through GSoC.

Proudest Achievement

Team lead in CodeFest, 24 hour hackathon. We created a simple task automation tool, API-driven—chain requests together. Side note: no public repo (it was a live demo), but I learned a lot from leading under pressure, coding a functioning prototype, and nailing the pitch, all of which I will be bringing to APIDash in the future.

Why APIDash?

His clean Flutter design on APIDash and its potential as a great API tool hooked me. I’ve been wrangling these types of APIs in projects — testing things, debugging them, chaining them together — and I’m stoked to knowledge-bomb APIDash with testing and workflow goodies devs will adore.

Commitment

I am 100% committed to GSoC—7+ hrs day, full-time from May to August 2025. I have a huge gap in my uni schedule at that time so it allows me a solid chunk of time to just focus.

Syncing with Mentors

Regular check-ins? Count me in! I love feedback and collaboration, and that’s how I’ll give this project some sugar to make sure it’s hitting APIDash’s goals.”

# Project Proposal

Title

APIDash Improvements: API testing suite, workflow builder and collection runner

Abstract

This project will enhance APIDash to include strong API Testing Suite (validation, integration, security, performance, scalability) integrated, a drag-and-drop Workflow Builder for seamless chaining of requests, and a Collection Runner with real-time monitoring. A practical, developer-friendly solution was created in 350 hours addressing issues #96, #100 and #120, managing the documentation, Flutter/Dart knowledge and problem-solving at hand.

Project Details

Objectives

Testing Suite — Integrate 5 types of tests with APIDash to ensure reliability, security and performance of APIs.

Workflow Builder: Create API request chains easily with dynamic variable passing.

Collection Runner & Monitor: Automate batch testing with clear, actionable results

Community Impact: Saving developers time + Adding more real-world usage to scale APIDash.

Technical Plan

1. API Testing Suite

A comprehensive suite to validate, secure, and load-test APIs:

Validation Testing: Verify the responses are as intended
  - Implementation: Extend APIDash’s request model with an `Assertion` class.  
  - *Code Sample*:
    ```dart
    class Assertion {
      final String type; // e.g., "status", "body"
      final String key; // e.g., "userId"
      final String expected; // e.g., "200"
      Assertion(this.type, this.key, this.expected);

      bool validate(http.Response response) {
        switch (type) {
          case "status":
            return response.statusCode.toString() == expected;
          case "header":
            return response.headers[key.toLowerCase()] == expected;
          case "body":
            return jsonDecode(response.body)[key] == expected;
          default:
            return false;
        }
      }
    }
    ```
  - UI: Form-based input (e.g., “Status = 200”) with pass/fail feedback.

- Integration Testing: Verify multi-API workflows (detailed in Workflow Builder).  
- Security Testing: Detect vulnerabilities like exposed keys or missing headers.  
  - Code Sample:
    ```dart
    class SecurityCheck {
      final String issue;
      SecurityCheck(this.issue);

      bool check(http.Request req, http.Response res) {
        if (issue == "exposed_key" && req.headers["Authorization"]?.contains("secret") == true) return false;
        if (issue == "missing_csp" && res.headers["content-security-policy"] == null) return false;
        return true;
      }
    }
    ```
- Performance Testing: Measure latency under repeated requests.  
  - Code Sample:
    ```dart
    Future<Map<String, double>> runPerformanceTest(String url, int iterations) async {
      final client = http.Client();
      final times = <int>[];
      try {
        for (var i = 0; i < iterations; i++) {
          final start = DateTime.now();
          await client.get(Uri.parse(url));
          times.add(DateTime.now().difference(start).inMilliseconds);
        }
        return {"average_ms": times.reduce((a, b) => a + b) / iterations};
      } finally {
        client.close();
      }
    }
    ```
- Scalability Testing: Assess capacity under concurrent loads.  
  - *Code Sample*:
    ```dart
    Future<Map<String, double>> runScalabilityTest(String url, int concurrentRequests) async {
      final client = http.Client();
      try {
        final requests = List.generate(concurrentRequests, (_) => client.get(Uri.parse(url)));
        final responses = await Future.wait(requests);
        return {"success_rate": responses.where((r) => r.statusCode == 200).length / concurrentRequests};
      } finally {
        client.close();
      }
    }
    ```

2. Workflow Builder
A system to chain API requests with dynamic outputs (e.g., token passing).  
- Implementation: Use a `WorkflowNode` linked-list model with a Flutter-based UI (list or drag-and-drop).  
- Code Sample:
  ```dart
  class WorkflowNode {
    final String name, url;
    Map<String, String> outputs = {};
    WorkflowNode? next;
    WorkflowNode(this.name, this.url);

    Future<void> execute(http.Client client, Map<String, String> vars) async {
      final uri = Uri.parse(url.replaceAllMapped(RegExp(r'{{(\w+)}}'), (m) => vars[m[1]] ?? ""));
      final response = await client.get(uri);
      if (name == "Get Token") outputs["token"] = jsonDecode(response.body)["token"];
    }
  }

  class Workflow {
    WorkflowNode? head;

    void addNode(String name, String url) {
      final node = WorkflowNode(name, url);
      if (head == null) head = node;
      else {
        var current = head;
        while (current!.next != null) current = current.next;
        current.next = node;
      }
    }

    Future<void> run() async {
      final client = http.Client();
      var vars = <String, String>{};
      try {
        var current = head;
        while (current != null) {
          await current.execute(client, vars);
          vars.addAll(current.outputs);
          current = current.next;
        }
      } finally {
        client.close();
      }
    }
  }
  ```
- UI: Nodes listed or draggable, with variable substitution (e.g., `{{token}}`).

3. Collection Runner & Monitor
Automate batch testing and visualize results.  
- Implementation: Execute request collections, track metrics, and display via Flutter widgets.  
- Code Sample:
  ```dart
  class TestResult {
    final String name;
    final bool passed;
    final int responseTime;
    final List<String> failures;
    TestResult(this.name, this.passed, this.responseTime, this.failures);
  }

  class CollectionRunner {
    final List<Map<String, dynamic>> requests;
    CollectionRunner(this.requests);

    Future<List<TestResult>> run() async {
      final client = http.Client();
      final results = <TestResult>[];
      try {
        for (var req in requests) {
          final start = DateTime.now();
          final response = await client.get(Uri.parse(req["url"]));
          final time = DateTime.now().difference(start).inMilliseconds;
          final assertions = (req["assertions"] as List)
              .map((a) => Assertion(a["type"], a["key"], a["expected"]))
              .toList();
          final failures = assertions
              .where((a) => !a.validate(response))
              .map((a) => "${a.key} ≠ ${a.expected}")
              .toList();
          results.add(TestResult(req["name"], failures.isEmpty, time, failures));
        }
        return results;
      } finally {
        client.close();
      }
    }
  }
  ```
- Output: Table/graph UI showing “Get Token: Pass (120ms), Fetch Data: Pass (150ms), Avg: 135ms.”

Implementation Strategy
Framework: Dart & Flutter, integrated into APIDash’s request handling.

Testing:

Component tests (like the unit tests for test_runner_test. dart).
E2E flow integration tests.
- Documentation: Updated README + a “Test APIs in 5 Minutes” tutorial.

Timeline (June–August 2025, 12 weeks)

| Phase  | Dates | Tasks | Deliverables |

|---------------|-----------------|--------------------------------------------------|---------------------------|

Community Bonding | May 8–June 1 | Study APIDash codebase, align with mentors | Refined scope, initial setup |

| Week 1 | June 2–8  | Design suite structure, mock UI | Initialized Repo, UI wireframes |

| Week 2 | June 9–15 | Create validation test (assertions, UI) | Functional validation tests |
| Week 3 | June 16–22 | Shoring up security & performance | Security scans, latency metrics |
| Week 4 | June 23–29 | Scalability testing | Capacity support   |
| Weeks 5–6   | June 30–July 13 | Build Workflow Builder (nodes, UI) | Midterm: Suite + workflow demo |
| Week 7 | July 14–20 | Basis Collection Runner core   | Batch execution working |
| Week 8 | July 21–27   | Design Monitor UI(tables, graphs)|Visual results display |
| Weeks 9–10 | July 28–Aug 10 | Test suite (unit, integration), bug fixing | Stable, tested build |
| Week 11 | Aug 11–17 | Finish docs, UI polish | User-ready package   |
| Week 12   | Aug 18–24 | Final learning review, submission | Finalize project and docs |

Why Me?

Technical Fit: Flutter/Dart expert, API tester+ async (Future, Stream, Isolate) programming —all skills that APIDash wants.
-Proven Grit: Won a hackathon—for me delivery under pressure is key.
– Task: 7+ hours/day of work, full summer dedication.
Collaboration: Excited for mentor syncs to keep this on track, impactful.

Edge Over Others

It’s not just about features; it’s about saving devs time. My suite is lean, my workflows are well understood, and my runner’s output is clean. APIDash is all about no-nonsense, Flutter-native tools that are just too handy to do without.

---

Conclusion

My name’s Sanchit Sharma, and I’m here to turn APIDash into a testing and workflow powerhouse. Using my hackathon-trained skills, coding rapier and passion for clean solutions, I will deliver a project that enhances APIDash for the community. Let’s get this done—can’t wait to hear your thoughts!