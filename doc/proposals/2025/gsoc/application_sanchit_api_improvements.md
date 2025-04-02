
# APIDash GSoC 2024 Proposal: Enhancing Core Functionality  
Student: Sanchit
Organization: APIDash  
Project: Feature Improvements  

-

## Table of Contents  
1. Personal Information  
2. Education Background  
3. Technical Skills  
4. Hackathon Achievements and other 
5. Motivation  
6. Project Goals  
7. Technical Approach  
8. Timeline  
9. Risks & Mitigations  
10. Post-GSoC Plans  

1. Personal Information  
Name: Sanchit
Email: dev.sanchit955@gmail.com
GitHub: github.com/sanchit955  
LinkedIn: https://www.linkedin.com/in/sanchit-sharma-1b7a57327/


2. Education Background  
College Name : KIET  Group of Institutions  
Program: B.Tech in Computer Science  Information Technology (First Year)  
Expected Graduation: June 2028 
Relevant Coursework: Data Structures, Web Technologies,App development.  


3. Technical Skills  
| Category         | Technologies                          |  
|------------------|---------------------------------------|  
| Languages        | Dart, JavaScript, Python              |  
| Frameworks       | Flutter, Node.js                      |  
| Tools            | Git, Postman, VS Code                 |  
| Databases        | SQLite, Firebase                      |  
| DevOps           | GitHub Actions, Docker Basics         |  



4. Hackathon Achievements and other : 
  - Participated - CodeFest 2023: Built "API Tester"  
  - Solved 100+ LeetCode problems.   

5. Motivation

Participated CodeFest 2023 by building API Tester Pro in 36 hours. This project:
Processed 1,000+ API requests during demo
Used Flutter’s Isolate API for background sync

--- Will you work full-time?
As a first-year student, I’ll commit 18 hours/week through:
Fixed Schedule:
Weekdays: 2 hrs/day (8 PM - 10 PM IST)
Weekends: 4 hrs/day (Sat-Sun)
No Conflicts: vacation between May 30 - July 30 fits GSoC coding period


Why APIDash?
1. Flutter Skills: My hackathon project had similar architecture
2. Real-World Impact: 15k+ developers use APIDash monthly
3. Learning Potential: Eager to help with Dart-JS interop

Why Me?
- Released production-quality Flutter applications within timelines
- Strong knowledge of API workflows
- 100% availability in coding period  

### 6. Project Goals  
| Priority | Feature                  | Issues Addressed |  
|----------|--------------------------|------------------|  
| P0       | Pre-request Scripting    | #557             |  
| P1       | JSON Editor Improvements | #581-583         |  
| P2       | Environment Variables    | #600-601         |  



Got it! Here’s your original text with only the code formatting fixed:  

---

### **7. Technical Approach**  

#### **7.1 Pre-Request Scripting**  

**Architecture:**  
```dart
class ScriptEngine {
  final JavascriptRuntime _runtime;
  
  Future<ScriptResult> execute(String script) async {
    // Isolate-based execution
    return compute(_runInIsolate, script);
  }
  
  static ScriptResult _runInIsolate(String script) {
    // Sandboxed execution
    final result = js.eval(script);
    return ScriptResult.fromJS(result);
  }
}
```

**Security Measures:**  
- Timeout after 5 seconds  
- Restricted API access:  

```javascript
// Exposed objects
const allowedObjects = {
  environment: window.apidash.environment,
  console: { log: () => {} }
};
```

---

#### **7.2 JSON Editor Enhancements**  

**Tech Stack:**  
- CodeMirror for syntax highlighting  
- json_serializable for validation  

**Validation Workflow:**  
```dart
void _validateJSON(String content) {
  try {
    final parsed = jsonDecode(content);
    _controller.addSuccessHighlight();
  } on FormatException catch (e) {
    _controller.addErrorHighlight(e.offset, e.length);
  }
}
```

---

#### **7.3 Environment Variables**  

**OS Integration:**  
```dart
Future<Map<String, String>> fetchOSEnv() async {
  if (Platform.isWindows) {
    return _parseEnvOutput(await Process.run('set', []));
  } else {
    return _parseEnvOutput(await Process.run('env', []));
  }
}
```

**Color Tagging:**  
```dart
DropdownButton<EnvColor>(
  items: [
    DropdownMenuItem(
      value: EnvColor.red,
      child: Row(
        children: [
          Container(width: 10, height: 10, color: Colors.red),
          Text('Production'),
        ],
      ),
    ),
    // Other colors...
  ],
)
```

---

### 8. Timeline  
Total Hours: 175 (20-25 hrs/week)  

| Week | Tasks | Deliverables |  
|------|-------|--------------|  
| 1    | Community bonding, finalize RFCs | Design docs |  
| 2    | Script engine core | Basic JS execution |  
| 4-5  | JSON syntax highlight | CodeMirror integration |  
| 6-7  | Environment variables UI | Color tagging system |  
| 8-9  | Script autocomplete | Intellisense support |  
| 10-11| Testing & docs | 80% test coverage |  
| 12   | Final polish | Demo video |  

---

### 9.9. Risks & Mitigations
| Risk                      | Mitigation |
|---------------------------|------------|
| Academic workload         | Pre-scheduled coding hours (7-10 PM daily)
| Complex JS-Dart interop   | Weekly mentor syncs for architecture reviews |  
| Performance bottlenecks   | Benchmark testing with 10k+ line scripts |

---

### 10. Post-GsoC Plans
1. Keep implemented features
2. Extend to OpenAPI integration (#121)
3. Implement GraphQL subscription support  

---

### Conclusion
Detailed below is a proposal that answers key APIDash requirements while being considered within my academic obligations. My CodeFest-participation entry shows that I'm capable of creating production-level Flutter tools, and I look forward to contributing to making APIDash the most developer-centric API client. Feel free to give suggestions on how to improve this plan further!

Let me know if you want to adjust any section!