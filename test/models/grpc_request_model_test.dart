import 'dart:convert';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('GrpcParameterModel Tests', () {
    test('Default constructor and properties', () {
      const model = GrpcParameterModel(name: 'test');
      expect(model.name, 'test');
      expect(model.type, 'string');
      expect(model.value, '');
      expect(model.enabled, true);
      expect(model.tag, isNull);
      expect(model.enumValues, isNull);
    });

    test('FromJson / ToJson serialization', () {
      const model = GrpcParameterModel(
        name: 'age',
        tag: 1,
        type: 'int32',
        value: '25',
        enabled: false,
        enumValues: ['A', 'B'],
      );

      final json = model.toJson();
      expect(json['name'], 'age');
      expect(json['tag'], 1);
      expect(json['type'], 'int32');
      expect(json['value'], '25');
      expect(json['enabled'], false);
      expect(json['enumValues'], ['A', 'B']);

      final decoded = GrpcParameterModel.fromJson(json);
      expect(decoded, model);
    });
  });

  group('GrpcRequestModel Tests', () {
    test('Default constructor and properties', () {
      const model = GrpcRequestModel();
      expect(model.url, '');
      expect(model.useTLS, false);
      expect(model.streamingType, GrpcStreamingType.unary);
      expect(model.messageHistory, isEmpty);
      expect(model.requestBody, '');
      expect(model.useReflection, false);
      expect(model.metadata, isEmpty);
      expect(model.isMetadataEnabled, isEmpty);
      expect(model.availableServices, isEmpty);
      expect(model.availableMethods, isEmpty);
      expect(model.parameters, isEmpty);
    });

    test('metadataMap extracts enabled/valid metadata correctly', () {
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'Authorization', value: 'Bearer token'),
          NameValueModel(name: '', value: 'empty name'),
        ],
      );

      final map = model.metadataMap;
      expect(map.length, 1);
      expect(map['Authorization'], 'Bearer token');
    });

    test('metadataMap handles null metadata', () {
      const model = GrpcRequestModel(metadata: null);
      final map = model.metadataMap;
      expect(map, isEmpty);
    });

    test('FromJson / ToJson serialization', () {
      final model = GrpcRequestModel(
        url: 'grpc.postman-echo.com',
        service: 'HelloService',
        method: 'SayHello',
        protoFile: '/path/to/proto',
        useTLS: true,
        streamingType: GrpcStreamingType.bidi,
        requestBody: 'test',
        useReflection: true,
        metadata: [const NameValueModel(name: 'k', value: 'v')],
        isMetadataEnabled: [true],
        availableServices: ['S1'],
        availableMethods: ['M1'],
        parameters: [const GrpcParameterModel(name: 'p1')],
      );

      final json = jsonDecode(jsonEncode(model.toJson()));
      final decoded = GrpcRequestModel.fromJson(json);
      expect(decoded, model);
    });
  });
}
