# GSoC 2025 Proposal: AI UI Designer for APIs

## About

**Full Name**: Ning Wei  
**Contact Info**: Allenwei0503@gmail.com 
**Discord Handle**: @allen_wn  
**GitHub Profile**: [https://github.com/AllenWn](https://github.com/AllenWn)  
**LinkedIn**: [https://www.linkedin.com/in/ning-wei-allen0503](https://www.linkedin.com/in/ning-wei-allen0503)  
**Time Zone**: UTC+8  
**Resume**: https://drive.google.com/file/d/1Zvf1IhKju3rFfnDsBW1WmV40lz0ZMNrD/view?usp=sharing

## University Info

**University**: University of Illinois at Urbana-Champaign  
**Program**: B.S. in Computer Engineering  
**Year**: 2nd year undergraduate  
**Expected Graduation**: May 2027

---

## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?**  
Not yet officially, but I’ve been actively exploring open source projects like API Dash and contributing via discussion and design planning. I am currently studying the API Dash repository and developer guide to prepare for my first PR.

2. **What is your one project/achievement that you are most proud of? Why?**  
I'm proud of building an AI-assisted email management app using Flutter and Go, which automatically categorized and responded to emails using ChatGPT API. It gave me end-to-end experience in integrating APIs, generating dynamic UIs, and designing developer-friendly tools.

3. **What kind of problems or challenges motivate you the most to solve them?**  
I enjoy solving problems that eliminate repetitive work for developers and improve workflow productivity — especially through automation and AI integration.

4. **Will you be working on GSoC full-time?**  
Yes. I will be dedicating full-time to this project during the summer.

5. **Do you mind regularly syncing up with the project mentors?**  
Not at all — I look forward to regular syncs and feedback to align with the project vision.

6. **What interests you the most about API Dash?**  
API Dash is focused on improving the developer experience around APIs, which is something I care deeply about. I love the vision of combining UI tools with AI assistance in a privacy-first, extensible way.

7. **Can you mention some areas where the project can be improved?**  
- More intelligent code generation from API response types  
- Drag-and-drop UI workflow  
- Visual previews and theming customization  
- Integration with modern LLMs for field-level naming and layout suggestions

---

## Project Proposal Information

### Proposal Title

AI UI Designer for APIs

# Relevant Issues: [#617]  

### Abstract

This project proposes the development of an AI-powered UI generation assistant within the API Dash application. The tool will automatically analyze API responses (primarily in JSON format), infer their structure, and dynamically generate Flutter-based UI components such as tables, forms, or cards. Developers will be able to preview, customize, and export these layouts as usable Dart code. By combining rule-based heuristics with optional LLM (e.g., Ollama, GPT) enhancements, the feature aims to streamline API data visualization and speed up frontend prototyping. The generated UI will be clean, modular, and directly reusable in real-world Flutter applications.

---

### Detailed Description

This project introduces a new feature into API Dash: AI UI Designer — an intelligent assistant that takes an API response and converts it into dynamic UI components, allowing developers to quickly visualize, customize, and export frontend code based on live API data. It will analyze the data and suggest corresponding UI layouts using Dart/Flutter widgets such as `DataTable`, `Card`, or `Form`. 

#### Step 1: Parse API Response Structure

The first step is to understand the structure of the API response, which is usually in JSON format. The goal is to transform the raw response into an intermediate schema that can guide UI generation.

- Most API responses are either:
    - Object: A flat or nested key-value map.
    - Array of Objects: A list of items, each following a similar structure.
- Understanding the structure allows us to decide:
    - What kind of UI component fits best (e.g., table, form, card).
    - How many fields to show, and how deep the nesting goes.
- Common field types (string, number, boolean, array, object) impact widget selection.
- Special patterns (e.g., timestamps, emails, URLs) can be detected and used to enhance UI.

##### Implementation Plan：

- Start with JSON
    - Initially only support JSON input, as it's the most common.
    - Use Dart's built-in dart:convert package to parse the response.
- Build a Recursive Schema Parser
    - Traverse the JSON response recursively.
    - For each node (key), determine:
        - Type: string, number, bool, object, array
        - Optional metadata (e.g., nullability, format hints)
        - Depth and parent-child relationships
    - Output a tree-like structure such as:
    ```json
    {
      "type": "object",
      "fields": [
        {"key": "name", "type": "string"},
        {"key": "age", "type": "number"},
        {"key": "profile", "type": "object", "fields": [...]},
        {"key": "posts", "type": "array", "itemType": "object", "fields": [...]}
      ]
    }
    ```

- Detect Patterns (Optional AI Help)
    - Apply heuristics or regex to detect:
        - Timestamps: ISO strings, epoch time
        - Prices: numeric + currency signs
        - Boolean flags: isActive, enabled, etc.
    - This helps in choosing smart widgets (e.g., Switch for booleans).

- Create a Schema Class
    - Implement a Dart class (e.g., ParsedSchema) to store this structure.
    - This class will be passed into the UI generation logic in Step 2.

- Add Support for Validation
    - Check if response is malformed or inconsistent (e.g., arrays with mixed types).
    - If invalid, show fallback UI or error.

- Future Scope
    - Add XML support by using XML parsers.
    - Extend the parser to allow user overrides/custom schema mapping.

#### Step 2: Design AI Agent Logic

This step involves designing the core logic that maps the parsed API response schema to corresponding UI components. The AI agent will follow a hybrid approach: combining rule-based mapping with optional LLM-powered enhancement for smarter UI suggestions.

##### 2.1 Rule-Based Mapping System
To ensure fast and consistent results, we will first implement a simple rule-based system that maps specific JSON structures to Flutter widgets. This allows us to generate a basic layout even in environments where LLMs are not available or desirable.

Example rules:
- If the root is an array of objects → generate a DataTable
- If the object contains mostly key-value pairs → generate a Card or Form
- If fields include timestamps or numeric trends → suggest LineChart
- If keys match common patterns like email, phone, price, etc. → render with appropriate widgets (TextField, Dropdown, Currency formatter)

These mappings will be implemented using Dart classes and can be loaded from a YAML/JSON config file to support extensibility.

##### 2.2 LLM-Powered Enhancements
To go beyond static rules and provide smarter UI suggestions, we will integrate an LLM (e.g., Ollama locally or GPT via API). The LLM will receive the parsed schema and be prompted to:
- Suggest the layout structure (vertical list, tabs, grouped cards, etc.)
- Label fields more intuitively (e.g., product_id → "Product ID")
- Reorder fields based on usage context
- Suggest default values, placeholder text, or icons

Prompt Example:
```json
{
  "task": "Generate UI plan for API response",
  "schema": {
    "type": "object",
    "fields": [
      {"name": "username", "type": "string"},
      {"name": "email", "type": "string"},
      {"name": "created_at", "type": "timestamp"}
    ]
  }
}
```

Expected LLM output:
```json
{
  "layout": "vertical_card",
  "fields": [
    {"label": "Username", "widget": "TextField"},
    {"label": "Email", "widget": "TextField"},
    {"label": "Signup Date", "widget": "DateDisplay"}
  ]
}
```

##### 2.3 Fallback and Configuration
- If LLM call fails or is disabled (e.g., offline use), the system falls back to rule-based logic.
- The user can toggle LLM mode in settings.
- The response from LLM will be cached for repeat inputs to reduce latency and cost.

##### 2.4 Customization Layer (Optional)
After layout generation, users will be able to:
- Preview different layout suggestions (from rule-based vs. LLM)
- Select a layout and make field-level changes (hide/show, rename, rearrange)
- Submit feedback for improving future suggestions (optional)

#### Step 3: Generate and Render UI in Flutter

Once the layout plan is decided (via rule-based mapping or LLM suggestion), the system will dynamically generate corresponding Flutter widgets based on the API response structure and content types.

##### 3.1 Widget Mapping and Construction

- For each field or group in the parsed schema, we map it to a predefined Flutter widget. Example mappings:
    - List of Objects → DataTable
    - Simple key-value object → Card, Column with Text widgets
    - String fields → TextField (if editable), or SelectableText
    - Number series over time → Line chart (e.g., using fl_chart package)
- The widget structure will be built using standard Dart code with StatefulWidget or StatelessWidget, depending on interactivity.
- 
Implementation Plan:

- Create a WidgetFactory class that receives a layout plan and schema, and returns a Widget tree.
- This factory will follow a clean design pattern to make it testable and modular.
- Use Flutter’s json_serializable or custom classes to deserialize API responses into displayable values.

##### 3.2 Dynamic Rendering in the App

- The generated widget tree will be rendered in a dedicated “AI UI Preview” pane inside API Dash.
- The rendering will be fully dynamic: when the schema or layout changes, the UI preview updates in real time.
- This pane will support:
    - Light customization like toggling fields, reordering, hiding/showing
    - Live data preview using the actual API response

Technical Flow:

- When user clicks "AI UI Designer", a modal or new route opens with the UI preview panel.
- This panel will:
    - Show the raw schema & layout (editable if needed)
    - Render the widget tree using Flutter's widget system
- Any user adjustments will re-trigger the widget regeneration and re-render.

##### 3.3 Preview and Debugging Tools

- Add a “Developer Mode” that shows:
    - Schema tree
    - Widget mapping details
    - Generated Dart code (read-only)
- This helps with debugging and refining layout logic.

##### 3.4 Scalability Considerations

- To keep UI rendering responsive:
    - Use lazy-loading for large JSON arrays (e.g., scrollable tables)
    - Avoid deep nesting: limit UI depth or use ExpansionTile for hierarchical views
    - Support pagination if list is too long

By the end of this step, users should be able to preview their API response as a fully functional, dynamic UI inside API Dash — without writing a single line of Flutter code.

#### Step 4: Export UI Code

Once the user is satisfied with the generated and customized UI layout, the tool should allow them to export the UI as usable Flutter code, so it can be directly reused in their own projects. This step focuses on transforming the dynamic widget tree into clean, readable Dart code and offering convenient export options.

##### 4.1 Code Generation Pipeline

To generate Flutter code dynamically, we will:
- Traverse the internal widget tree (from Step 3)
- For each widget, generate corresponding Dart code using string templates
    - Example: a DataTable widget will generate its DataTable constructor and children rows
    - Use indentation and formatting to ensure readability

Implementation Plan:
- Create a CodeGenerator class responsible for converting widget definitions into raw Dart code strings.
- Use prebuilt templates for common components: Card, Column, DataTable, etc.
- Handle nested widgets recursively to maintain structure.

##### 4.2 Export Formats

We will support two export options:
1.Raw Dart Code Export
- Output the generated Dart code into a text area or preview pane
- Allow users to:
    - Copy to clipboard
    - Download as .dart file
- Highlight syntax for better UX (using a package like highlight)

2.Optional JSON Layout Export
- If we implement a config-driven rendering architecture, offer an export of the layout plan/schema as JSON
- Useful for re-importing or using with a visual UI builder

##### 4.3 Integration into API Dash

- Add an "Export" button below the UI preview pane
- When clicked, the generated code will be shown in a modal or new tab
- Provide one-click buttons:
    - "Copy Code"
    - "Download Dart File"
    - (Optional) "Download Layout JSON"

##### 4.4 Reusability and Developer Focus

- Ensure that the exported code:
    - Is clean and idiomatic Dart    
    - Can be copied directly into any Flutter project with minimal edits
    - Includes basic import statements and class wrappers if needed
- Add helpful comments in the generated code (e.g., // This widget was generated from API response)

##### 4.5 Challenges and Considerations

- Ensuring valid syntax across nested widgets
- Handling edge cases (e.g., empty fields, null values)
- Optionally, offer theming/styling presets to match user preferences

By the end of this step, users can instantly turn live API data into production-ready Flutter UI code, significantly reducing time spent on repetitive frontend scaffolding.

#### Step 5: Integrate into API Dash

The final step is to fully integrate the AI UI Designer into the API Dash application, so that users can seamlessly trigger UI generation from real API responses and interact with the entire pipeline — from data to UI preview to export — within the app.

##### 5.1 Entry Point in UI

We will add a new button or menu entry labeled “AI UI Designer” within the API response tab (or near the response preview area).

- When a user executes an API call and gets a JSON response:
    - A floating action button or contextual menu becomes available
    - Clicking it opens the AI UI Designer pane

Implementation Plan:
- Extend the existing response panel UI to include a trigger button
- Use a showModalBottomSheet() or a full-screen route to launch the designer

##### 5.2 Internal Architecture and Flow

The full integration involves multiple coordinated modules:
- Trigger UI → (Button click)
- JSON Parser Module (from Step 1) → Convert API response to schema
- Mapping Logic (Step 2) → Rule-based and/or LLM-assisted UI mapping
- Widget Tree Builder (Step 3) → Build live widget layout
- Preview + Export UI (Step 4) → Let users customize and extract code

Each module will be built as a reusable Dart service/class, and all UI logic stays within the API Dash UI tree.

We’ll keep the architecture modular so the designer logic is isolated and testable.

##### 5.3 Offline / Privacy-Friendly Support

Since API Dash is a privacy-first local client, the AI agent should work entirely offline by default using lightweight LLMs such as Ollama, which can run locally.

- If a user prefers using OpenAI or Anthropic APIs, provide optional settings to configure remote endpoints
- Set Ollama as the default backend, and wrap LLM logic inside a service with interchangeable backends

##### 5.4 User Flow Example

- User sends API request in API Dash
- JSON response is shown
- User clicks “AI UI Designer” button
- The parsed structure is shown with layout suggestions
- User can preview UI, rearrange components, and customize styles
- Once satisfied, user clicks “Export”
- Dart code is generated and available to copy/download

##### 5.5 Tests, Documentation & Maintenance

- Add integration tests to validate:
    - Triggering and rendering behavior
    - Correct widget tree output
    - Export function accuracy
- Document:
    - Each module (parsing, mapping, UI rendering, export)
    - Developer usage guide (in docs/)
- Ensure all new code follows API Dash’s contribution style and linting rules

By integrating into API Dash cleanly and modularly, this feature becomes a native part of the developer workflow — helping users transform any API into usable UI in seconds, without leaving the app.

---

## Weekly Timeline (Tentative)

| Week          | Milestone                                                                                  |
|---------------|---------------------------------------------------------------------------------------------|
| Community Bonding | Join Discord, introduce myself, understand API Dash architecture, finalize scope with mentors |
| Week 1         | Build recursive parser for JSON responses; test on static examples; output schema trees   |
| Week 2         | Extend parser to handle nested objects, arrays, and basic pattern recognition (e.g., timestamps) |
| Week 3         | Implement rule-based schema-to-widget mapper; define mapping logic for tables, cards, forms |
| Week 4         | Design widget data model and logic for translating schema into Flutter widget trees        |
| Week 5         | Develop dynamic Flutter widget generator; render `DataTable`, `Card`, `TextField`, etc.   |
| Week 6         | Build basic UI preview pane inside API Dash with user interaction support (e.g., toggles)  |
| Week 7 (Midterm Evaluation) | Submit code with parser + rule-based mapping + preview UI; receive mentor feedback |
| Week 8         | Add layout customization features: visibility toggles, reordering, field labels            |
| Week 9         | Integrate basic Ollama-based LLM agent for field naming & layout suggestion                |
| Week 10        | Abstract LLM backend to support GPT/Anthropic alternatives via API config                  |
| Week 11        | Implement code export: generate Dart source code, copy-to-clipboard & download options     |
| Week 12        | Optional: add JSON config export; polish UX and improve error handling                     |
| Week 13        | Write documentation, developer setup guide, internal tests for each module                 |
| Week 14 (Final Evaluation) | Final review, cleanup, feedback response, and submission                       |

Thanks again for your time and guidance. I’ve already started studying the API Dash codebase and developer guide, and I’d love your feedback on this plan — does it align with your vision?  
If selected, I’m excited to implement this project. If this idea is already taken, I’m open to switching to another API Dash project that fits my background.
