import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthType {
  none,
  basicAuth,
  apiKey,
  bearerToken,
  jwtBearer,
  digestAuth,
  oauth1,
  oauth2,
}

String authTypeToString(AuthType authType) {
  switch (authType) {
    case AuthType.basicAuth:
      return "Basic Auth";
    case AuthType.apiKey:
      return "API Key";
    case AuthType.bearerToken:
      return "Bearer Token";
    case AuthType.jwtBearer:
      return "JWT Bearer";
    case AuthType.digestAuth:
      return "Digest Auth";
    case AuthType.oauth1:
      return "OAuth 1.0";
    case AuthType.oauth2:
      return "OAuth 2.0";
    case AuthType.none:
    default:
      return "None";
  }
}

final authTypeProvider = StateProvider<AuthType>((ref) => AuthType.none);
final authCredentialsProvider = StateProvider<Map<String, String>>((ref) => {
      'username': '',
      'password': '',
      'apiKey': '',
      'token': '',
    });

void updateAuthType(WidgetRef ref, AuthType newAuthType) {
  ref.read(authTypeProvider.notifier).state = newAuthType;
}

void updateCredentials(WidgetRef ref, Map<String, String> newCredentials) {
  ref.read(authCredentialsProvider.notifier).update((state) => {
        ...state,
        ...newCredentials,
      });
}

List<NameValueModel> generateAuthHeaders(WidgetRef ref) {
  final authType = ref.read(authTypeProvider);
  final credentials = ref.read(authCredentialsProvider);

  switch (authType) {
    case AuthType.basicAuth:
      if (credentials['username']?.isNotEmpty == true &&
          credentials['password']?.isNotEmpty == true) {
        String basicAuth =
            'Basic ${base64Encode(utf8.encode('${credentials['username']}:${credentials['password']}'))}';
        return [NameValueModel(name: "Authorization", value: basicAuth)];
      }
      break;
    case AuthType.bearerToken:
    case AuthType.jwtBearer:
      break;
    case AuthType.apiKey:
      break;
    case AuthType.oauth1:
    case AuthType.oauth2:
    case AuthType.digestAuth:
    case AuthType.none:
      break;
  }
  return [];
}
