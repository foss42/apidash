import 'package:test/test.dart';
import 'package:apidash/models/kvrow_model.dart';

void main() {
  KVRow kvRow1 = const KVRow("harry", 23);
  String kvRow1Expected = "{harry: 23}";

  test('Testing toString()', () {
    expect(kvRow1.toString(), kvRow1Expected);
  });

  KVRow kvRow2Expected = const KVRow("winter", "26");
  test('Testing copyWith()', () {
    expect(kvRow1.copyWith(k: "winter", v: "26"), kvRow2Expected);
  });

  test('Testing hashcode', () {
    expect(kvRow1.hashCode, greaterThan(0));
  });
}
