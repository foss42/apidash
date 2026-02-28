# postman

Seamlessly convert Postman Collection Format v2.1 to Dart and vice versa.

Helps you bring your APIs stored in Postman to Dart and work with them.

Currently, this package is being used by [API Dash](https://github.com/foss42/apidash), a beautiful open-source cross-platform (macOS, Windows, Linux, Android & iOS) API Client built using Flutter which can help you easily create & customize your API requests, visually inspect responses and generate API integration code. A lightweight alternative to postman & insomnia.

## Usage

### Example 1: Postman collection JSON string to Postman model

```dart
import 'package:postman/postman.dart';

void main() {
  var collectionJsonStr = r'''
{
  "info": {
    "_postman_id": "a31e8a59-aa12-48c5-96a3-133822d7247e",
    "name": "API Dash",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    "_exporter_id": "26763819"
  },
  "item": [
    {
      "name": "GET Requests",
      "item": [
        {
          "name": "Simple GET",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "https://api.apidash.dev",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ]
            }
          },
          "response": []
        },
        {
          "name": "Country Data",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "https://api.apidash.dev/country/data?code=US",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ],
              "path": [
                "country",
                "data"
              ],
              "query": [
                {
                  "key": "code",
                  "value": "US"
                }
              ]
            }
          },
          "response": []
        }
      ]
    },
    {
      "name": "POST Requests",
      "item": [
        {
          "name": "Case Lower",
          "request": {
            "method": "POST",
            "header": [],
            "body": {
              "mode": "raw",
              "raw": "{\n\"text\": \"I LOVE Flutter\"\n}",
              "options": {
                "raw": {
                  "language": "json"
                }
              }
            },
            "url": {
              "raw": "https://api.apidash.dev/case/lower",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ],
              "path": [
                "case",
                "lower"
              ]
            }
          },
          "response": []
        }
      ]
    }
  ]
}
''';

  var collection = postmanCollectionFromJsonStr(collectionJsonStr);

  print(collection.info?.name);
  // API Dash
  print(collection.item?[0].name);
  // GET Requests
  print(collection.item?[0].item?[0].request?.url?.protocol);
  // https
  print(collection.item?[0].item?[0].request?.url?.raw);
  // https://api.apidash.dev
}
```

### Example 2: Postman collection from JSON

```dart
import 'package:postman/postman.dart';

void main() {
  var collectionJson = {
    "info": {
      "_postman_id": "a31e8a59-aa12-48c5-96a3-133822d7247e",
      "name": "API Dash",
      "schema":
          "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
      "_exporter_id": "26763819"
    },
    "item": [
      {
        "name": "GET Requests",
        "item": [
          {
            "name": "Simple GET",
            "request": {
              "method": "GET",
              "header": [],
              "url": {
                "raw": "https://api.apidash.dev",
                "protocol": "https",
                "host": ["api", "apidash", "dev"]
              }
            },
            "response": []
          },
          {
            "name": "Country Data",
            "request": {
              "method": "GET",
              "header": [],
              "url": {
                "raw": "https://api.apidash.dev/country/data?code=US",
                "protocol": "https",
                "host": ["api", "apidash", "dev"],
                "path": ["country", "data"],
                "query": [
                  {"key": "code", "value": "US"}
                ]
              }
            },
            "response": []
          }
        ]
      },
      {
        "name": "POST Requests",
        "item": [
          {
            "name": "Case Lower",
            "request": {
              "method": "POST",
              "header": [],
              "body": {
                "mode": "raw",
                "raw": "{\n\"text\": \"I LOVE Flutter\"\n}",
                "options": {
                  "raw": {"language": "json"}
                }
              },
              "url": {
                "raw": "https://api.apidash.dev/case/lower",
                "protocol": "https",
                "host": ["api", "apidash", "dev"],
                "path": ["case", "lower"]
              }
            },
            "response": []
          }
        ]
      }
    ]
  };

  var collection = PostmanCollection.fromJson(collectionJson);

  print(collection.info?.name);
  // API Dash
  print(collection.item?[0].name);
  // GET Requests
  print(collection.item?[0].item?[0].request?.url?.protocol);
  // https
  print(collection.item?[0].item?[0].request?.url?.raw);
  // https://api.apidash.dev
}
```

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/postman/LICENSE).
