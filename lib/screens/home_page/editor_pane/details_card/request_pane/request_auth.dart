import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';

class EditAuthType extends ConsumerWidget {
  const EditAuthType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequest = ref.watch(selectedRequestModelProvider);

    if (selectedRequest == null) {
      return const SizedBox.shrink();
    }

    final currentAuthType = selectedRequest.authType;
    final currentAuthData = selectedRequest.authData;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Auth Type Dropdown
          DropdownButtonFormField<APIAuthType>(
            value: currentAuthType,
            decoration: const InputDecoration(
              labelText: 'Authentication Type',
              border: OutlineInputBorder(),
            ),
            items: APIAuthType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (APIAuthType? newType) {
              if (newType != null) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      authType: newType,
                      authData: null, // reset when auth type changes
                    );
              }
            },
          ),
          const SizedBox(height: 16),

          // Dynamic Auth Input Fields
          _buildAuthFields(ref, currentAuthType, currentAuthData),
        ],
      ),
    );
  }

  Widget _buildAuthFields(
    WidgetRef ref,
    APIAuthType authType,
    APIAuthModel? authData,
  ) {
    final controllerMap = <String, TextEditingController>{};

    void updateAuth(APIAuthModel model) {
      ref.read(collectionStateNotifierProvider.notifier).update(
            authData: model,
          );
    }

    switch (authType) {
      case APIAuthType.basic:
        final usernameController = TextEditingController(
          text: (authData is BasicAuth) ? authData.username : '',
        );
        final passwordController = TextEditingController(
          text: (authData is BasicAuth) ? authData.password : '',
        );
        return Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) => updateAuth(BasicAuth(
                  username: value, password: passwordController.text)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) => updateAuth(BasicAuth(
                  username: usernameController.text, password: value)),
            ),
          ],
        );

      // 

      case APIAuthType.none:
        return const Text("No authentication selected.");

      // TODO: Implement digest, oauth1, oauth2 later
      default:
        return const Text("This auth type is not implemented yet.");
    }
  }
}
