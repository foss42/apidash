// ignore_for_file: use_build_context_synchronously

import 'package:apidash/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide WindowCaption;
import 'widgets/widgets.dart' show WindowCaption;
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    // Add this line to override the default close handler
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
    final l10n = AppLocalizations.of(context);
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (ref.watch(
          settingsProvider.select((value) => value.promptBeforeClosing))) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n!.kSaveChanges),
            content: Text(l10n.kSaveChangesSubtitle),
            actions: [
              OutlinedButton(
                child: Text(l10n.kLabelNo),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
              FilledButton(
                child: Text(l10n.kLabelSave),
                onPressed: () async {
                  await ref
                      .read(collectionStateNotifierProvider.notifier)
                      .saveData();
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
    return const Dashboard();
  }
}

class DashApp extends ConsumerWidget {
  const DashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: L10n.delegates,
      supportedLocales: L10n.supportedLocales,
      locale: Locale(ref.watch(defaultLocaleStateProvider)),
      theme: ThemeData(
        fontFamily: kFontFamily,
        fontFamilyFallback: kFontFamilyFallback,
        colorSchemeSeed: kColorSchemeSeed,
        useMaterial3: true,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        fontFamily: kFontFamily,
        fontFamilyFallback: kFontFamilyFallback,
        colorSchemeSeed: kColorSchemeSeed,
        useMaterial3: true,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: kIsMobile
          ? const MobileDashboard(
              title: 'Requests',
              scaffoldBody: CollectionPane(),
            )
          : Stack(
              children: [
                kIsLinux ? const Dashboard() : const App(),
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
    );
  }
}
