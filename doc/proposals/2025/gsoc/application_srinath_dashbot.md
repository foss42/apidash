# GSoC Proposal: DashBot - AI-Powered API Assistant for API Dash


## About

1. **Full Name**: Vennapusa Srinath Reddy  
2. **Email**: srinathreddy0115@gmail.com  
3. **Phone-no**: +91-7569756336  
4. **Discord Handle**: srinath15  
5. **Home Page**: [srinathreddy.netlify.app](https://srinathreddy.netlify.app/)  
6. **Blog**: [sidduverse.notion.site/Acoustic-Echo-Cancellation](https://sidduverse.notion.site/Acoustic-Echo-Cancellation-175c6a02985880a79be4e68b56eaee51?pvs=4)  
7. **GitHub Profile Link**: [github.com/siddu015](https://github.com/siddu015/)  
8. **Twitter**: [x.com/siddu1501](https://x.com/siddu1501)  
9. **LinkedIn**: [linkedin.com/in/srinath-reddy-0a57a224b](https://www.linkedin.com/in/srinath-reddy-0a57a224b/)  
10. **Time Zone**: Indian Standard Time (IST, UTC+5:30)  
11. **Link to a Resume**: [Resume](https://drive.google.com/file/d/1zF6JrxVozYWZDKSXHUUzcVNbEc91XUoD/view?usp=sharing)  

## University Info
- **University Name**: Reva University  
- **Program**: B.Tech in Computer Science and Engineering (Artificial Intelligence and Data Science)  
- **Year**: 3rd Year (Started in 2022)  
- **Expected Graduation Date**: June 2026  

## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   Yes, I've contributed to DashBot for API Dash during FOSS Hack 2025. Over the past month, I've worked on its initial development and submitted several pull requests to the [API Dash repository](https://github.com/foss42/apidash). Relevant contributions include:  
   - Issue opened for ChatBot: [#605](https://github.com/foss42/apidash/issues/605)  
   - FOSS Hack PR for ChatBot: [#608](https://github.com/foss42/apidash/pull/608)  
   - Initial draft PR for DashBot: [#641](https://github.com/foss42/apidash/pull/641)  
   - Recent PR for modified DashBot version: [#699](https://github.com/foss42/apidash/pull/699)  

2. **What is your one project/achievement that you are most proud of? Why?**  
   I'm most proud of *LaughLab*, a personalized meme suggestion platform I built. The idea was to integrate a meme recommendation system with a user's keyboard, suggesting memes as they type based on their preferences, with a database that adapts over time. Check out the repo: [LaughLab](https://github.com/siddu015/LaughLab). I'm proud of this because it won 2nd place at E-Summit 2024 at Dayananda Sagar College—it was a fun and innovative challenge.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I'm motivated by meaningful technical challenges that push me to learn something new. I thrive on solving problems involving innovative features or complex logic, even if I only partially solve them. While I'm decent at UI/UX for usability, my passion lies in the technical backend—building things that work under the hood.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
   My 6th semester ends on June 7th, 2025, after which I'll work on GSoC full-time. Until then, I'll dedicate my time to detailed project planning, researching optimal implementation strategies, and discussing ideas with mentors to ensure a strong start.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all—I enjoy collaborating and value mentor feedback. Regular sync-ups keep me aligned and help me improve my work continuously.

6. **What interests you the most about API Dash?**  
   API Dash's open-source nature hooked me. As someone who uses APIs daily in personal and work projects, I've relied on tools like Postman but always wondered how they function internally. Discovering API Dash at FOSS Hack 2025 gave me that insight and sparked my interest. I'm excited to contribute meaningfully to a tool I'd use myself.

7. **Can you mention some areas where the project can be improved?**  
   I see huge potential in enhancing API Dash through DashBot. Having developed initial features (e.g., response explanation, debugging), I believe DashBot can be fine-tuned and fully integrated into API Dash's architecture. This would enable more accurate, context-aware assistance and support personalized, AI-driven workflows using local models—making API Dash a smarter, user-centric tool.

## Project Proposal Information

### 1. Proposal Title  
**DashBot - AI-Powered API Assistant for API Dash**

### 2. Abstract  
DashBot aims to transform API Dash into an intelligent, AI-driven API exploration and development tool. By integrating advanced AI capabilities, we'll create a comprehensive assistant that helps developers understand, debug, document, and implement APIs more efficiently.

### 3. Detailed Description  
- **Problem**: API Dash users manually handle debugging, testing, and documentation, slowing workflows. As an early-stage tool, it lacks AI-driven automation.  
- **Project Goals** :
   Develop an intelligent, modular AI assistant for API interactions
   Provide context-aware API analysis and support
   Create a flexible, extensible AI service architecture
   Enhance developer productivity through intelligent insights



- **Technical Architecture**
  Core Components

| Service | Key Features | Capabilities |
|---------|--------------|--------------|
| AI Analysis Service | - Semantic API request parsing | - Contextual understanding |
|  | - Multi-model AI integration | - Intelligent insights generation |
| Debugging Service | - Advanced error pattern recognition | - Root cause analysis |
|  | - Automated fix suggestions | - Performance bottleneck detection |
| Documentation Generator | - Automatic API documentation | - Comprehensive endpoint description |
|  | - Example generation | - Interactive documentation support |
| Code Generation Service | - Multi-framework code generation | - Intelligent client code creation |
|  | - Framework-specific best practices | - Customizable generation templates |
| Visualization Service | - Interactive response explorers | - API performance charts |
|  | - Network flow visualizations | - Data transformation insights |

<img width="1200" alt="Screenshot 2025-03-25 at 10 00 45" src="https://github.com/user-attachments/assets/b12b488b-612d-4ca3-8b8e-be47ba59a123" />

**LLM Provider Management**
   - Abstracted LLM provider interface
   - Multiple provider support
      - Local Ollama models
      - Cloud AI services (OpenAI, Anthropic, other API's)
   - Dynamic model selection
   - Resource-aware model recommendations

### 4. Weekly Timeline (175 Hours, ~12 Weeks)  

| Week | Duration | Focus Area | Key Activities |
|------|----------|------------|----------------|
| 1 | 15h | Bonding & Setup | Project initialization, mentor sync, environment setup |
| 2 | 15h | Beta Polish | Finalize initial features, basic debugging, documentation |
| 3-4 | 30h | Advanced Debugging | Auto-debugging implementation, comprehensive test generation |
| 5-7 | 45h | Visualizations | Plotting system development, response visualizations, customization |
| 8-9 | 30h | Frontend Code | Multi-framework code generation, API testing, response handling |
| 10 | 15h | Local LLM Integration | DashBot local model setup, Ollama integration, model selection |
| 11 | 15h | LLM Enhancements | Computational power optimization, DashBot toggle functionality |
| 11 | 15h | Benchmarks & UI | LLM evaluation, UI improvements, model compatibility testing |
| 12 | 10h | Testing & Wrap-Up | Comprehensive end-to-end testing, documentation finalization |
