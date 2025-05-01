import 'dart:convert';
import 'dart:math';
import 'package:apidash/providers/authorization_providers.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
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
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    seed = random.nextInt(kRandMax);
  }

  void _updateHeaders() {
    final currentHeaders =
        ref.read(selectedRequestModelProvider)?.httpRequestModel?.headers ?? [];
    final authModel = ref.watch(authorizationProvider);
    final currentAuthType =
        ref.watch(authorizationProvider.select((value) => value.authType));
    var newHeaders = currentHeaders.toList();

    if (currentAuthType == AuthType.basic ||
        currentAuthType == AuthType.bearer) {
      newHeaders = currentHeaders
          .where((h) => (h.name).toLowerCase() != 'authorization')
          .toList();
    }
    if (currentAuthType == AuthType.apikey &&
        authModel.apiKeyAuthModel.addTo == AddTo.header) {
      if (authModel.apiKeyAuthModel.key.isNotEmpty &&
          authModel.apiKeyAuthModel.value.isNotEmpty) {
        newHeaders.add(NameValueModel(
          name: authModel.apiKeyAuthModel.key,
          value: authModel.apiKeyAuthModel.value,
        ));
      }
    }

    if (currentAuthType != AuthType.noauth) {
      String authValue = '';
      switch (currentAuthType) {
        case AuthType.basic:
          authValue =
              'Basic ${base64Encode(utf8.encode('${authModel.basicAuthModel.username}:${authModel.basicAuthModel.password}'))}';
          break;
        case AuthType.bearer:
          authValue = 'Bearer ${authModel.bearerAuthModel.token}';
          break;
        case AuthType.noauth:
          break;
        default:
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
  
void _updateQueryParams() {
  final currentParams = ref
          .read(selectedRequestModelProvider)
          ?.httpRequestModel
          ?.params ??
      [];
  final authModel = ref.watch(authorizationProvider);
  final currentAuthType =
      ref.watch(authorizationProvider.select((value) => value.authType));

  if (
      currentAuthType == AuthType.apikey &&
      authModel.apiKeyAuthModel.addTo == AddTo.query) {
    final apiKeyName = authModel.apiKeyAuthModel.key;
    final apiKeyvalue = authModel.apiKeyAuthModel.value;

    if (apiKeyName.isNotEmpty && apiKeyvalue.isNotEmpty) {
      // Check if a parameter with ANY name from apiKey auth already exists
      // if it does, we need to update the name and value
      // if it doesn't, we need to add a new parameter
      bool foundExisting = false;
      List<NameValueModel> newParams = currentParams.map((param) {
        if (currentParams.indexWhere((p) => p.name == authModel.apiKeyAuthModel.key) != -1) {
          foundExisting = true;
          return param.copyWith(name: apiKeyName, value: apiKeyvalue);
        }
        return param;
      }).toList();

      if (!foundExisting) {
        // Add new parameter
        newParams = [...newParams, NameValueModel(name: apiKeyName, value: apiKeyvalue)];
      }

      ref.read(collectionStateNotifierProvider.notifier).update(
            params: newParams,
            isParamEnabledList: List.filled(newParams.length, true),
          );
    }
  } else {
    //If not enabled or not apiKey auth, remove the param if it exists
    List<NameValueModel> newParams = currentParams.where((param) => param.name != authModel.apiKeyAuthModel.key).toList();
    ref.read(collectionStateNotifierProvider.notifier).update(
          params: newParams,
          isParamEnabledList: List.filled(newParams.length, true),
        );
  }
}

  // @override
  // void didUpdateWidget(covariant EditRequestAuthorization oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _updateHeaders();
  //   _updateQueryParams();

  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final authNotifier = ref.read(authorizationProvider.notifier);
    final authModel = ref.watch(authorizationProvider);
    final currentAuthType =
        ref.watch(authorizationProvider.select((value) => value.authType));
    final selectedId = ref.watch(selectedIdStateProvider);

    return Padding(
      padding: kP10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'The authorization header will be automatically generated when you send the request.'),
          const SizedBox(height: 16),
           ...[
            SizedBox(
              height: kHeaderHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Select Authorization Type:"),
                  const SizedBox(width: 8),
                  ADDropdownButton<AuthType>(
                    value: currentAuthType,
                    values: [
                      (AuthType.noauth, 'No Auth'),
                      (AuthType.basic, 'Basic Auth'),
                      (AuthType.bearer, 'Bearer Token'),
                      (AuthType.apikey, 'API Key'),
                    ],
                    onChanged: (value) {
                      authNotifier.update(
                        authType: value,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            switch (currentAuthType) {
              AuthType.basic => Column(children: [
                  TextFormField(
                    key: Key("$selectedId-username"),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    initialValue: authModel.basicAuthModel.username,
                    onChanged: (value) {
                      authNotifier.update(
                        username: value,
                      );

                      /// TODO: when value is not null and not empty add the authorization header
                      if (value.isNotEmpty) {
                        _updateHeaders();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: Key("$selectedId-password"),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: colorScheme.surface,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    initialValue: authModel.basicAuthModel.password,
                    obscureText: _obscurePassword,
                    onChanged: (value) {
                      authNotifier.update(
                        password: value,
                      );
                      if (value.isNotEmpty) {
                        _updateHeaders();
                      }
                    },
                  ),
                ]),
              AuthType.bearer => Column(children: [
                  TextFormField(
                    key: Key("$selectedId-token"),
                    decoration: InputDecoration(
                      labelText: 'Token',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    initialValue: authModel.bearerAuthModel.token,
                    onChanged: (value) {
                      authNotifier.update(
                        token: value,
                      );
                      if (value.isNotEmpty) {
                        _updateHeaders();
                      }
                    },
                  ),
                ]),
              AuthType.apikey => Column(children: [
                  TextFormField(
                    key: Key("$selectedId-key"),
                    decoration: InputDecoration(
                      labelText: 'Key',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    initialValue: authModel.apiKeyAuthModel.key,
                    onChanged: (value) {
                      authNotifier.update(
                        apiKey: value,
                      );
                      if (value.isNotEmpty &&
                          authModel.apiKeyAuthModel.addTo == AddTo.query) {
                        _updateQueryParams();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: Key("$selectedId-value"),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: colorScheme.surface,
                    ),
                    initialValue: authModel.apiKeyAuthModel.value,
                    onChanged: (value) {
                      authNotifier.update(
                        apiValue: value,
                      );
                      if (value.isNotEmpty &&
                          authModel.apiKeyAuthModel.addTo == AddTo.query) {
                        _updateQueryParams();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: kHeaderHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Add to:"),
                        const SizedBox(width: 8),
                        ADDropdownButton<AddTo>(
                          value: authModel.apiKeyAuthModel.addTo,
                          values: [
                            (
                              AddTo.header,
                              'Header',
                            ),
                            (AddTo.query, 'Query Params'),
                          ],
                          onChanged: (value) {
                            authNotifier.update(
                              addTo: value,
                            );
                            if (value == AddTo.header) {
                              _updateHeaders();
                            } else if (value == AddTo.query) {
                              _updateQueryParams();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              _ => Container()
            },
          ],
        ],
      ),
    );
  }
}
