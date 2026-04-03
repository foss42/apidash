### Initial Idea Submission

**Full Name**: Balu Kodeboyina  
**University name**: Dhanekula Institute of Engineering & Technology  
**Program you are enrolled in (Degree & Major/Minor)**: BTech Computer Science  
**Year**: 2nd  
**Expected graduation date**: 2028  

**Project Title**: API Explorer Feature for API Dash

**Relevant issues**:
- https://github.com/foss42/apidash/issues/619

**Idea description**:

API Dash allows users to create and test API requests, but users must manually import
collections or OpenAPI files. There is no simple way to browse and explore APIs directly.

This project proposes building an API Explorer feature that allows users to:

- Load OpenAPI / Swagger files
- Browse API endpoints
- Preview request details
- Import selected endpoints into collections
- Quickly test APIs

### Proposed Design

The API Explorer will include:

1. API Loader
   - Load OpenAPI JSON/YAML
   - Validate format

2. Endpoint Viewer
   - Show endpoints list
   - Show method, URL, parameters

3. Import System
   - Select endpoint
   - Convert to RequestModel
   - Add to collection

4. UI Integration
   - New API Explorer screen
   - Search & filter APIs

### Implementation Plan

Phase 1
- Study API Dash codebase
- Understand RequestModel and Collections

Phase 2
- Build OpenAPI parser
- Extract endpoints

Phase 3
- Create API Explorer UI
- Show endpoints list

Phase 4
- Import endpoints into collection
- Testing

Phase 5
- Bug fixing
- Documentation

### Why this project

This feature will make API Dash easier for developers by allowing them to explore APIs
without manually creating requests.
