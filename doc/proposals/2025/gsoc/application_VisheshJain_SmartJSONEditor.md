# Google Summer of Code 2025 - Application

## 👤 About Me

- **Name**: Vishesh Jain  
- **Email**: [visheshj2005@gmail.com](mailto:visheshj2005@gmail.com)  
- **Phone**: +91 9664049426  
- **Portfolio**: [visheshj2005.netlify.app](https://visheshj2005.netlify.app)  
- **GitHub**: [github.com/visheshj2005](https://github.com/visheshj2005)  
- **LinkedIn**: [linkedin.com/in/visheshj2005](https://www.linkedin.com/in/visheshj2005/)  
- **Time Zone**: IST (UTC+05:30, Kolkata)

---

## 🎓 University Information

- **Institution**: Techno India NJR Institute of Technology  
- **University**: Rajasthan Technical University  
- **Program**: B.Tech in Computer Science and Engineering  
- **Current Year**: 2nd Year  
- **Expected Graduation**: July 31, 2027  

---

## 💡 Motivation & Past Experience

As a passionate developer, I enjoy working on projects that solve real-world problems. I discovered open source through community-driven projects and was immediately drawn to the collaborative and impactful nature of it.  

Participating in GSoC is a chance to work on meaningful contributions under mentorship while improving my coding, collaboration, and problem-solving skills. I am eager to contribute to API Dash, a project that aligns with my interests in backend development, APIs, and Flutter.  

---

## 📄 Project Proposal Information

### **Proposal Title**:  
**Enhancing JSON Body Editor in API Dash**

### **Abstract**:  
This project proposes improvements to the JSON body editor within API Dash. Key features include syntax highlighting, JSON validation, and beautification. These additions will significantly improve usability and reduce common errors when editing API requests.

---

## 📘 Detailed Description

### **Introduction**  
API Dash is a cross-platform API client built using Flutter. While it supports composing HTTP and GraphQL requests, its JSON body editor lacks several features crucial for developer productivity.

### **Problem Statement**  
The current JSON body editor is basic. Developers often require real-time syntax checking, validation, and formatting while constructing JSON payloads. The absence of these features can lead to inefficiencies and avoidable errors.

### **Objectives**

- Implement syntax highlighting for better code readability.
- Add JSON validation to help users quickly identify formatting or structural issues.
- Provide a beautification tool to auto-format JSON for cleaner presentation.

### **Methodology**

1. **Research**: Analyze other popular API tools (like Postman or Insomnia) to gather insights into best practices.
2. **Syntax Highlighting**: Use existing Flutter packages like `highlight` or `flutter_highlight` to implement.
3. **JSON Validation**: Implement a real-time validator using Dart’s `jsonDecode()` wrapped in error handling.
4. **Beautification**: Use packages or custom logic to pretty-print JSON with indentation and proper formatting.
5. **Integration**: Seamlessly integrate all new features into the existing codebase with modular design.
6. **Testing**: Ensure all features are unit tested and manually tested across platforms (Windows, macOS, Linux).

---

## 🗓 Weekly Timeline

| Week | Task |
|------|------|
| 1–2  | Set up the development environment. Study the codebase. Define implementation plan. |
| 3–4  | Design and begin implementation of the syntax highlighting feature. |
| 5–6  | Complete syntax highlighting; write tests and conduct initial feedback testing. |
| 7–8  | Develop JSON validation logic with error feedback mechanism. |
| 9–10 | Integrate JSON beautification tool and test on different payloads. |
| 11–12 | Perform extensive cross-platform testing and resolve reported issues. |
| 13   | Final refinements, documentation, and submission of final work report. |

---

## ✅ Expected Outcomes

- A fully functional JSON body editor in API Dash with:
  - Syntax highlighting
  - Real-time validation
  - One-click beautification
- Clean, documented, and tested code merged into the upstream repository.
- Improved developer experience and fewer errors during API request composition.
