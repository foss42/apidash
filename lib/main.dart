import 'dart:io';
import 'dart:math' as math;
import 'package:apidash/providers/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/services.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      window_size.getWindowInfo().then((window) {
        final screen = window.screen;
        if (screen != null) {
          final screenFrame = screen.visibleFrame;
          final width =
              math.max((screenFrame.width / 2).roundToDouble(), 1200.0);
          final height =
              math.max((screenFrame.height / 2).roundToDouble(), 800.0);
          final left = ((screenFrame.width - width) / 2).roundToDouble();
          final top = ((screenFrame.height - height) / 3).roundToDouble();
          final frame = Rect.fromLTWH(left, top, width, height);
          window_size.setWindowFrame(frame);
          window_size.setWindowMinSize(const Size(900, 600));
          window_size.setWindowMaxSize(Size.infinite);
          window_size.setWindowTitle("API Dash");
        }
      });
    }
  }
  await openBoxes();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeStateProvider);
    theme.themeMode ??= ThemeMode.system == Brightness.light ? true : false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        colorSchemeSeed: theme.primaryColor,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        colorSchemeSeed: theme.primaryColor,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: theme.themeMode != null
          ? theme.themeMode!
              ? ThemeMode.light
              : ThemeMode.dark
          : ThemeMode.system,
      home: const HomePage(),
    );
  }
}
