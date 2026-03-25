import 'package:apidash_core/apidash_core.dart';
import 'package:better_networking/better_networking.dart';
import 'package:uuid/uuid.dart';

import 'execution_response.dart';
import 'request_executor.dart';

class ApidashRequestExecutor implements RequestExecutor {
  final APIType apiType;
  final SupportedUriSchemes defaultUriScheme;
  final bool noSSL;
  final String _uuid = const Uuid().v4();

  ApidashRequestExecutor({
    this.apiType = APIType.rest,
    this.defaultUriScheme = SupportedUriSchemes.https,
    this.noSSL = false,
  });

  @override
  Future<ExecutionResponse> execute(HttpRequestModel request) async {
    // Generate a unique ID so better_networking's client manager
    // can properly track, isolated, and dispose of the HTTP client for this test.
    final String executionId = 'agentic_test_${_uuid}_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final result = await sendHttpRequest(
        executionId,
        apiType,
        request,
        defaultUriScheme: defaultUriScheme,
        noSSL: noSSL,
      );

      final response = result.$1;
      final duration = result.$2;
      final error = result.$3;

      if (error != null && response == null) {
        return ExecutionResponse(
          error: error,
          time: duration,
        );
      }
      
      if (response != null) {
        return ExecutionResponse(
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
          time: duration,
        );
      }

      return ExecutionResponse(
        error: 'Unknown execution failure. No response or error recorded.',
        time: duration,
      );
    } catch (e) {
      return ExecutionResponse(
        error: 'Execution Exception: $e',
      );
    }
  }
}