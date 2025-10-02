import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

const _specJson = '''
{
  "openapi": "3.0.0",
  "info": {"title": "Sample API", "version": "1.0.0"},
  "servers": [{"url": "https://api.apidash.dev"}],
  "paths": {
    "/users": {
      "get": {"responses": {"200": {"description": "ok"}}},
      "post": {"responses": {"201": {"description": "created"}}}
    },
    "/auth/login": {
      "post": {"responses": {"200": {"description": "login"}}}
    }
  }
}
''';

void main() {
  group('OpenApiImportService parsing & summary', () {
    test('tryParseSpec returns spec', () {
      final spec = OpenApiImportService.tryParseSpec(_specJson);
      expect(spec, isNotNull);
      final summary = OpenApiImportService.summaryForSpec(spec!);
      expect(summary, contains('Endpoints discovered: 3'));
      // Order of set iteration may vary; assert both tokens present instead.
      expect(summary, contains('GET'));
      expect(summary, contains('POST'));
    });

    test('tryParseSpec handles problematic security field with empty arrays',
        () {
      const specWithEmptySecurityArray = '''
{
  "openapi": "3.0.0",
  "info": {
    "title": "Cat Fact API",
    "version": "1.0.0"
  },
  "paths": {
    "/fact": {
      "get": {
        "responses": {
          "200": {
            "description": "Success"
          }
        }
      }
    }
  },
  "security": [[]]
}''';

      final result =
          OpenApiImportService.tryParseSpec(specWithEmptySecurityArray);
      expect(result, isNotNull);
      expect(result!.info.title, equals('Cat Fact API'));
      expect(result.info.version, equals('1.0.0'));
      expect(result.paths, isNotNull);
      expect(result.paths!.keys, contains('/fact'));
    });

    test('tryParseSpec handles valid security field with actual requirements',
        () {
      const specWithRealSecurity = '''
{
  "openapi": "3.0.0",
  "info": {
    "title": "Secured API",
    "version": "1.0.0"
  },
  "paths": {
    "/secured": {
      "get": {
        "responses": {
          "200": {
            "description": "Success"
          }
        }
      }
    }
  },
  "security": [
    {
      "api_key": []
    }
  ]
}''';

      final result = OpenApiImportService.tryParseSpec(specWithRealSecurity);
      expect(result, isNotNull);
      expect(result!.info.title, equals('Secured API'));
    });

    test('tryParseSpec returns null for invalid JSON', () {
      const invalidSpec = 'not valid json';
      final result = OpenApiImportService.tryParseSpec(invalidSpec);
      expect(result, isNull);
    });

    test('tryParseSpec returns null for non-OpenAPI JSON', () {
      const nonOpenApiSpec = '''
{
  "notOpenApi": true,
  "someField": "value"
}''';
      final result = OpenApiImportService.tryParseSpec(nonOpenApiSpec);
      expect(result, isNull);
    });

    test('extractSpecMeta includes endpoints & baseUrl', () {
      final spec = OpenApiImportService.tryParseSpec(_specJson)!;
      final meta = OpenApiImportService.extractSpecMeta(spec);
      expect(meta['endpointsCount'], 3);
      expect(meta['baseUrl'], 'https://api.apidash.dev');
      expect((meta['methods'] as List).contains('GET'), true);
      expect((meta['methods'] as List).contains('POST'), true);
    });
  });

  group('OpenApiImportService operation helpers', () {
    late OpenApi spec;
    setUp(() {
      spec = OpenApiImportService.tryParseSpec(_specJson)!;
    });

    test('buildOperationPicker returns import action', () {
      final picker = OpenApiImportService.buildOperationPicker(spec);
      expect(picker['explanation'], contains('OpenAPI parsed'));
      final actions = (picker['actions'] as List);
      expect(actions.length, 1);
      expect(actions.first['action'], 'import_now_openapi');
      expect(picker['meta'], isA<Map>());
    });

    test('payloadForOperation builds expected shape', () {
      final pathItem = spec.paths!['/users']!;
      final op = pathItem.get!; // GET operation
      final payload = OpenApiImportService.payloadForOperation(
        baseUrl: spec.servers!.first.url!,
        path: '/users',
        method: 'get',
        op: op,
      );
      expect(payload['method'], 'GET');
      expect(payload['url'], 'https://api.apidash.dev/users');
      expect(payload['headers'], isA<Map>());
    });
  });

  group('OpenApiImportService extended coverage', () {
    const extendedSpecJson = '''
{
  "openapi": "3.0.0",
  "info": {"title": "Extended API", "version": "2.0.0"},
  "servers": [
    {"url": "https://api.apidash.dev/"},
    {"url": "  "}
  ],
  "paths": {
    "/search": {
      "get": {
        "tags": ["search", "core"],
        "parameters": [
          {"name": "X-Test", "in": "header", "schema": {"type": "string"}}
        ],
        "requestBody": {
          "content": {
            "application/json": {"example": {"q": "term"}}
          }
        },
        "responses": {
          "200": {"description": "ok", "content": {"application/json": {"schema": {"type": "object"}}}}
        }
      },
      "post": {
        "tags": ["search"],
        "requestBody": {
          "content": {
            "multipart/form-data": {"schema": {"type": "object", "properties": {"file": {"type": "string"}}}}
          }
        },
        "responses": {"200": {"description": "created", "content": {"application/json": {"schema": {"type": "object"}}}}}
      }
    },
    "/upload": {
      "post": {
        "tags": ["files"],
        "requestBody": {
          "content": {
            "application/x-www-form-urlencoded": {"schema": {"type": "object", "properties": {"name": {"type": "string"}}}}
          }
        },
        "responses": {"200": {"description": "ok"}}
      }
    }
  }
}
''';

    test(
        'extractSpecMeta captures tags, content types, trimming and noteworthy routes',
        () {
      final spec = OpenApiImportService.tryParseSpec(extendedSpecJson)!;
      final meta = OpenApiImportService.extractSpecMeta(spec,
          maxRoutes: 1); // trigger trimming branch
      // endpointsCount should reflect all operations (GET, POST on /search, POST on /upload) = 3
      expect(meta['endpointsCount'], 3);
      // routes trimmed to 1
      expect((meta['routes'] as List).length, 1);
      // noteworthyRoutes should include /search and possibly /upload depending on heuristic; ensure contains user/search keyword logic
      final noteworthy = (meta['noteworthyRoutes'] as List);
      expect(
        noteworthy.any((r) => (r['path'] as String).contains('search')),
        true,
      );
      // methods & tags include expected values
      final methods = (meta['methods'] as List);
      expect(methods.contains('GET'), true);
      expect(methods.contains('POST'), true);
      final tags = (meta['tags'] as List);
      expect(tags.contains('search'), true);
      // request/response content types captured
      final reqCts = (meta['requestContentTypes'] as List);
      expect(reqCts.isNotEmpty, true);
      final respCts = (meta['responseContentTypes'] as List);
      expect(respCts.contains('application/json'), true);
    });

    test(
        'payloadForOperation covers json request body & header param & baseUrl slash trimming',
        () {
      final spec = OpenApiImportService.tryParseSpec(extendedSpecJson)!;
      final getOp = spec.paths!['/search']!.get!;
      final payload = OpenApiImportService.payloadForOperation(
        baseUrl: spec.servers!.first.url!, // ends with slash
        path: '/search',
        method: 'get',
        op: getOp,
      );
      // baseUrl with trailing slash should not duplicate
      expect(payload['url'], 'https://api.apidash.dev/search');
      final headers = (payload['headers'] as Map<String, dynamic>);
      // header param captured (value placeholder empty)
      expect(headers.containsKey('X-Test'), true);
      // JSON content type set and example serialized
      expect(headers['Content-Type'], 'application/json');
      expect(payload['body'], contains('"q"'));
      expect(payload['form'], false);
    });

    test('payloadForOperation covers form request body variants', () {
      final spec = OpenApiImportService.tryParseSpec(extendedSpecJson)!;
      final postOp = spec.paths!['/search']!.post!; // multipart form
      final payload1 = OpenApiImportService.payloadForOperation(
        baseUrl: spec.servers!.first.url!,
        path: '/search',
        method: 'post',
        op: postOp,
      );
      expect(payload1['form'], true);
      expect(
          (payload1['headers'] as Map)['Content-Type'], 'multipart/form-data');

      final uploadOp = spec.paths!['/upload']!.post!; // urlencoded form
      final payload2 = OpenApiImportService.payloadForOperation(
        baseUrl: spec.servers!.first.url!,
        path: '/upload',
        method: 'post',
        op: uploadOp,
      );
      expect(payload2['form'], true);
      expect((payload2['headers'] as Map)['Content-Type'],
          'application/x-www-form-urlencoded');
    });

    test('buildOperationPicker with insights branch', () {
      final spec = OpenApiImportService.tryParseSpec(extendedSpecJson)!;
      final picker = OpenApiImportService.buildOperationPicker(spec,
          insights: 'Some insights');
      expect(picker['explanation'], contains('Some insights'));
    });

    test('buildOperationPicker zero endpoints branch', () {
      const emptySpecJson =
          '{"openapi":"3.0.0","info":{"title":"Empty","version":"1"},"paths":{}}';
      final spec = OpenApiImportService.tryParseSpec(emptySpecJson)!;
      final picker = OpenApiImportService.buildOperationPicker(spec);
      expect(picker['actions'], isEmpty);
      expect(picker['explanation'], contains('No operations'));
    });
  });
}
