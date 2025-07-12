import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/widgets/widgets.dart';
import 'consts.dart';

class BasicAuthFields extends StatelessWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;
  final bool readOnly;

  const BasicAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController(
      text: authData?.basic?.username ?? '',
    );
    final passwordController = TextEditingController(
      text: authData?.basic?.password ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          readOnly: readOnly,
          hintText: kHintUsername,
          controller: usernameController,
          onChanged: (_) => _updateBasicAuth(
            usernameController,
            passwordController,
          ),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: readOnly,
          hintText: kHintPassword,
          isObscureText: true,
          controller: passwordController,
          onChanged: (_) => _updateBasicAuth(
            usernameController,
            passwordController,
          ),
        ),
      ],
    );
  }

  void _updateBasicAuth(
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) {
    final basicAuth = AuthBasicAuthModel(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );
    updateAuth(authData?.copyWith(
          type: APIAuthType.basic,
          basic: basicAuth,
        ) ??
        AuthModel(
          type: APIAuthType.basic,
          basic: basicAuth,
        ));
  }
}
