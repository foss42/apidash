import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:insomnia_collection/insomnia_collection.dart';

void main() {
  group('InsomniaIO Tests', () {
    late InsomniaIO insomniaIO;

    setUp(() {
      insomniaIO = InsomniaIO();
    });

    group('getHttpRequestModelList', () {
      test('should parse simple GET request', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/country/codes",
      "name": "test-get",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'test-get');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url, 'https://api.apidash.dev/country/codes');
        expect(result[0].$2.headers, isEmpty);
        expect(result[0].$2.params, isEmpty);
        expect(result[0].$2.body, isNull);
        expect(result[0].$2.formData, isNull);
      });

      test('should parse GET request with query parameters', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://food-service-backend.onrender.com/api/users/",
      "name": "get-with-params",
      "method": "GET",
      "body": {},
      "parameters": [
        {
          "id": "pair_1",
          "name": "user_id",
          "value": "34",
          "description": "",
          "disabled": false
        }
      ],
      "headers": [
        {"name": "User-Agent", "value": "insomnia/10.3.0"}
      ],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'get-with-params');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.url,
            'https://food-service-backend.onrender.com/api/users/');
        expect(result[0].$2.params,
            [const NameValueModel(name: 'user_id', value: '34')]);
        expect(result[0].$2.isParamEnabledList, [true]);
        expect(result[0].$2.headers, [
          const NameValueModel(
              name: 'User-Agent', value: 'insomnia/10.3.0'),
        ]);
        expect(result[0].$2.isHeaderEnabledList, [true]);
      });

      test('should parse POST request with JSON body', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/case/lower",
      "name": "test-post",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"text\": \"Grass is green\"\n}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'test-post');
        expect(result[0].$2.method, HTTPVerb.post);
        expect(result[0].$2.url, 'https://api.apidash.dev/case/lower');
        expect(result[0].$2.bodyContentType, ContentType.json);
        expect(result[0].$2.body, '{\n  "text": "Grass is green"\n}');
        expect(result[0].$2.headers, [
          const NameValueModel(
              name: 'Content-Type', value: 'application/json'),
        ]);
      });

      test('should parse PUT request with JSON body', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://reqres.in/api/users/2",
      "name": "test-put",
      "method": "PUT",
      "body": {
        "mimeType": "application/json",
        "text": "{\n    \"name\": \"morpheus\",\n    \"job\": \"zion resident\"\n}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'test-put');
        expect(result[0].$2.method, HTTPVerb.put);
        expect(result[0].$2.url, 'https://reqres.in/api/users/2');
        expect(result[0].$2.bodyContentType, ContentType.json);
        expect(result[0].$2.body,
            '{\n    "name": "morpheus",\n    "job": "zion resident"\n}');
      });

      test('should only extract request type resources, ignoring others', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/country/codes",
      "name": "test-get",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    },
    {
      "_id": "fld_1",
      "parentId": "wrk_1",
      "name": "Test Folder",
      "description": "A test folder",
      "_type": "request_group"
    },
    {
      "_id": "wrk_1",
      "name": "Test Workspace",
      "scope": "collection",
      "_type": "workspace"
    },
    {
      "_id": "env_1",
      "parentId": "wrk_1",
      "name": "Base Environment",
      "environmentType": "kv",
      "_type": "environment"
    },
    {
      "_id": "jar_1",
      "parentId": "wrk_1",
      "name": "Default Jar",
      "cookies": [],
      "_type": "cookie_jar"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$1, 'test-get');
        expect(result[0].$2.method, HTTPVerb.get);
      });

      test('should parse multiple request resources', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/country/codes",
      "name": "test-get",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    },
    {
      "_id": "req_2",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/case/lower",
      "name": "test-post",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\"text\": \"Grass is green\"}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    },
    {
      "_id": "req_3",
      "parentId": "fld_1",
      "url": "https://reqres.in/api/users/2",
      "name": "test-put",
      "method": "PUT",
      "body": {
        "mimeType": "application/json",
        "text": "{\"name\": \"morpheus\"}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 3);
        expect(result[0].$1, 'test-get');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[1].$1, 'test-post');
        expect(result[1].$2.method, HTTPVerb.post);
        expect(result[2].$1, 'test-put');
        expect(result[2].$2.method, HTTPVerb.put);
      });

      test('should return null for invalid JSON', () {
        const content = 'this is not valid json';
        final result = insomniaIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should return null for empty string', () {
        const content = '';
        final result = insomniaIO.getHttpRequestModelList(content);
        expect(result, isNull);
      });

      test('should return empty list when no request resources exist', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "wrk_1",
      "name": "Test Workspace",
      "scope": "collection",
      "_type": "workspace"
    },
    {
      "_id": "env_1",
      "parentId": "wrk_1",
      "name": "Base Environment",
      "environmentType": "kv",
      "_type": "environment"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('should default to GET for unknown HTTP method', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev",
      "name": "unknown-method",
      "method": "FOOBAR",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.get);
      });

      test('should default to GET for null method', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev",
      "name": "no-method",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.get);
      });

      test('should handle disabled headers and query params', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev",
      "name": "disabled-test",
      "method": "GET",
      "body": {},
      "parameters": [
        {"name": "active", "value": "1", "disabled": false},
        {"name": "inactive", "value": "0", "disabled": true}
      ],
      "headers": [
        {"name": "Accept", "value": "application/json", "disabled": false},
        {"name": "X-Debug", "value": "true", "disabled": true}
      ],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 1);
        expect(result[0].$2.headers?.length, 2);
        expect(result[0].$2.isHeaderEnabledList, [true, false]);
        expect(result[0].$2.params?.length, 2);
        expect(result[0].$2.isParamEnabledList, [true, false]);
      });

      test('should handle request with no body mimeType', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev",
      "name": "no-body",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.body, isNull);
        expect(result[0].$2.formData, isNull);
      });

      test('should parse formdata body with text and file fields', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/upload",
      "name": "form-upload",
      "method": "POST",
      "body": {
        "mimeType": "multipart/form-data",
        "params": [
          {"name": "token", "value": "xyz", "type": "text"},
          {"name": "avatar", "type": "file", "fileName": "/path/to/file.png"}
        ]
      },
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

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
              name: 'avatar',
              value: '/path/to/file.png',
              type: FormDataType.file),
        );
        expect(result[0].$2.body, isNull);
      });

      test('should strip URL parameters from URL', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.example.com/search?q=test&page=1",
      "name": "url-with-params",
      "method": "GET",
      "body": {},
      "parameters": [
        {"name": "q", "value": "test"},
        {"name": "page", "value": "1"}
      ],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.url, 'https://api.example.com/search');
      });

      test('should parse DELETE method', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/users/1",
      "name": "delete-user",
      "method": "DELETE",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.delete);
      });

      test('should parse PATCH method', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/users/1",
      "name": "patch-user",
      "method": "PATCH",
      "body": {
        "mimeType": "application/json",
        "text": "{\"status\": \"active\"}"
      },
      "parameters": [],
      "headers": [],
      "_type": "request"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result![0].$2.method, HTTPVerb.patch);
        expect(result[0].$2.body, '{"status": "active"}');
        expect(result[0].$2.bodyContentType, ContentType.json);
      });

      test('should parse full API Dash Insomnia collection', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-05T13:05:11.752Z",
  "__export_source": "insomnia.desktop.app:v10.3.0",
  "resources": [
    {
      "_id": "req_1",
      "parentId": "fld_1",
      "url": "https://food-service-backend.onrender.com/api/users/",
      "name": "get-with-params",
      "method": "GET",
      "body": {},
      "parameters": [
        {"id": "pair_1", "name": "user_id", "value": "34", "description": "", "disabled": false}
      ],
      "headers": [
        {"name": "User-Agent", "value": "insomnia/10.3.0"}
      ],
      "_type": "request"
    },
    {
      "_id": "fld_1",
      "parentId": "wrk_1",
      "name": "APIDash-APItests",
      "description": "These are test endpoints for API Dash",
      "_type": "request_group"
    },
    {
      "_id": "wrk_1",
      "name": "APIDash-APItests",
      "scope": "collection",
      "_type": "workspace"
    },
    {
      "_id": "req_2",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/country/codes",
      "name": "test-get",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "_type": "request"
    },
    {
      "_id": "req_3",
      "parentId": "fld_1",
      "url": "https://api.apidash.dev/case/lower",
      "name": "test-post",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"text\": \"Grass is green\"\n}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    },
    {
      "_id": "req_4",
      "parentId": "fld_1",
      "url": "https://reqres.in/api/users/2",
      "name": "test-put",
      "method": "PUT",
      "body": {
        "mimeType": "application/json",
        "text": "{\n    \"name\": \"morpheus\",\n    \"job\": \"zion resident\"\n}"
      },
      "parameters": [],
      "headers": [
        {"name": "Content-Type", "value": "application/json"}
      ],
      "_type": "request"
    },
    {
      "_id": "env_1",
      "parentId": "wrk_1",
      "name": "Base Environment",
      "environmentType": "kv",
      "_type": "environment"
    },
    {
      "_id": "jar_1",
      "parentId": "wrk_1",
      "name": "Default Jar",
      "cookies": [],
      "_type": "cookie_jar"
    }
  ]
}''';

        final result = insomniaIO.getHttpRequestModelList(json);

        expect(result, isNotNull);
        expect(result!.length, 4);

        // GET with params
        expect(result[0].$1, 'get-with-params');
        expect(result[0].$2.method, HTTPVerb.get);
        expect(result[0].$2.params?.length, 1);
        expect(result[0].$2.params?[0],
            const NameValueModel(name: 'user_id', value: '34'));

        // Simple GET
        expect(result[1].$1, 'test-get');
        expect(result[1].$2.method, HTTPVerb.get);

        // POST with JSON
        expect(result[2].$1, 'test-post');
        expect(result[2].$2.method, HTTPVerb.post);
        expect(result[2].$2.bodyContentType, ContentType.json);

        // PUT with JSON
        expect(result[3].$1, 'test-put');
        expect(result[3].$2.method, HTTPVerb.put);
        expect(result[3].$2.bodyContentType, ContentType.json);
      });
    });

    group('insomniaResourceToEnvironmentModel', () {
      test('should convert environment resource to EnvironmentModel', () {
        const json = r'''
{
  "_type": "export",
  "__export_format": 4,
  "resources": [
    {
      "_id": "env_1",
      "parentId": "wrk_1",
      "name": "Test Environment",
      "environmentType": "kv",
      "kvPairData": [
        {"id": "kv_1", "name": "API_KEY", "value": "abc123", "type": "text", "enabled": true},
        {"id": "kv_2", "name": "SECRET", "value": "s3cret", "type": "secret", "enabled": true},
        {"id": "kv_3", "name": "DISABLED_VAR", "value": "test", "type": "text", "enabled": false}
      ],
      "_type": "environment"
    }
  ]
}''';

        // Parse to get the environment resource directly
        final ic = insomniaCollectionFromJsonStr(json);
        final resource = ic.resources!
            .firstWhere((r) => r.type == 'environment');

        final result = insomniaIO.insomniaResourceToEnvironmentModel(resource);

        expect(result.id, 'env_1');
        expect(result.name, 'Test Environment');
        expect(result.values.length, 3);
        expect(result.values[0].key, 'API_KEY');
        expect(result.values[0].value, 'abc123');
        expect(result.values[0].type, EnvironmentVariableType.variable);
        expect(result.values[0].enabled, true);
        expect(result.values[1].key, 'SECRET');
        expect(result.values[1].value, 's3cret');
        expect(result.values[1].type, EnvironmentVariableType.secret);
        expect(result.values[1].enabled, true);
        expect(result.values[2].key, 'DISABLED_VAR');
        expect(result.values[2].value, 'test');
        expect(result.values[2].type, EnvironmentVariableType.variable);
        expect(result.values[2].enabled, false);
      });
    });
  });
}
