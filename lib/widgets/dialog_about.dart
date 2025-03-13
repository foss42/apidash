import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/providers/update_provider.dart';
import 'package:apidash/widgets/widgets.dart';

showAboutAppDialog(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final isUpdateAvailable = ref.watch(updateAvailableProvider);
            final updateInfo = ref.watch(updateCheckProvider).valueOrNull;
            
            return AlertDialog(
              contentPadding: kPt20 + kPh20 + kPb10,
              content: Container(
                width: double.infinity,
                height: double.infinity,
                constraints: const BoxConstraints(maxWidth: 540, maxHeight: 544),
                child: const IntroMessage(),
              ),
              actions: [
                if (isUpdateAvailable && updateInfo != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: Text("Update to ${updateInfo['latestVersion'].replaceAll(RegExp(r'<[^>]*>'), '')}"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      // Get download URL from assets
                      final assets = updateInfo['assets'] as List;
                      if (assets.isNotEmpty) {
                        String downloadUrl = '';
                        
                        // Find the appropriate asset for the current platform
                        for (var asset in assets) {
                          final name = asset['name'] as String;
                          if (name.endsWith('.exe')) {
                            downloadUrl = asset['browser_download_url'];
                            break;
                          }
                        }
                        
                        if (downloadUrl.isNotEmpty) {
                          await launchUrl(Uri.parse(downloadUrl));
                        }
                      }
                    },
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          }
        );
      });
}
