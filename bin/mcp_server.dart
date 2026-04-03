import 'dart:io';
import 'package:apidash/mcp_server/server.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    stderr.writeln('Usage: dart run bin/mcp_server.dart <hive_path>');
    exit(1);
  }

  final hivePath = args[0];
  final server = ApidashMcpServer(hivePath: hivePath);
  await server.run();
}
