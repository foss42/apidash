import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final StreamController<String> _messageController =
      StreamController<String>.broadcast();
  final StreamController<Object> _errorController =
      StreamController<Object>.broadcast();

  WebSocketChannel? _channel;

  Stream<String> get messages => _messageController.stream;
  Stream<Object> get errors => _errorController.stream;
  Future<(String, Duration)> connect(
      String url, Function(String) onMessage) async {
    if (!isInitialized()) {
      _channel = WebSocketChannel.connect(Uri.parse(url));
    }
    Stopwatch stopwatch = Stopwatch()..start();
    await _channel!.ready;
    // Start listening to the channel right after it's connected
    _channel!.stream.listen((event) {
      _messageController.add(event);
      onMessage(event);
    }, onError: (error) {
      _errorController.add(error);
    });
    stopwatch.stop();
    return ("Websocket connection established!", stopwatch.elapsed);
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void receive() {
    if (_channel != null) {
      _channel!.stream.listen((event) {
        _messageController.add(event);
      }, onError: (error) {
        _errorController.add(error);
      });
    }
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }

  bool isInitialized() {
    return _channel != null;
  }
}
