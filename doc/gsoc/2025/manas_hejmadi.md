# GSoC'25 - AI-Based API Response to Dynamic UI and Tool Generator

> Final report summarizing my contributions to the project as part of GSoC'25

## Project Details
1. **Contributor** : Manas M Hejmadi
2. **Mentors** : Ashita P, Ankit M, Ragul Raj M
3. **Organization**: API Dash
4. **Project**: AI-Based API Response to Dynamic UI and Tool Generator

#### Quick Links
- [GSoC Project Page](https://summerofcode.withgoogle.com/myprojects/details/hhUUM8wl)
- [Code Repository](https://github.com/foss42/apidash)
- [Discussion Logs](https://github.com/foss42/apidash/discussions/852)

## Project Description

The primary objective of this project was to extend the ApiDash client with new generative AI capabilities that go far beyond the scope of traditional API testing clients. This will position apidash as an OpenSource AI-Native API Testing client.

Our initial vision was to develop an AI-powered agent capable of transforming raw API responses into structured UI schemas and fully functional UI components that could be directly exported and used in frontend applications. Additionally, we wanted to enable dynamic customization of UI components through natural language prompts, allowing developers to customise the design and layout according to their personal preference. This UI code could then be exported and used directly in their Flutter projects. 

As mentioned in the project proposal, we were also aiming to create a one-click `API Request to Tool` generation pipeline, allowing external AI agents to independently interact with APIs. This is a crucial requirement for modern agentic workflows and the idea was that apidash must be ready to serve these needs.

However, during the planning phase it became clear that these ambitious features required strong foundational infrastructure to work at a production level. Under the guidance of my mentors, we identified and implemented several core architectural improvements, such as:

- Refactoring the networking layer into a modular, standalone package to enhance testability and maintainability.
- Adding streaming support via Server-Sent Events (SSE) to enable real-time AI interactions.
- Introducing AI request handling and a dedicated AI primitives package. This ensures that any future apidash feature that would need generative ai, can directly import this primitives package instead of implementing everything again. this saves both time and effort.

All in all, these completion of these improvements will establish apidash as a modern, industry ready platform for developers and AI-driven workflows alike.


## Feature Description

###  `better_networking` package creation & project-wide refactor

`Package Link`: https://pub.dev/packages/better_networking

`Associated Pull Request`: [#857](https://github.com/foss42/apidash/pull/857)

Initially, the entire networking constructs that apidash relied on was fully written inside a module named `apidash_core`. 
The networking code was fairly advanced including support for GraphQL, request cancellations and a lot of other good features. However, as it was tightly coupled with apidash, we were unable to allow the rest of the flutter developer community to use these features. We believe in giving back to the open source community whenever we can and hence the mentors and I decided to refactor everything into a new package. 
During discussions, I came up with the name `better_networking` and we envisioned it to  be the go-to package for everything related to networking for a flutter application.

This is an example of how better_networking simplifies request handling


```dart
final model = HttpRequestModel(
  url: 'https://api.example.com/data',
  method: HTTPVerb.post,
  headers: [
    NameValueModel(name: 'Authorization', value: 'Bearer <token>'),
  ],
  body: '{"key": "value"}',
);

//Sending HTTP Requests
final (resp, duration, err) = await sendHttpRequest(
  'unique-request-id',
  APIType.rest,
  model,
);

// To cancel the request
cancelHttpRequest('unique-request-id');
```

This proved to be a great decision, as we were able to separate it completely, publish it on [pub.dev](https://pub.dev/packages/better_networking), and achieve over 95% code coverage through isolated testing.

Code coverage before refactor:
![Code Coverage Report](./images/codecovold.png)

Code coverage after Refactor:
![Code Coverage Report](./images/bnetlcov.png)

---

### Added SSE and Streaming Support to the Client
`Associated Pull Request`: [#861](https://github.com/foss42/apidash/pull/861)

![Code Coverage Report](./images/sse_ex1.png)

SSE Support was a long pending [issue](https://github.com/foss42/apidash/issues/116) (since 2024). Once I was done with the `better_networking` package creation, the mentors asked me to look into how i can implement SSE within the package and by extension into apidash. After doing some research and a review into the existing PRs by other contributors for this feature, I noticed that everyone created new Request and Response Models for SSE in code. 

However, I did not agree with this approach as SSE is just a different content-type is not a fundamentally separate request type like GraphQL. 
To demonstrate this, I wrote up a quick demo with SSE baked into the existing apidash foundations.

This new mechanism is very simple and elegant. Basically, every request in apidash is executed in streaming mode using `StreamedResponse` in dart. If the response headers specify a content-type marked as streaming, the listener remains active and statefully saves all incoming values into the sseOutput attribute of the response model. If the content-type does not match any supported streaming type, the listener terminates and the output is returned immediately. In this way, the existing request/response model can handle both Streaming and Normal HTTP Requests

This is an example of how I rewrote the original implementation of `sendHttpRequest` in terms of this new SSE handler
```dart
Future<(HttpResponse?, Duration?, String?)> sendHttpRequest(
  String requestId,
  APIType apiType,
  HttpRequestModel requestModel, {
  SupportedUriSchemes defaultUriScheme = kDefaultUriScheme,
  bool noSSL = false,
}) async {
  final stream = await streamHttpRequest(
    requestId,
    apiType,
    requestModel,
    defaultUriScheme: defaultUriScheme,
    noSSL: noSSL,
  );
  final output = await stream.first;
  return (output?.$2, output?.$3, output?.$4);
}
```
The mentors were impressed with this approach as it was far more maintainable and sensible than creating new models specifically for SSE.
This way, everything stays unified and we reduce the amount of duplication
 
---

### Added Agents and AI Requests Support

`Associated Pull Request`: [#870](https://github.com/foss42/apidash/pull/870)

With the rapid rise of Generative AI, it became clear that API Dash required a dedicated AI request interface with support for agentic systems. Based on this need, my mentors tasked me with developing a comprehensive AI Requests feature

The user initiates a new request by selecting “AI”, then chooses a model and provides the required credentials through the Authorization tab. The request can be further configured by specifying system and user prompts and adjusting parameters such as `temperature`, `topP`, and `streaming or non-streaming mode`. Upon submission, the response is generated and presented either as cleaned plaintext/Markdown or in raw format, based on the user’s selection.


![AI Requests](./images/aireq1.png)
![AI Requests](./images/aireq2.png)

My initial implementation used tightly coupled LLM providers (e.g., gemini, openai) with specific models (e.g., gemini-2.0-flash) through hardcoded enums. These enums were directly referenced in code, which on closer review proved unsustainable. Given the rapid pace of innovation in LLMs, models become obsolete quickly, and maintaining hardcoded enums would require frequent code changes and was looking quite impractical.
Furthermore, using hardcoded enums prevents runtime dynamic loading, restricting users to only the models we explicitly provide. This limits flexibility and creates a poor experience, especially for advanced users who may need access to less common or custom models.

To address this, we adopted a remote model fetch system, where model identifiers are stored in a `models.json` file within the public apidash repository. Clients fetch this file at runtime, enabling over-the-air updates to model availability. In addition, we added support for custom model identifiers directly within the ModelSelector, giving users full flexibility to configure their own models.

Currently, we support several standard providers—such as Google Gemini, OpenAI, Anthropic, and Ollama—which offers a strong baseline of options while still allowing advanced customization.

![LLM Provider Selector](./images/modelselector1.png)

The AI Requests feature is built on top of the foundational genai package, which serves as the core layer for all AI-related functionality within apidash.
This package provides the complete set of API callers, methods, and formatters required to abstract away the complexities of interacting with AI tool APIs. By exposing a generalized interface across multiple providers, it eliminates the need to handle provider-specific details directly.
As a result, developers can easily build features that leverage generative AI without worrying about low-level implementation details—leaving the intricacies of API communication and formatting to the genai package.

Example of simplified usage (model-agnostic, works with any LLM out of the box)
```dart
final LLMModel model = LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash');
final ModelController controller = model.provider.modelController;

final payload = controller.inputPayload
  ..systemPrompt = 'Say YES or NO'
  ..userPrompt = 'The sun sets in the west'
  ..credential = 'AIza....';

final genAIRequest = controller.createRequest(model, payload);
final answer = await GenerativeAI.executeGenAIRequest(model, genAIRequest);

print(answer);
```

#### Agentic Infrastructure

![Agentic Infrastructure](./images/llmarch.png)

When developing AI-powered features in any application, the process typically involves steps such as system prompting, data validation, and output formatting. However, repeating this workflow for multiple features while taking care of errors and retry logic quickly becomes very cumbersom. To simplify this, we designed a well-defined architecture for building AI agents directly within code.

The core idea is straightforward: an AI agent in apidash is simply a Dart file containing a class that extends the base class `APIDashAIAgent`, defined as:
```dart
abstract class APIDashAIAgent {
  String get agentName;
  String getSystemPrompt();
  Future<bool> validator(String aiResponse);
  Future<dynamic> outputFormatter(String validatedResponse);
}
```
This base class provides the necessary hooks for implementing an agent. Developers can either rely on the default implementations or override these handlers with custom logic. The result is a fully abstracted, self-contained agent that can be invoked seamlessly from within the application.

These agents operate within an orchestrator and governor framework that manages everything behind the scenes. This design ensures that developers only need to invoke the agent, while background processes handle concerns such as automatic retries, exponential backoff, and error recovery seamlessly. This saves a lot of time and effort and allows developers to spend more time on improving their actual feature implementation.


#### Sample Agent Code

```dart
//simple_func_agent.dart

class SimpleFuncGenerator extends APIDashAIAgent {
  @override
  String get agentName => 'SIMPLE_FUNCGEN';

  @override
  String getSystemPrompt() {
    return """you are a programming language function generator. 
    your only task is to take whatever requirement is provided and convert
    it into a valid function named func in the provided programming language

    LANGUAGE: :LANG:
    REQUIREMENT: :REQUIREMENT:
"""; //suports templating via :<VARIABLE>:
  }

  @override
  Future<bool> validator(String aiResponse) async {
    return aiResponse.contains("func");
  }

  @override
  Future outputFormatter(String validatedResponse) async {
    validatedResponse = validatedResponse
        .replaceAll(RegExp(r'```[a-zA-Z]*\n?'), '')
        .replaceAll('```', '');
    return {
      'FUNC': validatedResponse,
    };
  }
}

//Calling an agent
 final res = await APIDashAgentCaller.instance.call(
    SimpleFuncGenerator(),
    ref: ref,
    input: AgentInputs(variables: {
      'REQUIREMENT': 'take the median of the given array',
      'TARGET_LANGUAGE': 'python3',
    }),
  );

```

---

### Created the API Tool Generator
As proposed in my GSoC proposal, I set out to implement an API Tool Call Generator within the application. It consists of an in-app agent that processes API request details and converts them into standardized tool-call code compatible with providers such as OpenAI, Gemini, LangChain, and others.

This feature is fully built on top of the agentic foundation established by `genai`. Once a user executes an API request and receives a response, they can click “Generate Tool”, which opens a tool generation dialog. Here, the user selects their preferred agent framework along with the target output language (currently Python or Node.js). The client then consolidates all request details, sends them to an LLM, and generates the corresponding function callers. These are subsequently integrated into a predefined, well-researched API Tool template, ensuring reliability and consistency.

![Tool Generation](./images/toolgen.png)

[add generated tool code output]

---

### Implemented the API Schema to Flutter UI Generator

With the foundational infrastructure in place, I was finally ready to implement the original goal of my GSoC project: the AI UI Designer.

The purpose of this feature is straightforward yet powerful—take API responses and automatically transform them into suitable UI components, while also providing the ability to modify the design through natural language instructions. Additionally, the generated UI can be exported as Flutter code, enabling seamless integration into frontend applications.

A Proof of Concept (PoC) for this functionality had already been demonstrated during the initial phase of GSoC. The remaining work involved converting the PoC into production-ready code, addressing error handling, improving stability, and ensuring it could scale as a fully integrated feature within apidash.

This marks a significant milestone, as the AI UI Designer bridges the gap between raw API responses and usable frontend components—removing boilerplate work and streamlining the developer workflow.

![API Response](./images/apischema.png)

With the AI UI Designer, the response returned from the above API can be automatically converted into a Flutter widget. This widget is generated and rendered using the Server-Driven UI (SDUI) approach, powered by the [Stac](https://stac.dev/) package.

[add video recording here]

after some modifications using natural language, we can get it to look like this,
![Generated Widget](./images/gencomp.png)

### Additional Examples of Generated UI Components

[api request details 1]
[image 1]
[exported flutter code]

[api request details 2]
[image 2]

[api request details 3]
[image 3]

[api request details 4]
[image 4]

[api request details 5]
[image 5]

---

## Complete Pull Request Report



| Feature | PR | Issue | Status | Comments |
|---|---|---|---|---|
|Proof of Concept & Proposal Doc|[#755](https://github.com/foss42/apidash/pull/755)||Merged||
|FIX: `<optimized out>` exception|[#780](https://github.com/foss42/apidash/pull/780)|[#782](https://github.com/foss42/apidash/issues/782)|Merged||
|AI Requests Feature Initial Implementation|[#850](https://github.com/foss42/apidash/pull/850)||Closed|multiple modifications suggested|
|AI Requests Feature Fine tuning|[#856](https://github.com/foss42/apidash/pull/856)||Closed|SSE and Separate Networking layer was deemed necessary before this PR|
|`better_networking` Package Creation|[#857](https://github.com/foss42/apidash/pull/857)||Merged|
`genai` package foundations|[#859](https://github.com/foss42/apidash/pull/859)||Closed|Mentor requested for a new PR after making some changes|
|SSE Feature Foundations|[#860](https://github.com/foss42/apidash/pull/860)||Closed|Mentor requested changes and rebase to main branch|
|SSE & Streaming Support|[#861](https://github.com/foss42/apidash/pull/861)|[#116](https://github.com/foss42/apidash/issues/116)|Merged||
|`genai` & AI Requests Feature|[#870](https://github.com/foss42/apidash/pull/870)|[#871](https://github.com/foss42/apidash/issues/871)|Merged||
Foundations: Agents & AI UI Designer + Tool Generation |[#874](https://github.com/foss42/apidash/pull/874)||Closed|Mentor requested to make a new PR that was based on top of main branch code|
|AI UI Designer & Tool Generator|[#880](https://github.com/foss42/apidash/pull/880)|[#617](https://github.com/foss42/apidash/issues/617)|Open|Under Review
|Final Report Documentation|[#878](https://github.com/foss42/apidash/pull/878)||Open|Under Review
---


## Challenges Faced

#### Incomplete Responses after SSE implmentation
After migrating to SSE, apidash was designed to first listen to a stream and return immediately if the content type wasn’t streaming-related. This worked fine until I discovered an edge case with very long responses: the HTTP protocol splits such responses into multiple packets. Because of the initial stream design, only the first packet was returned, resulting in incomplete outputs.
To fix this, I implemented a manual chunking mechanism where all incoming packets are collected until the stream ends, after which they are concatenated into the complete response. This resolved the issue and ensured correctness for long streaming outputs.

#### Component Rendering Dilemma
The core feature of the AI UI Designer is an in-app dynamic component renderer. Implementing this is challenging because Dart does not support full runtime reflection for Flutter widgets. In other words, a Flutter program cannot directly execute or render dynamically generated Flutter code at runtime.
I experimented with the available reflection mechanisms in Dart, but they are limited to the language itself and do not extend to Flutter’s widget tree. As a result, I was only able to render very basic elements such as Text widgets. Anything more complex was practically impossible to achieve with Dart’s restricted reflection capabilities.

Next, I considered using the Dart SDK to build the code into a Flutter Web app and display it to the user through a localhost iframe. However, this would require bundling the Dart SDK with the application, making it significantly heavier. Moreover, it would involve writing platform channel code for macOS, Windows, and other platforms, which would be highly impractical.

Disappointed with these limitations, I devised a new approach: instead of attempting in-app rendering, I generated the Flutter code and sent it to an external service that could immediately build and deploy it as a Flutter web application, which could then be displayed within an iframe. I implemented this as a project called [FlutRun](https://github.com/synapsecode/AI_UI_designer_prototype) and successfully demonstrated it to the mentors.
However, this approach was also rejected, as ApiDash is a privacy-first API client that prohibits sending user requests to any external servers (with the exception of LLM calls). Even routing requests to our own servers is restricted, which made this solution impractical to implement.

Lastly, after some research and discussions with my mentors, I was introduced to the concept of <b>Server-Driven User Interfaces (SDUI)</b>. The core idea is to represent UI as a parseable structure (such as JSON) and then dynamically render it using a rendering pipeline written in Flutter. This approach proved to be both practical and efficient. In fact, I came across the Stac package, which implemented this concept seamlessly, and that ultimately became the solution we adopted.

#### Lack of Error Handling in Stac 
Stac (the JSON-based representation of Flutter UIs) is opinionated and differs slightly from native Flutter code. As a result, when LLMs generate Stac code, they often produce small mistakes.

The challenge is that the Stac framework surfaces these mistakes only as console errors—they don’t bubble up as exceptions to the caller. I attempted to capture them using Flutter’s ErrorZones and similar mechanisms, but without success.

This limitation is significant because I wanted to implement a reset feature: if the LLM generates invalid Stac code, the app should be able to roll back to the last known good state. With the current design, this isn’t feasible. I even reached out to the Stac founders, who confirmed that proper error bubbling is planned but won’t be available anytime soon.

The only real workaround right now would be to fork Stac and patch it manually—something I’m still debating. For the time being, we’ve mitigated the issue by tuning the system prompt and restricting generations to a small, well-understood subset of Stac. This approach has been working decently so far.

#### Stac Code Clipping
When the API response is highly complex, agents may generate a verbose UI specification. This can cause the resulting Stac JSON to become so large that it exceeds the LLM’s output context window, resulting in clipped (incomplete) JSON.
The problem is difficult to detect because Stac lacks proper error handling, so truncated JSON cannot be validated reliably. When this occurs, the system encounters an ugly visual crash.
Unlike plain text, JSON cannot be trivially streamed or concatenated in parts, since partial structures may break schema integrity. At present, this remains an open issue without a clean solution.

#### Limitations of Prompting
Because of the platform’s privacy-first design, we cannot send user response data to external models. As a result, we must rely entirely on system prompts to enable this feature.
Stac code is highly specialized, and while fine-tuning an existing Flutter-focused or JSON-focused model would have been an effective approach, this option is not permitted under our constraints. This creates a significant challenge, since system prompting alone has limited capacity before context loss begins to degrade output quality.
Our temporary solution is to restrict the feature to a smaller subset of Stac. However, a long-term solution will be necessary to overcome these limitations and support the full scope of functionality.

---

## Future Work
- <b>Error Handling in Stac</b>
  Stac’s current error handling is limited, making debugging and reliability difficult. A future step would be to improve structured error messages and fallback behaviors for invalid or incomplete code paths. If upstream support remains insufficient, forking Stac to build robust error recovery (such as auto-corrections, retries, or clearer debug traces) may be necessary.

- <b>Expanding Restricted Stac SDUI Widget Library</b>

  At present, the Stac-driven UI generation supports only a subset of widget types. This restricts the richness of UIs generated from complex API responses. Future work will focus on extending the Stac SDUI widget library to cover advanced layout controls, interactive inputs, and custom components. This expansion will allow the system to handle more nuanced use cases and generate production-grade UIs directly from structured data.

- <b> Integration Tests for AI Features </b>
  Automated testing remains critical to ensure reliability and prevent regressions in AI-driven workflows. Integration tests will be built for tool generation and AI UI Designer

---

## Design and Prototypes Link
- [API Tool Generation Research Document ](https://docs.google.com/document/d/17wjzrJcE-HlSy3i3UdgQUEneCXXEKb-XNNiHSp-ECVg)
- [AI UI Designer prototype](https://github.com/synapsecode/AI_UI_designer_prototype)
- [FlutRun (My custom remote flutter component rendering service)](https://github.com/synapsecode/FlutRun)

---

## Conclusion
Google Summer of Code 2025 with apidash has been a truly amazing experience. My work throughout this project centered on building the core infrastructure that will be the heart of apidash's next-gen features, and I believe I have successfully laid a strong foundation. I look forward to seeing future contributors build upon it and take the project even further.

---