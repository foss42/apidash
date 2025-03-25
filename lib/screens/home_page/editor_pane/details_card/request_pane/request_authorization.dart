import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:apidash_design_system/tokens/typography.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestAuthorization extends ConsumerStatefulWidget {
  const EditRequestAuthorization({super.key});

  @override
  ConsumerState<EditRequestAuthorization> createState() =>
      EditRequestAuthorizationState();
}

class EditRequestAuthorizationState
    extends ConsumerState<EditRequestAuthorization> {
  String authType = 'bearer';
  bool isAuthEnabled = false;
  String username = '';
  String password = '';
  String bearerToken = '';

  late final TextEditingController _bearerTokenController =
      TextEditingController();
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _bearerTokenController.text = bearerToken;
    _usernameController.text = username;
    _passwordController.text = password;
    _initializeAuthModel();
  }

  @override
  void dispose() {
    _bearerTokenController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _initializeAuthModel() {
    final authData = ref
        .read(collectionStateNotifierProvider.notifier)
        .getCurrentAuth(ref.read(selectedIdStateProvider));

    if (authData != null) {
      setState(() {
        authType = authData['type'] ?? 'bearer';
        isAuthEnabled = authData['isEnabled'] ?? false;
        username = authData['username'] ?? '';
        password = authData['password'] ?? '';
        bearerToken = authData['token'] ?? '';
        _bearerTokenController.text = bearerToken;
        _usernameController.text = username;
        _passwordController.text = password;
      });
    }
  }

  void _updateAuth() {
    ref.read(collectionStateNotifierProvider.notifier).updateAuth(
          authType: authType,
          isEnabled: isAuthEnabled,
          bearerToken: authType == 'bearer' ? bearerToken : null,
          username: authType == 'basic' ? username : null,
          password: authType == 'basic' ? password : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: kDataTableRowHeight * 2,
        maxHeight: kDataTableRowHeight * 5,
      ),
      child: Container(
        margin: kP10,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30,
                  child: ADCheckBox(
                    keyId: "$selectedId-auth-checkbox",
                    value: isAuthEnabled,
                    onChanged: (value) {
                      setState(() {
                        isAuthEnabled = value!;
                      });
                      _updateAuth();
                    },
                    colorScheme: Theme.of(context).colorScheme,
                  ),
                ),
                kHSpacer10,
                DropdownButton<String>(
                  value: authType,
                  items: const [
                    DropdownMenuItem(
                      value: 'bearer',
                      child: Text('Bearer Token'),
                    ),
                    DropdownMenuItem(
                      value: 'basic',
                      child: Text('Basic Auth'),
                    ),
                  ],
                  onChanged: isAuthEnabled
                      ? (value) {
                          if (value != null) {
                            setState(() {
                              authType = value;
                              if (authType == 'basic') {
                                bearerToken = '';
                                _bearerTokenController.text = '';
                              } else {
                                username = '';
                                password = '';
                                _usernameController.text = '';
                                _passwordController.text = '';
                              }
                            });
                            _updateAuth();
                          }
                        }
                      : null,
                ),
                kHSpacer10,
                Text('=', style: kCodeStyle),
                kHSpacer10,
                if (authType == 'bearer')
                  Expanded(
                    child: TextField(
                      key: const ValueKey('bearer_token_field'),
                      controller: _bearerTokenController,
                      enabled: isAuthEnabled,
                      decoration: const InputDecoration(
                        hintText: 'Enter Bearer Token',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: isAuthEnabled
                          ? (value) {
                              bearerToken = value;
                              _updateAuth();
                            }
                          : null,
                    ),
                  ),
              ],
            ),
            if (authType == 'basic') ...[
              kVSpacer10,
              TextField(
                key: const ValueKey('username_field'),
                controller: _usernameController,
                enabled: isAuthEnabled,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: isAuthEnabled
                    ? (value) {
                        username = value;
                        _updateAuth();
                      }
                    : null,
              ),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey('password_field'),
                controller: _passwordController,
                enabled: isAuthEnabled,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: isAuthEnabled
                    ? (value) {
                        password = value;
                        _updateAuth();
                      }
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
