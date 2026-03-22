import 'dart:typed_data';
import 'package:better_networking/consts.dart';
import 'package:better_networking/models/models.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('HttpResponseModel', () {
    test('should serialize and deserialize correctly', () {
      final model = HttpResponseModel(
        statusCode: 200,
        headers: {'Content-Type': 'application/json'},
        requestHeaders: {'Accept': 'application/json'},
        body: '{"message":"ok"}',
        formattedBody: '{"message":"ok"}',
        bodyBytes: Uint8List.fromList([123, 34, 109, 101]),
        time: const Duration(milliseconds: 300),
        sseOutput: ['event1', 'event2'],
      );

      final json = model.toJson();
      final fromJson = HttpResponseModel.fromJson(json);

      expect(fromJson.statusCode, 200);
      expect(fromJson.headers?['Content-Type'], 'application/json');
      expect(fromJson.body, '{"message":"ok"}');
      expect(fromJson.time?.inMilliseconds, 300);
      expect(fromJson.bodyBytes, isNotNull);
      expect(fromJson.sseOutput?.length, 2);
    });

    test('contentType and mediaType getters', () {
      const model = HttpResponseModel(
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );

      expect(model.contentType, 'application/json; charset=utf-8');
      expect(model.mediaType?.mimeType, 'application/json');
    });

    test('fromResponse returns valid model (JSON body)', () {
      final http.Response response = http.Response(
        '{"key":"value"}',
        200,
        headers: {'content-type': 'application/json'},
      );

      final model = const HttpResponseModel().fromResponse(
        response: response,
        time: const Duration(milliseconds: 150),
      );

      expect(model.statusCode, 200);
      expect(model.body, '{"key":"value"}');
      expect(model.mediaType?.subtype, kSubTypeJson);
      expect(model.time?.inMilliseconds, 150);
    });

    test('fromResponse returns valid model (plain text body)', () {
      final http.Response response = http.Response(
        'This is plain text.',
        200,
        headers: {'content-type': 'text/plain'},
      );

      final model = const HttpResponseModel().fromResponse(
        response: response,
        time: const Duration(milliseconds: 50),
      );

      expect(model.statusCode, 200);
      expect(model.body, 'This is plain text.');
    });

    test('Uint8ListConverter converts correctly', () {
      const converter = Uint8ListConverter();
      final input = Uint8List.fromList([1, 2, 3, 4]);

      final json = converter.toJson(input);
      final output = converter.fromJson(json);

      expect(output, isA<Uint8List>());
      expect(output, equals(input));
    });

    test('DurationConverter converts correctly', () {
      const converter = DurationConverter();
      const input = Duration(seconds: 1, microseconds: 500);

      final json = converter.toJson(input);
      final output = converter.fromJson(json);

      expect(output?.inMicroseconds, input.inMicroseconds);
    });
  });
}
