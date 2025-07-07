import 'package:better_networking/models/auth/auth_bearer_model.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthBearerModel', () {
    test("Testing AuthBearerModel copyWith", () {
      var authBearerModel = authBearerModel1;
      final authBearerModelCopyWith = authBearerModel.copyWith(
        token: 'new_bearer_token',
      );
      expect(authBearerModelCopyWith.token, 'new_bearer_token');
      // original model unchanged
      expect(
        authBearerModel.token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );
    });

    test("Testing AuthBearerModel toJson", () {
      var authBearerModel = authBearerModel1;
      expect(authBearerModel.toJson(), authBearerModelJson1);
    });

    test("Testing AuthBearerModel fromJson", () {
      var authBearerModel = authBearerModel1;
      final modelFromJson = AuthBearerModel.fromJson(authBearerModelJson1);
      expect(modelFromJson, authBearerModel);
      expect(
        modelFromJson.token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );
    });

    test("Testing AuthBearerModel getters", () {
      var authBearerModel = authBearerModel1;
      expect(
        authBearerModel.token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );
    });

    test("Testing AuthBearerModel equality", () {
      const authBearerModel1Copy = AuthBearerModel(
        token:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );
      expect(authBearerModel1, authBearerModel1Copy);
      expect(authBearerModel1, isNot(authBearerModel2));
    });

    test("Testing AuthBearerModel with different tokens", () {
      expect(authBearerModel2.token, 'different_bearer_token_value');
      expect(authBearerModel1.token, isNot(authBearerModel2.token));
    });
  });
}
