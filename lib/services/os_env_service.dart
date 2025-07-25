import 'dart:io';

/// Service to handle OS environment variable operations
class OSEnvironmentService {
  /// Get the value of an environment variable from the OS
  /// Returns null if variable is not found
  String? getOSEnvironmentVariable(String key) {
    try {
      
      final envVars = Platform.environment;
      
      final matchingKey = envVars.keys
          .firstWhere((k) => k.toUpperCase() == key.toUpperCase(), orElse: () => '');
      
      if (matchingKey.isNotEmpty) {
        final value = envVars[matchingKey];
        return value;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if an environment variable exists in the OS
  bool hasOSEnvironmentVariable(String key) {
    try {
      final exists = Platform.environment.keys
          .any((k) => k.toUpperCase() == key.toUpperCase());
      return exists;
    } catch (e) {
      return false;
    }
  }
}

final osEnvironmentService = OSEnvironmentService();
