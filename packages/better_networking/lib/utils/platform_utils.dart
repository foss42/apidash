import 'dart:io';

/// Platform detection utilities for the better_networking package.
class PlatformUtils {
  static const bool isWeb = bool.fromEnvironment('dart.library.js_interop');

  /// Returns true if running on desktop platforms (macOS, Windows, Linux).
  static bool get isDesktop =>
      !isWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  /// Returns true if running on mobile platforms (iOS, Android).
  static bool get isMobile => !isWeb && (Platform.isIOS || Platform.isAndroid);

  /// Returns true if OAuth should use localhost callback server.
  /// This is true for desktop platforms.
  static bool get shouldUseLocalhostCallback => isDesktop;
}
