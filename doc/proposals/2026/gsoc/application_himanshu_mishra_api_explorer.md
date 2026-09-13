### About

1. **Full Name:** Himanshu Mishra
2. **Contact info (public email):** <himanshu.mishra0913@gmail.com>
3. **Discord handle in API Dash server (mandatory):** himanshu._.mishra
4. **GitHub profile link:** <https://github.com/himanshumishra1309>
5. **LinkedIn:** <https://www.linkedin.com/in/himanshu-mishra-459b882b4/>
6. **Time zone:** Asia/Kolkata (IST, UTC+5:30)
7. **Link to resume (public PDF):** <https://drive.google.com/file/d/1PqbUxnrgN88xDec_ZXnBjBH42BoHpA2y/view?usp=sharing>

### University Info

1. **University name:** Government College of Engineering Chhatrapati Sambhajinagar
2. **Program you are enrolled in (Degree & Major/Minor):** Major_BTech_Computer_Science_And_Engineering & Minor_Finance_And_Accounting
3. **Year:** Third-Year
4. **Expected graduation date:** May 2027

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   While I haven't been a long-term core contributor to a major FOSS project yet, I am highly motivated to deep-dive into open-source. Given the opportunity, I want to dedicate my learning and development towards FOSS. To build my understanding of open-source architectures, I have recently started actively looking into issues and raising PRs across various projects:

   **Pull Requests:**
   - React Docs: [#8209](https://github.com/reactjs/react.dev/pull/8209)
   - Joplin: [#14739](https://github.com/laurent22/joplin/pull/14739)
   - EventMint: [#499](https://github.com/samyakmaitre/eventmint/pull/499)
   - React Bits: [#776](https://github.com/DavidHDev/react-bits/pull/776)

   **Issues Logged / Investigated:**
   - Supabase: [#42243](https://github.com/supabase/supabase/issues/42243)
   - PalisadoesFoundation (talawa-api): [#4901](https://github.com/PalisadoesFoundation/talawa-api/issues/4901)
   - PalisadoesFoundation (talawa-docs): [#1117](https://github.com/PalisadoesFoundation/talawa-docs/issues/1117)
   - Brave Browser: [#49370](https://github.com/brave/brave-browser/issues/49370)
   - EventMint: [#495](https://github.com/samyakmaitre/eventmint/issues/495)

2. **What is your one project/achievement that you are most proud of? Why?**  
   I am most proud of winning the Smart India Hackathon (SIH) in 2024 when I was in my second year. It was my first time leading a team of 6 members. It was a challenging yet achievable endeavor where we built a [Faculty Appraisal Portal](https://github.com/himanshumishra1309/faculty-appraisal-portal.git). I worked heavily on the backend, deployed the complete solution on Google Cloud using Nginx, purchased the domain name, and successfully integrated it. This experience completely transformed my ability to design, lead, and deploy end-to-end systems under pressure.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I really enjoy problems that require a good amount of research and logic building. I like the challenge of taking something messy or unpredictable and finding a clean, logical way to make it work reliably for the end user. That’s exactly why the API Explorer project caught my eye. Out in the real world, public OpenAPI specs can be broken, missing fields, or formatted weirdly. Figuring out how to read them smoothly, handle all those weird edge cases without crashing the system, and build an automated pipeline that "just works" requires exactly the kind of practical problem-solving I love doing.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
   I will prioritize GSoC as my primary commitment during the coding period. If I have academic commitments, they will be limited and planned so that milestone delivery and mentor sync remain unaffected.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all. I strongly prefer frequent mentor feedback and will share structured weekly updates, blockers, and demos.

6. **What interests you the most about API Dash?**  
   What excites me most about API Dash is its potential to rival and eventually surpass enterprise tools like Postman, while remaining completely open-source. The fact that it is built entirely in Dart/Flutter makes it uniquely fast and cross-platform native out-of-the-box. I strongly believe in the mission of solving real developer productivity problems through an open ecosystem, and API Dash is perfectly positioned to become the go-to API client for developers globally.

7. **Can you mention some areas where the project can be improved?**  
   I have explored the project deeply, and it looks really good so far! However, there are a few areas we could expand on. Some protocols are currently missing, like WebSockets, and adding authorization import parity with tools like Postman would be a huge plus. I believe with the community's combined efforts, these can be integrated quickly. 
   
   Additionally, an **API Explorer** was one feature missing for first-time user onboarding. My goal with this GSoC proposal is to lay the foundational bricks for this explorer so that we can work further on making it the best discovery hub in the ecosystem.

### Project Proposal Information

1. **Proposal Title**  
   **API Explorer Automation: A Zero-Maintenance, Fault-Tolerant Pipeline with Community Curation**

2. **Abstract: A brief summary about the problem that you will be tackling & how.**  
   To support the “API Explorer” feature, API Dash requires a reliable way to collect, process, and serve public API data in a structured and usable format.

   This proposal focuses on building a fully automated pipeline using Python and GitHub Actions. The pipeline will fetch OpenAPI specifications, validate them, extract relevant information such as endpoints and request structures, and convert them into ready-to-use API templates.

   The system is designed to be fault-tolerant i.e invalid or broken APIs are isolated without affecting the rest of the pipeline. It also introduces a GitHub-based workflow for community contributions, allowing APIs to be submitted, validated, and improved in a structured manner without requiring additional backend infrastructure.

3. **Detailed Description**

#### 3.1 Architecture Overview

The proposed system is designed as a fully automated, GitHub-native pipeline that converts OpenAPI specifications into ready-to-use API templates for API Dash. The focus is on keeping the architecture simple, maintainable, and easy to extend.

**Step 1. Input Registry:**
*   **`sources.json`**: A curated list of trusted OpenAPI specification links. This serves as the primary data source.
*   **GitHub Formatted Issues**: Community-submitted API links via issue templates that act as a dynamic input source, expanding the registry over time.

**Step 2. Parsing Engine (Python):**
*   A scheduled Python script fetches OpenAPI files and extracts key information such as:
    *   Base URLs
    *   Endpoints and HTTP methods
    *   Path and query parameters
    *   Request body structure
    *   Required headers (if available)

**Step 3. Validation Layer:**
*   Each OpenAPI file is validated before processing to ensure reliability. The pipeline checks:
    *   Valid JSON/YAML format
    *   Presence of required fields such as `paths`
    *   Basic reachability of server URLs

**Step 4. Auto-Tagging System:**
*   APIs are categorized using a rule-based keyword mapping approach. For example, keywords like "GPT" map to `AI`, while "currency" maps to `Finance`. This keeps the system deterministic and easy to maintain.

**Step 5. Template Transformation:**
*   The extracted data is mapped into API Dash’s `ApiTemplate` format.
*   Path parameters and request fields are converted into variables so that APIs can be executed with minimal user setup.

**Step 6. Static Output (JSON):**
*   The final output is a `templates.json` file hosted via GitHub Pages. This allows the API Dash app to fetch and render templates efficiently without requiring a backend service.

#### 3.2 Fault Tolerance Strategy

Public OpenAPI specifications are often incomplete, inconsistent, or temporarily unavailable. The pipeline is designed to handle such cases without affecting the overall system.

**`templates.json` (Valid APIs):**
* Contains only APIs that successfully pass validation and parsing checks. This ensures that the application consumes only reliable and usable templates.

**`pipeline_report.json` (Failed APIs):**
* Stores APIs that could not be processed, along with detailed error messages such as:
  * Invalid schema or format
  * Missing required fields
  * Network errors (e.g., timeouts, 404 responses)

This separation ensures robustness while still providing transparency for debugging and improvement.

#### 3.3 Community Contribution & Feedback System

To enable community-driven improvements without introducing additional backend infrastructure, the system leverages GitHub as a lightweight data layer.

**Submission via GitHub Issues:**
* Contributors can submit new API links through a structured Issue template.

**Automated Validation:**
* A GitHub Action runs the pipeline against submitted APIs and validates them automatically.

**Feedback & Ratings (GitHub-based):**
* Each API template is mapped to a corresponding GitHub Issue:
  * **Upvotes/Downvotes:** Represented using GitHub reactions (👍 / 👎)
  * **Comments:** Stored as Issue comments

**Pipeline Integration:**
* The pipeline periodically fetches this data using the GitHub API and computes:
  * Popularity score (based on reactions)
  * Recent user feedback

This information is then included in the generated `templates.json`, allowing the API Dash app to display community insights alongside each API.

This approach avoids the need for a separate backend while still enabling a transparent and scalable feedback system.

#### 3.4 Edge Cases & Validation Considerations

To ensure reliability across diverse OpenAPI specifications, the pipeline accounts for common edge cases:
* Missing or empty `servers` field
* Multiple server URLs
* APIs requiring authentication headers
* Large or deeply nested schemas
* Rate-limited or temporarily unavailable endpoints

These cases are handled gracefully, with failures recorded in the pipeline report instead of breaking execution.

#### 3.5 Scope & Limitations

To keep the implementation focused and achievable within the GSoC timeline, the following scope boundaries are defined:
* Only OpenAPI-based APIs will be supported initially.
* Authentication flows (OAuth, API keys requiring user input) will not be fully automated.
* The pipeline will run on a scheduled basis (no real-time updates).
* Advanced search/filtering within templates will not be handled at the pipeline level.

These constraints ensure the system remains stable, maintainable, and aligned with project goals.

#### 3.6 Future Scalability Consideration

The current design intentionally uses static JSON and GitHub-based workflows to keep the system simple and maintainable.

If the platform evolves to require high-frequency updates, advanced querying, or large-scale user-generated data, the architecture can be extended to include a database layer (e.g., PostgreSQL or Supabase).

Since the pipeline already separates data extraction, transformation, and output generation, introducing a database in the future would be an incremental enhancement rather than a redesign.

#### 3.7 Technical Stack

The architecture focuses on battle-tested, lightweight tools available in the open-source ecosystem:
*   **Core Logic:** Python 3.10+ (Excellent ecosystem for JSON/YAML parsing and API fetching).
*   **Automation & CI/CD:** GitHub Actions (Automated cron scheduling and issue triggers).
*   **Data Hosting / CDN:** GitHub Pages (Zero-cost, static file hosting for `templates.json`).
*   **Community Data Layer:** GitHub REST API & GitHub Issues.
*   **App Integration:** Dart/Flutter (Mapping parsed properties to API Dash's internal `ApiTemplate` models).

4. **Weekly Timeline (90 Hours - Easy/Medium)**

#### Pre-GSoC (Community Bonding)
*   Finalize the exact internal JSON schema of the `ApiTemplate` format with the mentors.
*   Establish the baseline dictionary for the Rule-Based Auto-Tagging System.
*   Finalize the initial "Starter Pack" array of API sources to be hardcoded into `sources.json`.

#### Week 1: Core Engine & Data Extraction (The Parser)
*   **Action:** Build the foundational Python script that reads `sources.json` and fetches the raw OpenAPI specifications.
*   **Action:** Implement the extraction logic to correctly parse Base URLs, endpoints, headers, and request bodies from the OpenAPI payload.
*   **Action:** Implement the baseline Validation Layer (Step 3) to ensure only specifications possessing valid structures (e.g., `paths` object) are passed to the next step.

#### Week 2: Fault Tolerance & Transformer
*   **Action:** Write the Error Isolation Engine. Wrap the parser in `try/except` blocks to separate successful APIs from failed APIs.
*   **Action:** Generate the initial mock outputs for `templates.json` and `pipeline_report.json`.
*   **Action:** Build the data mapping logic that structurally transforms the extracted OpenAPI variables into API Dash's specific `ApiTemplate` variable format.

#### Week 3: Tagging System & GitHub Actions Schedulers
*   **Action:** Implement the Rule-Based Auto-Tagging engine (Step 4) to assign categories based on API titles and descriptions.
*   **Action:** Configure the primary GitHub Action workflow file (`.yml`) to orchestrate the pipeline exactly as charted in the flow diagram.
*   **Action:** Set **Scheduler 1 (Every 24h)** to fully run the pipeline, fetch the sources, parse them, and overwrite `templates.json` on GitHub Pages.

#### Week 4: The GitHub-Native Community Loop (Issues & Sync)
*   **Action:** Create the structured GitHub Issue Template to allow community members to submit new OpenAPI links natively.
*   **Action:** Build the Webhook/Action trigger so that when a user submits an issue, the pipeline runs a "dry-test". If it fails, the Action bot auto-comments on the PR with the exact `pipeline_report.json` error.
*   **Action:** Write the logic to hook into the GitHub REST API to fetch Issue Reactions (👍/👎) and Comments associated with specific APIs.

#### Week 5: UI/UX & The High-Frequency Feedback Sync
*   **Action:** Configure **Scheduler 2 (Every 1h)** to independently pull reaction and comment data from GitHub Issues and update the "Popularity Scores" and metadata within the static files without needing to re-parse the heavy OpenAPI specs.
*   **Action:** Design and mock the Flutter App UI component for API Explorer.
*   **Action:** Integrate API Dash client logic to read `templates.json` seamlessly, displaying the auto-tags and popularity scores.

#### Week 6: Testing, Documentation, & Handoff
*   **Action:** Write extensive edge-case handling tests (e.g., handling missing `servers` fields, unexpected HTTP codes during fetches).
*   **Action:** Draft maintainer documentation on how to interpret `pipeline_report.json` and address recurring API errors.
*   **Action:** Draft community guidelines on how users can submit APIs and understand the auto-bot validation messages.
*   **Buffer:** Final code reviews, formatting, and minor bug fixes.