import 'dart:io';
import 'package:test/test.dart';
import 'package:apidash/services/os_env_service.dart';

void main() {
  late OSEnvironmentService osEnvironmentService;
  
  setUp(() {
    osEnvironmentService = OSEnvironmentService();
  });

  group('OSEnvironmentService', () {
    test('getOSEnvironmentVariable returns the value for existing variable', () {
      // This test requires checking with a variable that's commonly available
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        final expectedValue = Platform.environment[testKey];
        final actualValue = osEnvironmentService.getOSEnvironmentVariable(testKey);
        
        expect(actualValue, expectedValue);
      } 
    });

    test('getOSEnvironmentVariable returns null for non-existent variable', () {
      const nonExistentKey = 'NON_EXISTENT_ENVIRONMENT_VARIABLE_12345';
      final value = osEnvironmentService.getOSEnvironmentVariable(nonExistentKey);
      
      expect(value, isNull);
    });

    test('getOSEnvironmentVariable is case-insensitive', () {
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        final expectedValue = Platform.environment[testKey];
        
        // Try with uppercase
        final upperCaseValue = osEnvironmentService.getOSEnvironmentVariable(testKey.toUpperCase());
        expect(upperCaseValue, expectedValue);
        
        // Try with lowercase
        final lowerCaseValue = osEnvironmentService.getOSEnvironmentVariable(testKey.toLowerCase());
        expect(lowerCaseValue, expectedValue);
      } 
    });

    test('hasOSEnvironmentVariable returns true for existing variable', () {
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        final exists = osEnvironmentService.hasOSEnvironmentVariable(testKey);
        expect(exists, isTrue);
      } 
    });

    test('hasOSEnvironmentVariable returns false for non-existent variable', () {
      const nonExistentKey = 'NON_EXISTENT_ENVIRONMENT_VARIABLE_12345';
      final exists = osEnvironmentService.hasOSEnvironmentVariable(nonExistentKey);
      
      expect(exists, isFalse);
    });

    test('hasOSEnvironmentVariable is case-insensitive', () {
      final testKey = Platform.environment.keys.firstWhere(
        (key) => Platform.environment[key]?.isNotEmpty ?? false,
        orElse: () => '',
      );
      
      if (testKey.isNotEmpty) {
        // Try with uppercase
        final existsUpper = osEnvironmentService.hasOSEnvironmentVariable(testKey.toUpperCase());
        expect(existsUpper, isTrue);
        
        // Try with lowercase
        final existsLower = osEnvironmentService.hasOSEnvironmentVariable(testKey.toLowerCase());
        expect(existsLower, isTrue);
      } 
    });
  });
}