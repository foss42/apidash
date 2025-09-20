import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

class UrlEnvService {
  String inferBaseUrl(String url) {
    try {
      final u = Uri.parse(url);
      if (u.hasScheme && u.host.isNotEmpty) {
        final portPart = (u.hasPort && u.port != 0) ? ':${u.port}' : '';
        return '${u.scheme}://${u.host}$portPart';
      }
    } catch (_) {}
    final m = RegExp(r'^(https?:\/\/[^\/]+)').firstMatch(url);
    return m?.group(1) ?? '';
  }

  Future<String> ensureBaseUrlEnv(
    String baseUrl, {
    required Map<String, EnvironmentModel>? Function() readEnvs,
    required String? Function() readActiveEnvId,
    required void Function(String id, {List<EnvironmentVariableModel>? values})
        updateEnv,
  }) async {
    if (baseUrl.isEmpty) return 'BASE_URL';
    String host = 'API';
    try {
      final u = Uri.parse(baseUrl);
      if (u.hasAuthority && u.host.isNotEmpty) host = u.host;
    } catch (_) {}
    final slug = host
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .toUpperCase();
    final key = 'BASE_URL_$slug';

    final envs = readEnvs();
    String? activeId = readActiveEnvId();
    activeId ??= kGlobalEnvironmentId;
    final envModel = envs?[activeId];

    if (envModel != null) {
      final exists = envModel.values.any((v) => v.key == key);
      if (!exists) {
        final values = [...envModel.values];
        values.add(EnvironmentVariableModel(
          key: key,
          value: baseUrl,
          enabled: true,
        ));
        updateEnv(activeId, values: values);
      }
    }
    return key;
  }

  Future<String> maybeSubstituteBaseUrl(
    String url,
    String baseUrl, {
    required Future<String> Function(String baseUrl) ensure,
  }) async {
    if (baseUrl.isEmpty || !url.startsWith(baseUrl)) return url;
    final key = await ensure(baseUrl);
    final path = url.substring(baseUrl.length);
    final normalized = path.startsWith('/') ? path : '/$path';
    return '{{$key}}$normalized';
  }
}
