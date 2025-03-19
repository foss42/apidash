import 'package:apidash/providers/auth_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class EditRequestAuth extends ConsumerWidget {
  const EditRequestAuth({super.key});

 @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authData = ref.watch(authDataProvider) ?? {};

    final usernameController = TextEditingController(text: authData['username'] ?? '');
    final passwordController = TextEditingController(text: authData['password'] ?? '');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Authorization',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _updateAuth(ref, usernameController, passwordController),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onChanged: (value) => _updateAuth(ref, usernameController, passwordController),
          ),
        ],
      ),
    );
  }

  void _updateAuth(WidgetRef ref, TextEditingController usernameController, TextEditingController passwordController) {
    ref.read(authTypeProvider.notifier).state = AuthType.basic;
    ref.read(authDataProvider.notifier).state = {
      'username': usernameController.text,
      'password': passwordController.text,
    };
  }
}
class DropdownButtonAuthType extends ConsumerWidget {
  const DropdownButtonAuthType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final requestAuthType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.bodyContentType));
    return DropdownButtonContentType(
      contentType: requestAuthType,
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(bodyContentType: value);
      },
    );
  }
}
