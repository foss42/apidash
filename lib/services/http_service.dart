import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

Future<(Response?, Duration?, String?)> request(
  RequestModel requestModel, {
  String defaultUriScheme = kDefaultUriScheme,
}) async {
  (Uri?, String?) uriRec = getValidRequestUri(
    requestModel.url,
    requestModel.enabledRequestParams,
    defaultUriScheme: defaultUriScheme,
  );
  if (uriRec.$1 != null) {
    Uri requestUrl = uriRec.$1!;
    Map<String, String> headers = requestModel.enabledHeadersMap;
    Response response;
    String? body;
    Dio dio = Dio();
    try {
      Stopwatch stopwatch = Stopwatch()..start();
      var isMultiPartRequest =
          requestModel.requestBodyContentType == ContentType.formdata;
      if (kMethodsWithBody.contains(requestModel.method)) {
        var requestBody = requestModel.requestBody;
        if (requestBody != null && !isMultiPartRequest) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            body = requestBody;
            headers[HttpHeaders.contentLengthHeader] = contentLength.toString();
            if (!requestModel.hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.requestBodyContentType.header;
            }
          }
        }
        if (isMultiPartRequest) {
          final formData = FormData();
          for (FormDataModel data in (requestModel.requestFormDataList ?? [])) {
            if (data.type == FormDataType.text) {
              formData.fields.add(MapEntry(data.name, data.value));
            } else {
              formData.files.add(MapEntry(data.name,
                  await MultipartFile.fromFile(data.value, filename: data.name)));
            }
          }
          Response multiPartResponse = await dio.request(
            requestUrl.toString(),
            data: formData,
            options: Options(
              method: requestModel.method.name.toUpperCase(),
              headers: headers,
            ),
            cancelToken: requestModel.cancelToken,
          );
          dio.close();
          return (multiPartResponse, stopwatch.elapsed, null);
        }
      }
      switch (requestModel.method) {
        case HTTPVerb.get:
          response = await dio.get(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            cancelToken: requestModel.cancelToken,
          );
          break;
        case HTTPVerb.head:
          response = await dio.head(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            cancelToken: requestModel.cancelToken,
          );
          break;
        case HTTPVerb.post:
          response = await dio.post(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            data: body,
            cancelToken: requestModel.cancelToken,
          );
          break;
        case HTTPVerb.put:
          response = await dio.put(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            data: body,
            cancelToken: requestModel.cancelToken,
          );
          break;
        case HTTPVerb.patch:
          response = await dio.patch(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            data: body,
            cancelToken: requestModel.cancelToken,
          );
          break;
        case HTTPVerb.delete:
          response = await dio.delete(
            requestUrl.toString(),
            options: Options(
              headers: headers,
            ),
            data: body,
            cancelToken: requestModel.cancelToken,
          );
          break;
      }
      dio.close();
      stopwatch.stop();
      return (response, stopwatch.elapsed, null);
    }on DioException catch(e){
      dio.close();
      if(e.type == DioExceptionType.cancel){
        return (null, null, e.type.toString());
      }
      return (null, null, e.toString());
    } catch (e) {
      dio.close();
      return (null, null, e.toString());
    }
  } else {
    return (null, null, uriRec.$2);
  }
}
