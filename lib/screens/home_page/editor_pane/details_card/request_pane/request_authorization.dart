import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';


class EditRequestAuthorization extends ConsumerStatefulWidget {
  const EditRequestAuthorization({super.key});

  @override
  ConsumerState<EditRequestAuthorization> createState() =>
      _EditRequestAuthorizationState();
}

class _EditRequestAuthorizationState
    extends ConsumerState<EditRequestAuthorization> {
  late int seed;
  final random = Random.secure();
  late AuthType _currentAuthType;
  late String _username = '';
  late String _password = '';
  late String _token = '';
  late bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
    _currentAuthType = AuthType.none;

    final request = ref.read(selectedRequestModelProvider);
    final authHeader = request?.httpRequestModel?.headers?.firstWhere(
      (h) => (h.name).toLowerCase() == 'authorization',
      orElse: () => const NameValueModel(name: '', value: ''),
    );

    if (authHeader?.value?.startsWith('Basic ') ?? false) {
      _currentAuthType = AuthType.basic;
      try {
        final decoded =
            utf8.decode(base64Decode(authHeader!.value!.substring(6)));
        final parts = decoded.split(':');
        _username = parts.isNotEmpty ? parts[0] : '';
        _password = parts.length > 1 ? parts[1] : '';
        _isEnabled = true;
      } catch (_) {}
    } else if (authHeader?.value?.startsWith('Bearer ') ?? false) {
      _currentAuthType = AuthType.bearer;
      _token = authHeader!.value!.substring(7);
      _isEnabled = true;
    }
  }

  void _updateHeaders() {
    final currentHeaders =
        ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers ?? [];

  // exisiting authorization header will be remove if header is  changed
    final newHeaders = currentHeaders
        .where((h) => (h.name).toLowerCase() != 'authorization')
        .toList();

    if (_isEnabled && _currentAuthType != AuthType.none) {
      String authValue = '';
      switch (_currentAuthType) {
        case AuthType.basic:
          authValue = 'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';
          break;
        case AuthType.bearer:
          authValue = 'Bearer $_token';
          break;
        case AuthType.none:
          break;
      }

      if (authValue.isNotEmpty) {
        newHeaders.add(NameValueModel(
          name: 'Authorization',
          value: authValue,
        ));
      }
    }

    ref.read(collectionStateNotifierProvider.notifier).update(
          headers: newHeaders,
          isHeaderEnabledList: List.filled(newHeaders.length, true),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: kP10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ADCheckBox(
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value!;
                  });
                  _updateHeaders();
                },
                colorScheme: colorScheme,
                keyId: 'auth-enable-checkbox',
              ),
              const SizedBox(width: 8),
              const Text('Enable Authorization'),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEnabled) ...[
            DropdownButtonFormField<AuthType>(
              value: _currentAuthType,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                hintText: 'Select Authorization Type',
              ),
              items: const [
                DropdownMenuItem(
                  value: AuthType.none,
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: AuthType.basic,
                  child: Text('Basic Auth'),
                ),
                DropdownMenuItem(
                  value: AuthType.bearer,
                  child: Text('Bearer Token'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentAuthType = value;
                  });
                  _updateHeaders();
                }
              },
            ),
            const SizedBox(height: 16),
            if (_currentAuthType == AuthType.basic) ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                initialValue: _username,
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                  _updateHeaders();
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                initialValue: _password,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                  _updateHeaders();
                },
              ),
            ],
            if (_currentAuthType == AuthType.bearer) ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Token',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                initialValue: _token,
                onChanged: (value) {
                  setState(() {
                    _token = value;
                  });
                  _updateHeaders();
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}