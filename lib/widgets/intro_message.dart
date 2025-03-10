import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/update_provider.dart';
import '../consts.dart';
import 'markdown.dart';
import 'error_message.dart';

class IntroMessage extends ConsumerWidget {
  const IntroMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late String text;
    late final String version;
    final isUpdateAvailable = ref.watch(updateAvailableProvider);
    final updateInfo = ref.watch(updateCheckProvider).valueOrNull;
    String? latestVersion;
    
    if (isUpdateAvailable && updateInfo != null) {
      latestVersion = updateInfo['latestVersion']?.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    Future<void> introData() async {
      text = await rootBundle.loadString(kAssetIntroMd);
      version = (await PackageInfo.fromPlatform()).version;
    }

    return FutureBuilder(
      future: introData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return const ErrorMessage(message: "An error occured");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (Theme.of(context).brightness == Brightness.dark) {
            text = text.replaceAll("{{mode}}", "dark");
          } else {
            text = text.replaceAll("{{mode}}", "light");
          }

          if (isUpdateAvailable && latestVersion != null) {
            // Replace version with sanitized version and update button
            final versionWithUpdate = '$version [Update to $latestVersion available]';
            text = text.replaceAll("{{version}}", versionWithUpdate);
          } else {
            text = text.replaceAll("{{version}}", version);
          }

          return CustomMarkdown(
            data: text,
            padding: EdgeInsets.zero,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
