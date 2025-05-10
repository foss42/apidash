import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_request_result.dart';

class RequestExecutor {
  static Future<ApiRequestResult> execute({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
  }) async {
    final stopwatch = Stopwatch()..start();
    final client = http.Client();
    try {
      http.Response response;
      final defaultTimeout = const Duration(seconds: 30);
      try {
        switch (method.toUpperCase()) {
          case 'GET':
            response = await client.get(
              Uri.parse(url),
              headers: headers,
            ).timeout(timeout ?? defaultTimeout);
            break;
          case 'POST':
            response = await client.post(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
            break;
          case 'PUT':
            response = await client.put(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
            break;
          case 'DELETE':
            response = await client.delete(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
            break;
          case 'PATCH':
            response = await client.patch(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: response.statusCode,
          body: response.body,
          duration: stopwatch.elapsed,
          error: null,
        );
      } on TimeoutException {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'Request timed out after [${(timeout ?? defaultTimeout).inSeconds}[ seconds',
        );
      } on http.ClientException catch (e) {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'HTTP client error: ${e.message}',
        );
      } on FormatException catch (e) {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'Format error: ${e.message}',
        );
      } catch (e) {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: e.toString(),
        );
      }
    } finally {
      client.close();
    }
  }
}
