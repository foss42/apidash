import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:apidash/services/raw_web_socket_channel.dart';

void main() {
  group('RawWebSocketChannel', () {
    test('Integration - Auto PONG enabled', () async {
      var server = await ServerSocket.bind('localhost', 0);
      int port = server.port;
      
      var serverFuture = server.first.then((Socket socket) async {
        List<int> buffer = [];
        bool handshaked = false;
        
        var completer = Completer<bool>();
        
        socket.listen((data) {
          if (!handshaked) {
            buffer.addAll(data);
            String req = String.fromCharCodes(buffer);
            if (req.contains('\r\n\r\n')) {
              var lines = req.split('\r\n');
              String key = lines.firstWhere((l) => l.toLowerCase().startsWith('sec-websocket-key:')).split(':')[1].trim();
              var accept = base64.encode(sha1.convert(utf8.encode(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")).bytes);
              socket.add(utf8.encode(
                'HTTP/1.1 101 Switching Protocols\r\n'
                'Upgrade: websocket\r\n'
                'Connection: Upgrade\r\n'
                'Sec-WebSocket-Accept: $accept\r\n\r\n'
              ));
              handshaked = true;
              
              socket.add([0x89, 0x00]);
            }
          } else {
            if (data.isNotEmpty) {
              int opcode = data[0] & 0x0F;
              if (opcode == 0x0A) {
                if (!completer.isCompleted) completer.complete(true);
              }
            }
          }
        });
        return completer.future;
      });

      var channel = await RawWebSocketChannel.connect('ws://localhost:$port', autoPongEnabled: true);
      
      bool pongReceived = await serverFuture.timeout(Duration(seconds: 2));
      expect(pongReceived, isTrue);
      
      await server.close();
    });
    
    test('Integration - Auto PONG disabled', () async {
      var server = await ServerSocket.bind('localhost', 0);
      int port = server.port;
      
      var serverFuture = server.first.then((Socket socket) async {
        List<int> buffer = [];
        bool handshaked = false;
        
        var completer = Completer<bool>();
        
        socket.listen((data) {
          if (!handshaked) {
            buffer.addAll(data);
            String req = String.fromCharCodes(buffer);
            if (req.contains('\r\n\r\n')) {
              var lines = req.split('\r\n');
              String key = lines.firstWhere((l) => l.toLowerCase().startsWith('sec-websocket-key:')).split(':')[1].trim();
              var accept = base64.encode(sha1.convert(utf8.encode(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")).bytes);
              socket.add(utf8.encode(
                'HTTP/1.1 101 Switching Protocols\r\n'
                'Upgrade: websocket\r\n'
                'Connection: Upgrade\r\n'
                'Sec-WebSocket-Accept: $accept\r\n\r\n'
              ));
              handshaked = true;
              
              socket.add([0x89, 0x00]);
            }
          } else {
            if (data.isNotEmpty) {
              int opcode = data[0] & 0x0F;
              if (opcode == 0x0A) {
                if (!completer.isCompleted) completer.complete(true);
              }
            }
          }
        });
        
        await Future.delayed(Duration(seconds: 1));
        if (!completer.isCompleted) completer.complete(false);
        return completer.future;
      });

      var channel = await RawWebSocketChannel.connect('ws://localhost:$port', autoPongEnabled: false);
      
      bool pongReceived = await serverFuture;
      expect(pongReceived, isFalse);
      
      await server.close();
    });
  });
}
