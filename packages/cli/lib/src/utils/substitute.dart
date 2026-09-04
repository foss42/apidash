import 'package:better_networking/better_networking.dart';

/// Minimal `{{key}}` environment-variable substitution for the CLI.
///
/// ponytail: naive `{{key}}` token replacement only — no secrets, no
/// active-env/global merging, no escaping of literal braces. Unknown tokens
/// are left untouched. Upgrade path: extract the app's `substituteVariables`
/// (lib/utils/envvar_utils.dart) into apidash_core and call that here.
String substitute(String input, Map<String, String> vars) {
  var out = input;
  vars.forEach((k, v) => out = out.replaceAll('{{$k}}', v));
  return out;
}

/// Applies `{{key}}` substitution to a request's url, header names/values and
/// body before sending. (params/formData/auth intentionally not covered — see
/// the ceiling on [substitute].)
HttpRequestModel applyEnv(HttpRequestModel model, Map<String, String> vars) {
  if (vars.isEmpty) return model;
  return model.copyWith(
    url: substitute(model.url, vars),
    headers: model.headers
        ?.map((h) => h.copyWith(
              name: substitute(h.name, vars),
              value: h.value is String ? substitute(h.value, vars) : h.value,
            ))
        .toList(),
    body: model.body == null ? null : substitute(model.body!, vars),
  );
}

/// Builds a `{key: value}` map from a stored environment map
/// (EnvironmentModel.toJson shape). Includes only enabled, non-secret
/// variables — matching the desktop app's substitution map.
Map<String, String> envVarMap(Map<String, dynamic> env) {
  final out = <String, String>{};
  for (final v in (env['values'] as List? ?? const [])) {
    final m = v as Map;
    if (m['enabled'] == true && m['type'] != 'secret') {
      out[m['key'].toString()] = (m['value'] ?? '').toString();
    }
  }
  return out;
}
