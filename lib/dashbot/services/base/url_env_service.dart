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

  /// Ensure (or create) an environment variable for a base URL coming from an
  /// OpenAPI spec import. If the spec had no concrete host (thus parsing the
  /// base URL yields no host) we derive a key using the first word of the spec
  /// title to avoid every unrelated spec collapsing to BASE_URL_API.
  ///
  /// Behaviour:
  /// - If [baseUrl] is empty: returns a derived key `BASE_URL_<TITLEWORD>` but
  ///   does NOT create an env var (there is no value to store yet).
  /// - If [baseUrl] has a host: behaves like [ensureBaseUrlEnv]. If the host
  ///   itself cannot be determined, it substitutes the first title word slug.
  Future<String> ensureBaseUrlEnvForOpenApi(
    String baseUrl, {
    required String title,
    required Map<String, EnvironmentModel>? Function() readEnvs,
    required String? Function() readActiveEnvId,
    required void Function(String id, {List<EnvironmentVariableModel>? values})
        updateEnv,
  }) async {
    // Derive slug from title's first word upfront (used as fallback)
    final titleSlug = _slugFromOpenApiTitleFirstWord(title);
    final trimmedBase = baseUrl.trim();
    final isTrivial = trimmedBase.isEmpty ||
        trimmedBase == '/' ||
        // path-only or variable server (no scheme and no host component)
        (!trimmedBase.startsWith('http://') &&
            !trimmedBase.startsWith('https://') &&
            !trimmedBase.contains('://'));
    if (isTrivial) {
      final key = 'BASE_URL_$titleSlug';

      final envs = readEnvs();
      String? activeId = readActiveEnvId();
      activeId ??= kGlobalEnvironmentId;
      final envModel = envs?[activeId];
      if (envModel != null) {
        final exists = envModel.values.any((v) => v.key == key);
        if (!exists) {
          final values = [...envModel.values];
          values.add(
            EnvironmentVariableModel(
              key: key,
              value: trimmedBase == '/' ? '' : trimmedBase,
              enabled: true,
            ),
          );
          updateEnv(activeId, values: values);
        }
      }
      return key;
    }

    String host = 'API';
    try {
      final u = Uri.parse(baseUrl);
      if (u.hasAuthority && u.host.isNotEmpty) host = u.host;
    } catch (_) {}

    // If host could not be determined (remains 'API'), use title-based slug.
    final slug = (host == 'API')
        ? titleSlug
        : host
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

  /// Build a slug from the first word of an OpenAPI spec title.
  /// Example: "Pet Store API" -> "PET"; "  My-Orders Service" -> "MY".
  /// Falls back to 'API' if no alphanumeric characters are present.
  String _slugFromOpenApiTitleFirstWord(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return 'API';
    // Split on whitespace, take first non-empty token
    final firstToken = trimmed.split(RegExp(r'\s+')).firstWhere(
          (t) => t.trim().isNotEmpty,
          orElse: () => 'API',
        );
    final cleaned = firstToken
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '')
        .toUpperCase();
    return cleaned.isEmpty ? 'API' : cleaned;
  }
}
