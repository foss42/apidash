import 'package:better_networking/models/auth/auth_basic_model.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthBasicAuthModel', () {
    test("Testing AuthBasicAuthModel copyWith", () {
      var authBasicModel = authBasicModel1;
      final authBasicModelCopyWith = authBasicModel.copyWith(
        password: 'new_password',
      );
      expect(authBasicModelCopyWith.password, 'new_password');
      // original model unchanged
      expect(authBasicModel.username, 'john_doe');
      expect(authBasicModel.password, 'secure_password');
    });

    test("Testing AuthBasicAuthModel toJson", () {
      var authBasicModel = authBasicModel1;
      expect(authBasicModel.toJson(), authBasicModelJson1);
    });

    test("Testing AuthBasicAuthModel fromJson", () {
      var authBasicModel = authBasicModel1;
      final modelFromJson = AuthBasicAuthModel.fromJson(authBasicModelJson1);
      expect(modelFromJson, authBasicModel);
      expect(modelFromJson.username, 'john_doe');
      expect(modelFromJson.password, 'secure_password');
    });

    test("Testing AuthBasicAuthModel getters", () {
      var authBasicModel = authBasicModel1;
      expect(authBasicModel.username, 'john_doe');
      expect(authBasicModel.password, 'secure_password');
    });

    test("Testing AuthBasicAuthModel equality", () {
      const authBasicModel1Copy = AuthBasicAuthModel(
        username: 'john_doe',
        password: 'secure_password',
      );
      expect(authBasicModel1, authBasicModel1Copy);
      expect(authBasicModel1, isNot(authBasicModel2));
    });

    test("Testing AuthBasicAuthModel with different values", () {
      expect(authBasicModel2.username, 'jane_smith');
      expect(authBasicModel2.password, 'another_password');
      expect(authBasicModel1.username, isNot(authBasicModel2.username));
      expect(authBasicModel1.password, isNot(authBasicModel2.password));
    });
  });
}
