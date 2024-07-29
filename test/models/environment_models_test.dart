import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

import 'environment_models.dart';

void main() {
  group("Testing EnvironmentModel", () {
    test("Testing EnvironmentModel copyWith", () {
      var environmentModel = environmentModel1;
      final environmentModelcopyWith =
          environmentModel.copyWith(name: 'Production');
      expect(environmentModelcopyWith.name, 'Production');
      // original model unchanged
      expect(environmentModel.name, 'Development');
    });

    test("Testing EnvironmentModel toJson", () {
      var environmentModel = environmentModel1;
      expect(environmentModel.toJson(), environmentModel1Json);
    });

    test("Testing EnvironmentModel fromJson", () {
      var environmentModel = environmentModel1;
      final modelFromJson = EnvironmentModel.fromJson(environmentModel1Json);
      expect(modelFromJson, environmentModel);
      expect(modelFromJson.values, const [
        EnvironmentVariableModel(
          key: 'key1',
          value: 'value1',
          type: EnvironmentVariableType.variable,
          enabled: true,
        ),
        EnvironmentVariableModel(
          key: 'key2',
          value: 'value2',
          type: EnvironmentVariableType.variable,
          enabled: false,
        ),
      ]);
    });

    test("Testing EnvironmentModel getters", () {
      var environmentModel = environmentModel1;
      expect(environmentModel.values, const [
        EnvironmentVariableModel(
          key: 'key1',
          value: 'value1',
          type: EnvironmentVariableType.variable,
          enabled: true,
        ),
        EnvironmentVariableModel(
          key: 'key2',
          value: 'value2',
          type: EnvironmentVariableType.variable,
          enabled: false,
        ),
      ]);
      expect(environmentModel.name, 'Development');
      expect(environmentModel.id, 'environmentId');
    });

    test("Testing EnvironmentModel immutability", () {
      var testEnvironmentModel = environmentModel1;
      final testEnvironmentModel2 =
          testEnvironmentModel.copyWith(values: testEnvironmentModel.values);
      expect(testEnvironmentModel2.values, testEnvironmentModel.values);

      expect(
          identical(testEnvironmentModel.values, testEnvironmentModel2.values),
          false);
      var testEnvironmentModel3 = testEnvironmentModel.copyWith(values: []);
      expect(testEnvironmentModel3.values, []);
    });
  });

  group("Testing EnvironmentVariableModel", () {
    test("Testing EnvironmentVariableModel copyWith", () {
      var environmentVariableModel = environmentVariableModel1;
      final environmentVariableModelcopyWith = environmentVariableModel
          .copyWith(key: 'key3', value: 'value3', enabled: false);
      expect(environmentVariableModelcopyWith.key, 'key3');
      expect(environmentVariableModelcopyWith.value, 'value3');
      expect(environmentVariableModelcopyWith.enabled, false);
      // original model unchanged
      expect(environmentVariableModel.key, 'key1');
      expect(environmentVariableModel.value, 'value1');
      expect(environmentVariableModel.enabled, true);
    });

    test("Testing EnvironmentVariableModel toJson", () {
      var environmentVariable = environmentVariableModel1;
      expect(environmentVariable.toJson(), environmentVariableModel1Json);

      var environmentSecret = environmentVariableModel2;
      expect(environmentSecret.toJson(), environmentVariableModel2Json);
    });

    test("Testing EnvironmentVariableModel fromJson", () {
      var environmentVariableModel = environmentVariableModel1;
      final modelFromJson =
          EnvironmentVariableModel.fromJson(environmentVariableModel1Json);
      expect(modelFromJson, environmentVariableModel);
    });

    test("Testing EnvironmentVariableModel getters", () {
      var environmentVariableModel = environmentVariableModel1;
      expect(environmentVariableModel.key, 'key1');
      expect(environmentVariableModel.value, 'value1');
      expect(environmentVariableModel.enabled, true);
    });

    test("Testing EnvironmentVariableModel immutability", () {
      var testEnvironmentVariableModel = environmentVariableModel1;
      final testEnvironmentVariableModel2 =
          testEnvironmentVariableModel.copyWith(key: 'key2');
      expect(testEnvironmentVariableModel2.key, 'key2');
      expect(testEnvironmentVariableModel2.value, 'value1');
      expect(testEnvironmentVariableModel2.enabled, true);

      expect(
          identical(
              testEnvironmentVariableModel, testEnvironmentVariableModel2),
          false);
    });
  });

  group("Testing EnvironmentVariableSuggestionModel", () {
    test("Testing EnvironmentVariableSuggestionModel copyWith", () {
      var environmentVariableSuggestionModel = environmentVariableSuggestion1;
      final environmentVariableSuggestionModelcopyWith =
          environmentVariableSuggestionModel.copyWith(
              environmentId: 'environmentId2',
              variable: environmentVariableModel2,
              isUnknown: true);
      expect(environmentVariableSuggestionModelcopyWith.environmentId,
          'environmentId2');
      expect(environmentVariableSuggestionModelcopyWith.variable,
          environmentVariableModel2);
      expect(environmentVariableSuggestionModelcopyWith.isUnknown, true);
      // original model unchanged
      expect(environmentVariableSuggestionModel.environmentId, 'environmentId');
      expect(environmentVariableSuggestionModel.variable,
          environmentVariableModel1);
      expect(environmentVariableSuggestionModel.isUnknown, false);
    });

    test("Testing EnvironmentVariableSuggestionModel immutability", () {
      var testEnvironmentVariableSuggestionModel =
          environmentVariableSuggestion1;
      final testEnvironmentVariableSuggestionModel2 =
          testEnvironmentVariableSuggestionModel.copyWith(
              environmentId: 'environmentId2',
              variable: environmentVariableModel2,
              isUnknown: true);
      expect(testEnvironmentVariableSuggestionModel2.environmentId,
          'environmentId2');
      expect(testEnvironmentVariableSuggestionModel2.variable,
          environmentVariableModel2);
      expect(testEnvironmentVariableSuggestionModel2.isUnknown, true);

      expect(
          identical(testEnvironmentVariableSuggestionModel,
              testEnvironmentVariableSuggestionModel2),
          false);
    });

    test("Testing EnvironmentVariableSuggestionModel hashCode", () {
      var environmentVariableSuggestionModel = environmentVariableSuggestion1;
      expect(environmentVariableSuggestionModel.hashCode, greaterThan(0));
    });
  });
}
