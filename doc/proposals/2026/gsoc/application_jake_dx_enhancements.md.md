# GSoC 2026 Proposal: Enhancing Developer Experience & Code Generation in API Dash

## About

- **Full Name:** Jake Compendio
- **Email:** jakecompendio02271@gmail.com
- **Discord Handle:** kaizre021
- **GitHub Profile:** https://github.com/arcana022719
- **Time Zone:** Asia/Manila (PST)
- **Location:** Philippines

## University Info  

- **University Name:** Visayas State University
- **Program:** Bachelor of Science in Computer Science
- **Year:** 3rd Year
- **Expected Graduation Date:** 2027

## Motivation & Past Experience  

### 1. FOSS Contributions  
I have actively explored the API Dash codebase and performed local validation of the code generation engine using the GitHub and NASA APOD APIs. I identified a critical Developer Experience (DX) gap where generated Python/JS snippets output minified JSON, making terminal debugging difficult. To address this, I raised **Issue #1555** to propose a JSON Pretty-Printing enrichment for generated snippets.

### 2. Proud Achievement  
I am currently developing **CodeDrill**, a software engineering project, and **AttendanceFlow**, an application designed for streamlined tracking. These projects have sharpened my skills in **React, Next.js, and Python**, as well as my understanding of state management and API integration.

### 3. Challenges that Motivate Me  
I am driven by the goal of becoming a **Cloud Engineer**. I enjoy solving "plumbing" problems—ensuring that data flows efficiently between services. Optimizing API Dash to be the go-to tool for cloud-native developers perfectly aligns with my career aspirations.

### 4. GSoC Commitment  
I am committed to dedicating 30+ hours per week to this project. As a third-year student, I am eager to use the summer to dive deep into the Flutter ecosystem and contribute meaningfully to the FOSS community.

### 5. Interest in APIDash  
API Dash is the perfect alternative to bloated tools like Postman. Its Flutter-based architecture is incredibly fast, and its focus on local-first privacy is a game-changer for modern development. I am particularly interested in its code generation capabilities, as they bridge the gap between testing and implementation.

## Project Proposal Information  

### Proposal Title: DX Enhancements: Smart Formatting & Request Resilience  

### Abstract  
This project focuses on two key improvements for API Dash: 
1. **Smart Code Formatting:** Implementing "Pretty Print" (indentation) logic for generated snippets (Python, JS, Dart) to replace the current minified output.
2. **Request Resilience:** Adding automated header presets (like User-Agents) to help users bypass common 403 Forbidden/Cloudflare blocks encountered during testing.

### Technical Implementation
* **Code Formatting:** Modify the `codegen` templates in the Flutter source code to wrap response body prints with formatting logic (e.g., `json.dumps(obj, indent=4)` for Python and `JSON.stringify(obj, null, 2)` for JavaScript).
* **UI/UX Integration:** Introduce a `isPrettyPrint` boolean state in the Code Generation tab to allow users to toggle between minified and formatted output.
* **Resilience Mechanisms:** Create a curated list of standard browser `User-Agent` strings within the app to allow for one-click header injection, reducing friction with bot-detection services.

## Weekly Timeline  

| **Week** | **Focus** | **Key Deliverables** |
|-------------|--------------------------------------|-------------------------------------|
| **Week 1-2** | Community Bonding & Setup | Engage on Discord, finalize the dev environment, and study the Flutter generator logic. |
| **Week 3-5** | Code Gen Formatting (Python/JS) | Implement `json.dumps` (Python) and `JSON.stringify` (JS) indentation in the generator engine. |
| **Week 6-7** | UI Integration | Add a "Pretty Print" toggle and "Format JSON" checkbox to the API Dash UI. |
| **Week 8-9** | Request Resilience Features | Implement User-Agent presets to handle Cloudflare/bot-detection friction. |
| **Week 10-11**| Testing & Edge Cases | Validate generators against complex APIs (NASA, GitHub, Open-Meteo). |
| **Week 12** | Documentation & Final PR | Complete User Guides and finalize the PR for the stable release. |

## Conclusion  
By improving the readability of generated code and the success rate of requests, we can make API Dash the most frictionless tool for developers globally. I am excited to bring my React and Python experience to the team.