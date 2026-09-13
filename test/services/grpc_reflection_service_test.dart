import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/services/grpc_reflection_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GrpcReflectionService Tests', () {
    const requestId = 'test-reflection-id';
    const model = GrpcRequestModel(url: 'localhost:50051');

    setUp(() {
      GrpcReflectionService.lastError = null;
    });

    test('listServices returns empty list on error', () async {
      // ConnectionManager has no channel for requestId, so callGrpcMethod throws.
      // GrpcReflectionService should catch and return empty list.
      final services = await GrpcReflectionService.listServices(requestId, model);
      expect(services, isEmpty);
    });

    test('getMethodsForService returns empty map on error', () async {
      final methods = await GrpcReflectionService.getMethodsForService(requestId, model, 'TestService');
      expect(methods, isEmpty);
    });

    test('getMethodSchema returns null on error', () async {
      final schema = await GrpcReflectionService.getMethodSchema(requestId, model, 'TestService', 'TestMethod');
      expect(schema, isNull);
    });

    test('getParamsForMethod returns empty list on error', () async {
      final params = await GrpcReflectionService.getParamsForMethod(requestId, model, 'TestService', 'TestMethod');
      expect(params, isEmpty);
    });
  });

  group('GrpcReflectionService v1/v1alpha fallback + error surfacing', () {
    const requestId = 'test-reflection-fallback-id';
    const model = GrpcRequestModel(url: 'localhost:50051');

    setUp(() {
      GrpcReflectionService.lastError = null;
    });

    test('tries stable v1 first, then v1alpha', () {
      // The fallback order is load-bearing: modern servers expose only v1, so it
      // must be attempted before the legacy v1alpha name.
      expect(GrpcReflectionService.reflectionServices, [
        'grpc.reflection.v1.ServerReflection',
        'grpc.reflection.v1alpha.ServerReflection',
      ]);
      // Both versions share the same streaming method.
      expect(GrpcReflectionService.reflectionMethod, 'ServerReflectionInfo');
    });

    test('listServices records the real failure in lastError (not swallowed)',
        () async {
      // No channel is registered for requestId, so callGrpcMethod throws for
      // BOTH reflection versions. The failure must be captured (so the UI can
      // show it) instead of silently returning an empty dropdown.
      final services =
          await GrpcReflectionService.listServices(requestId, model);
      expect(services, isEmpty);
      expect(GrpcReflectionService.lastError, isNotNull);
      expect(GrpcReflectionService.lastError, contains('No active gRPC channel'));
    });

    test('getMethodsForService also surfaces the error via lastError', () async {
      final methods = await GrpcReflectionService.getMethodsForService(
          requestId, model, 'TestService');
      expect(methods, isEmpty);
      expect(GrpcReflectionService.lastError, isNotNull);
      expect(GrpcReflectionService.lastError, contains('No active gRPC channel'));
    });

    test('getMethodSchema surfaces the error via lastError', () async {
      final schema = await GrpcReflectionService.getMethodSchema(
          requestId, model, 'TestService', 'TestMethod');
      expect(schema, isNull);
      expect(GrpcReflectionService.lastError, isNotNull);
    });
  });
}
