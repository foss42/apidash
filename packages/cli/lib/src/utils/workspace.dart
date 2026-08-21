import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

String? detectWorkspacePath() {
  try {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null) return null;

    final configPath = Platform.isLinux 
        ? p.join(home, '.local', 'share', 'com.example.apidash', 'shared_preferences.json')
        : (Platform.isMacOS 
            ? p.join(home, 'Library', 'Application Support', 'com.example.apidash', 'shared_preferences.json')
            : null);

    if (configPath != null && File(configPath).existsSync()) {
      final content = File(configPath).readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final settingsStr = json['flutter.apidash-settings'] as String?;
      
      if (settingsStr != null) {
        final settings = jsonDecode(settingsStr) as Map<String, dynamic>;
        return settings['workspaceFolderPath'] as String?;
      }
    }
  } catch (_) {}
  return null;
}

String getDefaultDataDir() {
  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  if (home == null) return './test-hive-storage';

  if (Platform.isLinux) {
    return p.join(home, '.local', 'share', 'apidash');
  } else if (Platform.isMacOS) {
    return p.join(home, 'Library', 'Application Support', 'apidash');
  } else if (Platform.isWindows) {
    return p.join(Platform.environment['APPDATA'] ?? home, 'apidash');
  }
  
  return './test-hive-storage';
}
