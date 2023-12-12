import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/services.dart';
import 'consts.dart' show kIsLinux, kIsMacOS, kIsWindows;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await openBoxes();
  if (kIsLinux) {
    await setupInitialWindow();
  }
  if (kIsMacOS || kIsWindows) {
    var win = getInitialSize();
    await setupWindow(sz: win.$1, off: win.$2);
  }
  runApp(
    const ProviderScope(
      child: DashApp(),
    ),
  );
}
