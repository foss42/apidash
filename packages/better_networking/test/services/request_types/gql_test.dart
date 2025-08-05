import 'dart:convert';
import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_request_model.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:test/test.dart';

const kGQLquery = r'''query {
      country(code: "IN") {
        name
        capital
        emoji
      }
    }
  ''';

void main() {
  group('streamHttpRequest: GraphQL Specific Tests', () {
    test('GraphQL Test (Should get the correct data)', () async {
      const model = HttpRequestModel(
        url: 'https://countries.trevorblades.com/',
        query: kGQLquery,
      );

      final stream = await streamHttpRequest(
        'graphql_test',
        APIType.graphql,
        model,
      );

      final response = await stream.first;

      expect(response, isNotNull, reason: 'No response from GraphQL server');
      final body = response!.$2?.body ?? '{}';

      final decoded = jsonDecode(body);
      final errors = decoded['errors'];
      if (errors != null) {
        fail('GraphQL Error: ${jsonEncode(errors)}');
      }

      final country = decoded['data']?['country'];
      expect(country, isNotNull, reason: 'No country data found');
      expect(country['name'], equals('India'));
      expect(country['capital'], isNotEmpty);
      expect(country['emoji'], isNotEmpty);
    });

    test('GraphQL: Invalid Query should return error', () async {
      const badQuery = r'''query { invalidField }''';
      const model = HttpRequestModel(
        url: 'https://countries.trevorblades.com/',
        query: badQuery,
      );
      final stream = await streamHttpRequest(
        'graphql_bad',
        APIType.graphql,
        model,
      );
      final output = await stream.first;

      final body = output!.$2?.body ?? '{}';
      final decoded = jsonDecode(body);
      final errors = decoded['errors'];
      expect(
        errors,
        isNotNull,
        reason: 'Invalid GraphQL query must return error',
      );
    });

    test('GraphQL: Cancellation should work', () async {
      const model = HttpRequestModel(
        url: 'https://countries.trevorblades.com/',
        query: kGQLquery,
      );
      final stream = await streamHttpRequest(
        'graphql_test_cancellation',
        APIType.graphql,
        model,
      );
      httpClientManager.cancelRequest('graphql_test_cancellation');
      final output = await stream.last;
      final errMsg = output?.$4;
      expect(errMsg, 'Request Cancelled');
    });
  });
}
