import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('HarParserIO Tests', () {
    late HarParserIO harParserIO;

    setUp(() {
      harParserIO = HarParserIO();
    });

    group('getHttpRequestModelList', () {
      test('should parse simple GET request', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
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
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'https://api.apidash.dev');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev');
        expect(result[0].$2.headers, isEmpty);
        expect(result[0].$2.params, isEmpty);
        expect(result[0].$2.body, isNull);
      });

      test('should parse GET request with query parameters', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
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
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev/country/data');
        expect(result[0].$2.params,
            [const NameValueModel(name: 'code', value: 'US')]);
        expect(result[0].$2.isParamEnabledList, [true]);
      });

      test('should parse GET request with multiple query parameters', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:02:00.000Z",
        "time": 200,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
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
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.url, 'https://api.apidash.dev/humanize/social');
        expect(result[0].$2.params?.length, 5);
        expect(result[0].$2.params?[0],
            const NameValueModel(name: 'num', value: '8700000'));
        expect(result[0].$2.params?[4],
            const NameValueModel(name: 'trailing_zeros', value: 'true'));
        expect(result[0].$2.isParamEnabledList,
            [true, true, true, true, true]);
      });

      test('should parse POST request with JSON body', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:03:00.000Z",
        "time": 300,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/case/lower",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/json",
            "text": "{ \"text\": \"I LOVE Flutter\" }"
          },
          "bodySize": 50
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.url, 'https://api.apidash.dev/case/lower');
        expect(result[0].$2.bodyContentType, ContentType.json);
        expect(result[0].$2.body, '{ "text": "I LOVE Flutter" }');
      });

      test('should parse POST request with multipart/form-data (text params)',
          () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
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
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              {"name": "text", "value": "API", "contentType": "text/plain"},
              {"name": "sep", "value": "|", "contentType": "text/plain"},
              {"name": "times", "value": "3", "contentType": "text/plain"}
            ]
          },
          "bodySize": 100
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

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
      });

      test('should parse POST request with multipart/form-data (file upload)',
          () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:05:00.000Z",
        "time": 400,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/io/img",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              {"name": "token", "value": "xyz", "contentType": "text/plain"},
              {"name": "imfile", "fileName": "hire AI.jpeg", "contentType": "image/jpeg"}
            ]
          },
          "bodySize": 150
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

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
              value: 'hire AI.jpeg',
              type: FormDataType.file),
        );
      });

      test(
          'should parse POST request with application/x-www-form-urlencoded body',
          () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:06:00.000Z",
        "time": 200,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/form",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/x-www-form-urlencoded",
            "text": "username=john&password=secret123"
          },
          "bodySize": 40
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.bodyContentType, ContentType.formdata);
        expect(result[0].$2.formData?.length, 2);
        expect(
          result[0].$2.formData?[0],
          const FormDataModel(
              name: 'username', value: 'john', type: FormDataType.text),
        );
        expect(
          result[0].$2.formData?[1],
          const FormDataModel(
              name: 'password', value: 'secret123', type: FormDataType.text),
        );
      });

      test('should parse multiple entries', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
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
          "method": "POST",
          "url": "https://api.apidash.dev/case/lower",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/json",
            "text": "{\"text\": \"hello\"}"
          },
          "bodySize": 20
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
          "method": "DELETE",
          "url": "https://api.apidash.dev/users/1",
          "headers": [],
          "queryString": [],
          "bodySize": 0
        },
        "response": {
          "status": 204,
          "statusText": "No Content",
          "headers": [],
          "bodySize": 0
        }
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 3);
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev');
        expect(result[1].$2.method, HTTPVerb.post);
        expect(result[1].$2.url, 'https://api.apidash.dev/case/lower');
        expect(result[1].$2.bodyContentType, ContentType.json);
        expect(result[2].$2.method, HTTPVerb.delete);
        expect(result[2].$2.url, 'https://api.apidash.dev/users/1');
      });

      test('should return null for invalid JSON', () {
        const content = 'this is not valid json';
        final result = harParserIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should return null for empty string', () {
        const content = '';
        final result = harParserIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should handle disabled headers and query params', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:00:00.000Z",
        "time": 100,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev?a=1&b=2",
          "headers": [
            {"name": "Accept", "value": "application/json", "disabled": false},
            {"name": "X-Debug", "value": "true", "disabled": true}
          ],
          "queryString": [
            {"name": "a", "value": "1", "disabled": false},
            {"name": "b", "value": "2", "disabled": true}
          ],
          "bodySize": 0
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

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
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:00:00.000Z",
        "time": 100,
        "request": {
          "method": "FOOBAR",
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
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.get);
      });

      test('should strip URL parameters from request URL', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:00:00.000Z",
        "time": 100,
        "request": {
          "method": "GET",
          "url": "https://api.example.com/search?q=test&page=1",
          "headers": [],
          "queryString": [
            {"name": "q", "value": "test"},
            {"name": "page", "value": "1"}
          ],
          "bodySize": 0
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.url, 'https://api.example.com/search');
      });

      test('should return empty list for HAR with no entries', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": []
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should handle PUT method', () {
        const json = r'''
{
  "log": {
    "version": "1.2",
    "creator": {"name": "Test", "version": "1.0"},
    "entries": [
      {
        "startedDateTime": "2025-03-25T12:00:00.000Z",
        "time": 100,
        "request": {
          "method": "PUT",
          "url": "https://api.apidash.dev/users/1",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "application/json",
            "text": "{\"name\": \"updated\"}"
          },
          "bodySize": 30
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
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.put);
        expect(result[0].$2.body, '{"name": "updated"}');
        expect(result[0].$2.bodyContentType, ContentType.json);
      });

      test(
          'should parse full API Dash HAR collection with all 6 request types',
          () {
        const json = r'''
{
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
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      },
      {
        "startedDateTime": "2025-03-25T12:01:00.000Z",
        "time": 150,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev/country/data?code=US",
          "headers": [],
          "queryString": [{"name": "code", "value": "US"}],
          "bodySize": 0
        },
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      },
      {
        "startedDateTime": "2025-03-25T12:02:00.000Z",
        "time": 200,
        "request": {
          "method": "GET",
          "url": "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true",
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
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      },
      {
        "startedDateTime": "2025-03-25T12:03:00.000Z",
        "time": 300,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/case/lower",
          "headers": [],
          "queryString": [],
          "postData": {"mimeType": "application/json", "text": "{ \"text\": \"I LOVE Flutter\" }"},
          "bodySize": 50
        },
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      },
      {
        "startedDateTime": "2025-03-25T12:04:00.000Z",
        "time": 350,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/io/form",
          "headers": [{"name": "User-Agent", "value": "Test Agent"}],
          "queryString": [],
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              {"name": "text", "value": "API", "contentType": "text/plain"},
              {"name": "sep", "value": "|", "contentType": "text/plain"},
              {"name": "times", "value": "3", "contentType": "text/plain"}
            ]
          },
          "bodySize": 100
        },
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      },
      {
        "startedDateTime": "2025-03-25T12:05:00.000Z",
        "time": 400,
        "request": {
          "method": "POST",
          "url": "https://api.apidash.dev/io/img",
          "headers": [],
          "queryString": [],
          "postData": {
            "mimeType": "multipart/form-data",
            "params": [
              {"name": "token", "value": "xyz", "contentType": "text/plain"},
              {"name": "imfile", "fileName": "hire AI.jpeg", "contentType": "image/jpeg"}
            ]
          },
          "bodySize": 150
        },
        "response": {"status": 200, "statusText": "OK", "headers": [], "bodySize": 0}
      }
    ]
  }
}''';

        final result = harParserIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 6);

        // Simple GET
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev');

        // GET with query param
        expect(result[1].$2.method, HTTPVerb.get);
        expect(result[1].$2.url, 'https://api.apidash.dev/country/data');
        expect(result[1].$2.params?.length, 1);

        // GET with multiple query params
        expect(result[2].$2.params?.length, 5);

        // POST with JSON body
        expect(result[3].$2.method, HTTPVerb.post);
        expect(result[3].$2.bodyContentType, ContentType.json);
        expect(result[3].$2.body, '{ "text": "I LOVE Flutter" }');

        // POST with multipart form data
        expect(result[4].$2.method, HTTPVerb.post);
        expect(result[4].$2.bodyContentType, ContentType.formdata);
        expect(result[4].$2.formData?.length, 3);

        // POST with file upload
        expect(result[5].$2.method, HTTPVerb.post);
        expect(result[5].$2.bodyContentType, ContentType.formdata);
        expect(result[5].$2.formData?.length, 2);
        expect(result[5].$2.formData?[1].type, FormDataType.file);
        expect(result[5].$2.formData?[1].value, 'hire AI.jpeg');
      });
    });

    group('parseFormData', () {
      test('should parse simple form data string', () {
        final harIO = HarParserIO();
        final result = harIO.parseFormData('key1=value1&key2=value2');

        expect(result, {'key1': 'value1', 'key2': 'value2'});
      });

      test('should return empty map for null input', () {
        final harIO = HarParserIO();
        final result = harIO.parseFormData(null);

        expect(result, isEmpty);
      });

      test('should return empty map for empty string', () {
        final harIO = HarParserIO();
        final result = harIO.parseFormData('');

        expect(result, isEmpty);
      });

      test('should handle URL-encoded values', () {
        final harIO = HarParserIO();
        final result =
            harIO.parseFormData('name=John%20Doe&city=New%20York');

        expect(result, {'name': 'John Doe', 'city': 'New York'});
      });

      test('should skip malformed pairs without equals sign', () {
        final harIO = HarParserIO();
        final result = harIO.parseFormData('valid=pair&invalid&also=good');

        expect(result, {'valid': 'pair', 'also': 'good'});
      });

      test('should handle single key-value pair', () {
        final harIO = HarParserIO();
        final result = harIO.parseFormData('key=value');

        expect(result, {'key': 'value'});
      });
    });
  });
}
