// ignore_for_file: use_build_context_synchronously

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide WindowCaption;
import 'widgets/widgets.dart' show WindowCaption, WorkspaceSelector;
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
    try {
    await windowManager.setPreventClose(true);
  } catch (e) {
    debugPrint('setPreventClose failed: $e');
  }
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
  final shouldPrompt =
      ref.read(settingsProvider.select((v) => v.promptBeforeClosing));
  final hasUnsaved = ref.read(hasUnsavedChangesProvider);
  if (shouldPrompt && hasUnsaved) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text(
          'Do you want to save your workspace before closing API Dash?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await windowManager.setPreventClose(false);
              } catch (e) {
                debugPrint('setPreventClose(false) failed: $e');
              }
              await windowManager.destroy();
            },
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref
                    .read(collectionStateNotifierProvider.notifier)
                    .saveData();
              } catch (e) {
                final sm = ScaffoldMessenger.of(context);
                sm.hideCurrentSnackBar();
                sm.showSnackBar(SnackBar(content: Text('Save failed: $e')));
                debugPrint('saveData failed: $e');
                return; 
              }

              Navigator.of(context).pop();
              try {
                await windowManager.setPreventClose(false);
              } catch (e) {
                debugPrint('setPreventClose(false) failed: $e');
              }
              await windowManager.destroy();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  } else {
    try {
      await windowManager.setPreventClose(false);
    } catch (e) {
      debugPrint('setPreventClose(false) failed: $e');
    }
    await windowManager.destroy();
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
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    final workspaceFolderPath = ref
        .watch(settingsProvider.select((value) => value.workspaceFolderPath));
    final showWorkspaceSelector = kIsDesktop && (workspaceFolderPath == null);
    final userOnboarded = ref.watch(userOnboardedProvider);
    return Portal(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: kLightMaterialAppTheme,
        darkTheme: kDarkMaterialAppTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: showWorkspaceSelector
            ? WorkspaceSelector(
                onContinue: (val) async {
                  await initHiveBoxes(kIsDesktop, val);
                  ref
                      .read(settingsProvider.notifier)
                      .update(workspaceFolderPath: val);
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
                  !kIsLinux && !kIsMobile
                      ? const App()
                      : context.isMediumWindow
                          ? (kIsMobile && !userOnboarded)
                              ? OnboardingScreen(
                                  onComplete: () async {
                                    await setOnboardingStatusToSharedPrefs(
                                      isOnboardingComplete: true,
                                    );
                                    ref
                                        .read(userOnboardedProvider.notifier)
                                        .state = true;
                                  },
                                )
                              : const MobileDashboard()
                          : const Dashboard(),
                  if (kIsWindows)
                    SizedBox(
                      height: 29,
                      child: WindowCaption(
                        backgroundColor: Colors.transparent,
                        brightness:
                            isDarkMode ? Brightness.dark : Brightness.light,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
