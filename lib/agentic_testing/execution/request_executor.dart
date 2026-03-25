import 'package:apidash_core/apidash_core.dart';
import 'execution_response.dart';

abstract class RequestExecutor {
  Future<ExecutionResponse> execute(HttpRequestModel request);
}