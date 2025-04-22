import 'package:flutter_js/flutter_js.dart';

late JavascriptRuntime jsRuntime;

void initializeJsRuntime() {
  jsRuntime = getJavascriptRuntime();
}

void disposeJsRuntime() {
  jsRuntime.dispose();
}
