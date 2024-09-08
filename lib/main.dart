import 'package:apidash/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'consts.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsModel = await getSettingsFromSharedPrefs();
  await initApp(settingsModel: settingsModel);
  if (kIsDesktop) {
    await initWindow(settingsModel: settingsModel);
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

Future<void> initApp({SettingsModel? settingsModel}) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await openBoxes(
    kIsDesktop,
    settingsModel?.workspaceFolderPath,
  );
  await autoClearHistory(settingsModel: settingsModel);
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
