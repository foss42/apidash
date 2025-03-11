import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/jwt_utils.dart';

void main() {
  group('JWT Utils Tests', () {
    const testToken =
        "your_valid_jwt_token_here"; // Replace with a real valid token
    const expiredToken =
        "your_expired_jwt_token_here"; // Replace with an expired token
    
    test('Save and retrieve token', () async {
      await JwtUtils.saveToken(testToken);
      final retrievedToken = await JwtUtils.getToken();
      expect(retrievedToken, equals(testToken));
    });

    test('Check if token is valid', () {
      final isValid = JwtUtils.isTokenValid(testToken);
      expect(isValid, isTrue);
    });

    test('Check if expired token is invalid', () {
      final isExpired = JwtUtils.isTokenValid(expiredToken);
      expect(isExpired, isFalse);
    });

    test('Extract payload from token', () {
      final payload = JwtUtils.getPayload(testToken);
      expect(payload, isA<Map<String, dynamic>>());
      expect(payload.containsKey("sub"), isTrue); // Adjust according to your JWT structure
    });

    test('Delete token', () async {
      await JwtUtils.
