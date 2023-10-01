import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';
import 'dart/pkg_http.dart';
import 'kotlin/pkg_okhttp.dart';
import 'python/pkg_http_client.dart';
import 'python/pkg_requests.dart';
import 'others/har.dart';

class Codegen {
  String? getCode(
    CodegenLanguage codegenLanguage,
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    switch (codegenLanguage) {
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
