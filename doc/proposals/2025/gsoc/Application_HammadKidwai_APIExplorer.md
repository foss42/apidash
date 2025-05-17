# Google Summer of Code, 2025: API DASH  
**Proposal** **By**  **Hammad Kidwai**

---

### Project Title: API Explorer  
**Project Length:** 175 Hours  
**Project Mentors:** Ashita Prasad, Ankit Mahato, Ragul Raj M


---

## 1. About Me

**Name:** Hammad Kidwai  
**Phone Number:** +91 9005190887  
**Email Address:** hammadkidwai1602@gmail.com  
**Discord Handle:**  
**Github:** [https://github.com/hammad-16](https://github.com/hammad-16)  
**LinkedIn:** [https://www.linkedin.com/in/hammad-kidwai/](https://www.linkedin.com/in/hammad-kidwai/)  
**Time Zone:** IST (GMT +0530)  
**Resume:** [Resume Link](https://drive.google.com/file/d/1wTfTILeIlSDjBIuxvzQ6LIJUl2mF5Zl7/view?usp=drivesdk)

---

## 2. University Information

**University Name:** IIIT Agartala  
**Program:** Bachelors of Technology  
**Branch:** Computer Science and Engineering  
**Current Year:** Third Year  
**Expected Graduation Date:** May 2026

---

## 3. Questionnaire

**a. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
I have not been the longest contributor to the Open-Source community. I have very recently found out about the great learning experience it tends to be while contributing to Open-Source projects and have made few Pull Requests in different projects, mainly working on frontend changes as of now. But I certainly have a gist of how the community functions.

**b. What is your one project/achievement that you are most proud of? Why?**  
I had built a proper functioning cross platform Chatting application using the Flutter framework, integrated Firebase for authentication purposes, Firestore for storage and other functions for enabling other features. I find it as a key testimonial to my Dart/Flutter expertise, because this project was the reference with which my team started and built upon in the Software Development track of the ETHOS Hackathon organised by the prestigious institution of IIT Guwahati, where we ended up notching the runner up position.  
[Certificate Link](https://certificate.givemycertificate.com/c/902c925e-e366-47f1-b452-e1300306c9ae)

**c. What kind of problems or challenges motivate you the most to solve them?**  
Being a student of Computer Science and an avid technology enthusiast, I love to explore new frameworks, languages and domains. Now on the path of discovering and studying these technologies, I sincerely appreciate and admire the resources and systems easing the process involved. I believe that for a developer, enhancing their productivity and solving user’s issues are the biggest challenges. And I tend to engage in means to bridge the gap and find it the most motivating opportunity for me as a developer.  

**d. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
I will most certainly be devoting my Summer towards the proposed project exclusively during the period of May-July. Otherwise from August onwards, I will also be engaged with mu course’s seventh semester, studying primarily the core subjects of Computer Science. Regardless I assure to keep contributing to the project throughout the period.

**e. Do you mind regularly syncing up with the project mentors?**  
I certainly wouldn’t mind. I am comfortable with regularly syncing-up with the project mentors, maintain transparency and asynchronously communicate with them ideas and implementations throughout the project tenure.

**f. What interests you the most about API Dash?**  
Being a flutter developer, what excites me most about API Dash is how it brings together best in class Dart support and developer friendly UI: it’s the only open source API client that generates ready to use Dart code (both http and dio libraries) and even lets you run snippets in DartPad, so integrating APIs into your Flutter apps becomes a one click affair instead of tedious manual cURL conversions. On top of that, its syntax highlighted editor handles JSON, YAML, SQL, HTML, Markdown and even Unicode/emoji in both requests and responses, and you can preview or craft text/markdown responses directly—perfect for someone like you who writes both code and content, as it elevates your ability to build, test and document APIs in a single, seamless workflow.

**g. Can you mention some areas where the project can be improved?**  
Although APIDash is definitely an exceptional resource but as a project there are some improvements that can be implemented:  
• A better UI for application with a more lucrative styling  
• The project can employ to create accounts to track API testing and manage past activities.  
• GitHub based API contribution workflows can improve scalability.

---

## 4. Proposal Information

### Proposal Title  
The API Explorer project aims to streamline the API discovery and integration process within APIDash. By curating a categorized collection of publicly available APIs with ready-to-use templates, developers can skip the repetitive manual setup phase. I propose to build an automation pipeline that parses OpenAPI/HTML files, categorize and enriches data, and provides users with pre-configured API request templates. Optional features include user ratings, GitHub-based API submission, and a searchable interface for rapid access to resources.

---

### Plan of Action

#### Parsing and Automation Pipeline  
The Parsing and Automation Pipeline serves as the foundation of API Dash, responsible for ingesting API documentation from various sources. It employs sophisticated tools like **Swagger Parser** to automatically process structured OpenAPI specifications, while also utilizing custom web scrapers to extract information from HTML documentation pages. This dual approach ensures comprehensive coverage across API formats. The pipeline methodically extracts critical elements including endpoints, authentication requirements, example request payloads, and expected responses. All this enriched data is then systematically organized and stored in a structured format, likely utilizing JSON for portability or Firestore for scalable cloud storage and real-time synchronization capabilities. This automated pipeline eliminates the tedious manual work of API documentation analysis, dramatically reducing the time required to onboard new APIs.

#### Categorization & Tagging Engine  
The Categorization & Tagging Engine brings order to the vast ecosystem of APIs by intelligently classifying them into intuitive domains. It employs algorithmic analysis to automatically tag APIs based on their purpose and functionality, creating categories such as weather, finance, artificial intelligence, social media, and more. When simple keyword matching proves insufficient for accurate categorization, the engine** after discussion, can leverage more advanced Natural Language Processing (NLP) techniques** to derive semantic understanding from API documentation. This semantic analysis allows for more nuanced categorization, capturing the true purpose of each API beyond simple keyword matches. The resulting taxonomy creates an intuitive browsing experience for users, allowing them to quickly discover relevant APIs for their specific needs without having to sift through unrelated options.

#### Template Generator  
The Template Generator transforms raw API specifications into immediately usable request templates. For each API endpoint, it automatically generates properly formatted request templates that include all necessary components: headers configured with the correct content types, authentication placeholders for easy token integration, and request bodies structured according to the API's requirements. These templates are stored in a format that's directly compatible with API Dash workspaces, allowing for seamless importing. This compatibility ensures that users can transition from discovery to testing with minimal friction. The template generator effectively bridges the gap between documentation and implementation, enabling developers to begin interacting with APIs immediately rather than spending time manually configuring requests based on documentation.

#### Frontend UI in Flutter  
The Frontend UI, built with Flutter, delivers a consistent and intuitive experience across all platforms. It features a category-driven explorer interface that organizes APIs into logical groupings, making discovery natural and efficient. The interface includes robust search functionality with multiple filtering options, allowing users to quickly narrow down APIs based on criteria such as category, popularity, or specific capabilities. Each API listing provides comprehensive preview capabilities, displaying endpoint details, required parameters, and example responses without requiring users to leave the explorer. The signature feature—the "Import into Workspace" button—enables users to instantly transfer any API template into their active workspace with a single click, eliminating the traditional copy-paste workflow and accelerating the API integration process significantly.

---

### Tech Stack  
The API Dash platform leverages a modern and scalable technology stack designed for performance and developer productivity. The frontend will be built entirely with Dart and Flutter, ensuring a consistent, responsive interface across web, iOS, and Android platforms while maintaining a single codebase. Backend processing relies on either Node.js or Python, chosen for their robust ecosystem of libraries particularly suited for parsing and automation tasks. Data persistence is handled through Firestore or Firebase, providing real-time database capabilities, authentication services, and cloud functions in a unified platform. For the community contribution system, the GitHub API enables seamless integration with the world's largest development platform, allowing for structured submission workflows, version control, and collaboration. This carefully selected stack balances performance requirements with development efficiency, ensuring that API Dash can scale while maintaining rapid iteration cycles.

---

## Implementation Flowchart
![image](https://github.com/user-attachments/assets/e2c69558-63df-4bb8-b0f3-94be31f423dd)

---

### I. Timeline of Delivery

| Phase         | Time Period       | Implementation                                                                 |
|---------------|------------------|--------------------------------------------------------------------------------|
| Pre-GSoC      | Till June 1       | • Codebase Analysis  <br> • Mentor Interactions. <br> • Finalize technologies to use. <br> • Research on popular APIs and concept of API storage. <br> • Draft plan for automation and enrichment pipeline |
| Phase 1       | June 2 - June 15  | • Build parser for OpenAPI and sample HTML-based APIs. <br> • Text extraction of endpoints, payloads, etc. <br> • Complete parser for OpenAPI v3 <br> • Start HTML documentation. <br> • Begin storing extracted data in structured JSON format. |
| Phase 2       | June 16 - June 29 | • Create automation pipeline for enrichment. <br> • Add tagging logic to categorize APIs. <br> • Enrich APIs with authentication, sample payloads, headers. <br> • Store data in Firestore /JSON structure. |
| Phase 3       | June 30 - July 13 | • Generate API request templates. <br> • Connect templates to API Dash's import system. <br> • Build a dataset of at least 20 popular APIs. <br> • Final testing of backend + submit for midterm evaluation. |
| |                  | Midterm Evaluation                                                             |
| Phase 4       | July 14 - July 27 | • Design and implement API Explorer screen in Flutter. <br> • Add search, filtering, category browsing. <br> • Create API preview & “Import to Workspace” functionality |
| Phase 5       | July 28 - Aug 10  | • Add user reviews, rating systems. <br> • Implement GitHub-based API contributions. <br> • Display trending/popular APIs. |
| Phase 6       | Aug 10 - Aug 15   | • Bug fixes, UI cleanup and other optimization. <br> • Write documentation and prepare final report. <br> • Submit the final report. |

---
