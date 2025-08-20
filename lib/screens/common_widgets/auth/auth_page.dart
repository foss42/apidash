import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'api_key_auth_fields.dart';
import 'basic_auth_fields.dart';
import 'bearer_auth_fields.dart';
import 'digest_auth_fields.dart';
import 'jwt_auth_fields.dart';
import 'consts.dart';

class AuthPage extends StatelessWidget {
  final AuthModel? authModel;
  final bool readOnly;
  final Function(APIAuthType? newType)? onChangedAuthType;
  final Function(AuthModel? model)? updateAuthData;

  const AuthPage({
    super.key,
    this.authModel,
    this.readOnly = false,
    this.onChangedAuthType,
    this.updateAuthData,
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
              APIAuthType.none =>
                Text(readOnly ? kMsgNoAuth : kMsgNoAuthSelected),
              _ => Text(readOnly
                  ? "${authModel?.type.name} $kMsgAuthNotSupported"
                  : kMsgNotImplemented),
            }
          ],
        ),
      ),
    );
  }
}
