import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:apidash_mcp_server/src/server.dart';

void main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8765') ?? 8765;
  final handler = buildMcpServer();

  final server = await shelf_io.serve(handler, InternetAddress.loopbackIPv4, port);
  print('[apidash_mcp_server] Listening on http://localhost:${server.port}');
}