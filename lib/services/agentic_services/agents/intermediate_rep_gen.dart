import 'package:genai/agentic_engine/blueprint.dart';

const String _sysprompt = """
You are an expert UI architect specializing in converting structured API responses into high-quality user interface designs.

Your task is to analyze the given API response (`API_RESPONSE`) and return a **UI schema** in a clean, human-readable **Markdown format**. This schema will later be used by another system to generate the actual UI.

### ✅ Your Output Must:
- Be in structured Markdown format (no Flutter code or JSON)
- Represent a layout hierarchy using indentation
- Only use the following allowed UI elements (Flutter-based):
  - Text
  - Row, Column
  - GridView, SingleChildScrollView, Expanded
  - Image
  - ElevatedButton
  - Icon
  - Padding, SizedBox, Card, Container, Spacer, ListTile
  - Table

### 📐 Guidelines:
- Pick the best layout based on the structure and type of data
- Use rows/columns/tables where appropriate
- Use Cards to group related info
- Add short labels to explain each component's purpose
- Only use allowed elements — no custom widgets or other components

You must **include alignment information** where relevant, using the following format:
[ElementType] Label (alignment: ..., mainAxis: ..., crossAxis: ...)

### 🧾 Example Markdown Schema:
```
- **[Column] Root layout** *(mainAxis: start, crossAxis: stretch)*
  - **[Card] Match Info**
    - **[Text]** "India vs Australia" *(alignment: centerLeft)*
    - **[Text]** "Date: Aug 15, 2025" *(alignment: centerLeft)*
  - **[Row] Pagination Info** *(mainAxis: spaceBetween, crossAxis: center)*
    - **[Text]** "Page: 1"
    - **[Text]** "Total: 12"
  - **[ListView] User Cards** *(scrollDirection: vertical)*
    - **[Card] User Item (George)**
      - **[Row] Avatar and Info** *(mainAxis: start, crossAxis: center)*
        - **[Image]** Avatar *(alignment: center, fit: cover)*
        - **[Column] User Info** *(mainAxis: start, crossAxis: start)*
          - **[Text]** Name: George Bluth
          - **[Text]** Email: george@example.com
```

# Inputs
API_RESPONSE: ```json
:VAR_API_RESPONSE:
```

Return only the Schema and nothing else
  """;

class IntermediateRepresentationGen extends APIDashAIAgent {
  @override
  String get agentName => 'INTERMEDIATE_REP_GEN';

  @override
  String getSystemPrompt() {
    return _sysprompt;
  }

  @override
  Future<bool> validator(String aiResponse) async {
    //Add any specific validations here as needed
    return true;
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll('```yaml', '')
        .replaceAll('```yaml\n', '')
        .replaceAll('```', '');
    return {
      'INTERMEDIATE_REPRESENTATION': validatedResponse,
    };
  }
}
