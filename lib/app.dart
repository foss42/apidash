import 'dart:developer' as developer;

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

  Future<void> _init() async {
    try {
      await windowManager.setPreventClose(true);
    } catch (e) {
      developer.log('Failed to set prevent close: $e', name: 'App');
    }
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
    final bool isPreventClose = await windowManager.isPreventClose();
    if (!mounted) return;
    if (isPreventClose) {
      final promptBeforeClosing =
          ref.read(settingsProvider).promptBeforeClosing;
      final hasUnsaved = ref.read(hasUnsavedChangesProvider);
      if (promptBeforeClosing && hasUnsaved) {
        final navigator = Navigator.of(context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Save Changes'),
            content:
                const Text('Want to save changes before you close API Dash?'),
            actions: [
              OutlinedButton(
                child: const Text('No'),
                onPressed: () async {
                  navigator.pop();
                  await windowManager.setPreventClose(false);
                  await windowManager.close();
                },
              ),
              FilledButton(
                child: const Text('Save'),
                onPressed: () async {
                  await ref
                      .read(collectionStateNotifierProvider.notifier)
                      .saveData();
                  navigator.pop();
                  await windowManager.setPreventClose(false);
                  await windowManager.close();
                },
              ),
            ],
          ),
        );
      } else {
        await windowManager.setPreventClose(false);
        await windowManager.close();
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
                    developer.log(
                      'Failed to destroy window: $e',
                      name: 'DashApp',
                    );
                  }
                },
              )
            : !kIsLinux && !kIsMobile
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
      ),
    );
  }
}
