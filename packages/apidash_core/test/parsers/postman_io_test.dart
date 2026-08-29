import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('PostmanIO Tests', () {
    late PostmanIO postmanIO;

    setUp(() {
      postmanIO = PostmanIO();
    });

    group('getHttpRequestModelList', () {
      test('should parse simple GET request', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
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
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'Simple GET');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev');
        expect(result[0].$2.headers, isEmpty);
        expect(result[0].$2.params, isEmpty);
        expect(result[0].$2.body, isNull);
        expect(result[0].$2.formData, isNull);
      });

      test('should parse GET request with query parameters', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'Country Data');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev/country/data');
        expect(result[0].$2.params,
            [const NameValueModel(name: 'code', value: 'US')]);
        expect(result[0].$2.isParamEnabledList, [true]);
      });

      test('should parse GET request with multiple query parameters', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Humanize Rank",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.get);
        expect(
            result[0].$2.url, 'https://api.apidash.dev/humanize/social');
        expect(result[0].$2.params?.length, 5);
        expect(result[0].$2.params?[0],
            const NameValueModel(name: 'num', value: '8700000'));
        expect(result[0].$2.params?[4],
            const NameValueModel(name: 'trailing_zeros', value: 'true'));
        expect(result[0].$2.isParamEnabledList,
            [true, true, true, true, true]);
      });

      test('should parse POST request with raw JSON body', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Case Lower",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\"text\": \"I LOVE Flutter\"}",
          "options": {
            "raw": {
              "language": "json"
            }
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.url, 'https://api.apidash.dev/case/lower');
        expect(result[0].$2.body, '{"text": "I LOVE Flutter"}');
        expect(result[0].$2.bodyContentType, ContentType.json);
        expect(result[0].$2.formData, isNull);
      });

      test('should parse POST request with formdata', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
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
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.url, 'https://api.apidash.dev/io/form');
        expect(result[0].$2.bodyContentType, ContentType.formdata);
        expect(result[0].$2.headers, [
          const NameValueModel(name: 'User-Agent', value: 'Test Agent'),
        ]);
        expect(result[0].$2.isHeaderEnabledList, [true]);
        expect(result[0].$2.formData, [
          const FormDataModel(
              name: 'text', value: 'API', type: FormDataType.text),
          const FormDataModel(
              name: 'sep', value: '|', type: FormDataType.text),
          const FormDataModel(
              name: 'times', value: '3', type: FormDataType.text),
        ]);
        expect(result[0].$2.body, isNull);
      });

      test('should parse POST request with formdata including file', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Form with File",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "formdata",
          "formdata": [
            {"key": "token", "value": "xyz", "type": "text"},
            {"key": "imfile", "type": "file", "src": "/path/to/image.jpeg"}
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.bodyContentType, ContentType.formdata);
        expect(result[0].$2.formData?.length, 2);
        expect(
          result[0].$2.formData?[0],
          const FormDataModel(
              name: 'token', value: 'xyz', type: FormDataType.text),
        );
        expect(
          result[0].$2.formData?[1],
          const FormDataModel(
              name: 'imfile',
              value: '/path/to/image.jpeg',
              type: FormDataType.file),
        );
      });

      test('should parse nested folder structure (full collection)', () {
        const json = r'''
{
  "info": {
    "name": "API Dash",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
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
              "query": [{"key": "code", "value": "US"}]
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
              "raw": "{\"text\": \"I LOVE Flutter\"}",
              "options": {"raw": {"language": "json"}}
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 3);
        expect(result[0].$1, 'Simple GET');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[1].$1, 'Country Data');
        expect(result[1].$2.method, HTTPVerb.get);
        expect(result[1].$2.params,
            [const NameValueModel(name: 'code', value: 'US')]);
        expect(result[2].$1, 'Case Lower');
        expect(result[2].$2.method, HTTPVerb.post);
        expect(result[2].$2.bodyContentType, ContentType.json);
      });

      test('should return null for invalid JSON', () {
        const content = 'this is not valid json';
        final result = postmanIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should return null for empty string', () {
        const content = '';
        final result = postmanIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should handle disabled headers and query params', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Request with disabled",
      "request": {
        "method": "GET",
        "header": [
          {"key": "Accept", "value": "application/json", "disabled": false},
          {"key": "X-Debug", "value": "true", "disabled": true}
        ],
        "url": {
          "raw": "https://api.apidash.dev?active=1&inactive=0",
          "query": [
            {"key": "active", "value": "1", "disabled": false},
            {"key": "inactive", "value": "0", "disabled": true}
          ]
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.headers?.length, 2);
        expect(result[0].$2.isHeaderEnabledList, [true, false]);
        expect(result[0].$2.params?.length, 2);
        expect(result[0].$2.isParamEnabledList, [true, false]);
      });

      test('should default to GET for unknown HTTP method', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Unknown Method",
      "request": {
        "method": "FOOBAR",
        "header": [],
        "url": {
          "raw": "https://api.apidash.dev"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.get);
      });

      test('should default to GET for null HTTP method', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "No Method",
      "request": {
        "header": [],
        "url": {
          "raw": "https://api.apidash.dev"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.get);
      });

      test('should handle raw body with unknown language option', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Unknown Lang",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "some raw content",
          "options": {
            "raw": {
              "language": "unknownlang"
            }
          }
        },
        "url": {
          "raw": "https://api.apidash.dev/endpoint"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.body, 'some raw content');
        expect(result[0].$2.bodyContentType, ContentType.json);
      });

      test('should return empty list for collection with no items', () {
        const json = r'''
{
  "info": {
    "name": "Empty",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": []
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should handle formdata with unknown type defaulting to text', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Unknown FormData Type",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "formdata",
          "formdata": [
            {"key": "field1", "value": "val1", "type": "unknowntype"}
          ]
        },
        "url": {
          "raw": "https://api.apidash.dev/upload"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.formData?[0].type, FormDataType.text);
      });

      test('should strip URL parameters from raw URL', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "URL with params",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "https://api.example.com/search?q=test&page=1",
          "query": [
            {"key": "q", "value": "test"},
            {"key": "page", "value": "1"}
          ]
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.url, 'https://api.example.com/search');
      });

      test('should parse full API Dash collection', () {
        const json = r'''
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
              "query": [{"key": "code", "value": "US"}]
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
              "options": {"raw": {"language": "json"}}
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
                {"key": "imfile", "type": "file", "src": "/Users/ashitaprasad/Downloads/hire AI.jpeg"}
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
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 6);

        // Simple GET
        expect(result[0].$1, 'Simple GET');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev');

        // Country Data
        expect(result[1].$1, 'Country Data');
        expect(result[1].$2.method, HTTPVerb.get);
        expect(result[1].$2.url, 'https://api.apidash.dev/country/data');
        expect(result[1].$2.params?.length, 1);

        // Humanize Rank
        expect(result[2].$1, 'Humanize Rank');
        expect(result[2].$2.params?.length, 5);

        // Case Lower
        expect(result[3].$1, 'Case Lower');
        expect(result[3].$2.method, HTTPVerb.post);
        expect(result[3].$2.bodyContentType, ContentType.json);

        // Form Example
        expect(result[4].$1, 'Form Example');
        expect(result[4].$2.method, HTTPVerb.post);
        expect(result[4].$2.bodyContentType, ContentType.formdata);
        expect(result[4].$2.formData?.length, 3);

        // Form with File
        expect(result[5].$1, 'Form with File');
        expect(result[5].$2.method, HTTPVerb.post);
        expect(result[5].$2.bodyContentType, ContentType.formdata);
        expect(result[5].$2.formData?.length, 2);
        expect(result[5].$2.formData?[1].type, FormDataType.file);
      });
    });

    group('postmanRequestToHttpRequestModel', () {
      test('should handle request with empty URL', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Empty URL",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": ""
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.url, '');
      });

      test('should handle DELETE method', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Delete Request",
      "request": {
        "method": "DELETE",
        "header": [],
        "url": {
          "raw": "https://api.apidash.dev/users/1"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.delete);
      });

      test('should handle PUT method', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Put Request",
      "request": {
        "method": "PUT",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\"name\": \"updated\"}",
          "options": {"raw": {"language": "json"}}
        },
        "url": {
          "raw": "https://api.apidash.dev/users/1"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.put);
        expect(result[0].$2.body, '{"name": "updated"}');
      });

      test('should handle PATCH method', () {
        const json = r'''
{
  "info": {
    "name": "Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Patch Request",
      "request": {
        "method": "PATCH",
        "header": [],
        "url": {
          "raw": "https://api.apidash.dev/users/1"
        }
      },
      "response": []
    }
  ]
}''';

        final result = postmanIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.patch);
      });
    });
  });
}
