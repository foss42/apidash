import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connectToWebSocket(
    Uri uri, Map<String, dynamic> headers) async {
  final socket = await WebSocket.connect(
    uri.toString(),
    headers: headers,
  );
  return IOWebSocketChannel(socket);
}
