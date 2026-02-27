import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connectToWebSocket(
    Uri uri, Map<String, dynamic> headers) async {
  // Browsers don't support custom headers natively in WebSocket (except Sec-WebSocket-Protocol natively).
  final protocols = headers.keys.contains('Sec-WebSocket-Protocol')
      ? headers['Sec-WebSocket-Protocol']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .toList()
      : null;

  return WebSocketChannel.connect(uri, protocols: protocols);
}
