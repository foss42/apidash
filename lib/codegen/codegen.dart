import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';
import 'dart/http.dart';
import 'kotlin/okhttp.dart';
import 'python/http_client.dart';
import 'python/requests.dart';
import 'others/har.dart';
import 'others/curl.dart';

class Codegen {
  String? getCode(
    CodegenLanguage codegenLanguage,
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    switch (codegenLanguage) {
      case CodegenLanguage.curl:
        return cURLCodeGen().getCode(requestModel, defaultUriScheme);
      case CodegenLanguage.har:
        return HARCodeGen().getCode(requestModel);
      case CodegenLanguage.dartHttp:
        return DartHttpCodeGen().getCode(requestModel, defaultUriScheme);
      case CodegenLanguage.kotlinOkHttp:
        return KotlinOkHttpCodeGen().getCode(requestModel, defaultUriScheme);
      case CodegenLanguage.pythonHttpClient:
        return PythonHttpClientCodeGen()
            .getCode(requestModel, defaultUriScheme);
      case CodegenLanguage.pythonRequests:
        return PythonRequestsCodeGen().getCode(requestModel, defaultUriScheme);
      default:
        throw ArgumentError('Invalid codegenLanguage');
    }
  }
}
