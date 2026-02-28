import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
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
}
