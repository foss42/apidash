import 'package:postman/postman.dart';

void main() {
  // Example 1: Postman collection JSON string to Postman model
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

  // Example 2: Postman collection from JSON
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

  var collection2 = PostmanCollection.fromJson(collectionJson);

  print(collection2.info?.name);
  // API Dash
  print(collection2.item?[0].name);
  // GET Requests
  print(collection2.item?[0].item?[0].request?.url?.protocol);
  // https
  print(collection2.item?[0].item?[0].request?.url?.raw);
  // https://api.apidash.dev
}
