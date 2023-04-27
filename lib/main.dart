import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'consts.dart' show kFontFamily, kFontFamilyFallback, kColorSchemeSeed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openBoxes();
  var win = getInitialSize();
  await setupWindow(sz: win.$0, off: win.$1);
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then((value) {
      ref.read(settingsProvider.notifier).update(size: value);
    });
  }

  @override
  void onWindowMoved() async {
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

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
      home: const HomePage(),
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }
}
