import 'dart:io';

/// Platform detection utilities for the better_networking package.
class PlatformUtils {
  /// Returns true if running on desktop platforms (macOS, Windows, Linux).
  static bool get isDesktop =>
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Returns true if running on mobile platforms (iOS, Android).
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;

  /// Returns true if running on web.
  static bool get isWeb => false;

  /// Returns true if OAuth should use localhost callback server.
  static bool get shouldUseLocalhostCallback => isDesktop;
}
