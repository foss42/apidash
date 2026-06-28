import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

const String kLatestReleaseApiUrl =
    'https://api.github.com/repos/foss42/apidash/releases/latest';
const String kReleasesUrl = 'https://github.com/foss42/apidash/releases';

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.isUpdateAvailable,
    required this.latestVersion,
    required this.releaseUrl,
  });

  final bool isUpdateAvailable;
  final String latestVersion;
  final String releaseUrl;
}

String normalizeVersion(String version) {
  final trimmed = version.trim();
  return trimmed.startsWith('v') ? trimmed.substring(1) : trimmed;
}

/// Returns `true` when [latest] is a strictly newer semantic version than
/// [current]. A leading `v` (e.g. `v0.5.0`) is tolerated. Returns `false`
/// for any unparseable input so the caller never surfaces a false positive.
bool isUpdateAvailable(String current, String latest) {
  try {
    return Version.parse(normalizeVersion(latest)) >
        Version.parse(normalizeVersion(current));
  } catch (_) {
    return false;
  }
}

/// Fetches the latest GitHub release and compares it with [currentVersion].
/// Returns `null` on any network or parsing error so the check can fail
/// silently without disturbing the user.
Future<AppUpdateInfo?> checkForUpdate(
  String currentVersion, {
  http.Client? client,
}) async {
  final httpClient = client ?? http.Client();
  try {
    final response = await httpClient
        .get(Uri.parse(kLatestReleaseApiUrl))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final tag = data['tag_name'] as String?;
    if (tag == null) return null;
    return AppUpdateInfo(
      isUpdateAvailable: isUpdateAvailable(currentVersion, tag),
      latestVersion: normalizeVersion(tag),
      releaseUrl: (data['html_url'] as String?) ?? kReleasesUrl,
    );
  } catch (_) {
    return null;
  } finally {
    if (client == null) httpClient.close();
  }
}
