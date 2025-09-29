import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('UrlEnvService.inferBaseUrl', () {
    final svc = UrlEnvService();
    test('basic https with path', () {
      expect(svc.inferBaseUrl('https://api.apidash.dev/v1/users?id=1'),
          'https://api.apidash.dev');
    });
    test('with port', () {
      expect(svc.inferBaseUrl('http://localhost:8080/api'),
          'http://localhost:8080');
    });
    test('with port 0 (default port)', () {
      expect(svc.inferBaseUrl('https://api.apidash.dev:0/api'),
          'https://api.apidash.dev');
    });
    test('without port (hasPort false)', () {
      expect(svc.inferBaseUrl('https://api.apidash.dev/api'),
          'https://api.apidash.dev');
    });
    test('url without scheme', () {
      expect(svc.inferBaseUrl('api.apidash.dev/path'), '');
    });
    test('url without host', () {
      expect(svc.inferBaseUrl('https:///path'), '');
    });
    test('fallback regex match', () {
      // This will hit the regex fallback path since Uri.parse will fail
      // to extract proper scheme/host for malformed URLs but regex can still match
      expect(svc.inferBaseUrl('https://malformed..host/path'),
          'https://malformed..host');
    });
    test('invalid returns empty', () {
      expect(svc.inferBaseUrl('not a url'), '');
    });
    test('regex fallback with valid http url', () {
      // Create a scenario where Uri.parse succeeds but doesn't have proper host
      expect(svc.inferBaseUrl('file://localhost/path'), 'file://localhost');
    });
  });

  group('UrlEnvService.ensureBaseUrlEnv & maybeSubstituteBaseUrl', () {
    final svc = UrlEnvService();

    test('ensure adds variable if missing and returns key', () async {
      final envId = 'env1';
      final envs = <String, EnvironmentModel>{
        envId: const EnvironmentModel(id: 'env1', name: 'Env1', values: []),
      };
      String? activeId = envId;
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => envs,
        readActiveEnvId: () => activeId,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );
      expect(key, startsWith('BASE_URL_'));
      expect(updated!.values.any((v) => v.key == key), true);
    });

    test('empty baseUrl returns BASE_URL', () async {
      final key = await svc.ensureBaseUrlEnv(
        '',
        readEnvs: () => <String, EnvironmentModel>{},
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );
      expect(key, 'BASE_URL');
    });

    test('uses global environment when activeId is null', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => envs,
        readActiveEnvId: () => null, // This should default to global
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );
      expect(key, 'BASE_URL_API_APIDASH_DEV');
      expect(updated!.values.any((v) => v.key == key), true);
    });

    test('does not add variable if it already exists', () async {
      final envId = 'env1';
      final existingVar = EnvironmentVariableModel(
        key: 'BASE_URL_API_APIDASH_DEV',
        value: 'https://existing.com',
        enabled: true,
      );
      final envs = <String, EnvironmentModel>{
        envId:
            EnvironmentModel(id: 'env1', name: 'Env1', values: [existingVar]),
      };
      String? activeId = envId;
      bool updateCalled = false;

      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => envs,
        readActiveEnvId: () => activeId,
        updateEnv: (id, {values}) {
          updateCalled = true;
        },
      );
      expect(key, 'BASE_URL_API_APIDASH_DEV');
      expect(
          updateCalled, false); // Should not call update since variable exists
    });

    test('handles null envs', () async {
      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => null,
        readActiveEnvId: () => 'env1',
        updateEnv: (id, {values}) {},
      );
      expect(key, 'BASE_URL_API_APIDASH_DEV');
    });

    test('handles null envModel', () async {
      final envs = <String, EnvironmentModel>{};
      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => envs,
        readActiveEnvId: () => 'nonexistent',
        updateEnv: (id, {values}) {},
      );
      expect(key, 'BASE_URL_API_APIDASH_DEV');
    });

    test('handles malformed URL in ensureBaseUrlEnv', () async {
      final envId = 'env1';
      final envs = <String, EnvironmentModel>{
        envId: const EnvironmentModel(id: 'env1', name: 'Env1', values: []),
      };
      String? activeId = envId;
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnv(
        'not-a-valid-url',
        readEnvs: () => envs,
        readActiveEnvId: () => activeId,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );
      expect(key, 'BASE_URL_API'); // Should fallback to 'API'
      expect(updated!.values.any((v) => v.key == key), true);
    });

    test('maybeSubstituteBaseUrl replaces prefix with variable', () async {
      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => <String, EnvironmentModel>{
          'env1': const EnvironmentModel(id: 'env1', name: 'Env1', values: []),
        },
        readActiveEnvId: () => 'env1',
        updateEnv: (id, {values}) {},
      );
      final replaced = await svc.maybeSubstituteBaseUrl(
        'https://api.apidash.dev/v1/users',
        'https://api.apidash.dev',
        ensure: (_) async => key,
      );
      expect(replaced, '{{$key}}/v1/users');
    });

    test('maybeSubstituteBaseUrl returns original URL when baseUrl is empty',
        () async {
      final url = 'https://api.apidash.dev/v1/users';
      final result = await svc.maybeSubstituteBaseUrl(
        url,
        '',
        ensure: (_) async => 'BASE_URL_API',
      );
      expect(result, url);
    });

    test(
        'maybeSubstituteBaseUrl returns original URL when URL does not start with baseUrl',
        () async {
      final url = 'https://different.com/v1/users';
      final baseUrl = 'https://api.apidash.dev';
      final result = await svc.maybeSubstituteBaseUrl(
        url,
        baseUrl,
        ensure: (_) async => 'BASE_URL_API',
      );
      expect(result, url);
    });

    test('maybeSubstituteBaseUrl handles path without leading slash', () async {
      final result = await svc.maybeSubstituteBaseUrl(
        'https://api.apidash.devv1/users', // No slash between baseUrl and path
        'https://api.apidash.dev',
        ensure: (_) async => 'BASE_URL_API',
      );
      expect(result, '{{BASE_URL_API}}/v1/users');
    });

    test('maybeSubstituteBaseUrl handles exact baseUrl match', () async {
      final result = await svc.maybeSubstituteBaseUrl(
        'https://api.apidash.dev',
        'https://api.apidash.dev',
        ensure: (_) async => 'BASE_URL_API',
      );
      expect(result, '{{BASE_URL_API}}/');
    });
  });

  group('UrlEnvService.ensureBaseUrlEnvForOpenApi', () {
    final svc = UrlEnvService();

    test('handles empty baseUrl with title', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      expect(key, 'BASE_URL_PET');
      expect(updated!.values.any((v) => v.key == key), true);
      final createdVar = updated!.values.firstWhere((v) => v.key == key);
      expect(
          createdVar.value, ''); // Empty baseUrl should result in empty value
    });

    test('handles "/" baseUrl with title', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '/',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      expect(key, 'BASE_URL_PET');
      expect(updated!.values.any((v) => v.key == key), true);
      final createdVar = updated!.values.firstWhere((v) => v.key == key);
      expect(createdVar.value, ''); // "/" should result in empty value
    });

    test('handles path-only baseUrl (no scheme) with title', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '/api/v1',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      expect(key, 'BASE_URL_PET');
      expect(updated!.values.any((v) => v.key == key), true);
      final createdVar = updated!.values.firstWhere((v) => v.key == key);
      expect(createdVar.value, '/api/v1');
    });

    test('handles variable server URL with title', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '{server}/api',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      expect(key, 'BASE_URL_PET');
      expect(updated!.values.any((v) => v.key == key), true);
      final createdVar = updated!.values.firstWhere((v) => v.key == key);
      expect(createdVar.value, '{server}/api');
    });

    test('handles full URL with host extraction', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        'https://petstore.swagger.io/v2',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      expect(key, 'BASE_URL_PETSTORE_SWAGGER_IO'); // Should use full host
      expect(updated!.values.any((v) => v.key == key), true);
      final createdVar = updated!.values.firstWhere((v) => v.key == key);
      expect(createdVar.value, 'https://petstore.swagger.io/v2');
    });

    test('handles malformed URL with title fallback', () async {
      final envs = <String, EnvironmentModel>{
        'global':
            const EnvironmentModel(id: 'global', name: 'Global', values: []),
      };
      EnvironmentModel? updated;

      // Use a URL that will fail to parse but is not considered trivial
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        'not-http-or-https://invalid',
        title: 'My Orders Service',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );

      // The URL "not-http-or-https://invalid" will parse and extract "invalid" as host
      expect(key, 'BASE_URL_INVALID');
      expect(updated!.values.any((v) => v.key == key), true);
    });

    test('does not add variable if it already exists (trivial case)', () async {
      final existingVar = EnvironmentVariableModel(
        key: 'BASE_URL_PET',
        value: 'existing value',
        enabled: true,
      );
      final envs = <String, EnvironmentModel>{
        'global': EnvironmentModel(
            id: 'global', name: 'Global', values: [existingVar]),
      };
      bool updateCalled = false;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updateCalled = true;
        },
      );

      expect(key, 'BASE_URL_PET');
      expect(updateCalled, false); // Should not update since variable exists
    });

    test('does not add variable if it already exists (full URL case)',
        () async {
      final existingVar = EnvironmentVariableModel(
        key: 'BASE_URL_PETSTORE_SWAGGER_IO',
        value: 'existing value',
        enabled: true,
      );
      final envs = <String, EnvironmentModel>{
        'global': EnvironmentModel(
            id: 'global', name: 'Global', values: [existingVar]),
      };
      bool updateCalled = false;

      final key = await svc.ensureBaseUrlEnvForOpenApi(
        'https://petstore.swagger.io/v2',
        title: 'Pet Store API',
        readEnvs: () => envs,
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {
          updateCalled = true;
        },
      );

      expect(key, 'BASE_URL_PETSTORE_SWAGGER_IO');
      expect(updateCalled, false);
    });

    test('handles null envModel (trivial case)', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'Pet Store API',
        readEnvs: () => <String, EnvironmentModel>{},
        readActiveEnvId: () => 'nonexistent',
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_PET');
    });

    test('handles null envModel (full URL case)', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        'https://petstore.swagger.io/v2',
        title: 'Pet Store API',
        readEnvs: () => <String, EnvironmentModel>{},
        readActiveEnvId: () => 'nonexistent',
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_PETSTORE_SWAGGER_IO');
    });

    test('handles null envs', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        'https://petstore.swagger.io/v2',
        title: 'Pet Store API',
        readEnvs: () => null,
        readActiveEnvId: () => 'env1',
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_PETSTORE_SWAGGER_IO');
    });
  });

  group('UrlEnvService._slugFromOpenApiTitleFirstWord', () {
    final svc = UrlEnvService();

    test('extracts first word from simple title', () {
      // We can't test private method directly, but we can test it through ensureBaseUrlEnvForOpenApi
      final result = svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'Pet Store API',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      result.then((key) => expect(key, 'BASE_URL_PET'));
    });

    test('handles title with special characters', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'My-Orders Service',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key,
          'BASE_URL_MY_ORDERS'); // First word "My-Orders" -> "MY_ORDERS" (hyphens become underscores)
    });

    test('handles empty title', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: '',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_API'); // Should fallback to API
    });

    test('handles whitespace-only title', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: '   \t\n  ',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_API');
    });

    test('handles title with only special characters', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: '--- ### !!!',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key, 'BASE_URL_API');
    });

    test('handles title with leading/trailing underscores after cleaning',
        () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: '__Test___API__',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key,
          'BASE_URL_TEST_API'); // First word "__Test___API__" -> "TEST_API" (cleaned)
    });

    test('handles multiple consecutive underscores', () async {
      final key = await svc.ensureBaseUrlEnvForOpenApi(
        '',
        title: 'Test___Multiple___Underscores',
        readEnvs: () => <String, EnvironmentModel>{
          'global':
              const EnvironmentModel(id: 'global', name: 'Global', values: []),
        },
        readActiveEnvId: () => null,
        updateEnv: (id, {values}) {},
      );

      expect(key,
          'BASE_URL_TEST_MULTIPLE_UNDERSCORES'); // First word "Test___Multiple___Underscores" -> "TEST_MULTIPLE_UNDERSCORES"
    });
  });
}
