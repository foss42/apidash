import 'dart:io';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Data class for passing information to isolate
class _IsolateUpdateData {
  final SendPort sendPort;
  final String currentVersion;

  _IsolateUpdateData({
    required this.sendPort,
    required this.currentVersion,
  });
}

class UpdateService {
  static const String _githubApiUrl = 'https://api.github.com/repos/foss42/apidash/releases/latest';
  static const String _skipVersionKey = 'skipped_version';
  
  Future<Map<String, dynamic>?> checkForUpdate() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      // Use isolate to fetch and process update information
      final updateInfo = await _checkForUpdateInIsolate(currentVersion);
      
      return updateInfo;
    } catch (e) {
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> _checkForUpdateInIsolate(String currentVersion) async {
    final receivePort = ReceivePort();
    
    // Create isolate and pass data
    final isolate = await Isolate.spawn(
      _isolateUpdateChecker, 
      _IsolateUpdateData(
        sendPort: receivePort.sendPort,
        currentVersion: currentVersion,
      ),
    );
    
    final result = await receivePort.first as Map<String, dynamic>?;
    
    receivePort.close();
    isolate.kill();
    
    return result;
  }
  
  // Static method to run in isolate
  static void _isolateUpdateChecker(_IsolateUpdateData data) async {
    try {
      // Fetch latest release from GitHub using Dio
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'APIDash';
      final response = await dio.get(_githubApiUrl);
      
      Map<String, dynamic>? result;
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        final latestVersion = responseData['tag_name'].toString().replaceAll('v', '');
        
        final isUpdateAvailable = _isolateShouldUpdate(data.currentVersion, latestVersion);
        
        if (isUpdateAvailable) {
          result = {
            'currentVersion': data.currentVersion,
            'latestVersion': latestVersion,
            'assets': responseData['assets'],
            'releaseNotes': responseData['body'] ?? 'No release notes available.',
          };
        }
      }
      
      data.sendPort.send(result);
    } catch (e) {
      data.sendPort.send(null);
    } finally {
      Isolate.exit();
    }
  }

  bool _shouldUpdate(String currentVersion, String latestVersion) {
    return _isolateShouldUpdate(currentVersion, latestVersion);
  }
  
  // Static version of _shouldUpdate to use in isolate
  static bool _isolateShouldUpdate(String currentVersion, String latestVersion) {
    final current = currentVersion.split('.').map(int.parse).toList();
    final latest = latestVersion.split('.').map(int.parse).toList();
    
    // Compare major version
    if (latest[0] > current[0]) {
      return true;
    } else if (latest[0] < current[0]) {
      return false;
    }
    
    // Compare minor version
    if (latest[1] > current[1]) {
      return true;
    } else if (latest[1] < current[1]) {
      return false;
    }
    
    // Compare patch version
    if (latest[2] > current[2]) {
      return true;
    }
    
    return false;
  }

  Future<void> skipVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_skipVersionKey, version);
  }

  Future<void> downloadAndInstallUpdate(String downloadUrl) async {
    if (Platform.isWindows) {
      final uri = Uri.parse(downloadUrl);
      await launchUrl(uri);
    } else if (Platform.isLinux) {
      final uri = Uri.parse(downloadUrl);
      await launchUrl(uri);
    } else if (Platform.isMacOS) {
      final uri = Uri.parse(downloadUrl);
      await launchUrl(uri);
    }
  }
}
