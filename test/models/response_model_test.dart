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

  test('Testing fromDioResponse (JSON)', () async {
    final responseRec = await sendDioRequest(
      requestModelGet1.id,
      requestModelGet1.apiType,
      requestModelGet1.httpRequestModel!,
    );

    expect(responseRec.$1, isNotNull, reason: 'Expected non-null response');
    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2 ?? Duration.zero,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.body,
        '{"data":"Check out https://api.apidash.dev/docs to get started."}');
    expect(responseData.formattedBody, '''{
  "data": "Check out https://api.apidash.dev/docs to get started."
}''');
  });

  test('Testing fromDioResponse (non-JSON content)', () async {
    final responseRec = await sendDioRequest(
      requestModelGet13.id,
      requestModelGet13.apiType,
      requestModelGet13.httpRequestModel!,
    );

    expect(responseRec.$1, isNotNull, reason: 'Expected non-null response');
    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2 ?? Duration.zero,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.body!.length, greaterThan(1000));
    expect(responseData.contentType, 'text/html; charset=utf-8');
    expect(responseData.mediaType!.mimeType, 'text/html');
  });

  // test('Testing contentType override by the user having no charset (#630)', () async {
  //   final responseRec = await sendDioRequest(
  //     requestModelPost11.id,
  //     requestModelPost11.apiType,
  //     requestModelPost11.httpRequestModel!,
  //   );

  //   expect(responseRec.$1, isNotNull, reason: 'Expected non-null response');
  //   final responseData = HttpResponseModel.fromDioResponse(
  //     response: responseRec.$1!,
  //     time: responseRec.$2 ?? Duration.zero,
  //   );

  //   expect(responseData.statusCode, 200);
  //   expect(responseData.body, '{"data":"i love flutter"}');
  //   expect(responseData.contentType, 'application/json');
  //   expect(responseData.requestHeaders?['content-type'], 'application/json');
  // });

  test('Testing default contentType charset added by dart', () async {
    final responseRec = await sendDioRequest(
      requestModelPost12.id,
      requestModelPost12.apiType,
      requestModelPost12.httpRequestModel!,
    );

    expect(responseRec.$1, isNotNull, reason: 'Expected non-null response');
    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2 ?? Duration.zero,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.requestHeaders?['content-type'],
        'application/json; charset=utf-8');
  });

  test('Testing latin1 charset added by user', () async {
    final responseRec = await sendDioRequest(
      requestModelPost13.id,
      requestModelPost13.apiType,
      requestModelPost13.httpRequestModel!,
    );

    expect(responseRec.$1, isNotNull, reason: 'Expected non-null response');
    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2 ?? Duration.zero,
    );

    expect(responseData.statusCode, 200);
    expect(responseData.requestHeaders?['content-type'],
        'application/json; charset=latin1');
  });

  test('Testing fromDioResponse for Bad SSL with certificate check', () async {
    final responseRec = await sendDioRequest(
      requestModelGetBadSSL.id,
      requestModelGetBadSSL.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      noSSL: false,
    );

    expect(responseRec.$1, isNull, reason: 'Response must be null on bad SSL');
    expect(responseRec.$3, isNotNull, reason: 'Expected SSL error message');
    expect(responseRec.$3!.contains('CERTIFICATE_VERIFY_FAILED'), true);
  });

  test('Testing ignore SSL check', () async {
    final responseRec = await sendDioRequest(
      requestModelGetBadSSL.id,
      requestModelGetBadSSL.apiType,
      requestModelGetBadSSL.httpRequestModel!,
      noSSL: true,
    );

    expect(responseRec.$1, isNotNull, reason: 'Expected non-null response with ignore SSL');
    final responseData = HttpResponseModel.fromDioResponse(
      response: responseRec.$1!,
      time: responseRec.$2 ?? Duration.zero,
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
