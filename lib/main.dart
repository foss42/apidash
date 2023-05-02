import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/services.dart';
import 'consts.dart' show kIsLinux;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  await openBoxes();
  if (kIsLinux) {
    await setupInitialWindow();
  } else {
    var win = getInitialSize();
    await setupWindow(sz: win.$0, off: win.$1);
  }
  runApp(
    ProviderScope(
      child: kIsLinux ? const DashApp() : const App(),
    ),
  );
}
