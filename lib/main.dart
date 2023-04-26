import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/providers.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'consts.dart' show kFontFamily, kFontFamilyFallback, kColorSchemeSeed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openBoxes();
  Size? sz = getInitialSize();
  await setupInitialWindow(sz);
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

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    Size sz = WidgetsBinding.instance.window.physicalSize;
    double dpr = WidgetsBinding.instance.window.devicePixelRatio;
    ref.read(settingsProvider.notifier).update(size: sz / dpr);
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
