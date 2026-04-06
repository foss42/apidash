import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

Future<String> flutterOAuth2CallbackHandler(
  String url, {
  required String callbackUrlScheme,
}) async {
  return FlutterWebAuth2.authenticate(
    url: url,
    callbackUrlScheme: callbackUrlScheme,
    options: const FlutterWebAuth2Options(
      useWebview: true,
      windowName: 'OAuth Authorization - API Dash',
    ),
  );
}
