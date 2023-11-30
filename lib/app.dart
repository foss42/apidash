import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart' hide WindowCaption;
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'consts.dart'
    show kFontFamily, kFontFamilyFallback, kColorSchemeSeed, kIsWindows;
import 'widgets/window_caption.dart';

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
  Widget build(BuildContext context) {
    return const DashApp();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}

class DashApp extends ConsumerStatefulWidget {
  const DashApp({super.key});

  @override
  ConsumerState<DashApp> createState() => _DashAppState();
}

class _DashAppState extends ConsumerState<DashApp> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: kFontFamily,
        fontFamilyFallback: kFontFamilyFallback,
        colorSchemeSeed: kColorSchemeSeed,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: kFontFamily,
        fontFamilyFallback: kFontFamilyFallback,
        colorSchemeSeed: kColorSchemeSeed,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Stack(
        children: [
          Dashboard(),
          if (kIsWindows)
            SizedBox(
              width: double.infinity,
              height: 28,
              child: WindowCaption(
                brightness: isDarkMode ? Brightness.dark : Brightness.light,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }
}
