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
        Text(
          "Username",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: usernameController,
          decoration: _inputDecoration(context, "Username"),
          onChanged: (_) => _updateBasicAuth(
            usernameController,
            passwordController,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: passwordController,
          decoration: _inputDecoration(context, "Password"),
          obscureText: true,
          onChanged: (_) => _updateBasicAuth(
            usernameController,
            passwordController,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 100,
      ),
      contentPadding: const EdgeInsets.all(18),
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.bodyMedium,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
