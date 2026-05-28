import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stac/stac.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Stac.initialize();

  //Load all LLMs
  await ModelManager.fetchAvailableModels();

  final recentPath = await readRecentWorkspacePath();
  var settingsModel = SettingsModel(workspaceFolderPath: recentPath);
  var onboardingStatus = false;

  final initStatus = await initApp(
    kIsDesktop,
    settingsModel: settingsModel,
  );
  if (initStatus) {
    final appSnapshot = await AppSettingsStore.instance.load();
    settingsModel = appSnapshot.settings ?? settingsModel;
    onboardingStatus = appSnapshot.onboardingComplete;
  }
  if (kIsDesktop) {
    await initWindow(settingsModel: settingsModel);
  }
  if (!initStatus) {
    await clearRecentWorkspacePath();
    settingsModel = settingsModel.copyWithPath(workspaceFolderPath: null);
  }

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(settingsModel: settingsModel),
        ),
        userOnboardedProvider.overrideWith((ref) => onboardingStatus),
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
    final workspaceReady = await initWorkspaceStorage(
      initializeUsingPath,
      settingsModel?.workspaceFolderPath,
    );
    debugPrint("workspaceReady: $workspaceReady");
    if (workspaceReady) {
      await autoClearHistory(settingsModel: settingsModel);
    }
    return workspaceReady;
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
