var collectionApiDashJsonStr = r'''
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
        },
        {
          "name": "Humanize Rank",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ],
              "path": [
                "humanize",
                "social"
              ],
              "query": [
                {
                  "key": "num",
                  "value": "8700000"
                },
                {
                  "key": "digits",
                  "value": "3"
                },
                {
                  "key": "system",
                  "value": "SS"
                },
                {
                  "key": "add_space",
                  "value": "true"
                },
                {
                  "key": "trailing_zeros",
                  "value": "true"
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
        },
        {
          "name": "Form Example",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "User-Agent",
                "value": "Test Agent",
                "type": "text"
              }
            ],
            "body": {
              "mode": "formdata",
              "formdata": [
                {
                  "key": "text",
                  "value": "API",
                  "type": "text"
                },
                {
                  "key": "sep",
                  "value": "|",
                  "type": "text"
                },
                {
                  "key": "times",
                  "value": "3",
                  "type": "text"
                }
              ]
            },
            "url": {
              "raw": "https://api.apidash.dev/io/form",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ],
              "path": [
                "io",
                "form"
              ]
            }
          },
          "response": []
        },
        {
          "name": "Form with File",
          "request": {
            "method": "POST",
            "header": [],
            "body": {
              "mode": "formdata",
              "formdata": [
                {
                  "key": "token",
                  "value": "xyz",
                  "type": "text"
                },
                {
                  "key": "imfile",
                  "type": "file",
                  "src": "/Users/ashitaprasad/Downloads/hire AI.jpeg"
                }
              ]
            },
            "url": {
              "raw": "https://api.apidash.dev/io/img",
              "protocol": "https",
              "host": [
                "api",
                "apidash",
                "dev"
              ],
              "path": [
                "io",
                "img"
              ]
            }
          },
          "response": []
        }
      ]
    }
  ]
}''';

var collectionApiDashJson = {
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
        },
        {
          "name": "Humanize Rank",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw":
                  "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
              "protocol": "https",
              "host": ["api", "apidash", "dev"],
              "path": ["humanize", "social"],
              "query": [
                {"key": "num", "value": "8700000"},
                {"key": "digits", "value": "3"},
                {"key": "system", "value": "SS"},
                {"key": "add_space", "value": "true"},
                {"key": "trailing_zeros", "value": "true"}
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
        },
        {
          "name": "Form Example",
          "request": {
            "method": "POST",
            "header": [
              {"key": "User-Agent", "value": "Test Agent", "type": "text"}
            ],
            "body": {
              "mode": "formdata",
              "formdata": [
                {"key": "text", "value": "API", "type": "text"},
                {"key": "sep", "value": "|", "type": "text"},
                {"key": "times", "value": "3", "type": "text"}
              ]
            },
            "url": {
              "raw": "https://api.apidash.dev/io/form",
              "protocol": "https",
              "host": ["api", "apidash", "dev"],
              "path": ["io", "form"]
            }
          },
          "response": []
        },
        {
          "name": "Form with File",
          "request": {
            "method": "POST",
            "header": [],
            "body": {
              "mode": "formdata",
              "formdata": [
                {"key": "token", "value": "xyz", "type": "text"},
                {
                  "key": "imfile",
                  "type": "file",
                  "src": "/Users/ashitaprasad/Downloads/hire AI.jpeg"
                }
              ]
            },
            "url": {
              "raw": "https://api.apidash.dev/io/img",
              "protocol": "https",
              "host": ["api", "apidash", "dev"],
              "path": ["io", "img"]
            }
          },
          "response": []
        }
      ]
    }
  ]
};
