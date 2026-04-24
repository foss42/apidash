// Conditional import: returns false on all non-web platforms
// CLI and server-side Dart always get kIsWeb = false
const bool kIsWeb = bool.fromEnvironment('dart.library.html');
