# Add ChatBot for API Assistance

Issue - https://github.com/foss42/apidash/issues/605  
PR - https://github.com/foss42/apidash/pull/608  
Link - https://fossunited.org/hack/fosshack25/p/7e6upj6f19

### What we planned to do:

We aim to implement a **ChatBot feature** in API Dash with the following capabilities:

1. **Explain API**:
    - **Description**: Analyze API responses and provide explanations in natural language.
    - **Features**: Generate clear descriptions of the API, including:
      - Purpose of the API.
      - Key parameters and their roles.
      - Response structure and fields.
    - Useful for **documentation** and **understanding API behavior**.
2. **Debug Requests Based on Status Codes & Error Messages**:
    - **Description**: Provide **structured debugging suggestions** for failed API requests.
    - **Features**:
        - Analyze status codes (e.g., 4xx, 5xx) and error messages.
        - Offer step-by-step guidance to resolve issues.
3. **Generate Test Cases**:
    - **Description**: Automatically generate **test cases** for API endpoints.
    - **Features**: Includes
      - Valid input scenarios.
      - Edge cases (e.g., invalid inputs, boundary values).
      - Expected responses and status codes.
    - Ensure test cases are **ready to use** in testing frameworks
4. **Generate Sample Codes**:
    - **Description**: Generate **ready-to-run code snippets** for various programming languages (e.g., Dart, Python, JavaScript, React, Flutter).
    - **Features:** Includes
      - API integration code.
      - Error handling.
      - UI components for frontend frameworks (e.g: React).
    - Ensure the code is **directly usable** with minimal modifications.

## What we built

### **1. Ollama Model Integration**

- **Dependency**: We integrated the AI chatbot with API Dash using the `ollama_dart: ^0.2.2` package.
- **System Requirements**: To use the Ollama model, the system must have the Ollama application installed locally with a compatible model.
- **Implementation**:
    - The interaction with the Ollama model is handled in `lib/services/ollama_services.dart`.
    - We tested multiple models, including `deepseek:r1:1.5b`, `ollama3.2:3b`, and `llama3.2:1b`.
    - Among these, `ollama3.2:3b` delivered the most accurate responses.
    - **Recommendation**: Use `ollama3.2:3b` or higher models for better accuracy.
    - **Customization**: Developers can switch models by modifying the “`model:''`” parameter in `/apidash/lib/services/ollama_service.dart`.

### **2. Dynamic UI: ChatBot Widget**

- **Design**:
    - A mini widget (`?`) is placed at the bottom right of the response panel.
    - When clicked, it expands into an AI chatbot interface.
- **Features**:
  - **Explain API**: Provides explanations for API functionalities.
  - **Debug API**: Assists in debugging API-related issues.
  - **Test Cases**: Generates test cases for APIs.
  - **Generate Code**: Helps in generating code snippets for API integration.
  - **General Questions**: Users can ask general questions about ApiDash.
- **Markdown Support**:
  - We used the `“package:flutter_markdown/flutter_markdown.dart”`package to format and display responses in a clean, readable manner.
    

### Setup Guide

- Install the updated dependency`ollama_dart: ^0.2.2`
- To use the Ollama model, the system must have the Ollama application installed locally with a compatible model.
- The interaction with the Ollama model is handled in `lib/services/ollama_services.dart`.
- **Recommendation**: Use `ollama3.2:3b` or higher models for better accuracy.
- Developers need to switch models by modifying the “`model:''`” parameter in `/apidash/lib/services/ollama_service.dart` to their local Ollama model to interact.
- There you go now run `flutter run` to use AI Chatbot in ApiDash.


## Issues
1. **Enhance Response Formatting**: Improve the AI to ensure consistent markdown formatting in responses, eliminating plain text outputs.
2. **Optimize Structured Outputs**: Fine-tune the AI to generate more organized and structured responses for better usability and clarity.


## Future Enhancements:
1. Enable users to integrate their local Ollama models seamlessly through the ChatBot interface for enhanced customization.
2. Enable one-click downloading and copying of test codes, ensuring a seamless workflow for developers.
3. Implementing a feature to generate test codes dynamically based on API endpoints and user inputs.
4. A feature to Integrate with complete system architecture
5. Suggesting the best practices from selected type of requests.
