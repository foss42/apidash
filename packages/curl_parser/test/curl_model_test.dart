import 'dart:convert';

import 'package:curl_parser/curl_parser.dart';
import 'package:seed/seed.dart';
import 'package:test/test.dart';

void main() {
  group('toJson / fromJson', () {
    test('round-trips a simple GET request', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://api.example.com/users?page=1'),
      );
      final json = curl.toJson();
      final restored = Curl.fromJson(json);
      expect(restored, equals(curl));
    });

    test('round-trips via JSON string encoding/decoding', () {
      final curl = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/data'),
        headers: {'Content-Type': 'application/json', 'X-Custom': 'value'},
        data: '{"key":"value"}',
        cookie: 'session=abc123',
        user: 'admin:secret',
        referer: 'https://example.com',
        userAgent: 'TestAgent/1.0',
        insecure: true,
        location: true,
      );
      final jsonString = jsonEncode(curl.toJson());
      final restored = Curl.fromJson(jsonDecode(jsonString));
      expect(restored, equals(curl));
    });

    test('round-trips with form data', () {
      final curl = Curl(
        method: 'POST',
        uri: Uri.parse('https://api.example.com/upload'),
        form: true,
        formData: [
          FormDataModel(
              name: 'file', value: '/path/to/file', type: FormDataType.file),
          FormDataModel(name: 'field', value: 'hello', type: FormDataType.text),
        ],
      );
      final json = curl.toJson();
      final restored = Curl.fromJson(json);
      expect(restored, equals(curl));
    });

    test('null optional fields serialize as null in toJson', () {
      final curl = Curl(
        method: 'GET',
        uri: Uri.parse('https://example.com'),
      );
      final json = curl.toJson();
      expect(json['headers'], isNull);
      expect(json['data'], isNull);
      expect(json['cookie'], isNull);
      expect(json['user'], isNull);
      expect(json['referer'], isNull);
      expect(json['userAgent'], isNull);
      expect(json['formData'], isNull);
    });

    test('fromJson uses defaults for missing boolean fields', () {
      final json = {
        'method': 'GET',
        'uri': 'https://example.com',
      };
      final curl = Curl.fromJson(json);
      expect(curl.form, isFalse);
      expect(curl.insecure, isFalse);
      expect(curl.location, isFalse);
    });
  });

  test('should not throw when form data entries are provided', () {
    expect(
      () => Curl(
        uri: Uri.parse('https://api.apidash.dev/upload'),
        method: 'POST',
        form: true,
        formData: [
          FormDataModel(
              name: "username", value: "john", type: FormDataType.text),
          FormDataModel(
              name: "password", value: "password", type: FormDataType.text),
        ],
      ),
      returnsNormally,
    );
  });

  test('should not throw when form data is null', () {
    expect(
      () => Curl(
        uri: Uri.parse('https://api.apidash.dev/upload'),
        method: 'POST',
        form: false,
        formData: null,
      ),
      returnsNormally,
    );
  });
}
