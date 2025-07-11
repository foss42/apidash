import 'package:better_networking/models/auth/auth_api_key_model.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthApiKeyModel', () {
    test("Testing AuthApiKeyModel copyWith", () {
      var authApiKeyModel = authApiKeyModel1;
      final authApiKeyModelCopyWith = authApiKeyModel.copyWith(
        key: 'new_api_key',
        location: 'query',
      );
      expect(authApiKeyModelCopyWith.key, 'new_api_key');
      expect(authApiKeyModelCopyWith.location, 'query');
      // original model unchanged
      expect(authApiKeyModel.key, 'ak-test-key-12345');
      expect(authApiKeyModel.location, 'header');
      expect(authApiKeyModel.name, 'x-api-key');
    });

    test("Testing AuthApiKeyModel toJson", () {
      var authApiKeyModel = authApiKeyModel1;
      expect(authApiKeyModel.toJson(), authApiKeyModelJson1);
    });

    test("Testing AuthApiKeyModel fromJson", () {
      var authApiKeyModel = authApiKeyModel1;
      final modelFromJson = AuthApiKeyModel.fromJson(authApiKeyModelJson1);
      expect(modelFromJson, authApiKeyModel);
      expect(modelFromJson.key, 'ak-test-key-12345');
      expect(modelFromJson.location, 'header');
      expect(modelFromJson.name, 'x-api-key');
    });

    test("Testing AuthApiKeyModel getters", () {
      var authApiKeyModel = authApiKeyModel1;
      expect(authApiKeyModel.key, 'ak-test-key-12345');
      expect(authApiKeyModel.location, 'header');
      expect(authApiKeyModel.name, 'x-api-key');
    });

    test("Testing AuthApiKeyModel default values", () {
      const authApiKeyModelMinimal = AuthApiKeyModel(key: 'test-key');
      expect(authApiKeyModelMinimal.key, 'test-key');
      expect(authApiKeyModelMinimal.location, 'header'); // default value
      expect(authApiKeyModelMinimal.name, 'x-api-key'); // default value
    });

    test("Testing AuthApiKeyModel equality", () {
      const authApiKeyModel1Copy = AuthApiKeyModel(
        key: 'ak-test-key-12345',
        location: 'header',
        name: 'x-api-key',
      );
      expect(authApiKeyModel1, authApiKeyModel1Copy);
      expect(authApiKeyModel1, isNot(authApiKeyModel2));
    });

    test("Testing AuthApiKeyModel with different configurations", () {
      expect(authApiKeyModel2.key, 'query-api-key-67890');
      expect(authApiKeyModel2.location, 'query');
      expect(authApiKeyModel2.name, 'api_key');
      expect(authApiKeyModel1.location, isNot(authApiKeyModel2.location));
      expect(authApiKeyModel1.name, isNot(authApiKeyModel2.name));
    });
  });
}
