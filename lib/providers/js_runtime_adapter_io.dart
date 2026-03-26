import 'package:flutter_js/flutter_js.dart';

typedef JsRuntimeAdapter = JavascriptRuntime;
typedef JsEvalResultAdapter = JsEvalResult;

JsRuntimeAdapter createJsRuntime() => getJavascriptRuntime();
