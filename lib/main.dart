import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';
import 'dart:async';
import 'package:apidash/providers/update_provider.dart';

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
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(settingsModel: settingsModel),
        )
      ],
      child: const DashApp(),
    ),
  );
  
  // Check for updates after app launch
  if (kIsDesktop) {
    // Delay update check to ensure app is fully initialized
    Timer(const Duration(seconds: 3), () async {
      try {
        final container = ProviderContainer();
        await container.read(updateCheckProvider.future);
      } catch (e) {
        debugPrint('❌ Error in update check: $e');
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
    debugPrint("initializeUsingPath: $initializeUsingPath");
    debugPrint("workspaceFolderPath: ${settingsModel?.workspaceFolderPath}");
    final openBoxesStatus = await initHiveBoxes(
      initializeUsingPath,
      settingsModel?.workspaceFolderPath,
    );
    debugPrint("openBoxesStatus: $openBoxesStatus");
    if (openBoxesStatus) {
      await autoClearHistory(settingsModel: settingsModel);
    }
    return openBoxesStatus;
  } catch (e) {
    debugPrint("initApp failed due to $e");
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
