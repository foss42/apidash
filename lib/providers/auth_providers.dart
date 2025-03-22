import 'dart:convert';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTypeProvider = StateProvider<AuthType>((ref) => AuthType.none);
final authDataProvider = StateProvider<Map<String, String>?>((ref) => null);
final authHeaderProvider = Provider<String?>(
  (ref) {
    final authType = ref.watch(authTypeProvider);
    final authData = ref.watch(authDataProvider);
    return AuthMethod.generateHeader(authType, authData);
  },
);

class AuthMethod {
  static String? generateHeader(AuthType type, Map<String, String>? data) {
    if (type == AuthType.none || data == null || data.isEmpty) return null;

    switch (type) {
      case AuthType.oAuth2:
      case AuthType.oAuth1:
      case AuthType.digest:
      case AuthType.jwtBearer:
      case AuthType.bearer:
        final token = data['token'] ?? '';
        if (token.isEmpty) return null;
        return 'Bearer $token';
      case AuthType.apiKey:
        final key = data['key'] ?? '';
        if (key.isEmpty) return null;
        return key;
      case AuthType.basic:
        final username = data['username'] ?? '';
        final password = data['password'] ?? '';
        if (username.isEmpty && password.isEmpty) return null;
        return 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      case AuthType.none:
        return null;
    }
  }

  static String getHeaderKey(AuthType type) =>
      type == AuthType.apiKey ? 'API-Key' : 'Authorization';

  static void syncHeaders(
      WidgetRef ref, AuthType authType, Map<String, String>? authData) {
    final collectionNotifier =
        ref.read(collectionStateNotifierProvider.notifier);
    final currentHeaders =
        ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers ?? [];
    final enabledList = ref
            .read(selectedRequestModelProvider)
            ?.httpRequestModel
            ?.isHeaderEnabledList ??
        List.filled(currentHeaders.length, true).toList();
    final filteredHeaders = currentHeaders
        .where((h) => h.name != 'Authorization' && h.name != 'API-Key')
        .toList();
    final updatedEnabledList = enabledList.length > filteredHeaders.length
        ? enabledList.sublist(0, filteredHeaders.length).toList()
        : enabledList.toList();

    final headerValue = generateHeader(authType, authData);
    final headerKey = getHeaderKey(authType);

    if (headerValue != null) {
      filteredHeaders.add(NameValueModel(name: headerKey, value: headerValue));
      updatedEnabledList.add(true);
    }
    if (headerValue != null ||
        currentHeaders
            .any((h) => h.name == 'Authorization' || h.name == 'X-API-Key')) {
      collectionNotifier.update(
        headers: filteredHeaders,
        isHeaderEnabledList: updatedEnabledList,
      );
    }
  }
}
