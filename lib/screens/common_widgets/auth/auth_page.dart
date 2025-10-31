import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:better_networking/better_networking.dart';
import 'api_key_auth_fields.dart';
import 'basic_auth_fields.dart';
import 'bearer_auth_fields.dart';
import 'digest_auth_fields.dart';
import 'jwt_auth_fields.dart';
import 'consts.dart';
import 'oauth1_fields.dart';
import 'oauth2_field.dart';

class AuthPage extends StatelessWidget {
  final AuthModel? authModel;
  final AuthInheritanceType? authInheritanceType;
  final bool readOnly;
  final Function(APIAuthType? newType)? onChangedAuthType;
  final Function(AuthModel? model)? updateAuthData;
  final Function(AuthInheritanceType? newType)? onChangedAuthInheritanceType;

  const AuthPage({
    super.key,
    this.authModel,
    this.authInheritanceType,
    this.readOnly = false,
    this.onChangedAuthType,
    this.updateAuthData,
    this.onChangedAuthInheritanceType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kLabelSelectAuthType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            // Auth inheritance selection
            if (!readOnly) ...[
              ADPopupMenu<AuthInheritanceType>(
                value: (authInheritanceType ?? AuthInheritanceType.none).displayType,
                values: AuthInheritanceType.values
                    .map((type) => (type, type.displayType))
                    .toList(),
                tooltip: "Select auth inheritance type",
                isOutlined: true,
                onChanged: onChangedAuthInheritanceType,
              ),
              const SizedBox(height: 16),
            ],
            // Show auth type selection only when not inheriting
            if (authInheritanceType != AuthInheritanceType.environment) ...[
              ADPopupMenu<APIAuthType>(
                value: authModel?.type.displayType,
                values: APIAuthType.values
                    .map((type) => (type, type.displayType))
                    .toList(),
                tooltip: kTooltipSelectAuth,
                isOutlined: true,
                onChanged: readOnly ? null : onChangedAuthType,
              ),
              const SizedBox(height: 48),
              switch (authModel?.type) {
                APIAuthType.basic => BasicAuthFields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                  ),
                APIAuthType.bearer => BearerAuthFields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.apiKey => ApiKeyAuthFields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.jwt => JwtAuthFields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.digest => DigestAuthFields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.oauth1 => OAuth1Fields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.oauth2 => OAuth2Fields(
                    readOnly: readOnly,
                    authData: authModel,
                    updateAuth: updateAuthData,
                ),
                APIAuthType.none =>
                  Text(readOnly ? kMsgNoAuth : kMsgNoAuthSelected),
                _ => Text(readOnly
                    ? "${authModel?.type.name} $kMsgAuthNotSupported"
                    : kMsgNotImplemented),
              }
            ] else ...[
              const Text("Using environment inherited authentication"),
            ]
          ],
        ),
      ),
    );
  }
}