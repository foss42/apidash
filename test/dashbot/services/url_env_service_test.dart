import 'package:apidash/dashbot/core/services/base/url_env_service.dart';
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
    test('invalid returns empty', () {
      expect(svc.inferBaseUrl('not a url'), '');
    });
  });

  group('UrlEnvService.ensureBaseUrlEnv & maybeSubstituteBaseUrl', () {
    final svc = UrlEnvService();
    final envId = 'env1';
    final envs = <String, EnvironmentModel>{
      envId: const EnvironmentModel(id: 'env1', name: 'Env1', values: []),
    };
    String? activeId = envId;
    EnvironmentModel? updated;

    test('ensure adds variable if missing and returns key', () async {
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

    test('maybeSubstituteBaseUrl replaces prefix with variable', () async {
      final key = await svc.ensureBaseUrlEnv(
        'https://api.apidash.dev',
        readEnvs: () => envs,
        readActiveEnvId: () => activeId,
        updateEnv: (id, {values}) {
          updated = envs[id]!.copyWith(values: values ?? const []);
          envs[id] = updated!;
        },
      );
      final replaced = await svc.maybeSubstituteBaseUrl(
        'https://api.apidash.dev/v1/users',
        'https://api.apidash.dev',
        ensure: (_) async => key,
      );
      expect(replaced, '{{$key}}/v1/users');
    });
  });
}
