import 'package:test/test.dart';
import 'package:apidash/models/name_value_model.dart';

void main() {
  const kvRow1 = NameValueModel(name: "harry", value: 23);
  String kvRow1Expected = "{harry: 23}";

  test('Testing toString()', () {
    expect(kvRow1.toString(), kvRow1Expected);
  });

  const kvRow2Expected = NameValueModel(name: "winter", value: "26");
  test('Testing copyWith()', () {
    expect(kvRow1.copyWith(name: "winter", value: "26"), kvRow2Expected);
  });

  test('Testing hashcode', () {
    expect(kvRow1.hashCode, greaterThan(0));
  });
}
