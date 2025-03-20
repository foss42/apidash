import 'package:apidash/consts.dart';
import 'package:apidash/providers/auth_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestAuth extends ConsumerWidget {
  const EditRequestAuth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authData = ref.watch(authDataProvider) ?? {};
    final authType = ref.watch(authTypeProvider);

    final usernameController =
        TextEditingController(text: authData['username'] ?? '');
    final passwordController =
        TextEditingController(text: authData['password'] ?? '');

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
                ), // Reusable dropdown
              ],
            ),
          ),
          if (authType == AuthType.basic) ...[
            Padding(
              padding: kPt5o10, // Consistent padding
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                textDirection: TextDirection.ltr,
                onChanged: (value) =>
                    _updateAuth(ref, usernameController, passwordController),
              ),
            ),
            Padding(
              padding: kPt5o10,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                textDirection: TextDirection.ltr,
                obscureText: true,
                onChanged: (value) =>
                    _updateAuth(ref, usernameController, passwordController),
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

class DropdownButtonAuthType extends StatelessWidget {
  final AuthType authType;
  final ValueChanged<AuthType?> onChanged;

  const DropdownButtonAuthType({
    super.key,
    required this.authType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AuthType>(
      value: authType,
      onChanged: onChanged,
      dropdownColor: Colors.white, // Background color of dropdown menu
      icon:
          const Icon(Icons.arrow_drop_down, color: Colors.blue), // Custom icon
      underline: Container(height: 0),
      padding:
          const EdgeInsets.symmetric(horizontal: 12.0), // Padding inside button
      borderRadius: BorderRadius.circular(8.0), // Rounded corners for menu
      elevation: 4,
      items: const [
        DropdownMenuItem(
          value: AuthType.none,
          child: Text('None'),
        ),
        DropdownMenuItem(
          value: AuthType.basic,
          child: Text('Basic'),
        ),
      ],
    );
  }
}
