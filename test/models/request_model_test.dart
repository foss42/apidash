import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'request_models.dart';

void main() {
  test('Testing copyWith', () {
    final requestModelcopyWith = testRequestModel.copyWith(name: 'API foss42');
    expect(requestModelcopyWith.name, 'API foss42');
  });

  test('Testing toJson', () {
    expect(testRequestModel.toJson(), requestModelJson);
  });

  test('Testing fromJson', () {
    final modelFromJson = RequestModel.fromJson(requestModelJson);
    expect(modelFromJson, testRequestModel);
  });

  group('Testing getUrl', () {
    test('when apiType is rest and httpRequestModel has url', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.rest,
      );
      expect(requestModel.getUrl(), 'https://api.apidash.dev/case/lower');
    });

    test('when apiType is rest and httpRequestModel is null', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.rest,
        httpRequestModel: null,
      );
      expect(requestModel.getUrl(), null);
    });

    test('when apiType is graphql and httpRequestModel has url', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.graphql,
      );
      expect(requestModel.getUrl(), 'https://api.apidash.dev/case/lower');
    });

    test('when apiType is graphql and httpRequestModel is null', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.graphql,
        httpRequestModel: null,
      );
      expect(requestModel.getUrl(), null);
    });

    test('when apiType is ai and aiRequestModel has url', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.ai,
        aiRequestModel: const AIRequestModel(url: 'https://api.ai.com'),
      );
      expect(requestModel.getUrl(), 'https://api.ai.com');
    });

    test('when apiType is ai and aiRequestModel is null', () {
      final requestModel = testRequestModel.copyWith(
        apiType: APIType.ai,
        aiRequestModel: null,
      );
      expect(requestModel.getUrl(), null);
    });
  });
}
