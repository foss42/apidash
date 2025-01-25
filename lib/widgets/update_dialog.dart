import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/update_provider.dart';
import 'dart:io';

class UpdateDialog extends ConsumerWidget {
  final Map<String, dynamic> updateInfo;

  const UpdateDialog({super.key, required this.updateInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String getPlatformAsset() {
      final assets = updateInfo['assets'] as List;
      String pattern = '';
      
      if (Platform.isWindows) {
        pattern = 'windows-x86_64.exe';
      } else if (Platform.isLinux) {
        pattern = 'linux-amd64.deb';
      } else if (Platform.isMacOS) {
        pattern = 'macos-x86_64.dmg';
      } else if (Platform.isAndroid) {
        final playStoreUrl = updateInfo['playStoreUrl'];
        if (playStoreUrl != null) {
          return playStoreUrl;
        }
        // Fallback to .apk if Play Store URL not available
        pattern = 'android-arm64.apk';
      } else if (Platform.isIOS) {
        final appStoreUrl = updateInfo['appStoreUrl'];
        if (appStoreUrl != null) {
          return appStoreUrl;
        }
        // Fallback to .ipa if App Store URL not available
        pattern = 'ios-universal.ipa';
      }
      
      final asset = assets.firstWhere(
        (asset) => asset['browser_download_url'].toString().contains(pattern),
        orElse: () => null,
      );
      return asset?['browser_download_url'] ?? '';
    }

    return Theme(
      data: ThemeData.dark(),
      child: AlertDialog(
        title: const Text('Update Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A new version (${updateInfo['latestVersion']}) is available.'),
            const SizedBox(height: 8),
            Text('Current version: ${updateInfo['currentVersion']}'),
            const SizedBox(height: 16),
            const Text('Release Notes:'),
            Text(updateInfo['releaseNotes'] ?? 'No release notes available.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(updateProvider).skipVersion(updateInfo['latestVersion']);
              Navigator.of(context).pop();
            },
            child: const Text('Skip This Version'),
          ),
          ElevatedButton(
            onPressed: () async {
              final downloadUrl = getPlatformAsset();
              if (downloadUrl.isNotEmpty) {
                await ref.read(updateProvider).downloadAndInstallUpdate(downloadUrl);
              }
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }
}
