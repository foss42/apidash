# GSoC 2026 Proposal — API Dash

## About

- **Full Name:** Ayus Kumar Pathak  
- **Contact Email:** ayuskpathak@gmail.com  
- **Discord Handle:** ayus_h_ 
- **Home Page:** https://vectr.co.in  
- **Blog:** N/A  
- **GitHub:** https://github.com/AyusKumarPathak  
- **LinkedIn:** https://linkedin.com/in/ayus-pathak  
- **Twitter:** N/A  
- **Time Zone:** IST (UTC+5:30)  
- **Resume:** https://drive.google.com/file/d/1x0fVHtSdLxIvMwb_i8mm9TRY2DJPI5p9/view

---

## University Info

- **University:** VIT-AP University, Andhra Pradesh, India  
- **Program:** B.Tech in Computer Science & Engineering  
- **Year:** 2nd Year  
- **Expected Graduation:** 2027  

---

## Motivation & Past Experience

### 1. FOSS Contributions
I am actively transitioning into open-source contributions and have begun exploring real-world repositories like API Dash. While I am early in my FOSS journey, I have strong development experience and am now focused on contributing meaningful features.  
GitHub: https://github.com/AyusKumarPathak  

---

### 2. Project I’m Most Proud Of
I built **Vectr**, a complete product from scratch, handling frontend, backend, and deployment.  
It reflects my ability to design scalable systems independently and execute end-to-end solutions.  

---

### 3. Problems That Motivate Me
I am most motivated by **systems that don’t scale manually**.  
The API Dash template issue is exactly that — a well-built UI blocked by lack of automation.  
I enjoy solving such bottlenecks with clean backend systems.

---

### 4. Availability
Yes, I will be working **full-time during GSoC** with no conflicting commitments.

---

### 5. Mentor Sync
Yes, I am fully comfortable with **regular sync-ups, feedback cycles, and iterative PRs**.

---

### 6. Interest in API Dash
API Dash is a developer-first tool solving real API exploration problems.  
What excites me most is:
- Clean Flutter architecture
- Real-world usability
- Clear gap in automation (perfect for impactful contribution)

---

### 7. Areas of Improvement
- No automated template generation system  
- Limited template dataset  
- No update mechanism for API changes  
- Weak category/tagging system  

---

### 8. Community Interaction
I have studied the API Dash codebase and GitHub discussions in depth and aligned my proposal with maintainer expectations. I am actively preparing to contribute via PRs.

---

## Project Proposal Information

### 1. Proposal Title
**Automated API Discovery & Template Generation Pipeline (API Explorer)**

---

### 2. Abstract

API Dash currently depends on manually created API templates, limiting scalability and freshness.  
This project proposes a **fully automated backend pipeline** that extracts API data from OpenAPI specs, HTML docs, and Markdown, and converts them into structured JSON templates usable by API Dash.

---

### 3. Detailed Description

The solution is a **decoupled Python-based pipeline** that:
### System Architecture

![Pipeline Architecture](images/pipeline_ayus.png)

#### Pipeline Flow:
API Sources → Parser Engine → Metadata Extraction → Tagging Engine → Template Builder → GitHub Actions → API Dash UI

#### Key Components:

- **Parser Engine**
  - Handles OpenAPI, HTML, Markdown
  - Normalizes data into a unified format

- **Metadata Extraction Layer**
  - Extracts endpoints, parameters, auth, schemas

- **Tagging Engine**
  - Rule-based classification (AI, Finance, Weather, etc.)
  - Deterministic and auditable

- **Template Builder**
  - Converts metadata → valid JSON templates
  - Schema validation ensures correctness

- **GitHub Actions Scheduler**
  - Weekly automated pipeline execution
  - Creates PRs with updated templates

---

### 4. Weekly Timeline (12 Weeks)

| Week | Work |
|------|------|
| 1 | Study API Dash codebase, JSON schema |
| 2 | Create 5–10 manual templates (UI validation) |
| 3 | Setup Python project, CI, models |
| 4 | Build OpenAPI parser |
| 5 | Build HTML parser |
| 6 | Build Markdown parser |
| 7 | Metadata extraction system |
| 8 | Tagging engine |
| 9 | Template builder |
| 10 | GitHub Actions automation |
| 11 | Scale to 50+ APIs + documentation |
| 12 | Testing, optimization, final submission |

---

## Additional Notes

- Fully aligned with API Dash architecture (TemplatesService JSON input)  
- No frontend changes required  
- Production-ready, scalable system  
- Designed for long-term extensibility (GraphQL, gRPC, AsyncAPI)

---

## Conclusion

This project directly solves a core scalability issue in API Dash by introducing automation.  
It is practical, well-scoped, and aligned with maintainers’ expectations.

I am confident in delivering this system end-to-end.

---
