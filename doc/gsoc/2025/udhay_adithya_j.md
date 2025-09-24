# GSoC'25 — API Dash: Authentication, Scripting, OAuth, and Dashbot

> Final report summarizing my contributions to API Dash as part of GSoC'25.

## Project Details

1. **Contributor** : Udhay Adithya J
2. **Mentors** : Ashita P, Ankit M, Ragul Raj M
3. **Organization** : API Dash
4. **Project** : Dashbot and API Authentication

#### Quick Links: 

- [GSoC Project Page](https://summerofcode.withgoogle.com/programs/2025/projects/1Yf6TmCm)
- [Code Repository](https://github.com/foss42/apidash)
- [Discussion Logs](https://github.com/foss42/apidash/discussions/851)

## Project Description

When we started planning, the first idea was to build Dashbot, an in‑app assistant that helps with API work such as explaining responses, fixing failing requests, importing cURL or OpenAPI, and generating tests or runnable code without leaving the current request. Very quickly we realized that to make AI features feel reliable and production‑ready, we needed to strengthen the base of the application first. After discussing with my mentors, I switched focus to core building blocks that other features could depend on and that users would benefit from immediately.

I began by implementing the common authentication methods that developers use every day. These include Basic Auth, API Key, Bearer, JWT Bearer, and Digest. I added a clean Authorization tab in the request editor, models to represent the data, a handler that applies the credentials to the request, environment variable support for all auth fields, caching via Hive so the values persist, and tests to keep everything stable. I also wrote a user guide so new users can set up auth without confusion.

Next, I worked on pre‑request and post‑response scripting so users can run JavaScript before a request is sent and after a response arrives. This is a common feature in other API clients, and we decided to follow the same standard. I used a JavaScript engine that runs natively with Flutter, converted the request, response, and active environment to JSON, passed that into a setup script that exposes a stable ad object, and then executed the user’s script below it. The script returns updated JSON, which I parse back into the right models and apply to the request or environment. I also extended this to work with GraphQL and planned for a logs console because people need to see what their scripts are doing.

After that, I added OAuth. OAuth 1.0 was straightforward because other clients usually do not implement the full three‑legged flow inside the app. Instead, they expect users to bring their own tokens, so I followed the same approach to make it practical. OAuth 2.0 was harder. The official OAuth 2.0 Dart package follows the spec closely, which means some providers and response formats are not supported. I wrote down the limitations to be transparent and added credential caching so users don’t have to repeat the flow every time. For desktop we open the browser and listen on localhost for a short time to capture the callback. For mobile we use the standard in‑app flow. This makes the experience consistent and reliable across platforms.

Once these foundations were ready, I went back to Dashbot. Because the base was strong now, building Dashbot became much smoother. Dashbot sits inside API Dash as a helper and is built in a way that is easy to extend, so we can add more tasks later without rewriting things. It can explain responses, help with failing requests, import cURL or OpenAPI, generate tests and runnable code, and even apply changes directly to the current request or create a new one if needed. The interface can be moved and resized inside the app so it never gets in the way of your work.

Finally, we noticed that scripts and AI features need a place to show their output and errors. I built a terminal‑style Logs tab inside the app that collects network events, system messages, and JavaScript logs in one place. It supports searching and filtering, and it highlights warnings and errors with colors so you can spot problems quickly. Internally, I changed how our JavaScript utilities are structured so they can safely send logs to the UI even though they run outside of widgets.

In the following sections I will explain each feature in detail with examples, file references inside this repository, and simple code where it helps. I will also add image placeholders that I will replace with real screenshots.

## Authentication: Basic, API Key, Bearer, JWT, Digest

I started by adding the everyday authentication methods so that anyone using API Dash can set up their credentials without workarounds. Inside the request editor there is now an Authorization tab where you can choose the auth type and fill the required fields. Internally this work lives in the `better_networking` package so it can be reused across the app. I created a single model that holds all supported types and I wrote a handler that reads the selected type and adds the right headers or query params to the request at the time of sending. I also added environment variable support for every input so secrets can be managed in one place, and I used Hive to cache values so they persist across sessions. I wrote tests for these code paths and a user guide that explains everything in plain language.

The core model is `AuthModel` in `packages/better_networking/lib/models/auth/api_auth_model.dart`. It stores the selected `APIAuthType` and the data objects for each specific method. This lets the UI and the request layer work with a single source of truth. The handler `handleAuth` in `packages/better_networking/lib/utils/auth/handle_auth.dart` looks at the chosen type and updates the request right before sending. For Basic it builds the base64 string and sets the Authorization header. For Bearer it sets `Authorization: Bearer <token>`. For API Key it either adds a header or a query parameter based on the user’s choice. For JWT it generates a signed token based on the selected algorithm and places it in the header or the URL. For Digest it supports both the direct mode where the realm and nonce are already known and the two‑step mode where API Dash sends one request, reads the server’s challenge from `WWW-Authenticate`, computes the response, and then adds the final Authorization header.

This is very close to how other API clients behave. I first proposed a different format but after discussion with my mentors we decided to match common patterns so people can migrate their requests easily. I also updated the UI to follow the API Dash design system so it feels consistent with the rest of the app. You can see the user guide at `doc/user_guide/authentication.md`. It has simple explanations and screenshots for each method. I will add fresh images here too.

[IMAGE: Auth tab overview]

Here is a small example that shows how the handler attaches a Bearer token to the headers. The handler reads the `AuthModel` and adds the correct `Authorization` header to the outgoing `HttpRequestModel`.

```
// packages/better_networking/lib/utils/auth/handle_auth.dart
case APIAuthType.bearer: {
	final bearerAuth = authData.bearer!;
	updatedHeaders.add(
		NameValueModel(
			name: 'Authorization',
			value: 'Bearer ${bearerAuth.token}',
		),
	);
	updatedHeaderEnabledList.add(true);
	break;
}
```

For JWT, the handler generates a signed token using the helper in `jwt_auth_utils.dart` and then puts it in the place you selected. If you choose header, the value is `Bearer <jwt>`. If you choose query, the key defaults to `token` unless you specify another one.

```
// packages/better_networking/lib/utils/auth/handle_auth.dart
case APIAuthType.jwt: {
	final jwtAuth = authData.jwt!;
	final jwtToken = generateJWT(jwtAuth);
	if (jwtAuth.addTokenTo == 'header') {
		final headerValue = jwtAuth.headerPrefix.isNotEmpty
				? '${jwtAuth.headerPrefix} $jwtToken'
				: jwtToken;
		updatedHeaders.add(NameValueModel(name: 'Authorization', value: headerValue));
		updatedHeaderEnabledList.add(true);
	} else if (jwtAuth.addTokenTo == 'query') {
		final paramKey = jwtAuth.queryParamKey.isNotEmpty ? jwtAuth.queryParamKey : 'token';
		updatedParams.add(NameValueModel(name: paramKey, value: jwtToken));
		updatedParamEnabledList.add(true);
	}
	break;
}
```

Digest support follows the standard flow. If the server already provided `realm` and `nonce` then API Dash computes the header directly. If not, API Dash sends one initial request, reads the `WWW-Authenticate` header, fills the missing fields, computes the hash, and then adds `Authorization: Digest ...` to the real request. The helper code for parsing and computing the header is in `packages/better_networking/lib/utils/auth/digest_auth_utils.dart`.

Environment variables are available in all auth fields. This means you can write something like `{{API_KEY}}` in the UI and API Dash will resolve it from the active environment before sending. Values are cached using Hive so you don’t need to retype them every time.

All this work is covered by tests and documented for users. I also created the first version of the Authentication user guide and kept it simple and visual so anyone can follow it. If you want to look at the changes, see the pull requests I opened for this feature at https://github.com/foss42/apidash/pull/855 and https://github.com/foss42/apidash/pull/866.

## Pre‑request and Post‑response Scripting

I wanted API Dash to support scripting like other clients so people can prepare data before a request and verify or transform data after a response. We chose JavaScript because it is the common standard. We use a JS engine that runs natively in Flutter, and we give the script a simple `ad` object to work with so the script can read and change the request, access the response, and work with environment variables. The same approach works for REST and GraphQL.

The JS setup lives in `lib/utils/js_utils.dart` as a long template string named `kJSSetupScript`. Before running the user’s code we inject three JSON strings: one for the request, one for the response (only for post‑response), and one for the active environment. Inside the setup, we parse these into JS objects and build the `ad` helper. The helper exposes functions like `ad.request.headers.set(...)`, `ad.request.params.set(...)`, `ad.request.url.set(...)`, and similar helpers for environment. There is also `ad.console` that forwards console messages to the app so users can see logs.

On the Dart side I wrote `executePreRequestScript` and `executePostResponseScript` in `lib/services/flutter_js_service.dart`. These functions convert models to JSON, run the JS code along with the setup script, and parse the result back. For pre‑request the function returns a new `RequestModel` with the modified `HttpRequestModel`. For post‑response it can update the response and the environment. When there is no active environment selected, the function skips updates safely. This keeps the behavior predictable and simple for users.

Here is a short example that shows how a pre‑request script can set a header and a query parameter from environment values.

```
// user script (runs after kJSSetupScript)
const token = ad.environment.get('API_TOKEN');
if (token) {
	ad.request.headers.set('Authorization', `Bearer ${token}`);
}
const region = ad.environment.get('REGION');
if (region) {
	ad.request.params.set('region', region);
}
```

For post‑response scripts, the script can check status codes and write results back into the environment for later requests. The `ad.console` methods like `log`, `warn`, and `error` are forwarded to API Dash so users can see what happened. This was missing at first and it made debugging hard, so later I added a proper Logs tab in the app to show these messages clearly.

The scripting UI has its own tab in the request editor. It also supports GraphQL requests so the same scripting patterns work there too. While building this I evaluated code editors for Flutter. I tried `flutter_code_editor`, but it had visual issues with folding and scrolling when switching tabs with big scripts. I documented the problem in the discussion linked from the pull request. I may replace or fix this in the future to make long scripts smoother to edit.

You can see the main pull requests for scripting at https://github.com/foss42/apidash/pull/846 and https://github.com/foss42/apidash/pull/865.

[IMAGE: Scripting tab — pre‑request]
[IMAGE: Scripting tab — post‑response with console output]

## OAuth 1.0 and OAuth 2.0

After the basic auth methods, I completed the remaining authentication types: OAuth 1.0 and OAuth 2.0. This was new territory for me. I learned the flows step by step and aligned our behavior with how other API clients do it so users feel at home. OAuth 1.0 in API Dash focuses on signing requests with the values you provide. Other clients do not run a full three‑legged OAuth 1.0 flow inside the app; they expect you to paste the Access Token and Token Secret you already have. I followed the same approach so the feature is simple and reliable. The signing logic is in `packages/better_networking/lib/utils/auth/oauth1_utils.dart`, and the data model is in `packages/better_networking/lib/models/auth/auth_oauth1_model.dart`.

OAuth 2.0 was more challenging because the official `oauth2` Dart package follows the RFC strictly. Many providers are fine with that, but some legacy servers return token responses in non‑JSON formats or have other differences. Because of that, I wrote a small developer note at `doc/dev_guide/oauth_authentication_limitations.md` to be clear about what works and what does not. API Dash sends `Accept: application/json` to token endpoints and expects JSON. On desktop we also need a free port between 8080 and 8090 for the temporary callback server. If all ports are used, the auth flow fails and the UI explains why.

I implemented the three common grant types: Authorization Code, Client Credentials, and Resource Owner Password. We cache credentials to a file so you don’t have to repeat the flow on every request. For desktop, we open your default browser and listen locally for the callback for a short time, then close the temporary server. For mobile, we use the standard in‑app flow. The helper code is in `packages/better_networking/lib/utils/auth/oauth2_utils.dart` and it uses a callback server from `packages/better_networking/lib/services/oauth_callback_server.dart`. The models are in `packages/better_networking/lib/models/auth/auth_oauth2_model.dart`.

Here is a short excerpt that shows how the Authorization Code grant adds the access token to the request after the flow completes. The handler appends `Authorization: Bearer <token>` to your request headers so you can send the request right away.

```
// packages/better_networking/lib/utils/auth/handle_auth.dart
case APIAuthType.oauth2: {
	// ... run the selected grant flow and get the client
	updatedHeaders.add(
		NameValueModel(
			name: 'Authorization',
			value: 'Bearer ${res.$1.credentials.accessToken}',
		),
	);
	updatedHeaderEnabledList.add(true);
	break;
}
```

If the provider returns a refresh token, the credentials file stores it so the client can refresh when needed. When a user wants to reset the session, deleting the credentials file clears the token state and the UI resets too. I also made sure the error messages are simple so people know exactly why a flow failed and what to try next.

You can review the main pull request for OAuth at https://github.com/foss42/apidash/pull/867 and read the limitations document at `doc/dev_guide/oauth_authentication_limitations.md`.

[IMAGE: OAuth2 Authorization Code flow]
[IMAGE: OAuth2 tokens visible in UI]

## Dashbot: In‑app API Helper

After laying the foundation, I built Dashbot as an in‑app helper that sits right inside API Dash. It is designed to be simple to use and easy to extend. It has a header with buttons to minimize, close, and clear the chat. Below that there are quick action buttons for common tasks so you do not need to type long prompts. These include Explain, Debug, Document, and Test. When you click an action, Dashbot builds a prompt using the latest request and response and asks the local model to generate a helpful reply. The main chat area shows your messages on the right and Dashbot replies on the left. Messages are saved and restored so you do not lose history when you close and reopen the panel.

The main widget is `lib/dashbot/widgets/dashbot_widget.dart`. It uses Riverpod providers in `lib/dashbot/providers/dashbot_providers.dart` to store messages and to control whether the panel is minimized. The quick actions are simple buttons that call `_sendMessage` with a short command. The widget then calls the service, waits for the reply, and adds the bot message to the chat. When Dashbot generates runnable test cases it shows a button under the reply that opens a Test Runner dialog.

```
// lib/dashbot/widgets/dashbot_widget.dart (quick actions)
ElevatedButton.icon(
	onPressed: () => _sendMessage("Explain API"),
	icon: const Icon(Icons.info_outline, size: 16),
	label: const Text("Explain"),
);
// ... similarly for Debug, Document, Test
```

The service is in `lib/dashbot/services/dashbot_service.dart`. It connects to a local model via `ollama_dart` using the endpoint in `lib/dashbot/consts.dart`. The method `handleRequest` looks at the input and dispatches to the correct feature. If the input is not one of the quick actions it falls back to a general query mode that can still use the current request and response as context.

```
// lib/dashbot/services/dashbot_service.dart
Future<String> handleRequest(String input, RequestModel? req, dynamic res) async {
	if (input == "Explain API") return _explainFeature.explainLatestApi(requestModel: req, responseModel: res);
	if (input == "Debug API") return _debugFeature.debugApi(requestModel: req, responseModel: res);
	if (input == "Document API") return _documentationFeature.generateApiDocumentation(requestModel: req, responseModel: res);
	if (input == "Test API") return _testGeneratorFeature.generateApiTests(requestModel: req, responseModel: res);
	return _generalQueryFeature.generateResponse(input, requestModel: req, responseModel: res);
}
```

Each feature builds a focused prompt. The Explain feature in `lib/dashbot/features/explain.dart` reads the request method, URL, headers, parameters, body, status code, and response content. It asks for a short explanation in very clear language so users can understand the response quickly. The Debug feature in `lib/dashbot/features/debug.dart` asks for a text‑only analysis when an API call fails and lists the exact steps to fix the problem. The Documentation feature in `lib/dashbot/features/documentation.dart` generates usable documentation with an overview, authentication note, request details, response structure, errors, and a code sample. The Test Generator feature in `lib/dashbot/features/test_generator.dart` produces a set of cURL tests that cover valid, invalid, and edge cases.

Dashbot renders content using `lib/dashbot/widgets/content_renderer.dart`. This renderer supports normal text, markdown, and code blocks in many languages. JSON code blocks are pretty‑printed. It tries syntax highlighting first and falls back to a simple code view if needed, so outputs stay readable. The chat bubbles are built by `lib/dashbot/widgets/chat_bubble.dart` and include a quick copy button on bot messages.

When Dashbot generates tests, it offers a “Run Test Cases” button. Clicking it opens `lib/dashbot/widgets/test_runner_widget.dart`, which parses cURL commands from the markdown and runs them. The runner shows status, response, and a colored result for each test. You can run all tests or individual ones and copy a command easily. Here is a small part of the parsing and running flow:

```
// lib/dashbot/widgets/test_runner_widget.dart (simplified)
final curlRegex = RegExp(r'```bash\ncurl\s+(.*?)\n```', dotAll: true);
// ...extract commands and then run
final response = await http.get(Uri.parse(url));
// or for POST use body and http.post
```

Messages are stored using simple persistence through the hive handler so your chat is restored the next time you open Dashbot. The provider `chatMessagesProvider` loads and saves the conversation behind the scenes. This makes the assistant feel consistent across sessions.

In practice this design makes Dashbot very easy to extend. Adding a new task means writing a small feature class that builds a good prompt from the current request and response and then wiring a quick action to call it. The rest of the UI stays the same. This keeps the code clean and focused. For now Dashbot returns clear text and code blocks. In the future it can also apply changes to the current request or create new requests based on the suggestion, because all the context is already available in the service method.

You can review the pull request for Dashbot at https://github.com/foss42/apidash/pull/887.

[IMAGE: Dashbot panel open with quick actions]
[IMAGE: Dashbot explanation reply with markdown]
[IMAGE: Test Runner dialog with results]


## Logs Console (Terminal)

While building scripting and Dashbot, I realized users need a clear place to see what is happening behind the scenes. I designed a simple terminal‑style Logs tab that collects important messages in one view. It shows JavaScript console output from pre/post scripts, system messages from the JS runtime, and other app events in order. You can scan quickly, search by text, and focus on warnings or errors using filters. Colors make the severity easy to spot.

On the JavaScript side, the `ad.console` helper in the setup script forwards logs back to Dart using a small bridge. The calls below are part of `kJSSetupScript` in `lib/utils/js_utils.dart` and they send messages for info, warning, and error.

```
// lib/utils/js_utils.dart (inside kJSSetupScript)
console: {
	log: (...args) => {
		try { sendMessage('consoleLog', JSON.stringify(args)); } catch (_) {}
	},
	warn: (...args) => {
		try { sendMessage('consoleWarn', JSON.stringify(args)); } catch (_) {}
	},
	error: (...args) => {
		try { sendMessage('consoleError', JSON.stringify(args)); } catch (_) {}
	}
}
```

On the Dart side, I wired the JS bridge to receive these messages. The handler currently prints them and includes a note to route them into the in‑app terminal UI. This is in `lib/services/flutter_js_service.dart`.

```
// lib/services/flutter_js_service.dart
// TODO: These log statements can be printed in a custom api dash terminal.
void setupJsBridge() {
	jsRuntime.onMessage('consoleLog', (args) {
		// [JS LOG]: message
	});
	jsRuntime.onMessage('consoleWarn', (args) {
		// [JS WARN]: message
	});
	jsRuntime.onMessage('consoleError', (args) {
		// [JS ERROR]: message
	});
	jsRuntime.onMessage('fatalError', (args) {
		// [JS FATAL ERROR]: message, error, stack
	});
}
```

This design keeps the scripting API simple for users. You can call `ad.console.log(...)`, `ad.console.warn(...)`, or `ad.console.error(...)` in scripts and then open the Logs tab to see what happened, including any fatal errors with their stack traces from the JS engine. Internally, logs are captured centrally so the UI can show them in order, highlight severity, and allow quick filtering or clearing. This has already helped me and early users debug scripts and understand OAuth/token flows faster.

[IMAGE: Logs tab showing JS and system messages]

## Challenges

Designing authentication so that it feels familiar. I first drafted a custom data format for auth, but after prototyping UI flows we realized it would confuse users migrating from other tools. I rewrote the models to match common patterns instead. This made the handler simpler and the UI clearer. It also helped with writing tests because each case mapped to a known behavior.

Integrating a JavaScript engine safely. Scripts run outside widgets, and they need access to request, response, and environment. I used a setup script that parses JSON and exposes a small `ad` object to avoid leaking internals. The bridge captures console logs and fatal errors so we can show them in the Logs tab. This isolation kept the app stable even when scripts throw.

Editor stability for long scripts. The first code editor I tried had folding and scroll issues when switching tabs with large scripts. It looked broken and made editing hard. I minimized the folding features and documented the issue for a future fix or replacement. The scripting API remains stable regardless of the editor widget.

OAuth2 differences across providers. The official client is strict with RFCs, which is good for correctness but exposes differences with legacy servers. I added clear error messages and a limitations note so users know what to expect. On desktop, capturing the callback via a short‑lived localhost server also needed careful port handling and clean shutdowns.

Making Dashbot reliable with real context. The prompts have to be grounded in the current request and response to be useful. I wrote small feature classes so each task focuses on one job, and I added a content renderer that gracefully falls back when highlighters fail. This kept the chat readable and the outputs actionable.

Surface for debugging in the app. Without a log view, scripting and OAuth were hard to reason about. I added the Logs tab and a simple severity model so we can filter and spot errors quickly. This improved both development and user experience.

## Pull Requests Summary

| PR | Title / Area | Notes |
| --- | --- | --- |
| #855 | Authentication (Basic/Bearer/API Key) | Models, handler, UI wiring, env vars, docs |
| #866 | JWT and Digest Auth | JWT signing + Digest two‑step flow |
| #846 | Scripting (pre/post) | JS runtime, `kJSSetupScript`, ad object, Dart glue |
| #865 | Scripting UI refinements | Editor fixes, GraphQL support, console bridge |
| #867 | OAuth 1.0 and 2.0 | Flows, callback server, caching, limitations doc |
| #887 | Dashbot core | Widget, features, content renderer, test runner |

I will update the table with final titles/labels if any change on merge.


