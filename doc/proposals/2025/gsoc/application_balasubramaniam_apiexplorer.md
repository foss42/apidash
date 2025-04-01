# API Dash - GSoC 2025 Proposal

## About 

- **Full Name**: BALASUBRAMANIAM L
- **Contact Info**: 
  - Mobile: +91 9345238008
  - Email: balasubramaniam12007@gmail.com
- **Discord**: .balasubrmaniam
- **GitHub**: [Balasubramaniam](https://github.com/BalaSubramaniam12007)
- **LinkedIn**: [Balasubramaniam](http://www.linkedin.com/in/balasubramaniam2007)
- **Twitter**: [Balasubramaniam](https://x.com/BALASUBRAMAN1AM)
- **Time zone**: GMT+5:30

## University Info

- **University name**: Saveetha University, Chennai
- **Institution name**: Saveetha Engineering college
- **Degree & Major**: Bachelor of Technology
- **Year**: 1st Year
- **Expected Graduation**: 2028

## Motivation & Past Experience

### What interests you the most about API Dash?
I find that API Dash is a simple, hassle-free tool for quickly testing APIs without authentication. It supports multiple MIME types for easy response viewing and generates accurate code for different frameworks. Plus, its welcoming open-source community helps newcomers with their first contributions.

### Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?
Yes, I have contributed to this same project, API Dash, before. 
- [#665](https://github.com/foss42/apidash/pull/665) Implement global status bar => This PR introduces a global status bar to notify users of failed requests, warnings, and validation errors, improving error visibility and user awareness.
- [[#676 Tab bar](https://github.com/foss42/apidash/pull/676)] => The tab bar displays a list of API requests (represented as tabs) that the user can interact with—selecting a tab, closing it, or reordering it.

### Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?
I will not have any exams or other commitments during the entire coding period. My full focus will be on GSoC, allowing me to dedicate my time entirely to the project.

### Do you mind regularly syncing up with the project mentors?
Yes, I will communicate with my mentor through calls or chats for task updates and suggestions while remaining self-reliant.

## Project Proposal

### Proposal Title: API EXPLORER

### Abstract
The proposal focuses on enhancing the user experience of API Dash by creating a comprehensive API Explorer. The project will integrate a curated library of popular, publicly available APIs, simplifying the process for developers to discover, test, and import API endpoints into their workspaces. An automated backend pipeline will be developed to parse OpenAPI and HTML files, enriching and auto-tagging the extracted data to produce standardized JSON templates. This system aims to pre-configure authentication details, sample payloads, and expected responses, significantly reducing the manual setup time for developers. Additionally, the platform will feature a modern user interface that organizes APIs by domain, such as AI, finance, weather, and social media, while supporting direct imports into testing environments and encouraging community contributions. Ultimately, this solution is designed to reduce onboarding time and enhance efficiency, positioning API Dash as a valuable tool for API exploration and integration.

### Detailed Description

To enhance API Dash, we will create an automated pipeline that converts raw API specifications into enriched JSON templates, involving several key stages in the backend process.

#### Parsing & Data Extraction:
- Create a Dart parser to read API spec files in YAML, JSON, HTML, and Markdown.
- Extract key details like titles, descriptions, endpoints, and authentication info.
- Auto-generate sample payloads for testing when not provided.

#### Data Enrichment & Auto-Tagging:
- Enhance the extracted data by adding metadata for consistency and usability.
- Use NLP or regex to automatically tag and categorize APIs into domains like AI, finance, and weather.

#### JSON Template Generation: 
- Utilize json_serializable and json_annotation to convert enriched data into standardized JSON templates.

#### User Interface & Direct Import: 
- Develop a responsive, user-friendly UI that allows developers to discover, browse, search, and directly import API endpoints into their workspaces.

#### Offline Caching & Performance Optimization: 
- Integrate Hive for offline storage. 
- Optimize the automation pipeline for scalability.

#### GitHub Actions & Cron Job:
- When new API templates are added or updated, GitHub Actions will package them into a ZIP file and create a new release.
- A cron job will periodically fetch the latest releases, download the ZIP files, extract them, and store them in Hive for offline access.

#### Community Contributions:
In order to empower the developer community and keep the API templates accurate and up-to-date, this project establish contribution workflows via GitHub.

1. **Local Repository Contribution**: 
   - Developers can modify API specs locally using Git workflows, triggering an automated pipeline to generate enriched JSON templates for GitHub pull requests.

2. **Contribution via APIDASH**: 
   - As an innovative alternative, an in-app Documentation Editor will be integrated within API Dash. This feature allows users to:
   - Upload an API spec file or URL to trigger automated parsing.
   - Review and manually adjust the auto-generated JSON template in an easy-to-use editor.
   - Download the updated JSON template. In the future, trigger an automated GitHub pull request directly from the application.

### Implementing Essential Features (Project Deliverables):

1. **Automated Parsing & Template Generation**:
   - Build a backend pipeline to extract API details and generate enriched JSON templates with full testing configurations.

2. **Curated API Library & Categorization**:
   - Develop a UI to showcase APIs with search, filtering, and auto-tagging into categories like AI, finance, and weather.

3. **Direct Import Functionality**:
   - Enable developers to import pre-configured API request templates with authentication, sample payloads, and expected responses.

4. **Community Contributions & Reviews**:
   - Allow users to contribute via GitHub workflows, ensuring the API repository remains accurate and community-driven.

5. **Offline Caching & Performance Optimization**: 
   - Integrate Hive for offline storage. Optimize the automation pipeline for scalability.

6. **GitHub Actions & Cron Job Automation**: 
   - Automate API template updates:
     - GitHub Actions will package new or updated API templates into a ZIP file and trigger a new release.
     - A cron job will periodically fetch the latest releases, extract the templates, and store them in Hive for offline access.

### API EXPLORER Design:
Click here to check the prototype: [Figma Link\]](https://www.figma.com/design/lxKNiN6sCq0xRJsVW7ZnbI/Untitled?node-id=78-19&t=PvoLoDP7SNruhaQP-1)

### Packages & Requirements:

#### 1. Parsing & Data Processing
- [yaml](https://pub.dev/packages/yaml) – Parse and extract data from YAML API specs.
- [html](https://pub.dev/packages/html) – Process HTML content within API specifications.
- [markdown](https://pub.dev/packages/markdown) – Parse and format API documentation in Markdown.
- [json_serializable](https://pub.dev/packages/json_serializable),[ json_annotation](https://pub.dev/packages/json_annotation) – Handle structured API request templates.
- [nlp](https://pub.dev/packages/nlp)[OPTIONAL] – Implement taggers for categorization and keyword extraction.

#### 2. Automation & Background Tasks
- [cron](https://pub.dev/packages/cron) – Fetch the latest API template releases periodically.
- [archive](https://pub.dev/packages/cron) – Extract downloaded ZIP files containing API templates and store them in Hive.

#### 3. UI & UX Components
- [flutter_hooks](https://pub.dev/packages/flutter_hooks) – Manage lifecycle events and reactive UI logic efficiently
- UI elements include: Cards, Chip for API template display.

### Weekly Timeline:

#### Community Bonding Period
- Collaborate with mentors to discuss project scope.
- Finalize project scope, design, and deliverables.
- Outline the overall parsing pipeline, including auto‑tagging and data enrichment strategies.

#### Week 1: Environment Setup & Initial Parser/Extractor Enhancement
- Set up the development environment and structure the repository with /apis/ for raw files and /api_templates/ for generated JSON.
- Develop a basic parser and extractor module to read raw API files.
- Validate it with sample files to confirm accurate detection and extraction.

#### Week 2: Enhancing the Data Parsing Script
- Expand the initial data parsing script to handle multiple file formats.
- Ensure the parsing logic aligns with the API request models.
- Begin integrating error handling and logging for parsing processes
- Write unit tests to ensure proper parsing logic.

#### Week 3: Implementing Data Enrichment & Auto‑Tagging
- Enhance metadata by adding extra contextual details for each API.
- Implement NLP-based auto-tagging (if needed) or regex-based keyword matching.
- Categorize APIs automatically.
- Fine‑tune the logic for clear and accurate categorization of APIs.
- Write unit tests to validate auto-tagging accuracy and metadata enrichment.

#### Week 4: JSON Template Generation for API Request Templates
- Develop a module to generate structured JSON templates from the parsed API data.
- Ensure the generated JSON includes:
  - Authentication headers
  - Sample payloads
  - Expected responses
- Validate the JSON output against the standard API request model to guarantee consistency.

#### Week 5: Offline Storage Integration & Initial UI Work
- Integrate Hive to locally store JSON templates.
- Cache API request templates for quick offline access.
- Ensures smooth update and retrieval of stored data
- Outline basic API Explorer UI structure(e.g.,skeltons, placeholders for cards, search bar, filter controls).

#### Week 6: UI Development – API Explorer & Description Pages
- Finalize the API Explorer page with search, filters, pagination, and a card-based layout.
- Retrieve JSON templates from Hive.
- Develop the API Description page to show the method, sample payloads, and import options.
- Integrate navigation and UI for easy viewing and importing.
- Write unit and widget tests.

#### Midterm Evaluation

#### Week 7: Import Template into Request Functionality
- Implement the "Import API" feature, allowing users to: 
  - Load API request templates
  - Auto-fill authentication headers & payloads.
- Ensure authentication details, sample payloads, and headers are pre-filled when importing.
- Validate that users can modify and execute imported API requests.
- Write integration tests for the template import process.

#### Week 8: Contribution Workflow & Import Enhancements
- Editor Development:
  - Implement features for users to upload an API spec file or provide a URL.
  - Trigger the Dart processing script.
  - Develop an in-app Documentation Editor interface.
- User Interaction:
  - Allow users to review and manually adjust the auto-generated JSON template.
  - Provide options to download the JSON or (in a future phase) trigger automated PR creation.
- Test the editor's responsiveness and user interaction flow
- Write unit and integration tests for contribution workflows.

#### Week 9: Automation with GitHub Actions & ZIP Packaging
- Set up GitHub Actions to:
  - Trigger a new release when templates are updated
  - Package API templates into a ZIP file.
- Configure a cron job to fetch the latest ZIP release periodically.
- Develop functionality to extract the ZIP file and store the extracted JSON templates files in Hive.

#### Week 10: Unit & Widget Testing | Integration & End-to-End Testing
- Write additional unit, widget, and integration tests for uncovered edge cases.
- Conduct minimal additional testing for previously developed features.
- Implement additional validations on the generated JSON templates (e.g., schema checks).
- Gather feedback from mentors on implementation and refine functionalities accordingly.
- Conduct end-to-end validation for file/URL imports.
- Fix any bugs/issues found while testing.

#### Week 11: Code Optimization & Final Refinements
- Optimize parsing and enrichment logic for better performance.
- Improve UI/UX based on mentor feedback and testing.
- Perform final full-system testing and address any last-minute fixes.

#### Week 12: Final Review & Submission
- Analyze performance and quality to ensure features work smoothly.
- Final review with mentors.
- Prepare technical documentation and contribution documentation.
- Prepare documentation for final evaluation.

#### Final Evaluation

### Future Enhancements:
We will expand these features in future releases, but they may not work fully at this stage.
- **Ratings & Reviews**: Enable users to rate and review API templates for quality control.
- **GitHub Integration & PR Automation**: Automate pull request creation and integrate GitHub workflows for streamlined contributions.

### Relevant Project Experience: 
#### Project: ApiForge - OpenAPI Specification Management Tool
**Description:**
[ApiForge](https://balasubramaniam12007.github.io/) is a Flutter-based application designed to load, parse, and display OpenAPI specifications. It allows users to load OpenAPI specs either by providing a URL or uploading a local file (in JSON or YAML format) and export it as postman collections.

**Key Achievements:**
- **Load OpenAPI Specs**: Load specs from a URL or by uploading a local file (JSON/YAML). 
- **View Endpoints**: Display API endpoints with their methods, paths, and descriptions in a user-friendly format. 
- **Search Functionality**: Filter endpoints by path or method via search.
- **Export to Postman**: Export the loaded OpenAPI spec as a Postman collection for easy testing. 

**Technologies**: Flutter, Dart, OpenAPI, GitHub Actions, GitHub Pages

**Project Outcomes**: 
- OpenAPI Spec Import – Load specs via URL or local JSON/YAML files.
- API Endpoint Visualization – Display methods, paths, and descriptions
- Search & Filter – Quickly find endpoints by path or method.
- Postman Export – Convert OpenAPI specs into Postman collections.

### Blogs Posted:
**[A Month with Apidash: A Comprehensive Review](https://medium.com/@balasubramaniam12007/in-recent-years-the-need-for-streamlined-api-testing-and-integration-has-grown-alongside-the-rapid-9a4eab5bca02)**
- Date: Mar 25, 2025
- Description: The article reviews Apidash, highlighting its lightweight design, offline access, cross-platform compatibility, and built-in code generation, along with its benefits and guidance for developers getting started.