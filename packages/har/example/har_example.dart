import 'package:har/har.dart';

void main() {
  //Example 1
  var collectionJsonStr = r'''
{
  "log": {
    "version": "1.2",
    "creator": {
      "name": "Client Name",
      "version": "v8.x.x"
    },
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:00:00.000Z",
        "time": 100,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev",
          "headers": [],
          "queryString": [],
          "bodySize": 0
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      },
      {
        "startedDateTime": "2025-03-25T12:01:00.000Z",
        "time": 150,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev/country/data?code=US",
          "headers": [],
          "queryString": [
            {
              "name": "code",
              "value": "US"
            }
          ],
          "bodySize": 0
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      },
      {
        "startedDateTime": "2025-03-25T12:02:00.000Z",
        "time": 200,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
          "headers": [],
          "queryString": [
            { "name": "num", "value": "8700000" },
            { "name": "digits", "value": "3" },
            { "name": "system", "value": "SS" },
            { "name": "add_space", "value": "true" },
            { "name": "trailing_zeros", "value": "true" }
          ],
          "bodySize": 0
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      },
      {
        "startedDateTime": "2025-03-25T12:03:00.000Z",
        "time": 300,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/case/lower",
          "headers": [],
          "queryString": [],
          "bodySize": 50,
          "postData": {
            "mimeType": "application/json",
            "text": "{ \"text\": \"I LOVE Flutter\" }"
          }
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      },
      {
        "startedDateTime": "2025-03-25T12:04:00.000Z",
        "time": 350,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/io/form",
          "headers": [
            {
              "name": "User-Agent",
              "value": "Test Agent"
            }
          ],
          "queryString": [],
          "bodySize": 100,
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              { "name": "text", "value": "API", "contentType":"text/plain" },
              { "name": "sep", "value": "|", "contentType":"text/plain" },
              { "name": "times", "value": "3", "contentType":"text/plain" }
            ]
          }
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      } 
      ,
      {
        "startedDateTime": "2025-03-25T12:05:00.000Z",
        "time": 400,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/io/img",
          "headers": [],
          "queryString": [],
          "bodySize": 150,
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              { "name": "token", "value": "xyz", "contentType":"text/plain" },
              { "name": "imfile", "fileName": "hire AI.jpeg", "contentType":"image/jpeg" }
            ]
          }
        },
        "response": {
          "status": 200,
          "statusText": "OK",
          "headers": [],
          "bodySize": 0
        }
      }
    ]
  }
}
''';

  var collection = harLogFromJsonStr(collectionJsonStr);

  print(collection.log?.creator);
  print(collection.log?.entries?[0].startedDateTime);
  print(collection.log?.entries?[0].request?.url);

  var collectionJson = {
    "log": {
      "version": "1.2",
      "creator": {"name": "Client Name", "version": "v8.x.x"},
      "entries": [
        {
          "startedDateTime": "2025-03-25T12:00:00.000Z",
          "time": 100,
          "request": {
            "method": "GET",
            "url": "https://api.apidash.dev",
            "headers": [],
            "queryString": [],
            "bodySize": 0
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
          }
        },
        {
          "startedDateTime": "2025-03-25T12:01:00.000Z",
          "time": 150,
          "request": {
            "method": "GET",
            "url": "https://api.apidash.dev/country/data?code=US",
            "headers": [],
            "queryString": [
              {"name": "code", "value": "US"}
            ],
            "bodySize": 0
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
          }
        },
        {
          "startedDateTime": "2025-03-25T12:02:00.000Z",
          "time": 200,
          "request": {
            "method": "GET",
            "url":
                "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
            "headers": [],
            "queryString": [
              {"name": "num", "value": "8700000"},
              {"name": "digits", "value": "3"},
              {"name": "system", "value": "SS"},
              {"name": "add_space", "value": "true"},
              {"name": "trailing_zeros", "value": "true"}
            ],
            "bodySize": 0
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
          }
        },
        {
          "startedDateTime": "2025-03-25T12:03:00.000Z",
          "time": 300,
          "request": {
            "method": "POST",
            "url": "https://api.apidash.dev/case/lower",
            "headers": [],
            "queryString": [],
            "bodySize": 50,
            "postData": {
              "mimeType": "application/json",
              "text": "{ \"text\": \"I LOVE Flutter\" }"
            }
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
          }
        },
        {
          "startedDateTime": "2025-03-25T12:04:00.000Z",
          "time": 350,
          "request": {
            "method": "POST",
            "url": "https://api.apidash.dev/io/form",
            "headers": [
              {"name": "User-Agent", "value": "Test Agent"}
            ],
            "queryString": [],
            "bodySize": 100,
            "postData": {
              "mimeType": "multipart/form-data",
              "params": [
                {"name": "text", "value": "API", "contentType": "text/plain"},
                {"name": "sep", "value": "|", "contentType": "text/plain"},
                {"name": "times", "value": "3", "contentType": "text/plain"}
              ]
            }
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
          }
        },
        {
          "startedDateTime": "2025-03-25T12:05:00.000Z",
          "time": 400,
          "request": {
            "method": "POST",
            "url": "https://api.apidash.dev/io/img",
            "headers": [],
            "queryString": [],
            "bodySize": 150,
            "postData": {
              "mimeType": "multipart/form-data",
              "params": [
                {"name": "token", "value": "xyz", "contentType": "text/plain"},
                {
                  "name": "imfile",
                  "fileName": "hire AI.jpeg",
                  "contentType": "image/jpeg"
                }
              ]
            }
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "headers": [],
            "bodySize": 0
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
