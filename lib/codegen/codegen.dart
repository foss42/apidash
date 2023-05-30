import 'package:apidash/codegen/kotlin/pkg_okhttp.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request_model.dart';
import '../providers/collection_providers.dart';
import '../providers/settings_providers.dart';
import 'dart/pkg_http.dart';

class Codegen {
  const Codegen({required this.codegenLanguage});
  final CodegenLanguage codegenLanguage;
  String? getCode(
    WidgetRef ref,
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    final activeRequestModel = ref.watch(activeRequestModelProvider);
    final defaultUriScheme =
        ref.watch(settingsProvider.select((value) => value.defaultUriScheme));
    switch (codegenLanguage) {
      case CodegenLanguage.dartHttp:
        return DartHttpCodeGen().getCode(activeRequestModel!, defaultUriScheme);
      case CodegenLanguage.kotlinOkHttp:
        return KotlinOkHttpCodeGen().getCode(activeRequestModel!);
      default:
        throw ArgumentError('Invalid codegenLanguage');
    }
  }
}
