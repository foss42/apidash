import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'http_response_models.dart';

void main() {
  test('Testing toJSON', () {
    expect(responseModel.toJson(), responseModelJson);
  });

  test('Testing fromJson', () {
    final responseModelData = HttpResponseModel.fromJson(responseModelJson);
    expect(responseModelData, responseModel);
  });

  test('Testing fromResponse', () async {
    final response = await http.get(
      Uri.parse('https://api.apidash.dev/'),
    );
    final responseData = responseModel.fromResponse(response: response);
    expect(responseData.statusCode, 200);
    expect(responseData.body,
        '{"data":"Check out https://api.apidash.dev/docs to get started."}');
    expect(responseData.formattedBody, '''{
  "data": "Check out https://api.apidash.dev/docs to get started."
}''');
  });
  test('Testing fromResponse for contentType not Json', () async {
    final response = await http.get(
      Uri.parse('https://apidash.dev/'),
    );
    final responseData = responseModel.fromResponse(response: response);
    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(1000));
    expect(responseData.contentType, 'text/html; charset=utf-8');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });
  test('Testing hashcode', () {
    expect(responseModel.hashCode, greaterThan(0));
  });
}
