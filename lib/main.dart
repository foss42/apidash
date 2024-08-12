import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/services.dart';
import 'consts.dart' show kIsLinux, kIsMacOS, kIsWindows;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initApp();
  await initWindow();

  runApp(
    const ProviderScope(
      child: DashApp(),
    ),
  );
}

Future<void> initApp() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await openBoxes();
  await autoClearHistory();
}

Future<void> initWindow({Size? sz}) async {
  if (kIsLinux) {
    await setupInitialWindow(sz: sz);
  }
  if (kIsMacOS || kIsWindows) {
    var win = sz == null ? (sz, null) : getInitialSize();
    await setupWindow(sz: win.$1, off: win.$2);
  }
}
