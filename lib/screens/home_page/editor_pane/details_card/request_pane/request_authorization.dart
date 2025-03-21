import 'dart:convert';

import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../providers/auth_providers.dart';

class EditRequestAuthorization extends ConsumerStatefulWidget {
  const EditRequestAuthorization({super.key});

  @override
  ConsumerState<EditRequestAuthorization> createState() =>
      _EditRequestAuthorizationState();
}

class _EditRequestAuthorizationState
    extends ConsumerState<EditRequestAuthorization> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    _usernameController.addListener(() {
      ref.read(authCredentialsProvider.notifier).update((state) => {
            ...state,
            'username': _usernameController.text,
          });
    });

    _passwordController.addListener(() {
      ref.read(authCredentialsProvider.notifier).update((state) => {
            ...state,
            'password': _passwordController.text,
          });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateHeaders(AuthType? authType, String? username, String? password) {
    final headers = _generateAuthHeaders(authType, username, password);
    ref.read(collectionStateNotifierProvider.notifier).update(headers: headers);
  }

  List<NameValueModel> _generateAuthHeaders(
      AuthType? authType, String? username, String? password) {
    if (authType == AuthType.basicAuth &&
        username != null &&
        password != null &&
        username.isNotEmpty &&
        password.isNotEmpty) {
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      return [NameValueModel(name: "Authorization", value: basicAuth)];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final authType = ref.watch(authTypeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kVSpacer16,
          DropdownButtonFormField<AuthType>(
            value: authType,
            decoration: InputDecoration(
              labelText: kLabelAuthorizationType,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: AuthType.values.map((AuthType type) {
              return DropdownMenuItem(
                  value: type, child: Text(type.toString().split('.').last));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(authTypeProvider.notifier).update((state) => value);
                _updateHeaders(
                    value, _usernameController.text, _passwordController.text);
              }
            },
          ),
          const SizedBox(height: 16),
          if (authType == AuthType.basicAuth) ...[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                ref.read(authCredentialsProvider.notifier).update((state) => {
                      ...state,
                      'username': value,
                    });
                _updateHeaders(authType, value, _passwordController.text);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              obscureText: true,
              onChanged: (value) {
                ref.read(authCredentialsProvider.notifier).update((state) => {
                      ...state,
                      'password': value,
                    });
                _updateHeaders(authType, _usernameController.text, value);
              },
            ),
          ],
        ],
      ),
    );
  }
}
