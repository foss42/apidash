import 'package:apidash/screens/common_widgets/auth/api_key_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/basic_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/bearer_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/jwt_auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';

class EditAuthType extends ConsumerWidget {
  const EditAuthType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.read(selectedRequestModelProvider);

    if (selectedRequest == null) {
      return const SizedBox.shrink();
    }

    final currentAuthType = ref.watch(
      selectedRequestModelProvider
          .select((request) => request?.authModel?.type ?? APIAuthType.none),
    );
    final currentAuthData = selectedRequest.authModel;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Authentication Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            DropdownButtonFormField<APIAuthType>(
              value: currentAuthType,
              elevation: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              items: APIAuthType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.capitalize()),
                );
              }).toList(),
              onChanged: (APIAuthType? newType) {
                final selectedRequest = ref.read(selectedRequestModelProvider);
                if (newType != null) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        authData: selectedRequest?.authModel
                                ?.copyWith(type: newType) ??
                            AuthModel(type: newType),
                      );
                }
              },
            ),
            const SizedBox(height: 48),
            _buildAuthFields(context, ref, currentAuthData),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthFields(
    BuildContext context,
    WidgetRef ref,
    AuthModel? authData,
  ) {
    void updateAuth(AuthModel? model) {
      ref.read(collectionStateNotifierProvider.notifier).update(
            authData: model,
          );
    }

    switch (authData?.type) {
      case APIAuthType.basic:
        return BasicAuthFields(
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.bearer:
        return BearerAuthFields(
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.apiKey:
        return ApiKeyAuthFields(
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.jwt:
        return JwtAuthFields(
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.none:
        return const Text("No authentication selected.");
      default:
        return const Text("This auth type is not implemented yet.");
    }
  }
}
