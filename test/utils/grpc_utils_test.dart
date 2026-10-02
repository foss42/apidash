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

    test('decodeBinaryResponse accumulates repeated tags into a list', () {
      // tag 1 varint 5, tag 1 varint 7, tag 1 varint 9 (no schema)
      final data = [8, 5, 8, 7, 8, 9];
      final jsonResponse = GrpcUtils.decodeBinaryResponse(data);
      expect(jsonResponse, contains('"1"'));
      expect(jsonResponse, contains('5'));
      expect(jsonResponse, contains('7'));
      expect(jsonResponse, contains('9'));
      // The three values must be a JSON array, not an overwrite.
      expect(jsonResponse, contains('['));
    });

    test('paramsToBytes emits fixed64/double with correct wire type', () {
      final params = [
        const GrpcParameterModel(
            name: 'd', type: 'double', value: '1.5', tag: 1, enabled: true),
        const GrpcParameterModel(
            name: 'f64', type: 'fixed64', value: '10', tag: 2, enabled: true),
      ];
      final bytes = GrpcUtils.paramsToBytes(params);
      // tag 1 double -> wire 1 => (1<<3)|1 = 9, then 8 LE bytes of 1.5
      expect(bytes[0], 9);
      // tag 2 fixed64 -> wire 1 => (2<<3)|1 = 17
      expect(bytes[9], 17);
      // fixed64 value 10 -> 8 bytes little-endian, first byte 10 then zeros
      expect(bytes.sublist(10, 18), [10, 0, 0, 0, 0, 0, 0, 0]);
    });

    test('paramsToBytes emits fixed32/float with correct wire type', () {
      final params = [
        const GrpcParameterModel(
            name: 'f', type: 'float', value: '1.5', tag: 1, enabled: true),
        const GrpcParameterModel(
            name: 'f32', type: 'fixed32', value: '7', tag: 2, enabled: true),
        const GrpcParameterModel(
            name: 's32', type: 'sfixed32', value: '-1', tag: 3, enabled: true),
      ];
      final bytes = GrpcUtils.paramsToBytes(params);
      // tag 1 float -> wire 5 => (1<<3)|5 = 13
      expect(bytes[0], 13);
      // 1.5 as float32 LE = 00 00 C0 3F
      expect(bytes.sublist(1, 5), [0x00, 0x00, 0xC0, 0x3F]);
      // tag 2 fixed32 -> (2<<3)|5 = 21, value 7 LE
      expect(bytes[5], 21);
      expect(bytes.sublist(6, 10), [7, 0, 0, 0]);
      // tag 3 sfixed32 -> (3<<3)|5 = 29, value -1 LE = FF FF FF FF
      expect(bytes[10], 29);
      expect(bytes.sublist(11, 15), [0xFF, 0xFF, 0xFF, 0xFF]);
    });

    test('sint zigzag round-trips including negatives', () {
      // Encode sint32/sint64 via paramsToBytes then decode with a schema.
      for (final v in [0, -1, 1, -2, 2, 2147483647, -2147483648]) {
        final bytes = GrpcUtils.paramsToBytes([
          GrpcParameterModel(
              name: 's', type: 'sint32', value: '$v', tag: 1, enabled: true),
        ]);
        final schema = _schemaWith('TYPE_SINT32', 1, 's');
        final json = GrpcUtils.decodeBinaryResponse(bytes, schema: schema);
        expect(json, contains('"s": $v'),
            reason: 'sint32 round-trip failed for $v');
      }
      for (final v in [0, -1, 5, -9007199254740991]) {
        final bytes = GrpcUtils.paramsToBytes([
          GrpcParameterModel(
              name: 's', type: 'sint64', value: '$v', tag: 1, enabled: true),
        ]);
        final schema = _schemaWith('TYPE_SINT64', 1, 's');
        final json = GrpcUtils.decodeBinaryResponse(bytes, schema: schema);
        expect(json, contains('"s": $v'),
            reason: 'sint64 round-trip failed for $v');
      }
    });

    test('negative int32/int64 encode as signed varint and round-trip', () {
      final bytes = GrpcUtils.paramsToBytes([
        const GrpcParameterModel(
            name: 'n', type: 'int32', value: '-1', tag: 1, enabled: true),
      ]);
      // -1 int32 is a 10-byte varint: tag(8) + FF*9 + 01
      expect(bytes.length, 11);
      final schema = _schemaWith('TYPE_INT32', 1, 'n');
      final json = GrpcUtils.decodeBinaryResponse(bytes, schema: schema);
      expect(json, contains('"n": -1'));
    });

    test('float/double round-trip through decode with schema', () {
      final bytesD = GrpcUtils.paramsToBytes([
        const GrpcParameterModel(
            name: 'd', type: 'double', value: '3.25', tag: 1, enabled: true),
      ]);
      final jsonD = GrpcUtils.decodeBinaryResponse(bytesD,
          schema: _schemaWith('TYPE_DOUBLE', 1, 'd'));
      expect(jsonD, contains('"d": 3.25'));

      final bytesF = GrpcUtils.paramsToBytes([
        const GrpcParameterModel(
            name: 'f', type: 'float', value: '2.5', tag: 1, enabled: true),
      ]);
      final jsonF = GrpcUtils.decodeBinaryResponse(bytesF,
          schema: _schemaWith('TYPE_FLOAT', 1, 'f'));
      // 2.5 is exactly representable in float32.
      expect(jsonF, contains('"f": 2.5'));
    });

    test('fixed32/fixed64 integer round-trip through decode with schema', () {
      final bytes64 = GrpcUtils.paramsToBytes([
        const GrpcParameterModel(
            name: 'v', type: 'fixed64', value: '4294967296', tag: 1, enabled: true),
      ]);
      final json64 = GrpcUtils.decodeBinaryResponse(bytes64,
          schema: _schemaWith('TYPE_FIXED64', 1, 'v'));
      expect(json64, contains('"v": 4294967296'));

      final bytes32 = GrpcUtils.paramsToBytes([
        const GrpcParameterModel(
            name: 'v', type: 'fixed32', value: '70000', tag: 1, enabled: true),
      ]);
      final json32 = GrpcUtils.decodeBinaryResponse(bytes32,
          schema: _schemaWith('TYPE_FIXED32', 1, 'v'));
      expect(json32, contains('"v": 70000'));
    });

    test('packed repeated varint decodes into a list', () {
      // field 1, wire type 2, length 4, three packed varints:
      // 3 -> 03 ; 270 -> 8E 02 ; 15 -> 0F  => length 4
      final data = [0x0A, 0x04, 0x03, 0x8E, 0x02, 0x0F];
      final schema = _schemaWith('TYPE_INT32', 1, 'nums', repeated: true);
      final json = GrpcUtils.decodeBinaryResponse(data, schema: schema);
      expect(json, contains('"nums"'));
      expect(json, contains('3'));
      expect(json, contains('270'));
      expect(json, contains('15'));
      expect(json, contains('['));
    });

    test('repeated non-packed message tags accumulate', () {
      // Two occurrences of tag 1 as length-delimited "A" / "B" strings, decoded
      // against a repeated string field -> list.
      final data = [0x0A, 0x01, 0x41, 0x0A, 0x01, 0x42];
      final schema = _schemaWith('TYPE_STRING', 1, 'items', repeated: true);
      final json = GrpcUtils.decodeBinaryResponse(data, schema: schema);
      expect(json, contains('"items"'));
      expect(json, contains('"A"'));
      expect(json, contains('"B"'));
      expect(json, contains('['));
    });

    test('parseProtoFile strips comments and handles nested messages', () async {
      const nestedProto = '''
syntax = "proto3";
package demo;

import "google/protobuf/timestamp.proto";
option java_package = "com.example.demo";

// A line comment describing the service.
service Demo {
  /* block comment */
  rpc Ping (PingRequest) returns (stream PingReply) {}
}

message PingRequest {
  string id = 1; // inline comment
  Corpus corpus = 2;
  message Inner {
    int32 nested_only = 1;
  }
  repeated Inner inners = 3;
}

message PingReply {
  sint64 delta = 1;
  double score = 2;
}

enum Corpus {
  UNIVERSAL = 0;
  WEB = 1;
  IMAGES = 2;
}
''';
      final f = File('test_temp_nested.proto');
      await f.writeAsString(nestedProto);
      try {
        final result = await GrpcUtils.parseProtoFile(f.path);

        expect(result['services'], contains('Demo'));
        expect(result['methods']['Demo'], contains('Ping'));
        // `stream ` qualifier stripped from request type resolution.
        expect(result['methods']['Demo/Ping'], contains('PingRequest'));

        final reqFields =
            result['messageFields']['PingRequest'] as List<GrpcParameterModel>;
        // id, corpus, inners -> nested_only must NOT leak into the outer message.
        expect(reqFields.map((f) => f.name), containsAll(['id', 'corpus', 'inners']));
        expect(reqFields.map((f) => f.name), isNot(contains('nested_only')));

        // Nested message parsed under both simple and dotted names.
        expect(result['messageFields'].containsKey('Inner'), isTrue);
        expect(result['messageFields'].containsKey('PingRequest.Inner'), isTrue);
        final innerFields =
            result['messageFields']['Inner'] as List<GrpcParameterModel>;
        expect(innerFields.length, 1);
        expect(innerFields.first.name, 'nested_only');

        // Enum-typed field re-tagged as enum with values.
        final corpusField = reqFields.firstWhere((f) => f.name == 'corpus');
        expect(corpusField.type, 'enum');
        expect(corpusField.enumValues, containsAll(['UNIVERSAL', 'WEB', 'IMAGES']));

        // Scalar precise types preserved for the encoder.
        final replyFields =
            result['messageFields']['PingReply'] as List<GrpcParameterModel>;
        expect(replyFields.firstWhere((f) => f.name == 'delta').type, 'sint64');
        expect(replyFields.firstWhere((f) => f.name == 'score').type, 'double');
      } finally {
        if (await f.exists()) await f.delete();
      }
    });
  });
}

// Builds a GrpcMethodSchema whose output descriptor has a single field so the
// decoder can exercise typed wire handling.
GrpcMethodSchema _schemaWith(String protoType, int tag, String name,
    {bool repeated = false}) {
  final field = FieldDescriptorProto();
  field.setField(1, name);
  field.setField(3, tag);
  field.setField(
      4,
      repeated
          ? FieldDescriptorProto_Label.LABEL_REPEATED
          : FieldDescriptorProto_Label.LABEL_OPTIONAL);
  field.setField(5, _typeEnum(protoType));
  final desc = DescriptorProto();
  desc.setField(1, 'Msg');
  desc.field.add(field);
  return GrpcMethodSchema(
    outputType: 'Msg',
    outputDescriptor: desc,
    allDescriptors: {'Msg': desc},
  );
}

FieldDescriptorProto_Type _typeEnum(String protoType) {
  switch (protoType) {
    case 'TYPE_DOUBLE':
      return FieldDescriptorProto_Type.TYPE_DOUBLE;
    case 'TYPE_FLOAT':
      return FieldDescriptorProto_Type.TYPE_FLOAT;
    case 'TYPE_INT64':
      return FieldDescriptorProto_Type.TYPE_INT64;
    case 'TYPE_INT32':
      return FieldDescriptorProto_Type.TYPE_INT32;
    case 'TYPE_FIXED64':
      return FieldDescriptorProto_Type.TYPE_FIXED64;
    case 'TYPE_FIXED32':
      return FieldDescriptorProto_Type.TYPE_FIXED32;
    case 'TYPE_STRING':
      return FieldDescriptorProto_Type.TYPE_STRING;
    case 'TYPE_SFIXED32':
      return FieldDescriptorProto_Type.TYPE_SFIXED32;
    case 'TYPE_SINT32':
      return FieldDescriptorProto_Type.TYPE_SINT32;
    case 'TYPE_SINT64':
      return FieldDescriptorProto_Type.TYPE_SINT64;
    default:
      return FieldDescriptorProto_Type.TYPE_INT32;
  }
}
