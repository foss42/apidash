# better_networking

`better_networking` is a lightweight and extensible Dart package designed to simplify HTTP requests and streaming operations. It provides enhanced request modeling, consistent response handling, and built-in utility functions to streamline interactions with both REST and GraphQL APIs. Whether you're handling HTTP requests or streaming data (e.g., Server-Sent Events), this package makes the process more testable and developer-friendly.

---

## 🔧 Features

- **Unified request modeling** via `HttpRequestModel`
- **Consistent response handling** with `HttpResponseModel`
- **Streamed response support** (e.g., SSE)
- **Client management** with cancellation and lifecycle control
- **Built-in utilities** for parsing headers and content types
- **Support for both REST and GraphQL APIs**

---

## 📦 Installation

To install the `better_networking` package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  better_networking: ^<latest-version>
```

Then run the following command in your terminal to fetch the package:

```bash
flutter pub get
```

---

## 🚀 Quick Start

Here’s a basic example to get you started with the package:

```dart
final model = HttpRequestModel(
  url: 'https://api.example.com/data',
  method: HTTPVerb.post,
  headers: [
    NameValueModel(name: 'Authorization', value: 'Bearer <token>'),
  ],
  body: '{"key": "value"}',
);

final (resp, duration, err) = await sendHttpRequest(
  'unique-request-id',
  APIType.rest,
  model,
);

// To cancel the request
cancelHttpRequest('unique-request-id');
```

---

## 🧩 API Overview

### 📥 `HttpRequestModel`

The `HttpRequestModel` defines the structure for outgoing HTTP requests, including headers, body content, parameters, and more.

#### Constructor:

```dart
const factory HttpRequestModel({
  @Default(HTTPVerb.get) HTTPVerb method,
  @Default("") String url,
  List<NameValueModel>? headers,
  List<NameValueModel>? params,
  List<bool>? isHeaderEnabledList,
  List<bool>? isParamEnabledList,
  @Default(ContentType.json) ContentType bodyContentType,
  String? body,
  String? query,
  List<FormDataModel>? formData,
});
```

#### Fields:

- **`method`**: The HTTP verb to use (e.g., GET, POST, PUT).
- **`url`**: The target URL for the request.
- **`headers`**: A list of header key-value pairs.
- **`params`**: URL parameters as key-value pairs.
- **`isHeaderEnabledList`**: Toggles for enabling/disabling individual headers.
- **`isParamEnabledList`**: Toggles for enabling/disabling individual parameters.
- **`bodyContentType`**: The MIME type for the request body (e.g., `json`, `form`).
- **`body`**: The raw body of the request (usually a JSON or string).
- **`query`**: A custom query string to be appended to the URL.
- **`formData`**: Multipart form data (for file uploads, etc.).

---

### 🔁 Request Sending Examples

#### ➤ Standard REST HTTP Request

This example demonstrates a simple GET request to fetch data from a REST API:

```dart
const model = HttpRequestModel(
  url: 'https://jsonplaceholder.typicode.com/posts/1',
  method: HTTPVerb.get,
  headers: [
    NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
    NameValueModel(name: 'Accept', value: 'application/json'),
  ],
);

final (resp, dur, err) = await sendHttpRequest(
  'get_test',
  APIType.rest,
  model,
);

final output = jsonDecode(resp?.body ?? '{}');
print(output);
```

#### ➤ Standard GraphQL HTTP Request

This example demonstrates a GraphQL query:

```dart
const model = HttpRequestModel(
  url: 'https://countries.trevorblades.com/',
  query: kGQLquery,  // Your GraphQL query string
);

final (resp, dur, err) = await sendHttpRequest(
  'gql_test',
  APIType.graphql,
  model,
);

final output = jsonDecode(resp?.body ?? '{}');
print(output);
```

#### ➤ Streamed HTTP Request (e.g., SSE)

If you're dealing with server-sent events (SSE) or other streaming data, use the `streamHttpRequest` method:

```dart
const model = HttpRequestModel(
  url: 'https://sse.dev/test',
  method: HTTPVerb.get,
);

final stream = await streamHttpRequest('sse_test', APIType.rest, model);

stream.listen((data) {
  if (data != null) {
    final HttpResponse? resp = data.$2;
    final Duration? dur = data.$3;
    final String? err = data.$4;

    // Handle the response here
  }
});
```

## 🤝 Contributing

We welcome contributions to the `better_networking` package! If you'd like to contribute, please fork the repository and submit a pull request. For major changes or new features, it's a good idea to open an issue first to discuss your ideas.

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))
- Manas Hejmadi (contributor) ([GitHub](https://github.com/synapsecode))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/better_networking/LICENSE).
