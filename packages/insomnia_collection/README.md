# insomnia

Seamlessly convert Insomnia Collection Format v4 to Dart.

Helps you bring your APIs stored in Insomnia to Dart and work with them.

Currently, this package is being used by [API Dash](https://github.com/foss42/apidash), a beautiful open-source cross-platform (macOS, Windows, Linux, Android & iOS) API Client built using Flutter which can help you easily create & customize your API requests, visually inspect responses and generate API integration code. A lightweight alternative to postman & insomnia.

## Usage

### Example 1: Insomnia collection JSON string to Insomnia model

```dart
import 'package:insomnia_collection/insomnia_collection.dart';

void main() {
  // Example 1: Insomnia collection JSON string to Insomnia model
  var collectionJsonStr = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
    "resources": [
    {
    "_id":"req_15f4d64ca3084a92a0680e29a958c9da",
    "parentId":"fld_a2e9704c49034e36a05cdb3a233f6ebd",
    "modified":1736112258432,
    "created":1736111908438,
    "url":"https://food-service-backend.onrender.com/api/users/",
    "name":"get-with-params",
    "description":"",
    "method":"GET",
    "body":{},
    "parameters": [
        {"id":"pair_bf0ae4f4280e440a8a591b64fd4ec4f4","name":"user_id","value":"34","description":"","disabled":false}
        ],
        "headers":[{"name":"User-Agent","value":"insomnia/10.3.0"}],
        "authentication":{},
        "metaSortKey":-1736111908438,
        "isPrivate":false,
        "pathParameters":[],
        "settingStoreCookies":true,
        "settingSendCookies":true,
        "settingDisableRenderRequestBody":false,
        "settingEncodeUrl":true,
        "settingRebuildPath":true,
          "settingFollowRedirects": "global",
          "_type":"request"
          },
    {
        "_id":"fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "parentId":"wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified":1736082089076,
        "created":1736082089076,
        "name":"APIDash-APItests",
        "description":"These are test endpoints for API Dash",
        "environment":{},"environmentPropertyOrder":null,
        "metaSortKey":-1736082080559,
        "preRequestScript":"",
        "afterResponseScript":"",
        "authentication":{},
        "_type":"request_group"
    },
    {"_id":"wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
    "parentId":null,
    "modified":1736082089075,
    "created":1736082089075,
    "name":"APIDash-APItests","description":"",
    "scope":"collection","_type":"workspace"},
    {
    "_id":"req_db3c393084f14369bb409afe857e390c",
    "parentId":"fld_a2e9704c49034e36a05cdb3a233f6ebd",
    "modified":1736082089077,
    "created":1736082089077,
    "url":"https://api.apidash.dev/country/codes",
    "name":"test-get",
    "description":"",
    "method":"GET",
    "body":{},
    "parameters":[],
    "headers":[],
    "authentication":{},
    "preRequestScript":"",
    "metaSortKey":-1736082080558,
    "isPrivate":false,
    "afterResponseScript":"",
    "settingStoreCookies":true,
    "settingSendCookies":true,
    "settingDisableRenderRequestBody":false,
    "settingEncodeUrl":true,
    "settingRebuildPath":true,
    "settingFollowRedirects":"global",
    "_type":"request"},
    {"_id":"req_ba718bbacd094e95a30ef3f07baa4e42",
    "parentId":"fld_a2e9704c49034e36a05cdb3a233f6ebd",
    "modified":1736082089078,"created":1736082089078,
    "url":"https://api.apidash.dev/case/lower",
    "name":"test-post",
    "description":"",
    "method":"POST",
    "body":{"mimeType":"application/json","text":"{\n  \"text\": \"Grass is green\"\n}"},
    "parameters":[],
    "headers":[{"name":"Content-Type","value":"application/json"}],
    "authentication":{},
    "preRequestScript":"",
    "metaSortKey":-1736082080557,
    "isPrivate":false,
    "afterResponseScript":"",
    "settingStoreCookies":true,
    "settingSendCookies":true,
    "settingDisableRenderRequestBody":false,
    "settingEncodeUrl":true,
    "settingRebuildPath":true,
    "settingFollowRedirects":"global",
    "_type":"request"},
    {"_id":"req_24cff90fc3c74e71a567f61d3f8e8cc1",
    "parentId":"fld_a2e9704c49034e36a05cdb3a233f6ebd",
    "modified":1736082089078,
    "created":1736082089078,
    "url":"https://reqres.in/api/users/2",
    "name":"test-put",
    "description":"",
    "method":"PUT",
    "body":{"mimeType":"application/json",
    "text":"{\n    \"name\": \"morpheus\",\n    \"job\": \"zion resident\"\n}"},
    "parameters":[],
    "headers":[{"name":"Content-Type","value":"application/json"}],
    "authentication":{},
    "preRequestScript":"",
    "metaSortKey":-1736082080556,
    "isPrivate":false,
    "afterResponseScript":"",
    "settingStoreCookies":true,
    "settingSendCookies":true,
    "settingDisableRenderRequestBody":false,
    "settingEncodeUrl":true,
    "settingRebuildPath":true,
    "settingFollowRedirects":"global",
    "_type":"request"},
    {
        "_id":"env_9d818b2866dffc9831640d91a516ea3986e16bda",
        "parentId":"wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified":1736082095630,"created":1736082095630,
        "name":"Base Environment",
        "data":{},"dataPropertyOrder":null,
        "color":null,
        "isPrivate":false,
        "metaSortKey":1736082095630,
        "environmentType":"kv",
        "_type":"environment"
    },
    {
        "_id":"jar_9d818b2866dffc9831640d91a516ea3986e16bda",
        "parentId":"wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified":1736082095688,
        "created":1736082095688,
        "name":"Default Jar",
        "cookies":[],
        "_type":"cookie_jar"
    }
    ]
}
''';



  var collection;
  try {
    collection = insomniaCollectionFromJsonStr(collectionJsonStr);



    print(collection.exportSource);
    // insomnia.desktop.app:v10.3.0
    print(collection.resources?[3].name);
    // test-get
    print(collection.resources?[3].method);
    // GET
    print(collection.resources?[3].url);
    // https://api.apidash.dev/country/codes
  } catch (e) {
    print(e.toString() + 'error from collection');
  }
}
```

### Example 2: Insomnia collection from JSON

```dart
import 'package:insomnia_collection/insomnia_collection.dart';

void main() {
   // Example 2: Insomnia collection from JSON
  var collectionJson = {
    "_type": "export",
    "__export_format": 4,
    "__export_date": "2025-01-05T13:05:11.752Z",
    "__export_source": "insomnia.desktop.app:v10.3.0",
    "resources": [
      {
        "_id": "req_15f4d64ca3084a92a0680e29a958c9da",
        "parentId": "fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "modified": 1736112258432,
        "created": 1736111908438,
        "url": "https://food-service-backend.onrender.com/api/users/",
        "name": "get-with-params",
        "description": "",
        "method": "GET",
        "body": {},
        "parameters": [
          {
            "id": "pair_bf0ae4f4280e440a8a591b64fd4ec4f4",
            "name": "user_id",
            "value": "34",
            "description": "",
            "disabled": false
          }
        ],
        "headers": [
          {"name": "User-Agent", "value": "insomnia/10.3.0"}
        ],
        "authentication": {},
        "metaSortKey": -1736111908438,
        "isPrivate": false,
        "pathParameters": [],
        "settingStoreCookies": true,
        "settingSendCookies": true,
        "settingDisableRenderRequestBody": false,
        "settingEncodeUrl": true,
        "settingRebuildPath": true,
        "settingFollowRedirects": "global",
        "_type": "request"
      },
      {
        "_id": "fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "parentId": "wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified": 1736082089076,
        "created": 1736082089076,
        "name": "APIDash-APItests",
        "description": "These are test endpoints for API Dash",
        "environment": {},
        "environmentPropertyOrder": null,
        "metaSortKey": -1736082080559,
        "preRequestScript": "",
        "afterResponseScript": "",
        "authentication": {},
        "_type": "request_group"
      },
      {
        "_id": "wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "parentId": null,
        "modified": 1736082089075,
        "created": 1736082089075,
        "name": "APIDash-APItests",
        "description": "",
        "scope": "collection",
        "_type": "workspace"
      },
      {
        "_id": "req_db3c393084f14369bb409afe857e390c",
        "parentId": "fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "modified": 1736082089077,
        "created": 1736082089077,
        "url": "https://api.apidash.dev/country/codes",
        "name": "test-get",
        "description": "",
        "method": "GET",
        "body": {},
        "parameters": [],
        "headers": [],
        "authentication": {},
        "preRequestScript": "",
        "metaSortKey": -1736082080558,
        "isPrivate": false,
        "afterResponseScript": "",
        "settingStoreCookies": true,
        "settingSendCookies": true,
        "settingDisableRenderRequestBody": false,
        "settingEncodeUrl": true,
        "settingRebuildPath": true,
        "settingFollowRedirects": "global",
        "_type": "request"
      },
      {
        "_id": "req_ba718bbacd094e95a30ef3f07baa4e42",
        "parentId": "fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "modified": 1736082089078,
        "created": 1736082089078,
        "url": "https://api.apidash.dev/case/lower",
        "name": "test-post",
        "description": "",
        "method": "POST",
        "body": {
          "mimeType": "application/json",
          "text": "{\n  \"text\": \"Grass is green\"\n}"
        },
        "parameters": [],
        "headers": [
          {"name": "Content-Type", "value": "application/json"}
        ],
        "authentication": {},
        "preRequestScript": "",
        "metaSortKey": -1736082080557,
        "isPrivate": false,
        "afterResponseScript": "",
        "settingStoreCookies": true,
        "settingSendCookies": true,
        "settingDisableRenderRequestBody": false,
        "settingEncodeUrl": true,
        "settingRebuildPath": true,
        "settingFollowRedirects": "global",
        "_type": "request"
      },
      {
        "_id": "req_24cff90fc3c74e71a567f61d3f8e8cc1",
        "parentId": "fld_a2e9704c49034e36a05cdb3a233f6ebd",
        "modified": 1736082089078,
        "created": 1736082089078,
        "url": "https://reqres.in/api/users/2",
        "name": "test-put",
        "description": "",
        "method": "PUT",
        "body": {
          "mimeType": "application/json",
          "text":
              "{\n    \"name\": \"morpheus\",\n    \"job\": \"zion resident\"\n}"
        },
        "parameters": [],
        "headers": [
          {"name": "Content-Type", "value": "application/json"}
        ],
        "authentication": {},
        "preRequestScript": "",
        "metaSortKey": -1736082080556,
        "isPrivate": false,
        "afterResponseScript": "",
        "settingStoreCookies": true,
        "settingSendCookies": true,
        "settingDisableRenderRequestBody": false,
        "settingEncodeUrl": true,
        "settingRebuildPath": true,
        "settingFollowRedirects": "global",
        "_type": "request"
      },
      {
        "_id": "env_9d818b2866dffc9831640d91a516ea3986e16bda",
        "parentId": "wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified": 1736082095630,
        "created": 1736082095630,
        "name": "Base Environment",
        "data": {},
        "dataPropertyOrder": null,
        "color": null,
        "isPrivate": false,
        "metaSortKey": 1736082095630,
        "environmentType": "kv",
        "_type": "environment"
      },
      {
        "_id": "jar_9d818b2866dffc9831640d91a516ea3986e16bda",
        "parentId": "wrk_fde7dcc4f5064b74b0fd749cbf8f684a",
        "modified": 1736082095688,
        "created": 1736082095688,
        "name": "Default Jar",
        "cookies": [],
        "_type": "cookie_jar"
      }
    ]
  };

  var collection2;
  try {
    collection2 = InsomniaCollection.fromJson(collectionJson);
    print(collection2.exportSource);
    // insomnia.desktop.app:v10.3.0
    print(collection2.resources?[3].name);
    // test-get
    print(collection2.resources?[3].method);
    // GET
    print(collection2.resources?[3].url);
    // https://api.apidash.dev/country/codes
  } catch (e) {
    print(e.toString() + 'error from collection2');
  }
}
```

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))
- Papa Kofi (contributor) ([GitHub](https://github.com/StormGear))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/insomnia_collection/LICENSE).
