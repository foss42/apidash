# insomnia

Seamlessly convert Har Collection Format to Dart.

Helps you bring your APIs stored in Har to Dart and work with them.

Currently, this package is being used by [API Dash](https://github.com/foss42/apidash), a beautiful open-source cross-platform (macOS, Windows, Linux, Android & iOS) API Client built using Flutter which can help you easily create & customize your API requests, visually inspect responses and generate API integration code. A lightweight alternative to postman.

## Usage

### Example 1: Har collection JSON string to Har model

```dart
import 'package:har_parser/har_parser.dart';

void main() {
  // Example 1: Har collection JSON string to Har model
  var collectionJsonStr = r'''
{
"log": {
      "version": "1.2",
      "creator": {"name": "Sample HAR Creator", "version": "1.0"},
      "entries": [
        {
          "startedDateTime": "2024-02-23T08:00:00.000Z",
          "time": 50,
          "request": {
            "method": "GET",
            "url": "https://api.example.com/users",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {},
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 100, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:05:00.000Z",
          "time": 70,
          "request": {
            "method": "POST",
            "url": "https://api.example.com/login",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {
              "mimeType": "application/json",
              "text": "{\"username\":\"user\",\"password\":\"pass\"}"
            },
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 50, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:10:00.000Z",
          "time": 60,
          "request": {
            "method": "GET",
            "url": "https://api.example.com/products",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {},
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 200, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:15:00.000Z",
          "time": 80,
          "request": {
            "method": "PUT",
            "url": "https://api.example.com/products/123",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {
              "mimeType": "application/json",
              "text": "{\"name\":\"New Product\",\"price\":50}"
            },
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 50, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        }
      ]
    }
  }''';

  var collection = harLogFromJsonStr(collectionJsonStr);

  print(collection.log?.creator);
  print(collection.log?.entries?[0].startedDateTime);
  print(collection.log?.entries?[0].request?.url);
}
```

### Example 2: Har collection from JSON

```dart
import 'package:har_parser/har_parser.dart';

void main() {
   // Example 2: Har collection from JSON
var collectionJson = {
    "log": {
      "version": "1.2",
      "creator": {"name": "Sample HAR Creator", "version": "1.0"},
      "entries": [
        {
          "startedDateTime": "2024-02-23T08:00:00.000Z",
          "time": 50,
          "request": {
            "method": "GET",
            "url": "https://api.example.com/users",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {},
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 100, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:05:00.000Z",
          "time": 70,
          "request": {
            "method": "POST",
            "url": "https://api.example.com/login",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {
              "mimeType": "application/json",
              "text": "{\"username\":\"user\",\"password\":\"pass\"}"
            },
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 50, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:10:00.000Z",
          "time": 60,
          "request": {
            "method": "GET",
            "url": "https://api.example.com/products",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {},
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 200, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        },
        {
          "startedDateTime": "2024-02-23T08:15:00.000Z",
          "time": 80,
          "request": {
            "method": "PUT",
            "url": "https://api.example.com/products/123",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "queryString": [],
            "postData": {
              "mimeType": "application/json",
              "text": "{\"name\":\"New Product\",\"price\":50}"
            },
            "headersSize": -1,
            "bodySize": -1
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "cookies": [],
            "headers": [],
            "content": {"size": 50, "mimeType": "application/json"},
            "redirectURL": "",
            "headersSize": -1,
            "bodySize": -1
          }
        }
      ]
    }
  };

  var collection1 = HarLog.fromJson(collectionJson);
  print(collection1.log?.creator?.name);
  print(collection1.log?.entries?[0].startedDateTime);
  print(collection1.log?.entries?[0].request?.url);

}
```

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))
- Mohammed Ayaan (contributor) ([GitHub](https://github.com/ayaan-md-blr))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/har_parser/LICENSE).
