// ignore_for_file: use_build_context_synchronously

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/widgets.dart'
    show WindowCaption, WorkspaceSelector, WindowListenerWrapper;
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'consts.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WindowListenerWrapper(
      child:
          context.isMediumWindow ? const MobileDashboard() : const Dashboard(),
    );
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
                    await destroyWindow();
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
