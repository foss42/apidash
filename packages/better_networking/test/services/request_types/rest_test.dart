import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:better_networking/better_networking.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group('sendHttpRequest: REST Specific Tests', () {
    test('GET (Regular)', () async {
      const model = HttpRequestModel(
        url: 'https://api.apidash.dev',
        method: HTTPVerb.get,
        headers: [
          NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );
      final (resp, dur, err) = await sendHttpRequest(
        'get_test',
        APIType.rest,
        model,
      );
      final output = jsonDecode(resp?.body ?? '{}');
      expect(resp?.statusCode == 200, true, reason: 'Response must be 200');
      expect(jsonEncode(output), contains('doc'));
    });
  });

  group('streamHttpRequest: MULTIPART', () {
    test('MULTIPART (Regular)', () async {
      final tempDir = Directory.systemTemp.createTempSync();
      const fullName = 'temp_image.png';
      const token = 'xyz';
      final file = File('${tempDir.path}/$fullName');
      file.writeAsBytesSync(
        Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]),
      );
      final model = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/io/img',
        bodyContentType: ContentType.formdata,
        body: r"""{
"text": "I LOVE Flutter"
}""",
        formData: [
          const FormDataModel(
            name: "token",
            value: token,
            type: FormDataType.text,
          ),
          FormDataModel(
            name: "imfile",
            value: file.path,
            type: FormDataType.file,
          ),
        ],
      );
      final (resp, dur, err) = await sendHttpRequest(
        'mpreq',
        APIType.rest,
        model,
      );
      final output = jsonDecode(resp?.body ?? '{}');
      expect(resp?.statusCode == 200, true, reason: 'Response must be 200');
      expect(
        jsonEncode(output),
        contains(fullName),
        reason: 'Response must contain filename',
      );
      expect(
        jsonEncode(output),
        contains(token),
        reason: 'Response must contain token',
      );
    });
  });

  group('streamHttpRequest: REST Specific Tests', () {
    test('GET (Regular)', () async {
      const model = HttpRequestModel(
        url: 'https://api.apidash.dev',
        method: HTTPVerb.get,
        headers: [
          NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );
      final stream = await streamHttpRequest('get_test', APIType.rest, model);
      final output = await stream.first;
      expect(
        output?.$2?.statusCode == 200,
        true,
        reason: 'Response must be 200',
      );
      expect(output?.$2?.body, contains('doc'));
    });

    test('POST (JSON Body)', () async {
      const model = HttpRequestModel(
        url: 'https://api.apidash.dev/case/lower',
        method: HTTPVerb.post,
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        body: r"""{
"text": "I LOVE Flutter"
}""",
      );

      final stream = await streamHttpRequest('post_test', APIType.rest, model);
      final output = await stream.first;

      expect(output?.$2?.statusCode, equals(200), reason: 'Expected 200 Ok');
      final body = jsonDecode(output!.$2!.body);
      expect(body['data'], equals('i love flutter'));
    });

    test('Empty URL should be handled', () async {
      const model = HttpRequestModel(url: '', method: HTTPVerb.get);
      final stream = await streamHttpRequest(
        'empty_url_test',
        APIType.rest,
        model,
      );
      final output = await stream.first;
      expect(
        output?.$4,
        'URL is missing!',
        reason: 'Should show that URL is missing',
      );
    });

    test('Should Show Error for invalid URL', () async {
      const model = HttpRequestModel(url: '', method: HTTPVerb.get);
      final stream = await streamHttpRequest(
        'invalid_url_test',
        APIType.rest,
        model,
      );
      final output = await stream.first;

      expect(
        output?.$4,
        isNotNull,
        reason: 'Should return error for invalid URL',
      );
    });

    test('REST: Large response body', () async {
      const model = HttpRequestModel(
        url: 'https://api.github.com/repos/foss42/apidash',
        method: HTTPVerb.get,
      );

      final stream = await streamHttpRequest(
        'large_body_test',
        APIType.rest,
        model,
      );
      final output = await stream.first;

      final body = output!.$2?.body;
      expect(body, isNotNull);
      expect(
        body!.length,
        greaterThan(500),
        reason: 'Response should be large enough',
      );
    });

    test('REST: Cancellation', () async {
      const model = HttpRequestModel(
        url: 'https://api.apidash.dev/io/delay',
        method: HTTPVerb.get,
        params: [NameValueModel(name: 'wait', value: '5')],
        headers: [
          NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );
      Future.delayed(const Duration(seconds: 2), () {
        debugPrint("Stream canceled");
        cancelHttpRequest('get_test_c');
      });
      debugPrint("Stream start");
      final stream = await streamHttpRequest('get_test_c', APIType.rest, model);
      debugPrint("Stream get output");
      final output = await stream.first;
      final errMsg = output?.$4;
      expect(errMsg, 'Request Cancelled');
    });
  });

  group('Testing overrideContentType functionality', () {
    test('overrideContentType is true', () async {
      final request = prepareHttpRequest(
        url: Uri.parse('https://www.example.com'),
        method: 'POST',
        body: 'Hello',
        headers: {'content-type': 'application/json'},
        overrideContentType: true,
      );
      expect(request.headers['content-type'], 'application/json');
    });

    test('overrideContentType is false', () async {
      final request = prepareHttpRequest(
        url: Uri.parse('https://www.example.com'),
        method: 'POST',
        body: 'Hello',
        headers: {'content-type': 'application/json'},
        overrideContentType: false,
      );
      expect(request.headers['content-type'], isNot('application/json'));
      expect(
        request.headers['content-type'],
        'application/json; charset=utf-8',
      );
    });
  });
}
