import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/services/grpc_reflection_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GrpcReflectionService Tests', () {
    const requestId = 'test-reflection-id';
    const model = GrpcRequestModel(url: 'localhost:50051');

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
}
