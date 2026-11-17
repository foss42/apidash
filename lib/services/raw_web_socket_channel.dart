import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:async/async.dart';

/// A custom WebSocketChannel that bypasses dart:io's WebSocket in order to
/// allow fine-grained control over PING/PONG behavior, specifically to disable
/// the automatic PONG responses that dart:io forces.
class RawWebSocketChannel extends StreamChannelMixin implements WebSocketChannel {
  final Socket _socket;
  final StreamController _streamController = StreamController();
  final StreamController _sinkController = StreamController();
  
  bool _autoPongEnabled = true;
  Duration? _pingInterval;
  Timer? _pingTimer;

  @override
  late final Stream stream = _streamController.stream;

  @override
  late final WebSocketSink sink = _RawWebSocketSink(this);

  RawWebSocketChannel._(this._socket, {bool autoPongEnabled = true, Duration? pingInterval}) {
    _autoPongEnabled = autoPongEnabled;
    _pingInterval = pingInterval;
    
    _sinkController.stream.listen((data) {
      if (data is String) {
        _sendFrame(1, utf8.encode(data));
      } else if (data is List<int>) {
        _sendFrame(2, data);
      }
    }, onDone: () {
      _sendFrame(8, []);
      _close();
    });

    _startPingTimer();
  }

  static Future<RawWebSocketChannel> connect(String url, {Map<String, String>? headers, bool autoPongEnabled = true, Duration? pingInterval}) async {
    Uri uri = Uri.parse(url);
    int port = uri.port;
    if (port == 0) {
      port = uri.scheme == 'wss' ? 443 : 80;
    }
    
    Socket socket;
    if (uri.scheme == 'wss') {
      socket = await SecureSocket.connect(uri.host, port);
    } else {
      socket = await Socket.connect(uri.host, port);
    }
    
    final key = base64.encode(List<int>.generate(16, (i) => Random().nextInt(256)));
    String path = uri.path;
    if (path.isEmpty) path = '/';
    if (uri.query.isNotEmpty) path += '?${uri.query}';
    
    final req = StringBuffer();
    req.write('GET $path HTTP/1.1\r\n');
    req.write('Host: ${uri.host}:$port\r\n');
    req.write('Upgrade: websocket\r\n');
    req.write('Connection: Upgrade\r\n');
    req.write('Sec-WebSocket-Key: $key\r\n');
    req.write('Sec-WebSocket-Version: 13\r\n');
    if (headers != null) {
      for (final h in headers.entries) {
        req.write('${h.key}: ${h.value}\r\n');
      }
    }
    req.write('\r\n');
    
    socket.add(utf8.encode(req.toString()));
    await socket.flush();
    
    bool handshaked = false;
    List<int> buffer = [];
    final completer = Completer<RawWebSocketChannel>();
    
    late StreamSubscription sub;
    sub = socket.listen((data) {
      if (!handshaked) {
        buffer.addAll(data);
        String resp = String.fromCharCodes(buffer);
        if (resp.contains('\r\n\r\n')) {
          handshaked = true;
          int idx = resp.indexOf('\r\n\r\n');
          List<int> remaining = buffer.sublist(idx + 4);
          final channel = RawWebSocketChannel._(socket, autoPongEnabled: autoPongEnabled, pingInterval: pingInterval);
          
          sub.onData((data) {
            channel._handleData(data);
          });
          sub.onDone(() {
            channel._close();
          });
          sub.onError((e) {
            channel._streamController.addError(e);
            channel._close();
          });
          
          if (remaining.isNotEmpty) {
            channel._handleData(remaining);
          }
          completer.complete(channel);
        }
      }
    }, onError: (e) {
      if (!completer.isCompleted) completer.completeError(e);
    });
    
    return completer.future;
  }
  
  List<int> _readBuffer = [];
  
  void _handleData(List<int> data) {
    _readBuffer.addAll(data);
    
    while (_readBuffer.isNotEmpty) {
      if (_readBuffer.length < 2) return;
      
      int byte0 = _readBuffer[0];
      int byte1 = _readBuffer[1];
      
      bool fin = (byte0 & 0x80) != 0;
      int opcode = byte0 & 0x0F;
      bool masked = (byte1 & 0x80) != 0;
      int payloadLen = byte1 & 0x7F;
      
      int offset = 2;
      if (payloadLen == 126) {
        if (_readBuffer.length < 4) return;
        payloadLen = (_readBuffer[2] << 8) | _readBuffer[3];
        offset += 2;
      } else if (payloadLen == 127) {
        if (_readBuffer.length < 10) return;
        payloadLen = 0;
        for (int i = 0; i < 8; i++) {
          payloadLen = (payloadLen << 8) | _readBuffer[2 + i];
        }
        offset += 8;
      }
      
      List<int> maskKey = [];
      if (masked) {
        if (_readBuffer.length < offset + 4) return;
        maskKey = _readBuffer.sublist(offset, offset + 4);
        offset += 4;
      }
      
      if (_readBuffer.length < offset + payloadLen) return;
      
      List<int> payload = _readBuffer.sublist(offset, offset + payloadLen);
      if (masked) {
        for (int i = 0; i < payloadLen; i++) {
          payload[i] ^= maskKey[i % 4];
        }
      }
      
      _readBuffer = _readBuffer.sublist(offset + payloadLen);
      
      if (opcode == 0x1) {
        _streamController.add(utf8.decode(payload));
      } else if (opcode == 0x2) {
        _streamController.add(payload);
      } else if (opcode == 0x8) {
        _close();
      } else if (opcode == 0x9) {
        if (_autoPongEnabled) {
          _sendFrame(0xA, payload);
        }
      } else if (opcode == 0xA) {
      }
    }
  }
  
  void _sendFrame(int opcode, List<int> payload) {
    List<int> frame = [];
    frame.add(0x80 | opcode);
    
    int len = payload.length;
    if (len <= 125) {
      frame.add(0x80 | len);
    } else if (len <= 65535) {
      frame.add(0x80 | 126);
      frame.add((len >> 8) & 0xFF);
      frame.add(len & 0xFF);
    } else {
      frame.add(0x80 | 127);
      for (int i = 7; i >= 0; i--) {
        frame.add((len >> (8 * i)) & 0xFF);
      }
    }
    
    var random = Random();
    List<int> maskKey = [random.nextInt(256), random.nextInt(256), random.nextInt(256), random.nextInt(256)];
    frame.addAll(maskKey);
    
    for (int i = 0; i < len; i++) {
      frame.add(payload[i] ^ maskKey[i % 4]);
    }
    
    try {
      _socket.add(frame);
    } catch (_) {}
  }
  
  set pingInterval(Duration? interval) {
    _pingInterval = interval;
    _startPingTimer();
  }
  
  void _startPingTimer() {
    _pingTimer?.cancel();
    if (_pingInterval != null) {
      _pingTimer = Timer.periodic(_pingInterval!, (timer) {
        _sendFrame(0x9, []);
      });
    }
  }
  
  void _close() {
    _pingTimer?.cancel();
    if (!_streamController.isClosed) _streamController.close();
    try {
      _socket.destroy();
    } catch (_) {}
  }

  @override
  String? get protocol => null;

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  Future<void> get ready => Future.value();
}

class _RawWebSocketSink extends DelegatingStreamSink implements WebSocketSink {
  _RawWebSocketSink(RawWebSocketChannel channel) : super(channel._sinkController.sink);

  @override
  Future close([int? closeCode, String? closeReason]) {
    return super.close();
  }
}
