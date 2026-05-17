# GSoC 2026 Application:  Open Responses & Generative UI

### About

1. **Full Name:**  Rafia Maqsood
2. **Contact Info:** rafiamaqsood37@gmail.com
3. **Discord Handle:** RafiaMaqsood
4. **Home Page:** N/A
5. **Blog:** N/A
6. **GitHub:** [GitHub](https://github.com/rafiamaqsood)
7. **LinkedIn:** Not Public (verification pending)
8. **Time Zone:** Asia/Karachi (PKT, UTC+5)
9. **Resume:** https://drive.google.com/file/d/1AZOqOo6tQWNcRYzQS56rjd0LYxqCWQ_w/view?usp=drive_link

### University Info

1. **University:** University of Home-Economics Lahore
2. **Degree & Major:** Bachelor of Science (BS) in Computer Science 
3. **Year:** 6th semester(2023 batch)
4. **Expected Graduation:** June 2027

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes, I have contributed to API Dash by setting up the project locally, exploring the codebase structure, and understanding the request/response UI flow.
I have contributed by reporting and analyzing issues such as:
**On-screen keyboard overlaps input fields on Android (#1381)**
https://github.com/foss42/apidash/issues/1381
**Layout overflow when focusing URL field or Preview search bar after GET request on Android (#1535)**
https://github.com/foss42/apidash/issues/1535
I also worked on a fix and opened a PR:
**Fix bottom bar overflow and update widget tests (#1536)**
https://github.com/foss42/apidash/pull/1536

I additionally worked on implementing the functionality Implement "Add Custom Model" functionality in AI Model Selector (#1315). I started implementing the feature locally, but another contributor submitted a PR before I could open mine, so I did not submit it.
I've also been actively participating in the project through
Discussion on #5 - Open Responses & Generative UI #1227, also attended last weekly connect session.

**2. What is your one project/achievement you are most proud of?**

The project I am most proud of is **AmbuGo**, a Smart Traffic Light System designed to give priority to ambulances at intersections.
It is a full-stack IoT + Mobile App project with real-time synchronization.
Key features include:
Firebase Realtime Database to store ambulance emergency status
ESP32-based traffic lights that react to emergency signals
Flutter mobile app for ambulance driver authentication and emergency activation
Automatic return to normal traffic cycle after emergency ends
Tech Stack:
Flutter (Mobile App)
Firebase Realtime Database
ESP32 firmware (PlatformIO)
GitHub Repo: https://github.com/rafiamaqsood/AmbuGo
This project is important to me because it combines real-world problem-solving with software + hardware integration.

**3. What kind of problems motivate you most?**
I enjoy challenges where I can help the community using my app development skills such as Flutter, React Native, TypeScript, and AI.

**4. Will you be working on GSoC full-time?**

Yes, I will be working on GSoC full-time since my university summer vacation aligns with the GSoC coding period.

**5. Do you mind regularly syncing up with mentors?**

No, I actually think it is good for communication. It makes things clear, and I like regular sync-ups.

**6. What interests you most about API Dash?**

The idea about Open Responses & Generative UI because it combines AI interoperability with interactive UI visualization. It aligns well with my expertise and I would enjoy working on it.

**7. Areas where the project can be improved?**

One area that I noticed can be improved is mobile responsiveness. API Dash works well on large screens like tablets and desktop platforms, but on smaller Android devices there are multiple overflow issues. Once these open issues are resolved, the overall user experience on mobile devices will improve significantly.

**8. Have you interacted with and helped API Dash community? (GitHub/Discord links)**
Yes, I have interacted with the community through GitHub issues and discussions. I reported bugs, tested UI issues, and also worked on fixes and PRs.
Relevant links:
**On-screen keyboard overlaps input fields on Android (#1381)**
https://github.com/foss42/apidash/issues/1381
**Layout overflow when focusing URL field or Preview search bar after GET request on Android (#1535)**
https://github.com/foss42/apidash/issues/1535
I also worked on a fix and opened a PR:
**Fix bottom bar overflow and update widget tests (#1536)**
https://github.com/foss42/apidash/pull/1536

### Project Proposal Information

**1. Proposal Title**
Open Responses & Generative UI Visualization in API Dash

**2. Abstract**

API Dash currently displays AI API responses mainly as raw JSON/text, which makes it difficult for developers to quickly interpret structured AI outputs. This project aims to integrate **Open Responses** structured output support and enable a **Generative UI Preview** inside API Dash.

The goal is to detect responses following the Open Responses specification, parse them into a structured intermediate format, and render them as rich UI components such as cards, lists, tables, and markdown blocks. This will allow users to switch between raw JSON view and a visual rendered UI preview. The project will follow Google’s **A2UI guidelines** and explore Flutter’s **GenUI SDK** for rendering structured UI outputs. The final implementation will make API Dash more developer-friendly and provide a reference design that developers can reuse in their own Flutter or web apps.

**3. Detailed Description**

**Background / Problem**

Modern AI models increasingly return structured responses (tool calls, UI blocks, structured JSON outputs). These outputs are designed to be consumed programmatically or visually rather than manually reading raw JSON.

Currently, API Dash mainly shows AI responses as plain text or raw JSON. This creates problems such as:

- Developers must manually interpret the response structure  
- Tool-call or structured blocks are difficult to understand quickly  
- No preview exists for how the response could appear as a UI  
- The experience becomes less user-friendly for beginners and AI-driven workflows  

**Proposed Solution**

This project will implement **Open Responses structured response visualization** inside API Dash by introducing a Generative UI renderer.

The implementation will be divided into three main layers:

**(A) Detection Layer**

- Detect whether the response matches the Open Responses specification
- Identify structured response output blocks
- If unsupported, fallback to the current JSON/text response display

**(B) Parsing Layer**

- Parse Open Responses JSON into Dart model objects
- Convert response outputs into an intermediate UI schema
- Ensure the parser handles malformed or incomplete responses gracefully
- Add unit tests for parser correctness

**(C) Rendering Layer (Generative UI Preview)**

- Create a new "GenUI Preview" panel/tab in the response section
- Render parsed UI schema into Flutter widgets
- Allow switching between:
  - Raw JSON view
  - Preview view
  - GenUI Preview view

**Core UI Components Support**

For the first working version, the renderer will support:

- Text blocks
- Markdown blocks
- Cards
- Lists
- Tables (key-value and row-based)
- Error block / fallback rendering for unknown UI components

This ensures the feature is immediately useful while keeping the scope realistic for a 90-hour project.

**Alignment with A2UI / GenUI**

Google’s A2UI introduces clear guidelines for Generative UI systems. This project will ensure:

- UI components remain responsive and readable
- Rendering is consistent and stable across layouts
- Unsupported components do not break the UI
- UI is designed with extensibility so more components can be added later

If feasible, Flutter’s GenUI SDK will be explored for structured UI rendering.

**Expected Impact**

This feature will improve API Dash significantly by:

- Making AI responses easier to understand
- Helping developers debug AI outputs quickly
- Providing UI-based visualization of structured response outputs
- Offering a reference implementation for Generative UI integration
- Increasing API Dash’s usefulness compared to other API testing tools

**4. Weekly Timeline (90 Hours)**

**Community Bonding Period**

- Study Open Responses specification and structure
- Study A2UI guidelines and Flutter GenUI SDK examples
- Explore API Dash codebase response rendering pipeline
- Identify integration points for new preview panel
- Finalize implementation plan with mentors

Deliverables:
- Design notes and implementation plan
- Identified integration points in API Dash

### Week 1: Open Responses Parser Implementation

- Implement Open Responses response detection logic
- Implement parser for basic structured blocks (text + markdown)
- Add unit tests for parsing correctness
- Ensure safe handling of invalid JSON

Deliverables:
- Working parser foundation
- Passing unit tests

### Week 2: Generative UI Preview Panel Integration

- Add "GenUI Preview" panel/tab in response section
- Render text and markdown blocks into Flutter widgets
- Add fallback UI when response is unsupported

Deliverables:
- Working GenUI preview UI
- Basic structured rendering

### Week 3: Core UI Components Support

- Add card block rendering
- Add list rendering
- Add table rendering support
- Improve responsiveness and layout consistency

Deliverables:
- Core UI blocks supported
- Widget tests for UI rendering

### Week 4: Robustness + A2UI / GenUI Improvements

- Improve intermediate schema structure for better extensibility
- Explore Flutter GenUI SDK integration (if compatible)
- Add better error handling and debugging support
- Ensure graceful fallback for unsupported blocks

Deliverables:
- Stable renderer with improved robustness
- Better UX for unsupported/invalid responses

### Week 5: Testing, Documentation, Final Cleanup

- Improve unit and widget test coverage
- Refactor code to match API Dash architecture standards
- Add documentation explaining:
  - how Open Responses parsing works
  - how new UI blocks can be added
  - expected supported component types

Deliverables:
- Final PR ready for review
- Documentation added
- All tests passing

# Final Deliverables Summary

By the end of the project, API Dash will support:

- Open Responses structured output parsing
- A new Generative UI Preview panel/tab
- Rendering of core UI blocks (text, markdown, cards, lists, tables)
- Graceful fallback for unsupported response structures
- Unit tests + widget tests
- Documentation for future contributors and extensions