import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/services/connection_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectionManager gRPC Tests', () {
    const requestId = 'test-grpc-id';
    
    tearDown(() {
      ConnectionManager.instance.disconnectGrpc(requestId);
    });

    test('connectGrpc establishes a channel and extracts port from URL', () async {
      const model = GrpcRequestModel(
        url: 'grpc.postman-echo.com:8080',
        useTLS: false,
      );

      final channel = await ConnectionManager.instance.connectGrpc(requestId, model);
      expect(channel, isNotNull);
      expect(channel.host, 'grpc.postman-echo.com');
      expect(channel.port, 8080);
      expect(channel.options.credentials.isSecure, isFalse);

      final fetchedChannel = ConnectionManager.instance.getGrpcChannel(requestId);
      expect(fetchedChannel, channel);
    });

    test('connectGrpc uses default port 50051 if not provided', () async {
      const model = GrpcRequestModel(
        url: 'localhost',
        useTLS: true,
      );

      final channel = await ConnectionManager.instance.connectGrpc(requestId, model);
      expect(channel.host, 'localhost');
      expect(channel.port, 50051);
      expect(channel.options.credentials.isSecure, isTrue);
    });

    test('disconnectGrpc removes the channel', () async {
      const model = GrpcRequestModel(url: 'localhost');
      await ConnectionManager.instance.connectGrpc(requestId, model);
      expect(ConnectionManager.instance.getGrpcChannel(requestId), isNotNull);

      ConnectionManager.instance.disconnectGrpc(requestId);
      expect(() => ConnectionManager.instance.getGrpcChannel(requestId), throwsA(isA<TypeError>()));
    });

    test('callGrpcMethod throws Exception if no channel is active', () {
      expect(
        () => ConnectionManager.instance.callGrpcMethod(
          'non-existent-id',
          'Service',
          'Method',
          [1, 2, 3],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('disconnectAll removes all gRPC channels', () async {
      const model = GrpcRequestModel(url: 'localhost');
      await ConnectionManager.instance.connectGrpc('id1', model);
      await ConnectionManager.instance.connectGrpc('id2', model);

      ConnectionManager.instance.disconnectAll();

      expect(() => ConnectionManager.instance.getGrpcChannel('id1'), throwsA(anything));
      expect(() => ConnectionManager.instance.getGrpcChannel('id2'), throwsA(anything));
    });
  });
}
