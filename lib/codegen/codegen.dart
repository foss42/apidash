import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show getNewUuid;
import 'dart/http.dart';
import 'dart/dio.dart';
import 'go/http.dart';
import 'kotlin/okhttp.dart';
import 'python/http_client.dart';
import 'python/requests.dart';
import 'rust/actix.dart';
import 'rust/ureq.dart';
import 'js/axios.dart';
import 'js/fetch.dart';
import 'others/har.dart';
import 'others/curl.dart';

class Codegen {
  String? getCode(
    CodegenLanguage codegenLanguage,
    RequestModel requestModel,
    String defaultUriScheme, {
    String? boundary,
  }) {
    String url = requestModel.url;

    if (url.isEmpty) {
      url = kDefaultUri;
    }
    if (!url.contains("://") && url.isNotEmpty) {
      url = "$defaultUriScheme://$url";
    }
    var rM = requestModel.copyWith(url: url);

    switch (codegenLanguage) {
      case CodegenLanguage.curl:
        return cURLCodeGen().getCode(rM);
      case CodegenLanguage.har:
        return HARCodeGen().getCode(rM, defaultUriScheme, boundary: boundary);
      case CodegenLanguage.dartHttp:
        return DartHttpCodeGen().getCode(rM);
      case CodegenLanguage.dartDio:
        return DartDioCodeGen().getCode(rM);
      case CodegenLanguage.jsAxios:
        return AxiosCodeGen().getCode(rM);
      case CodegenLanguage.jsFetch:
        return FetchCodeGen().getCode(rM);
      case CodegenLanguage.nodejsAxios:
        return AxiosCodeGen(isNodeJs: true).getCode(rM);
      case CodegenLanguage.nodejsFetch:
        return FetchCodeGen(isNodeJs: true).getCode(rM);
      case CodegenLanguage.kotlinOkHttp:
        return KotlinOkHttpCodeGen().getCode(rM);
      case CodegenLanguage.pythonHttpClient:
        return PythonHttpClientCodeGen()
            .getCode(rM, boundary: boundary ?? getNewUuid());
      case CodegenLanguage.pythonRequests:
        return PythonRequestsCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.rustUreq:
        return RustUreqCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.rustActix:
        return RustActixCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.goHttp:
        return GoHttpCodeGen().getCode(rM);
    }
  }
}
