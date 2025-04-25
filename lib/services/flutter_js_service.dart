import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

late JavascriptRuntime jsRuntime;

void initializeJsRuntime() {
  jsRuntime = getJavascriptRuntime();
}

void disposeJsRuntime() {
  jsRuntime.dispose();
}

void evaluate(String code) {
  try {
    JsEvalResult jsResult = jsRuntime.evaluate(code);
    log(jsResult.stringResult);
  } on PlatformException catch (e) {
    log('ERROR: ${e.details}');
  }
}
