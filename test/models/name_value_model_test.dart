import 'package:test/test.dart';
import 'package:apidash/models/name_value_model.dart';

void main() {
  const nmRow1 = NameValueModel(name: "harry", value: 23);

  test('Testing toString()', () {
    const resultExpected =
        'NameValueModel(enabled: true, name: harry, value: 23)';
    expect(nmRow1.toString(), resultExpected);
  });

  test('Testing toJson()', () {
    const resultExpected = {"enabled": true, "name": "harry", "value": 23};
    expect(nmRow1.toJson(), resultExpected);
  });

  test('Testing copyWith()', () {
    const resultExpected = NameValueModel(name: "winter", value: "26");
    expect(nmRow1.copyWith(name: "winter", value: "26"), resultExpected);
  });

  test('Testing hashcode', () {
    expect(nmRow1.hashCode, greaterThan(0));
  });
}
