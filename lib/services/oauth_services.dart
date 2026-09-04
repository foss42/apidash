import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

/// Flutter implementation of OAuth2 callback handler using flutter_web_auth_2
Future<String> flutterOAuth2CallbackHandler(
  String url, {
  required String callbackUrlScheme,
}) async {
  return await FlutterWebAuth2.authenticate(
    url: url,
    callbackUrlScheme: callbackUrlScheme,
    options: const FlutterWebAuth2Options(
      useWebview: true,
      windowName: 'OAuth Authorization - API Dash',
    ),
  );
}
