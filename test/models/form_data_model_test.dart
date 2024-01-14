import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import 'package:apidash/models/form_data_model.dart';

void main() {
  const fdmRow1 = FormDataModel(
    name: "harry",
    value: "23",
    type: FormDataType.text,
  );

  test('Testing toString()', () {
    const resultExpected =
        'FormDataModel(name: harry, value: 23, type: FormDataType.text)';
    expect(fdmRow1.toString(), resultExpected);
  });

  test('Testing toJson()', () {
    const resultExpected = {"name": "harry", "value": "23", "type": "text"};
    expect(fdmRow1.toJson(), resultExpected);
  });
  test('Testing fromJson()', () {
    const resultExpected = fdmRow1;
    expect(
        FormDataModel.fromJson(
            {"name": "harry", "value": "23", "type": "text"}),
        resultExpected);
  });

  test('Testing copyWith()', () {
    const resultExpected = FormDataModel(
      name: "winter",
      value: "26",
      type: FormDataType.file,
    );
    expect(
        fdmRow1.copyWith(name: "winter", value: "26", type: FormDataType.file),
        resultExpected);
  });

  test('Testing hashcode', () {
    expect(fdmRow1.hashCode, greaterThan(0));
  });
}
