import 'dart:developer' as developer;
import 'dart:io' show Platform;

/// A pure Dart replacement for Flutter's kIsWeb to avoid pulling in the Flutter SDK.
const bool isThisWeb = bool.fromEnvironment('dart.library.js_interop');

/// A pure Dart replacement for Flutter's debugPrint.
void apidashLog(String message) {
  developer.log(message, name: 'apidash');
}

/// Helper to check for desktop platforms without Flutter.
bool get isDesktop => !isThisWeb && 
    (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

/// Helper to check for mobile platforms without Flutter.
bool get isMobile => !isThisWeb && 
    (Platform.isIOS || Platform.isAndroid);
