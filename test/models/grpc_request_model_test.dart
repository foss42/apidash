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

    test('metadataMap excludes rows the user unchecked', () {
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'x-keep', value: 'yes'),
          NameValueModel(name: 'x-probe', value: 'disabled'),
          NameValueModel(name: 'x-also-keep', value: 'yes'),
        ],
        isMetadataEnabled: [true, false, true],
      );

      final map = model.metadataMap;
      expect(map, {'x-keep': 'yes', 'x-also-keep': 'yes'});
      expect(map.containsKey('x-probe'), isFalse);
    });

    test('metadataMap is empty when every row is unchecked', () {
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'x-a', value: '1'),
          NameValueModel(name: 'x-b', value: '2'),
        ],
        isMetadataEnabled: [false, false],
      );

      expect(model.metadataMap, isEmpty);
    });

    test('metadataMap keeps all rows when flag list is empty (legacy request)',
        () {
      // Requests saved before the checkbox feature carry the `[]` default.
      // Those rows must stay enabled rather than silently stop being sent.
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'x-a', value: '1'),
          NameValueModel(name: 'x-b', value: '2'),
        ],
        isMetadataEnabled: [],
      );

      expect(model.metadataMap, {'x-a': '1', 'x-b': '2'});
    });

    test('metadataMap keeps all rows when flag list is null', () {
      const model = GrpcRequestModel(
        metadata: [NameValueModel(name: 'x-a', value: '1')],
        isMetadataEnabled: null,
      );

      expect(model.metadataMap, {'x-a': '1'});
    });

    test('metadataMap keeps all rows when flag list length mismatches', () {
      // Defensive: a short/stale flag list must not drop or misalign rows.
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'x-a', value: '1'),
          NameValueModel(name: 'x-b', value: '2'),
          NameValueModel(name: 'x-c', value: '3'),
        ],
        isMetadataEnabled: [true, false],
      );

      expect(model.metadataMap, {'x-a': '1', 'x-b': '2', 'x-c': '3'});
    });

    test('metadataMap still drops empty-name rows when flags are present', () {
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: '', value: 'no name'),
          NameValueModel(name: 'x-b', value: '2'),
        ],
        isMetadataEnabled: [true, true],
      );

      expect(model.metadataMap, {'x-b': '2'});
    });

    test('metadataMap maps enabled flags positionally, not by value', () {
      // Duplicate names must not confuse index alignment. Keeping the *first*
      // row is what distinguishes correct filtering from no filtering at all,
      // since an unfiltered map would let the second row overwrite the first.
      const model = GrpcRequestModel(
        metadata: [
          NameValueModel(name: 'x-dup', value: 'first'),
          NameValueModel(name: 'x-dup', value: 'second'),
        ],
        isMetadataEnabled: [true, false],
      );

      expect(model.metadataMap, {'x-dup': 'first'});
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
