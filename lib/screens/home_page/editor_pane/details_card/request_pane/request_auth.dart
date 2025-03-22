import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/auth_providers.dart';
import 'package:apidash/providers/collection_providers.dart';
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
  late final TextEditingController btokenController;
  late final TextEditingController apikeyController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    btokenController = TextEditingController();
    apikeyController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    btokenController.dispose();
    apikeyController.dispose();
    super.dispose();
  }

void _updateAuth(WidgetRef ref,) {
    final authType = ref.read(authTypeProvider);
    final authData = {
      if(authType == AuthType.basic)...{
        'username': usernameController.text,
        'password': passwordController.text,
      },
      if (authType == AuthType.apiKey) 'key': apikeyController.text,
      if (authType == AuthType.bearer) 'token': btokenController.text,
    };
    ref.read(authDataProvider.notifier).state = authData;
    final collectionNotifier = ref.read(collectionStateNotifierProvider.notifier);
    final currentHeaders = ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers ?? [];
    final enabledList = ref.read(selectedRequestModelProvider)?.httpRequestModel?.isHeaderEnabledList ?? List.filled(currentHeaders.length, true).toList();
    final filteredHeaders = currentHeaders.where((h) => h.name != 'Authorization' && h.name != 'API-Key').toList();
    final updatedEnabledList = enabledList.length > filteredHeaders.length 
        ? enabledList.sublist(0, filteredHeaders.length).toList() 
        : enabledList.toList();

    String? headerValue;
    String headerKey = 'Authorization';
    switch (authType) {
      case AuthType.basic:
        if (authData['username']?.isNotEmpty == true && authData['password']?.isNotEmpty == true) {
          headerValue = 'Basic ${base64Encode(utf8.encode('${authData['username']}:${authData['password']}'))}';
        }
        break;
      case AuthType.apiKey:
        if (authData['key']?.isNotEmpty == true) {
          headerValue = authData['key'];
          headerKey = 'API-Key';
        }
        break;
      case AuthType.bearer:
        if (authData['token']?.isNotEmpty == true) {
          headerValue = 'Bearer ${authData['token']}';
        }
        break;
      default:
        headerValue = null;
    }

    if (headerValue != null) {
      filteredHeaders.add(NameValueModel(name: headerKey, value: headerValue));
      updatedEnabledList.add(true);
    }
    if (headerValue != null || currentHeaders.any((h) => h.name == 'Authorization' || h.name == 'X-API-Key')) {
      collectionNotifier.update(
        headers: filteredHeaders,
        isHeaderEnabledList: updatedEnabledList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _authInputfield(authType,ref)
        ],
      ),
    );
  }
  Widget _authInputfield(AuthType authType, WidgetRef ref){
    switch (authType) {
      case AuthType.basic:
        return Column(
          children: [
            Padding(
              padding: kPt5o10,
              child: AuthTextField(
                controller: usernameController,
                labelText: 'Username',
                obscureText: false,
                onChanged: (value) {
                  _updateAuth(ref);
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
                  _updateAuth(ref);
                },
              ),
            ),
          ],
        );
      case AuthType.apiKey:
        return Padding(
              padding: kPt5o10,
              child: AuthTextField(
                controller: apikeyController,
                labelText: 'API Key',
                obscureText: false,
                onChanged: (value) {
                  _updateAuth(ref);
                },
              ),
            );
      case AuthType.bearer:
        return Padding(
              padding: kPt5o10,
              child: AuthTextField(
                controller: btokenController,
                labelText: 'Bearer Token',
                obscureText: false,
                onChanged: (value) {
                  _updateAuth(ref);
                },
              ),
            );
      default:
        return const SizedBox.shrink();
    }
  }
  }
            