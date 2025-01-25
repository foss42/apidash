import 'package:apidash/providers/update_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';
import 'widgets/update_dialog.dart';
import 'dart:async';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var settingsModel = await getSettingsFromSharedPrefs();
  final initStatus = await initApp(
    kIsDesktop,
    settingsModel: settingsModel,
  );
  if (kIsDesktop) {
    await initWindow(settingsModel: settingsModel);
  }
  if (!initStatus) {
    settingsModel = settingsModel?.copyWithPath(workspaceFolderPath: null);
  }

  runApp(
    Builder(
      builder: (context) {
        navigatorKey = GlobalKey<NavigatorState>();
        return MaterialApp(
          navigatorKey: navigatorKey,
          home: ProviderScope(
            overrides: [
              settingsProvider.overrideWith(
                (ref) => ThemeStateNotifier(settingsModel: settingsModel),
              )
            ],
            child: const DashApp(),
          ),
        );
      },
    ),
  );

  // Check for updates after app launch
  if (kIsDesktop) {
    // Delay update check to ensure app is fully initialized
    Timer(const Duration(seconds: 3), () async {
      try {
        final container = ProviderContainer();
        final updateInfo = await container.read(updateCheckProvider.future);        
        if (updateInfo != null) {
          if (navigatorKey.currentContext != null) {
            showDialog(
              context: navigatorKey.currentContext!,
              builder: (context) => ProviderScope(
                child: UpdateDialog(updateInfo: updateInfo),
              ),
            );
          }
        }
      } catch (e) {
        throw('❌ Error in update check: $e');
      }
    });
  }
}

Future<bool> initApp(
  bool initializeUsingPath, {
  SettingsModel? settingsModel,
}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  try {
    final openBoxesStatus = await initHiveBoxes(
      initializeUsingPath,
      settingsModel?.workspaceFolderPath,
    );
    if (openBoxesStatus) {
      await autoClearHistory(settingsModel: settingsModel);
    }
    return openBoxesStatus;
  } catch (e) {
    return false;
  }
}

Future<void> initWindow({
  Size? sz,
  SettingsModel? settingsModel,
}) async {
  if (kIsLinux) {
    await setupInitialWindow(
      sz: sz ?? settingsModel?.size,
    );
  }
  if (kIsMacOS || kIsWindows) {
    if (sz != null) {
      await setupWindow(
        sz: sz,
        off: const Offset(100, 100),
      );
    } else {
      await setupWindow(
        sz: settingsModel?.size,
        off: settingsModel?.offset,
      );
    }
  }
}
