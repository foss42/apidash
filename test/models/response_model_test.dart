import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'http_response_models.dart';
import 'request_models.dart';

void main() {
  test('Testing toJSON', () {
    expect(responseModel.toJson(), responseModelJson);
  });

  test('Testing fromJson', () {
    final responseModelData = HttpResponseModel.fromJson(responseModelJson);
    expect(responseModelData, responseModel);
  });

  test('Testing fromResponse', () async {
    var responseRec = await sendHttpRequest(
      requestModelGet1.id,
      requestModelGet1.apiType,
      requestModelGet1.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.body,
        '{"data":"Check out https://api.apidash.dev/docs to get started."}');
    expect(responseData.formattedBody, '''{
  "data": "Check out https://api.apidash.dev/docs to get started."
}''');
  });

  test('Testing fromResponse for contentType not Json', () async {
    var responseRec = await sendHttpRequest(
      requestModelGet13.id,
      requestModelGet13.apiType,
      requestModelGet13.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(1000));
    expect(responseData.contentType, 'text/html; charset=utf-8');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });

  test('Testing contentType override by the user having no charset (#630)',
      () async {
    var responseRec = await sendHttpRequest(
      requestModelPost11.id,
      requestModelPost11.apiType,
      requestModelPost11.httpRequestModel!,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.body, '{"data":"i love flutter"}');
    expect(responseData.contentType, 'application/json');
    expect(responseData.requestHeaders?['content-type'], 'application/json');
  });

  test('Testing default contentType charset added by dart', () async {
    var responseRec = await sendHttpRequest(
      requestModelPost12.id,
      requestModelPost12.apiType,
      requestModelPost12.httpRequestModel!,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.requestHeaders?['content-type'],
        'application/json; charset=utf-8');
  });

  test('Testing latin1 charset added by user', () async {
    var responseRec = await sendHttpRequest(
      requestModelPost13.id,
      requestModelPost13.apiType,
      requestModelPost13.httpRequestModel!,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.requestHeaders?['content-type'],
        'application/json; charset=latin1');
  });

  test('Testing fromResponse for Bad SSL with certificate check', () async {
    var responseRec = await sendHttpRequest(
      requestModelGetBadSSL.id,
      requestModelGetBadSSL.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );
    expect(responseRec.$3?.contains("CERTIFICATE_VERIFY_FAILED"), true);
    expect(responseRec.$1, isNull);
  });

  test('Testing fromResponse for Bad SSL with no certificate check', () async {
    var responseRec = await sendHttpRequest(
      requestModelGetBadSSL.id,
      requestModelGetBadSSL.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: true,
    );

    final responseData = responseModel.fromResponse(response: responseRec.$1!);
    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(400));
    expect(responseData.contentType, 'text/html');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });

  test('Testing hashcode', () {
    expect(responseModel.hashCode, greaterThan(0));
  });
}
