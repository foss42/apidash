import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/authorization_model.dart';

class AuthorizationNotifier extends StateNotifier<AuthorizationModel> {
  final Ref ref;

  AuthorizationNotifier(AuthorizationModel initialState, this.ref)
      : super(initialState);

  void update({
    bool? isEnabled,
    AuthType? authType,
    String? username,
    String? password,
    String? token,
    String? apiKey,
    String? apiValue,
    AddTo? addTo,
  }) {
    if (authType != null && authType != state.authType) {
      state = state.copyWith(authType: authType);
    }
    // General state update
    state = state.copyWith(
      isEnabled: isEnabled ?? state.isEnabled,
      basicAuthModel: state.authType == AuthType.basic
          ? state.basicAuthModel.copyWith(
              username: username ?? state.basicAuthModel.username,
              password: password ?? state.basicAuthModel.password,
            )
          : state.basicAuthModel,
          bearerAuthModel: state.authType == AuthType.bearer
          ? state.bearerAuthModel.copyWith(
              token: token ?? state.bearerAuthModel.token,
            ) : state.bearerAuthModel,
          apiKeyAuthModel: state.authType == AuthType.apikey
          ? state.apiKeyAuthModel.copyWith(
              key: apiKey ?? state.apiKeyAuthModel.key,
              value: apiValue ?? state.apiKeyAuthModel.value,
              addTo: addTo ?? state.apiKeyAuthModel.addTo,
            ) : state.apiKeyAuthModel,
    );

    _syncWithRequest();
  }

  void _syncWithRequest() {
    ref.read(collectionStateNotifierProvider.notifier).update(
          authorizationModel: state,
        );
  }
}

final authorizationProvider =
    StateNotifierProvider<AuthorizationNotifier, AuthorizationModel>((ref) {
  final currentRequest = ref.watch(selectedRequestModelProvider);
  return AuthorizationNotifier(
      currentRequest?.authorizationModel ?? AuthorizationModel(), ref);
});
