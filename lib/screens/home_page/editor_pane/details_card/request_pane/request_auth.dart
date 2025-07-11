import 'package:apidash/screens/common_widgets/auth/api_key_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/basic_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/bearer_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/digest_auth_fields.dart';
import 'package:apidash/screens/common_widgets/auth/jwt_auth_fields.dart';
import 'package:apidash_design_system/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';

class EditAuthType extends ConsumerWidget {
  final AuthModel? authModel;
  final bool readOnly;

  const EditAuthType({
    super.key,
    this.authModel,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthModel? currentAuthData;
    final APIAuthType currentAuthType;

    if (authModel != null) {
      currentAuthData = authModel;
      currentAuthType = authModel!.type;
    } else {
      final selectedRequest = ref.read(selectedRequestModelProvider);
      if (selectedRequest == null) {
        return const SizedBox.shrink();
      }

      currentAuthType = ref.watch(
        selectedRequestModelProvider.select((request) =>
            request?.httpRequestModel?.authModel?.type ?? APIAuthType.none),
      );
      currentAuthData = selectedRequest.httpRequestModel?.authModel;
    }
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
            ADPopupMenu<APIAuthType>(
              value: currentAuthType.displayType,
              values: APIAuthType.values
                  .map((type) => (type, type.displayType))
                  .toList(),
              tooltip: "Select Authentication Type",
              isOutlined: true,
              onChanged: readOnly
                  ? null
                  : (APIAuthType? newType) {
                      final selectedRequest =
                          ref.read(selectedRequestModelProvider);
                      if (newType != null) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(
                              authModel: selectedRequest
                                      ?.httpRequestModel?.authModel
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
      if (model == null) {
        ref.read(collectionStateNotifierProvider.notifier).update(
              authModel: AuthModel(type: APIAuthType.none),
            );
      }
      ref.read(collectionStateNotifierProvider.notifier).update(
            authModel: model,
          );
    }

    switch (authData?.type) {
      case APIAuthType.basic:
        return BasicAuthFields(
          readOnly: readOnly,
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.bearer:
        return BearerAuthFields(
          readOnly: readOnly,
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.apiKey:
        return ApiKeyAuthFields(
          readOnly: readOnly,
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.jwt:
        return JwtAuthFields(
          readOnly: readOnly,
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.digest:
        return DigestAuthFields(
          readOnly: readOnly,
          authData: authData,
          updateAuth: updateAuth,
        );
      case APIAuthType.none:
        return Text(readOnly
            ? "No authentication was used for this request."
            : "No authentication selected.");
      default:
        return Text(readOnly
            ? "Authentication details for ${authData?.type.name} are not yet supported in history view."
            : "This auth type is not implemented yet.");
    }
  }
}
