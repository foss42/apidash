// ignore_for_file: use_build_context_synchronously

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'widgets/widgets.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'consts.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then((value) {
      ref.read(settingsProvider.notifier).update(size: value);
    });
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowMoved() {
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      final shouldPrompt = ref.watch(settingsProvider.select((v) => v.promptBeforeClosing));
      final hasChanges = ref.watch(hasUnsavedChangesProvider);

      if (shouldPrompt && hasChanges) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Save Changes'),
            content: const Text('Want to save changes before you close API Dash?'),
            actions: [
              OutlinedButton(
                child: const Text('No'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
              FilledButton(
                child: const Text('Save'),
                onPressed: () async {
                  await ref.read(collectionStateNotifierProvider.notifier).saveData();
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          ),
        );
      } else {
        await windowManager.destroy();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow ? const MobileDashboard() : const Dashboard();
  }
}

class DashApp extends ConsumerWidget {
  const DashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the Dark Mode setting from the provider
    final isDarkMode = ref.watch(settingsProvider.select((value) => value.isDark));
    final workspaceFolderPath = ref.watch(settingsProvider.select((value) => value.workspaceFolderPath));
    final showWorkspaceSelector = kIsDesktop && (workspaceFolderPath == null);
    final userOnboarded = ref.watch(userOnboardedProvider);

    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Applies themes from the design system
        theme: kLightMaterialAppTheme,
        darkTheme: kDarkMaterialAppTheme,
        // Toggles the theme mode based on user settings
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: showWorkspaceSelector
            ? WorkspaceSelector(
                onContinue: (val) async {
                  await initHiveBoxes(kIsDesktop, val);
                  ref.read(settingsProvider.notifier).update(workspaceFolderPath: val);
                },
                onCancel: () async {
                  try {
                    await windowManager.destroy();
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
              )
            : Stack(
                children: [
                  // Main Application UI
                  !kIsLinux && !kIsMobile
                      ? const App()
                      : context.isMediumWindow
                          ? (kIsMobile && !userOnboarded)
                              ? OnboardingScreen(
                                  onComplete: () async {
                                    await setOnboardingStatusToSharedPrefs(isOnboardingComplete: true);
                                    ref.read(userOnboardedProvider.notifier).state = true;
                                  },
                                )
                              : const MobileDashboard()
                          : const Dashboard(),

                  // Windows Title Bar Theme Support
                  if (kIsWindows)
                    SizedBox(
                      height: 32, // Standard height for window caption
                      child: WindowCaption(
                        backgroundColor: Colors.transparent,
                        brightness: isDarkMode ? Brightness.dark : Brightness.light,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
