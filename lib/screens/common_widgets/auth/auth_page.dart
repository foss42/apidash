import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'api_key_auth_fields.dart';
import 'basic_auth_fields.dart';
import 'bearer_auth_fields.dart';
import 'digest_auth_fields.dart';
import 'jwt_auth_fields.dart';
import 'consts.dart';
import 'oauth1_fields.dart';
import 'oauth2_field.dart';

class AuthPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
            const SizedBox(height: 24),
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
            },
            if (authModel?.type != null && authModel?.type != APIAuthType.none) ...[
              const SizedBox(height: 24),
              AuthWarningTip(
                onTap: () {
                  ref.read(navRailIndexStateProvider.notifier).state = 1;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AuthWarningTip extends StatelessWidget {
  final VoidCallback onTap;

  const AuthWarningTip({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = colorScheme.surfaceContainerHighest.withOpacity(0.3);
    final borderColor = colorScheme.outlineVariant.withOpacity(0.5);
    final iconColor = colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: iconColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      const TextSpan(
                        text: "Tip: Use ",
                      ),
                      const TextSpan(
                        text: "secret variables",
                        style: TextStyle(fontWeight: FontWeight.w900,decoration: TextDecoration.underline),
                      ),
                      const TextSpan(
                        text: " for sensitive information. ",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

