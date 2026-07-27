import 'dart:io';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/services/grpc_reflection_service.dart';
import 'package:apidash/utils/grpc_utils.dart';
import 'package:test/test.dart';

void main() {
  group('GrpcUtils Tests', () {
    const protoContent = '''
syntax = "proto3";
package helloworld;
service Greeter {
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}
message HelloRequest {
  string name = 1;
  int32 age = 2;
}
message HelloReply {
  string message = 1;
}
''';

    late File tempProtoFile;

    setUp(() async {
      tempProtoFile = File('test_temp.proto');
      await tempProtoFile.writeAsString(protoContent);
    });

    tearDown(() async {
      if (await tempProtoFile.exists()) {
        await tempProtoFile.delete();
      }
    });

    test('parseProtoFile returns correct structure', () async {
      final result = await GrpcUtils.parseProtoFile(tempProtoFile.path);
      
      expect(result.containsKey('services'), isTrue);
      expect(result['services'], contains('Greeter'));

      expect(result.containsKey('methods'), isTrue);
      expect(result['methods']['Greeter'], contains('SayHello'));
      expect(result['methods']['Greeter/SayHello'], contains('HelloRequest'));

      expect(result.containsKey('messageFields'), isTrue);
      final fields = result['messageFields']['HelloRequest'] as List<GrpcParameterModel>;
      expect(fields.length, 2);
      
      final nameField = fields.firstWhere((f) => f.name == 'name');
      expect(nameField.tag, 1);
      expect(nameField.type, 'string');

      final ageField = fields.firstWhere((f) => f.name == 'age');
      expect(ageField.tag, 2);
      expect(ageField.type, 'int32');
    });

    test('parseProtoFile handles non-existent file', () async {
      final result = await GrpcUtils.parseProtoFile('non_existent_file.proto');
      expect(result, isEmpty);
    });

    test('paramsToJson handles various types', () {
      final params = [
        const GrpcParameterModel(name: 'strField', type: 'string', value: 'hello', enabled: true),
        const GrpcParameterModel(name: 'intField', type: 'int32', value: '42', enabled: true),
        const GrpcParameterModel(name: 'boolField', type: 'bool', value: 'true', enabled: true),
        const GrpcParameterModel(name: 'doubleField', type: 'double', value: '3.14', enabled: true),
        const GrpcParameterModel(name: 'disabledField', type: 'string', value: 'hide', enabled: false),
        const GrpcParameterModel(name: '', type: 'string', value: 'empty_name', enabled: true),
      ];

      final jsonString = GrpcUtils.paramsToJson(params);
      expect(jsonString, contains('"strField": "hello"'));
      expect(jsonString, contains('"intField": 42'));
      expect(jsonString, contains('"boolField": true'));
      expect(jsonString, contains('"doubleField": 3.14'));
      expect(jsonString, isNot(contains('disabledField')));
      expect(jsonString, isNot(contains('empty_name')));
    });

    test('paramsToBytes encodes basic types correctly', () {
      final params = [
        const GrpcParameterModel(name: 'strField', type: 'string', value: 'A', tag: 1, enabled: true),
        const GrpcParameterModel(name: 'intField', type: 'int32', value: '5', tag: 2, enabled: true),
        const GrpcParameterModel(name: 'boolField', type: 'bool', value: 'true', tag: 3, enabled: true),
      ];

      final bytes = GrpcUtils.paramsToBytes(params);
      expect(bytes.isNotEmpty, isTrue);
      // tag 1, type string (2) => (1 << 3) | 2 = 10
      // len 1 => 1
      // val A => 65
      // tag 2, type int32 (0) => (2 << 3) | 0 = 16
      // val 5 => 5
      // tag 3, type bool (0) => (3 << 3) | 0 = 24
      // val 1 => 1
      expect(bytes, [10, 1, 65, 16, 5, 24, 1]);
    });

    test('decodeBinaryResponse decodes simple message without schema', () {
      // 10, 1, 65 is string "A" with tag 1
      final data = [10, 1, 65];
      final jsonResponse = GrpcUtils.decodeBinaryResponse(data);
      expect(jsonResponse, contains('"1": "A"'));
    });
  });
}
