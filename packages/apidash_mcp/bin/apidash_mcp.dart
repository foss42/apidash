import 'package:apidash_mcp/apidash_mcp.dart';

Future<void> main(List<String> args) async {
  final server = ApiDashMcpServer();
  await server.serve();
}
