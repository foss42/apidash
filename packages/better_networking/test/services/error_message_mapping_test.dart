import 'dart:io';

import 'package:better_networking/services/http_service.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  group('mapNetworkErrorMessage', () {
    test('maps SocketException to connection-failed message', () {
      final msg = mapNetworkErrorMessage(const SocketException('dns failed'));
      expect(msg, startsWith(kMsgConnectionFailed));
      expect(msg, contains('SocketException'));
    });

    test('maps http.ClientException to connection-failed message', () {
      final msg = mapNetworkErrorMessage(http.ClientException('client issue'));
      expect(msg, startsWith(kMsgConnectionFailed));
      expect(msg, contains('ClientException'));
    });

    test('maps stringified SocketException text to connection-failed message', () {
      final msg = mapNetworkErrorMessage('SocketException: Failed host lookup');
      expect(msg, startsWith(kMsgConnectionFailed));
      expect(msg, contains('Failed host lookup'));
    });

    test('passes through non-network errors', () {
      final msg = mapNetworkErrorMessage(ArgumentError('bad arg'));
      expect(msg, contains('bad arg'));
    });
  });
}
