# Code Generation

API Dash can generate runnable code for your API requests in over 30 language and library combinations. This lets you quickly integrate any API call into your project.

## How to Generate Code

1. Select a request from your collection and make sure the URL, headers, parameters, and body are configured.
2. Click the **Code** icon (usually `</>`) to open the code generation panel.
3. Select a **language and library** from the dropdown.
4. The generated code appears instantly and updates when you change the request.
5. Click **Copy** to copy the code to your clipboard.

## Supported Languages & Libraries

| Language | Libraries |
|----------|-----------|
| **cURL** | cURL |
| **C** | libcurl |
| **C#** | HttpClient, RestSharp |
| **Dart** | http, dio |
| **Go** | net/http |
| **Java** | AsyncHttpClient, HttpClient, OkHttp, Unirest |
| **JavaScript** | Axios, fetch |
| **Julia** | HTTP |
| **Kotlin** | OkHttp |
| **PHP** | cURL, Guzzle, http_plug |
| **Python** | requests, http.client |
| **Ruby** | Faraday, net/http |
| **Rust** | Actix Client, curl-rust, Hyper, Reqwest, Ureq |
| **Swift** | Alamofire, URLSession |
| **HAR** | HTTP Archive format |

## What Is Included in Generated Code

The generated code reflects your current request configuration:

- **HTTP method** (GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS)
- **URL** with query parameters
- **Headers** (custom and content-type)
- **Request body** (JSON, form data, multipart, plain text)
- **Authentication** headers (when configured)
- **Error handling** and response printing

## Example

For a GET request to `https://api.apidash.dev/users`, selecting **Python (requests)** generates:

```python
import requests

url = 'https://api.apidash.dev/users'

response = requests.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
```

## Running Generated Code

- For quick setup and execution instructions (Python, JavaScript, Java), see [Run Generated Code Guide](https://github.com/foss42/apidash/blob/main/doc/run_generated_code.md).
- For full language-by-language instructions, see [How to Run Generated Code](./instructions_to_run_generated_code.md).

## Generating Code via Dashbot

Dashbot (the AI assistant) can also generate code with explanations:

1. Open Dashbot and choose **"Generate Code"**.
2. Select a language from the buttons (JavaScript, Python, Dart, Go, cURL).
3. Dashbot returns a code block with explanations and setup instructions.

> See the [Dashbot User Guide](./dashbot_user_guide.md) for more details.

## Tips

- The generated code updates live as you modify your request — use it as a quick preview of what your request looks like in code.
- Use environment variables in your request and replace the resolved values in generated code with your own configuration variables.
- Generated code includes all necessary imports and basic error handling for quick copy-paste usage.
