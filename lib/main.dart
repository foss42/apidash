import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await DesktopWindow.setWindowSize(Size(1400, 800));
    await DesktopWindow.setMinWindowSize(Size(1200, 800));
  }
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
