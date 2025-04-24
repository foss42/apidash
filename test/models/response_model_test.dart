import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
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

  test('Testing fromDioResponse (JSON)', () async {
    var responseRec = await sendDioRequest(
      requestModelGet1.id,
      requestModelGet1.apiType,
      requestModelGet1.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );

    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2!,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.body,
        '{"data":"Check out https://api.apidash.dev/docs to get started."}');
    expect(responseData.formattedBody, '''{
  "data": "Check out https://api.apidash.dev/docs to get started."
}''');
  });

  test('Testing fromDioResponse (non-JSON content)', () async {
    var responseRec = await sendDioRequest(
      requestModelGet13.id,
      requestModelGet1.apiType,
      requestModelGet13.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );

    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2!,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(1000));
    expect(responseData.contentType, 'text/html; charset=utf-8');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });

  test('Testing failed SSL check', () async {
    var responseRec = await sendDioRequest(
      requestModelGetBadSSL.id,
      requestModelGet1.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: false,
    );

    expect(responseRec.$3?.contains("CERTIFICATE_VERIFY_FAILED"), true);
    expect(responseRec.$1, isNull);
  });

  test('Testing ignore SSL check', () async {
    var responseRec = await sendDioRequest(
      requestModelGetBadSSL.id,
      requestModelGet1.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      defaultUriScheme: kDefaultUriScheme,
      noSSL: true,
    );

    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2!,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(400));
    expect(responseData.contentType, 'text/html');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });

  test('Testing hashcode', () {
    expect(responseModel.hashCode, greaterThan(0));
  });
}
