
![](images/gsoc_api.png)

# GSOC'26 Proposal - API Dash : CLI MCP Support

## About Me

1. **Name:** Manar Mohamed Hussien Elhabbal
2. **Email:** manar.elhabbal.dev@gmail.com
3. **Discord:** manarelhabbal
4. **Home Page:** N/A
5. **Blog:** N/A
6. **GitHub:** https://github.com/Manar-Elhabbal7
7. **LinkedIn:** https://www.linkedin.com/in/manar-elhabbal7/
8. **Timezone:** UTC+02:00 (Cairo)
9. **Resume:** [View Resume](https://drive.google.com/file/d/1CmRfSM-Zhz4g8EaYcGc-F9XmhIxv7chb/view?usp=drive_link)

---

## University Info

1. **University:** Mansoura University — Faculty of Computer and Information Sciences
2. **Program:** B.Sc. in Information Systems
3. **Year:** Third Year
4. **Expected Graduation:** 2027

---

### Motivation & Past Experience

### **1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes, I have worked on a variety of FOSS projects. I contributed to the GSSOC’25 India program, raising 9 merged PRs, and continued making further contributions afterward 
including **bug fixes, feature implementations, tests, workflow automation, and documentation improvements**.

## 🌟 Open Source Contributions


| # | Repository | Contribution | PR Link | Status |
|---|-----------|--------------|--------|--------|
| 1 | taskwarrior | Fix: add obfuscation handling for dependencies in ColumnDepends | [#4072](https://github.com/GothenburgBitFactory/taskwarrior/pull/4072) | Merged |
| 2 | xkaper001/DocPilot | Add GitHub Actions workflow to auto-comment on new issues | [#9](https://github.com/xkaper001/DocPilot/pull/9) | Merged |
| 3 | MasterAffan/OptiFit | Add Unit Tests for Backend | [#57](https://github.com/MasterAffan/OptiFit/pull/57) | Merged |
| 4 | MasterAffan/OptiFit | Bug Report: build fails due to duplicate ndkVersion | [#37](https://github.com/MasterAffan/OptiFit/pull/37) | Merged |
| 5 | MasterAffan/OptiFit | Add Demo Video Section to README | [#35](https://github.com/MasterAffan/OptiFit/pull/35) | Merged |
| 6 | MasterAffan/OptiFit | Add App Icons for All Platforms | [#53](https://github.com/MasterAffan/OptiFit/pull/53) | Merged |
| 7 | SharonIV0x86/CinderPeak | Add examples for CSR-COO storage format | [#47](https://github.com/SharonIV0x86/CinderPeak/pull/47) | Merged |
| 8 | may-tas/TextEditingApp | Edit Text dialog autofocus issue | [#69](https://github.com/may-tas/TextEditingApp/pull/69) | Merged |
| 9 | may-tas/TextEditingApp | Background Color Tray issue solution | [#62](https://github.com/may-tas/TextEditingApp/pull/62) | Merged |
| 10 | may-tas/TextEditingApp | Add more color options | [#53](https://github.com/may-tas/TextEditingApp/pull/53) | Merged |
| 11 | foss42/awesome-generative-ai-apis | Add Humanizer PRO - AI Text Humanizer API | [#359](https://github.com/foss42/awesome-generative-ai-apis/pull/359) | Open |
| 12 | AmrAhmed119/dart-testgen | Delete coverage_import_test.dart after execution | [#58](https://github.com/AmrAhmed119/dart-testgen/pull/58) | Merged |

---

### **2. What is your one project/achievement that you are most proud of? Why?**

I am very proud of my participation in GSSoC'25 (GirlScript Summer of Code). It was my first
open-source experience — I didn't know how to fork a repo or raise a PR, but I taught myself. 
By the end of the program, I had 9 PRs merged, earned 32 points, and
contributed to several different projects.

---

### **3. What kind of problems or challenges motivate you the most to solve them?**

I enjoy solving challenging problems that require creative thinking beyond brute force. I regularly practice on LeetCode and Codeforces, and I’m especially motivated by real-world challenges that push me to learn new concepts. The process of struggling, learning, and eventually solving the problem is what drives me.

---

### **4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, I will work on GSoC full-time. However, as I am a student, I may occasionally have exams or an internship. These responsibilities will not affect my contributions to the project, insha’Allah.

---

### **5. Do you mind regularly syncing up with the project mentors?**

Not at all  I welcome it. Regular sync-ups are a great opportunity to get feedback, stay on 
track, and learn from the mentors. 

---

### **6. What interests you the most about API Dash?**
API Dash stands out to me for several reasons:

 - Simple and Beautiful UI
API Dash has a clean, simple, and intuitive interface that makes it easy to use, even for beginners.

 - API Dash is truly **cross-platform**, supporting desktop and mobile platforms. This is a rare capability among API clients, as most competitors do not provide mobile support.

 - API Dash is built with **Flutter** and uses Flutter’s **GPU Skia rendering engine**, resulting in a smaller footprint and faster performance.

 - One of the most impressive features is **Dash Bot**, which supports **local LLMs**.  
    This means AI assistance can work **without sending requests to external servers**, making it ideal when working with **sensitive or private data**.

- Multimedia Preview :
    API Dash supports **multimedia previews**, including:
    - Images
    - PDFs
    - Audio
    - Videos

This is a **unique and powerful feature** compared to many other API clients.

- Multi-Language Code Generation:
    API Dash can generate code snippets for **more than 23 programming languages and libraries**, including:

    - Dart
    - Python
    - Node.js
    - and many others

    > This makes it very helpful for developers working across different tech stacks.

- Privacy-Focused Local Operation:
    API Dash works **locally**, helping ensure **privacy and security** while still supporting modern API technologies such as:

    - HTTP
    - GraphQL
    - SSE
    - Streaming
    - AI APIs

- Well-Structured Architecture :
As a developer, what interests me the most is the **well-structured and organized architecture of the codebase**.  
It made it easier for me to understand the project when exploring the source code and helps make the project **maintainable and contributor-friendly**.

---

### ⭐ **Overall Impression:**  
API Dash combines **simplicity, performance, privacy, and powerful developer features**, making it a highly versatile and modern API client.


---

### **7. Can you mention some areas where the project can be improved?**
API Dash's codebase has a few important areas that could be improved and refactored.

-  **test coverage for the core HTTP services is almost nonexistent**.  
The file `better_networking_test.dart` is empty, and `http_service_test.dart` is fully commented out. This means that the core networking layer currently has no automated tests, making it harder to ensure stability and reliability.

- **error handling is too generic**.  
Authentication failures currently return raw strings instead of well-defined exception types. 
so it becomes difficult to distinguish between different problems such as network errors, authentication failures, or response parsing issues.

-  **import failures lack proper feedback**.  
When importing collections from tools like **Postman** or **cURL**, the system sometimes returns `null` if something goes wrong. Since no error message is shown to the user, debugging these import failures will be very hard.

-  **authentication logic is repetitive**.  
In `handle_auth.dart`, similar authentication logic is repeated across multiple authentication types. Refactoring this using a **Strategy pattern** would reduce duplication and make the authentication system cleaner and easier to maintain.

Overall, The code need refactoring and addressing these issues would improve both **code quality and user experience**. Among them, **adding proper test coverage and improving error reporting for imports** should be the highest priority.

---

### Project Proposal Information

## Project Title : CLI & MCP Support

