import 'package:apidash/codegen/kotlin/pkg_okhttp.dart';
import 'package:apidash/consts.dart';

import 'package:apidash/models/models.dart' show RequestModel;
import 'dart/pkg_http.dart';

class Codegen {
  String? getCode(
    CodegenLanguage codegenLanguage,
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    switch (codegenLanguage) {
      case CodegenLanguage.dartHttp:
        return DartHttpCodeGen().getCode(requestModel, defaultUriScheme);
      case CodegenLanguage.kotlinOkHttp:
        return KotlinOkHttpCodeGen().getCode(requestModel);
      default:
        throw ArgumentError('Invalid codegenLanguage');
    }
  }
}
