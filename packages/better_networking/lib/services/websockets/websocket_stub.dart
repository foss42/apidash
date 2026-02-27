import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connectToWebSocket(Uri uri, Map<String, dynamic> headers) async {
  throw UnsupportedError('Cannot connect without dart:html or dart:io');
}
