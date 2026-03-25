import '../models/test_expectation.dart';
import '../execution/execution_response.dart';

class RulesEvaluator {
  /// Evaluates an executed response against the predefined expectations of the test case.
  /// Returns a boolean where `true` means the test passed its assertions.
  static bool evaluate(ExecutionResponse response, List<TestExpectation> expectations) {
    if (expectations.isEmpty) return true;

    for (final expected in expectations) {
      // 1. Evaluate Status Code Expectations
      if (expected.expectedStatus != null) {
        if (response.statusCode != expected.expectedStatus) {
          return false;
        }
      }

      // 2. Evaluate Maximum Time Latency Expectations (maxLatencyMs)
      if (expected.maxLatencyMs != null) {
        final actualTimeMs = response.time?.inMilliseconds;
        if (actualTimeMs == null || actualTimeMs > expected.maxLatencyMs!) {
          return false;
        }
      }

      // 3. Evaluate Must-Have Headers (requiredHeaders)
      if (expected.requiredHeaders.isNotEmpty) {
        final actualHeaders = response.headers ?? {};
        // Convert all keys to lowercase for safe comparison
        final normalizedHeaders = actualHeaders.map(
          (key, value) => MapEntry(key.toLowerCase(), value),
        );
        
        for (final header in expected.requiredHeaders) {
          final targetKey = header.toLowerCase();
          if (!normalizedHeaders.containsKey(targetKey)) {
            return false;
          }
        }
      }

      // 4. Evaluate Substring Body Occurrences (mustContainBodyTexts)
      if (expected.mustContainBodyTexts.isNotEmpty) {
        if (response.body == null) {
          return false; // Expected a body with specific text, but got no body
        }
        
        for (final substring in expected.mustContainBodyTexts) {
          if (!response.body!.contains(substring)) {
            return false;
          }
        }
      }
    }

    return true;
  }
}