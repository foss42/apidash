import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart';
import 'models/models.dart';
import 'models/oauth_config_model.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage for OAuth configs and credentials
  const secureStorage = FlutterSecureStorage();
  
  // Set minimum window size
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(800, 600),
    title: "API Dash",
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

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
