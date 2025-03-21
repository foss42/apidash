import 'package:apidash/consts.dart';
import 'package:apidash/providers/auth_providers.dart';
import 'package:apidash/widgets/dropdown_auth_type.dart';
import 'package:apidash/widgets/text_auth.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestAuth extends ConsumerStatefulWidget {
  const EditRequestAuth({super.key});

  @override
  ConsumerState<EditRequestAuth> createState() => _EditRequestAuthState();
}

class _EditRequestAuthState extends ConsumerState<EditRequestAuth> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authData = ref.watch(authDataProvider) ?? {};
    final authType = ref.watch(authTypeProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Select Authorization Type:'),
                DropdownButtonAuthType(
                  authType: authType,
                  onChanged: (AuthType? value) {
                    if (value != null) {
                      ref.read(authTypeProvider.notifier).state = value;
                      if (value == AuthType.none) {
                        ref.read(authDataProvider.notifier).state = null;
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          if (authType == AuthType.basic) ...[
            Padding(
              padding: kPt5o10,
              child: AuthTextField(
                controller: usernameController,
                labelText: 'Username',
                obscureText: false,
                onChanged: (value) {
                  _updateAuth(ref, usernameController, passwordController);
                },
              ),
            ),
            Padding(
              padding: kPt5o10,
              child: AuthTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                onChanged: (value) {
                  _updateAuth(ref, usernameController, passwordController);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateAuth(WidgetRef ref, TextEditingController usernameController,
      TextEditingController passwordController) {
    ref.read(authTypeProvider.notifier).state = AuthType.basic;
    ref.read(authDataProvider.notifier).state = {
      'username': usernameController.text,
      'password': passwordController.text,
    };
  }
}
