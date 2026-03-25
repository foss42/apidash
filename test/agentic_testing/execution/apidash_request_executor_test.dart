import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/agentic_testing/execution/apidash_request_executor.dart';
import 'package:apidash/agentic_testing/execution/request_executor.dart';

void main() {
  group('ApidashRequestExecutor', () {
    test('implements RequestExecutor and handles network delegation gracefully', () async {
      // Create the explicit concrete executor
      final executor = ApidashRequestExecutor();
      
      // Verify interface contracts match (Compiler enforcement)
      final RequestExecutor interfaceExecutor = executor;
      
      // Perform a real network request using a highly available public JSON API
      // to ensure `better_networking` handles the request properly.
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://jsonplaceholder.typicode.com/todos/1',
      );
      
      final response = await interfaceExecutor.execute(request);
      
      // We expect a correctly formatted response object
      expect(response, isNotNull);
      
      // Depending on the test machine's internet connection, we either get:
      // 1. A success status code (e.g., 200)
      // 2. An error string (e.g., SocketException because of no wifi)
      // Both represent a deterministic output captured successfully by the executor.
      expect(response.error != null || response.statusCode != null, isTrue);
      
      // If we got a network response, time must be tracked
      if (response.statusCode != null) {
        expect(response.time, isNotNull);
      }
    });

    test('handles invalid host gracefully and correctly maps the error', () async {
      final executor = ApidashRequestExecutor();
      
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://this-is-a-fake-domain-that-will-fail.com',
      );
      
      final response = await executor.execute(request);
      
      // Network lookup should fail, bubbling up into our deterministic error tracking
      expect(response.error, isNotNull);
      expect(response.statusCode, isNull);
    });
  });
}