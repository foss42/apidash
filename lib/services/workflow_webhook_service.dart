import 'dart:convert';
import 'dart:io';

class WorkflowWebhookTrigger {
  const WorkflowWebhookTrigger({
    required this.workflowId,
    required this.payload,
    required this.token,
  });

  final String workflowId;
  final Map<String, dynamic> payload;
  final String token;
}

class WorkflowWebhookService {
  HttpServer? _server;
  final String _token = DateTime.now().microsecondsSinceEpoch.toRadixString(36);

  String get token => _token;
  int? get port => _server?.port;
  bool get isRunning => _server != null;

  String endpointFor(String workflowId) =>
      'http://127.0.0.1:${port ?? 0}/workflow/$workflowId/trigger?token=$_token';

  Future<void> start({
    int preferredPort = 9237,
    required void Function(WorkflowWebhookTrigger trigger) onTrigger,
  }) async {
    if (_server != null) return;
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, preferredPort);
    _server!.listen((request) async {
      if (request.method != 'POST') {
        request.response.statusCode = HttpStatus.methodNotAllowed;
        await request.response.close();
        return;
      }
      final segments = request.uri.pathSegments;
      if (segments.length != 3 ||
          segments.first != 'workflow' ||
          segments.last != 'trigger') {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
        return;
      }
      final token = request.uri.queryParameters['token'];
      if (token != _token) {
        request.response.statusCode = HttpStatus.unauthorized;
        await request.response.close();
        return;
      }
      final workflowId = segments[1];
      try {
        final body = await utf8.decoder.bind(request).join();
        final decoded = body.isEmpty ? <String, dynamic>{} : jsonDecode(body);
        final payload = decoded is Map<String, dynamic>
            ? decoded
            : <String, dynamic>{'raw': decoded};
        onTrigger(
          WorkflowWebhookTrigger(
            workflowId: workflowId,
            payload: payload,
            token: token ?? '',
          ),
        );
        request.response.statusCode = HttpStatus.ok;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{'ok': true, 'workflowId': workflowId}),
        );
      } catch (_) {
        request.response.statusCode = HttpStatus.badRequest;
      } finally {
        await request.response.close();
      }
    });
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }
}
