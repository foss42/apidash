import 'package:apidash/screens/common_widgets/auth_textfield.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';

class BasicAuthFields extends StatelessWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;

  const BasicAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
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
          hintText: "Username",
          controller: usernameController,
          onChanged: (_) => _updateBasicAuth(
            usernameController,
            passwordController,
          ),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          hintText: "Password",
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
    updateAuth(
      authData?.copyWith(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      ),
    );
  }
}
