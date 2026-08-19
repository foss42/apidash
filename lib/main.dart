import 'dart:async';
import 'dart:convert';

import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stac/stac.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';
import 'dart:io';
import 'mcp/mcp_service.dart';

void main(List<String> args) async {
  // Check if external client is calling us in headless mode
  if (args.contains('--mcp-engine')) {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Get the standard app directory
    final docDir = await getApplicationDocumentsDirectory();

    // 2. Create a dedicated folder just for the AI Agent
    final agentPath = p.join(docDir.path, 'apidash', 'agent_workspace');
    final agentDir = Directory(agentPath);
    if (!await agentDir.exists()) {
      await agentDir.create(recursive: true);
    }

    // 3. Initialize Hive in this isolated folder
    Hive.init(agentPath);

    // 4. Open a custom history box for the agent
    await Hive.openBox('agent_history');

    // 5. Start the engine safely
    await mcpService.startHeadless();
    return;
  }

  // --- OTHERWISE, BOOT REGULAR FLUTTER GUI ---
  WidgetsFlutterBinding.ensureInitialized();
  await Stac.initialize();

  //Load all LLMs
  await ModelManager.fetchAvailableModels();

  var settingsModel = await getSettingsFromSharedPrefs();
  var onboardingStatus = await getOnboardingStatusFromSharedPrefs();
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
