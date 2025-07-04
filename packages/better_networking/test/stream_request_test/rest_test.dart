import 'dart:async';
import 'dart:convert';

import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_request_model.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:seed/models/name_value_model.dart';
import 'package:test/test.dart';

void main() {
  group('streamHttpRequest: REST Specific Tests', () {
    test('GET (Regular)', () async {
      const model = HttpRequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
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
      expect(output?.$2?.body, contains('userId'));
    });

    test('POST (JSON Body)', () async {
      const model = HttpRequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts',
        method: HTTPVerb.post,
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        body: '{"title": "foo", "body": "bar", "userId": 1}',
      );

      final stream = await streamHttpRequest('post_test', APIType.rest, model);
      final output = await stream.first;

      expect(
        output?.$2?.statusCode,
        equals(201),
        reason: 'Expected 201 Created',
      );
      final body = jsonDecode(output!.$2!.body);
      expect(body['title'], equals('foo'));
      expect(body['body'], equals('bar'));
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
        url: 'https://jsonplaceholder.typicode.com/posts',
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
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.get,
        headers: [
          NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );
      final stream = await streamHttpRequest('get_test_c', APIType.rest, model);
      httpClientManager.cancelRequest('get_test_c');
      final output = await stream.first;
      final errMsg = output?.$4;
      expect(
        errMsg,
        'Request Cancelled',
        reason: 'Request Cancellation Failed',
      );
    });
  });
}
