import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show getNewUuid;
import 'c/curl.dart';
import 'csharp/rest_sharp.dart';
import 'dart/http.dart';
import 'dart/dio.dart';
import 'go/http.dart';
import 'kotlin/okhttp.dart';
import 'php/curl.dart';
import 'php/guzzle.dart';
import 'php/http_plug.dart';
import 'python/http_client.dart';
import 'python/requests.dart';
import 'ruby/faraday.dart';
import 'ruby/net_http.dart';
import 'rust/actix.dart';
import 'rust/curl_rust.dart';
import 'rust/reqwest.dart';
import 'rust/ureq.dart';
import 'js/axios.dart';
import 'js/fetch.dart';
import 'others/har.dart';
import 'others/curl.dart';
import 'julia/http.dart';
import 'java/unirest.dart';
import 'java/okhttp.dart';
import 'java/async_http_client.dart';
import 'java/httpclient.dart';

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
      case CodegenLanguage.goHttp:
        return GoHttpCodeGen().getCode(rM);
      case CodegenLanguage.jsAxios:
        return AxiosCodeGen().getCode(rM);
      case CodegenLanguage.jsFetch:
        return FetchCodeGen().getCode(rM);
      case CodegenLanguage.nodejsAxios:
        return AxiosCodeGen(isNodeJs: true).getCode(rM);
      case CodegenLanguage.nodejsFetch:
        return FetchCodeGen(isNodeJs: true).getCode(rM);
      case CodegenLanguage.javaAsyncHttpClient:
        return JavaAsyncHttpClientGen().getCode(rM);
      case CodegenLanguage.javaHttpClient:
        return JavaHttpClientCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.javaOkHttp:
        return JavaOkHttpCodeGen().getCode(rM);
      case CodegenLanguage.javaUnirest:
        return JavaUnirestGen().getCode(rM);
      case CodegenLanguage.juliaHttp:
        return JuliaHttpClientCodeGen().getCode(rM);
      case CodegenLanguage.kotlinOkHttp:
        return KotlinOkHttpCodeGen().getCode(rM);
      case CodegenLanguage.pythonHttpClient:
        return PythonHttpClientCodeGen()
            .getCode(rM, boundary: boundary ?? getNewUuid());
      case CodegenLanguage.pythonRequests:
        return PythonRequestsCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.rubyFaraday:
        return RubyFaradayCodeGen().getCode(rM);
      case CodegenLanguage.rubyNetHttp:
        return RubyNetHttpCodeGen().getCode(rM);
      case CodegenLanguage.rustActix:
        return RustActixCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.rustCurl:
        return RustCurlCodeGen().getCode(rM);
      case CodegenLanguage.rustReqwest:
        return RustReqwestCodeGen().getCode(rM);
      case CodegenLanguage.rustUreq:
        return RustUreqCodeGen().getCode(rM, boundary: boundary);
      case CodegenLanguage.phpGuzzle:
        return PhpGuzzleCodeGen().getCode(rM);
      case CodegenLanguage.phpCurl:
        return PHPcURLCodeGen().getCode(rM);
      case CodegenLanguage.cCurlCodeGen:
        return CCurlCodeGen().getCode(rM);
      case CodegenLanguage.cSharpRestSharp:
        return CSharpRestSharp().getCode(rM);
      case CodegenLanguage.phpHttpPlug:
        return PhpHttpPlugCodeGen().getCode(rM);
    }
  }
}
