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

## Objectives Summary (DESCRIPTION)
The primary goal is to extend API Dash with capabilities that go beyond traditional API client functionality. This includes adding streaming and Server-Sent Events (SSE) support, introducing native AI-powered request handling, and refactoring the core networking components into a modular package for better maintainability and reusability.
In addition, we aim to leverage AI to build higher-level features such as an API-to-Flutter UI generator and an API tool generator to simplify integration for agentic AI applications. Together, these objectives position API Dash as a modern, intelligent, and extensible platform for both developers and AI-driven workflows.

## Proposed Objectives

to accomplish this feaure we had to develop core features which are as follows
MAJOR FEATURES: 

briefly describe what project is about

1. Refactor Apidash’s core networking components into a standalone reusable and testable package.
2. Add Streaming & Server-Sent Events (SSE) support to the Apidash client.
3. Integrate native AI request handling into the Apidash client.
4. Develop an AI-powered API-to-Flutter UI generator for seamless UI creation.
5. Build an API tool generator to help agentic AI applications connect with API endpoints.


## Feature Description

### Refactored API Dash's core networking architecture into a standalone package named `better_networking`

`Package Link`: https://pub.dev/packages/better_networking

`Associated Pull Request`: [#857](https://github.com/foss42/apidash/pull/857)

We envisioned `better_networking` to be the go-to package for everything related to networking for a flutter application. It contains very easy to use handlers for making all types of HTTP & GraphQL Requests along with advanced features such as Request cancellation and so on. Initially this was tightly coupled with the apidash codebase under `apidash_core`. I had to decouple it and make platform wide changes to accomodate the new package approach. This also allowed us to write better tests for it and reach 95+% code coverage.

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

![Code Coverage Report](./images/bnetlcov.png)

---

### Added SSE and Streaming Support to the Client
`Associated Pull Request`: [#861](https://github.com/foss42/apidash/pull/861)

![Code Coverage Report](./images/sse_ex1.png)
SSE Support was a long pending [issue](https://github.com/foss42/apidash/issues/116) (since 2024) and hence the mentors asked me to see if i was able to implement SSE support into `better_networking` and simultaneously into `apidash` itself. The implementations suggested by other contributors in the past involved creation of SSE as a completely new request type.
However, I did not agree with this approach as SSE is not a fundamentally separate request type like GraphQL. Hence, I wrote up a quick demo with SSE implemented within the existing apidash foundation code. The mentors were impressed with this approach as it was far more maintainable and sensible than creating new models for it.

Rewrote the original implementation of `sendHttpRequest` in terms of this new SSE handler
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
This way, everything stays unified and we reduce the amount of duplication
 
---

### Added Agents and AI Requests Support

`Associated Pull Request`: [#870](https://github.com/foss42/apidash/pull/870)

With the rapid rise of Generative AI, it became clear that API Dash required a dedicated AI request interface with support for agentic systems. Based on this need, my mentors tasked me with developing a comprehensive AI Requests feature, along with an integrated agent building framework for future agentic integrations within the apidash application

![AI Requests](./images/aireq1.png)
![AI Requests](./images/aireq2.png)

The new AI Requests feature supports key capabilities such as remote model import and selection, multi-provider integration, along with support for streaming responses.

![LLM Provider Selector](./images/modelselector2.png)

The newly created genai package enables users to build their own agents with features like prompt templating and more, making it simple and efficient to create powerful in-app agents.

![Agentic Infrastructure](./images/llmarch.png)

#### Sample Agent Code

```dart
//simple_func_agent.dart

class SimpleFuncGenerator extends APIDashAIAgent {
  @override
  String get agentName => 'SIMPLE_FUNCGEN';

  @override
  String getSystemPrompt() {
    return """You are a function generator.
Given API details (REQDATA) and a programming language (TARGET_LANGUAGE),
create a method named `func` that performs the API call.
Return only the code.
""";
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

```
---

### Created the API Tool Generator
As mentioned in my original GSoC proposal, i wanted to use the newly created agentic architecture provided by `genai` package to build an API Tool Generator. 
The in-app agent takes the API request details and converts it into standard tool call code from multiple providers such as `openai`, `gemini`, `langchain` and so on

![Tool Generation](./images/toolgen.png)

---

### Implemented the API Schema to Flutter UI Generator

The Proof of Concept (PoC) for this was already shown during the initial GSoC period. Once the agentic infrastructure had been developed under `genai` package. All that was left to do was to convert the PoC into production ready code along with handling all the errors. 

![API Response](./images/apischema.png)

we could convert the above API response into a Flutter UI that looks something like this and then export the code. We are free to make any natural language modifications if necessary too.

![Generated Widget](./images/gencomp.png)

This makes use of the Server Driven UI Concept powered by [Stac](https://stac.dev/)

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
|`genai` & AI Requests Feature|[#870](https://github.com/foss42/apidash/pull/870)|[#871](https://github.com/foss42/apidash/issues/871)|Open|Under Review
|AI UI Designer & Tool Generator|[#874](https://github.com/foss42/apidash/pull/874)|[#617](https://github.com/foss42/apidash/issues/617)|Open|Under Review
|Final Report Documentation|[#878](https://github.com/foss42/apidash/pull/878)||Open|Under Review
---


## Challenges Faced

talk about new learnign and overcoming issues

- SDUI Dilemma (cannot use hosted rendering server, cannot use Reflection, cannot bundle flutter sdk), hence had to rely on Server Driven UI using Stac
- Stac has no support for returning errors
- Larger UIs tend to generate too long Stac code which gets clipped and leads to faulty output
- Since we cannot fine tune or use external models (for data safety), we have to rely solely on Good System prompting to get the Stac code right. This is by far the biggest challenge and that is why we have restricted ourselves to a small subset of Stac widgets. We will expand on this in the future


## Future Work
- Expand on the available Stac SDUI Widgets so that more detailed UIs can be generated from API complex responses
- Integration tests for AI Requests Feature and the ToolGen, UIGen Features


## Design and Prototypes Link
- [API Tool Generation Research Document ](https://docs.google.com/document/d/17wjzrJcE-HlSy3i3UdgQUEneCXXEKb-XNNiHSp-ECVg)
- [AI UI Designer prototype](https://github.com/synapsecode/AI_UI_designer_prototype)
- [FlutRun (My custom remote flutter component rendering service)](https://github.com/synapsecode/FlutRun)