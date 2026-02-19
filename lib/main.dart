import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/ui/ui_design_system.dart';
import 'package:apidash_design_system/ui/zoom_controller.dart';
import 'package:apidash_design_system/ui/zoom_in.dart';
import 'package:apidash_design_system/ui/zoom_out.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final zoomController = ZoomController();

runApp(
  AnimatedBuilder(
    animation: zoomController,
    builder: (context, _) {
      return ProviderScope(
        child: Builder(
          builder: (context) {
            final width = MediaQuery.of(context).size.width;

            final designSystem = UIDesignSystem.fromScreenWidth(
              width,
              zoom: zoomController.zoom,
            );

            return Shortcuts(
              shortcuts: <LogicalKeySet, Intent>{
                LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.equal): const ZoomInIntent(),
                LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpadAdd): const ZoomInIntent(),
                LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.minus): const ZoomOutIntent(),
                LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.numpadSubtract): const ZoomOutIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  ZoomInIntent: CallbackAction<ZoomInIntent>(
                    onInvoke: (intent) {
                      zoomController.zoomIn();
                      return null;
                    },
                  ),
                  ZoomOutIntent: CallbackAction<ZoomOutIntent>(
                    onInvoke: (intent) {
                      zoomController.zoomOut();
                      return null;
                    },
                  ),
                },
                child: DesignSystemProvider(
                  designSystem: designSystem,
                  child: const DashApp(),
                ),
              ),
            );
          },
        ),
      );
    },
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
