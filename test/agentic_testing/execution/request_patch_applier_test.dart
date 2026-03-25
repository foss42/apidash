import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/agentic_testing/execution/request_patch_applier.dart';

void main() {
  group('RequestPatchApplier', () {
    test('applies url patch correctly', () {
      const baseRequest = HttpRequestModel(url: 'https://api.example.com');
      final patched = RequestPatchApplier.apply(
        baseRequest, 
        {'url': 'https://api.patched.com'}
      );
      
      expect(patched.url, 'https://api.patched.com');
    });

    test('applies body patch correctly', () {
      const baseRequest = HttpRequestModel(
        url: 'https://api.example.com',
        body: '{"old": true}'
      );
      
      final patched = RequestPatchApplier.apply(
        baseRequest, 
        {'body': '{"new": true}'}
      );
      
      expect(patched.body, '{"new": true}');
    });

    test('adds, modifies, and removes headers correctly', () {
      const baseRequest = HttpRequestModel(
        url: 'https://api.example.com',
        headers: [
          NameValueModel(name: 'Authorization', value: 'Bearer token'),
          NameValueModel(name: 'Accept', value: 'application/json'),
          NameValueModel(name: 'Keep', value: 'Me'),
        ],
      );

      final patch = {
        'headers': {
          'Authorization': 'Bearer new_token', // Modify
          'Accept': null,                      // Remove by throwing null
          'X-Custom': 'Added'                  // Add new
        }
      };

      final patched = RequestPatchApplier.apply(baseRequest, patch);
      final headers = patched.headers!;
      
      expect(headers.length, 3);
      
      // Kept intact
      expect(headers.any((h) => h.name == 'Keep' && h.value == 'Me'), isTrue);
      // Modified
      expect(headers.any((h) => h.name == 'Authorization' && h.value == 'Bearer new_token'), isTrue);
      // Added
      expect(headers.any((h) => h.name == 'X-Custom' && h.value == 'Added'), isTrue);
      // Removed
      expect(headers.any((h) => h.name == 'Accept'), isFalse);
    });
  });
}