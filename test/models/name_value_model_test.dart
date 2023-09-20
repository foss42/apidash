import 'package:test/test.dart';
import 'package:apidash/models/name_value_model.dart';

void main() {
  const nmRow1 = NameValueModel(name: "harry", value: 23);

  test('Testing toString()', () {
    const nmRow1Expected = {"name": "harry", "value": 23};
    expect(nmRow1.toJson(), nmRow1Expected);
  });

  test('Testing copyWith()', () {
    const nmRow2Expected = NameValueModel(name: "winter", value: "26");
    expect(nmRow1.copyWith(name: "winter", value: "26"), nmRow2Expected);
  });

  test('Testing hashcode', () {
    expect(nmRow1.hashCode, greaterThan(0));
  });
}
