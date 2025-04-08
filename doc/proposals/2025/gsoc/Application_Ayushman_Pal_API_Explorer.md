### About 

1. Full Name: Ayushman Pal  
2. Contact info (email, phone, etc.):  
   - Email: payushman72@gmail.com  
   - Phone: +91-8755087453  
3. Discord handle: mr_robot_016  
4. Home page (if any): https://github.com/WannaCry016  
5. GitHub profile link: https://github.com/WannaCry016  
6. LinkedIn: https://www.linkedin.com/in/ayushman-pal-392323254/  
7. Time zone: Indian Standard Time  
8. Link to a resume (PDF, publicly accessible via link and not behind any login-wall):  
   https://drive.google.com/file/d/18zCj5FUC4uffh8LmrSQft90mIry6iXDY/view  

### University Info

1. University name: Indian Institute of Technology, Madras  
2. Program you are enrolled in (Degree & Major/Minor): BTech, Chemical Engineering  
3. Year: 3rd Year  
4. Expected graduation date: 08/2026  

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   Yes, I have contributed to FOSS projects:  
   - https://github.com/foss42/apidash/pull/684: Fixed UI alignment issues to improve visual consistency across the app.  
   - https://github.com/foss42/apidash/pull/725: Made enhancements to the UI.  
   - https://github.com/foss42/apidash/pull/794: Replaced the underlying HTTP client from `http` to `dio`, enabling better error handling and extensibility.

2. **What is your one project/achievement that you are most proud of? Why?**  
   One project I’m proud of is the OEMS (Order Execution Management System), which I built in C++. It was a challenging backend system involving low-level networking, WebSockets, multi-threading, and real-time data streaming. I learned a lot about performance optimization and robust backend design through this project.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I’m most motivated by problems that involve developer experience, performance bottlenecks, and clean abstractions. I enjoy creating tools that improve developer workflows, exploring AI-powered enhancements, and optimizing real-time systems.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I plan to dedicate myself full-time to GSoC and ensure consistent progress throughout the coding period.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all — I value regular sync-ups and feedback to stay aligned with project goals and to produce high-quality work.

6. **What interests you the most about API Dash?**  
   API Dash is a clean, elegant tool built with a strong focus on developer productivity. I love its minimalist UI, open-source ethos, and the potential it has to become a one-stop tool for API testing with AI-enhanced features.

7. **Can you mention some areas where the project can be improved?**  
   - Adding support for protocols beyond REST/GraphQL (like gRPC or WebSockets).  
   - Making the API explorer more interactive and intuitive.  
   - Providing a plugin system or richer AI assistance during request creation.


### Project Proposal Information

**Proposal Title**: API Explorer: A Curated & Customizable API Library for API Dash

**Abstract**:  
API Dash lacks a built-in feature for discovering, managing, and importing publicly available APIs efficiently. Developers often manually set up API requests, which leads to repetitive, error-prone setups and increases onboarding time.

**Solution**:  
The API Explorer aims to address this by allowing developers to browse, save, import, and generate pre-filled API requests using various formats (OpenAPI, Postman, etc.). Key features include:

- Discover curated API templates categorized by domain (e.g., Finance, AI, Weather).  
- Upload OpenAPI/Postman/HTML documentation files and auto-generate corresponding API templates.  
- Save custom user-defined API templates for future use.  
- View endpoint metadata (parameters, authentication methods, response samples).  
- AI-assisted filling of incomplete documentation and auto-suggesting missing fields.  
- Convert an existing API request into a reusable template via one-click export.  
- Seamless integration into the Request Tab, allowing quick import and testing.  
- Future extensibility with plugin support or integrations with public API marketplaces.

**Detailed Description**:  
The API Explorer will be developed as a modular and extensible component within API Dash. It will include a frontend section (likely under a new tab) to explore API templates and a backend engine to parse uploaded OpenAPI specs or Postman collections. The templates will be stored either locally or optionally synced with GitHub gists/cloud. Each template will display metadata like endpoint name, method, headers, body format, query/path parameters, and examples. There will be options to import templates directly into the Request Tab and export request setups as shareable JSON templates. AI features will use LLM-powered completions (possibly via an optional local/integrated model or OpenAI plugin) to suggest missing headers, descriptions, or parameter values.

Users can also tag and organize their saved templates, making this not just a tool for immediate use, but also a personal API library over time.


### Weekly Timeline

**Community Bonding Period**  
- Interact with mentors, finalize the API Explorer UX and core scope.  
- Review existing API Dash codebase, especially how requests are stored/imported/exported.  
- Research supported import formats (OpenAPI 3.0+, Postman, cURL, etc.).  
- Set up environment for development and testing.

**Week 1: Core Architecture Setup**  
- Create skeleton UI for API Explorer tab/component.  
- Set up JSON template schema (compatible with OpenAPI/Postman).  
- Set up file upload mechanism and create file parser modules for OpenAPI and Postman.  
- Display parsed endpoints in a basic list view.


**Week 2: Template Viewer and Import Integration**  
- Build full UI to list, browse, and preview parsed APIs.  
- Add “Import to Request Tab” functionality for pre-filled API calls.  
- Support filtering APIs by tags, domain, and authentication type.  
- Add local storage/database support for saving templates.


**Week 3: User-defined Templates & Exporting**  
- Add feature to save a request as a template from the Request Tab.  
- Enable exporting these templates as JSON for backup or sharing.  
- UI for managing saved templates (edit, rename, delete, categorize).  
- Add visual indicators for required/optional fields in templates.


**Week 4: Advanced Parsing + AI Enhancements Phase 1**  
- Add support for additional fields like examples, descriptions, and status codes.  
- Integrate a basic AI module to auto-fill missing descriptions (OpenAI/local LLM).  
- Parse authentication metadata from OpenAPI/Postman and show in UI.  
- Test edge cases of complex nested parameters.


**Week 5: AI Enhancements Phase 2 + Bulk Import**  
- Add AI-assisted suggestions for filling headers, auth, or query values.  
- Enable uploading zip files with multiple specs for batch import.  
- Improve UI for better UX – tabs for Preview, Metadata, Raw JSON, etc.  
- Add light/dark mode compatibility and responsive design.


**Week 6: Template Organization & Tagging System**  
- Add tagging and categorization system for user templates.  
- Add search and filter options in the API Explorer.  
- Implement pagination or lazy loading for large collections.  
- Performance optimizations.


**Week 7: Testing, Validation, and Documentation**  
- Write unit/integration tests for parser modules and UI components.  
- Validate edge cases in OpenAPI/Postman import (complex nesting, arrays, etc.).  
- Write user documentation for API Explorer.  
- Create demo templates for popular APIs (e.g., OpenAI, Stripe, Twilio).


**Week 8: Final Review & Polishing**  
- Bug fixing, refactoring, and code cleanup.  
- Final UX refinements based on mentor feedback.  
- Ensure the final PR is merge-ready.  
- Prepare GSoC final report and a recorded demo video.
