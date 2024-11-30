import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/form_data_model.dart';
import 'package:curl_parser/curl_parser.dart';
import 'package:test/test.dart';

void main() {
  test('should not throw when form data entries are provided', () {
    expect(
      () => Curl(
        uri: Uri.parse('https://api.apidash.dev/upload'),
        method: 'POST',
        form: true,
        formData: [
          FormDataModel(
              name: "username", value: "john", type: FormDataType.text),
          FormDataModel(
              name: "password", value: "password", type: FormDataType.text),
        ],
      ),
      returnsNormally,
    );
  });

  test('should not throw when form data is null', () {
    expect(
      () => Curl(
        uri: Uri.parse('https://api.apidash.dev/upload'),
        method: 'POST',
        form: false,
        formData: null,
      ),
      returnsNormally,
    );
  });
}
