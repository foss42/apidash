import 'dart:convert';

import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets.dart';
import 'consts.dart';
import 'utils.dart';

class OAuth2Fields extends ConsumerStatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?)? updateAuth;
  const OAuth2Fields({
    super.key,
    required this.authData,
    this.updateAuth,
    this.readOnly = false,
  });
  @override
  ConsumerState<OAuth2Fields> createState() => _OAuth2FieldsState();
}

class _OAuth2FieldsState extends ConsumerState<OAuth2Fields> {
  late OAuth2GrantType _grantType;
  late String _authorizationUrl;
  late String _accessTokenUrl;
  late String _clientId;
  late String _clientSecret;
  late String _redirectUrl;
  late String _scope;
  late String _state;
  late String _codeChallengeMethod;
  late String _username;
  late String _password;
  late String _refreshToken;
  late String _identityToken;
  late String _accessToken;
  DateTime? _tokenExpiration;

  @override
  void initState() {
    super.initState();
    final oauth2 = widget.authData?.oauth2;
    _grantType = oauth2?.grantType ?? OAuth2GrantType.authorizationCode;
    _authorizationUrl = oauth2?.authorizationUrl ?? '';
    _accessTokenUrl = oauth2?.accessTokenUrl ?? '';
    _clientId = oauth2?.clientId ?? '';
    _clientSecret = oauth2?.clientSecret ?? '';
    _redirectUrl = oauth2?.redirectUrl ?? '';
    _scope = oauth2?.scope ?? '';
    _state = oauth2?.state ?? '';
    _username = oauth2?.username ?? '';
    _password = oauth2?.password ?? '';
    _refreshToken = oauth2?.refreshToken ?? '';
    _identityToken = oauth2?.identityToken ?? '';
    _accessToken = oauth2?.accessToken ?? '';
    _codeChallengeMethod = oauth2?.codeChallengeMethod ?? 'sha-256';

    // Load credentials from file if available
    _loadCredentialsFromFile();
  }

  Future<void> _loadCredentialsFromFile() async {
    final credentialsFilePath = widget.authData?.oauth2?.credentialsFilePath;
    if (credentialsFilePath != null && credentialsFilePath.isNotEmpty) {
      try {
        final credentialsFile = await loadFileFromPath(credentialsFilePath);
        if (credentialsFile != null) {
          final credentials = await credentialsFile.readAsString();
          if (credentials.isNotEmpty) {
            final Map<String, dynamic> decoded = jsonDecode(credentials);
            setState(() {
              if (decoded['refreshToken'] != null) {
                _refreshToken = decoded['refreshToken']!;
              } else {
                _refreshToken = "N/A";
              }
              if (decoded['idToken'] != null) {
                _identityToken = decoded['idToken']!;
              } else {
                _identityToken = "N/A";
              }
              if (decoded['accessToken'] != null) {
                _accessToken = decoded['accessToken']!;
              } else {
                _accessToken = "N/A";
              }
              // Parse expiration time
              if (decoded['expiration'] != null) {
                _tokenExpiration =
                    DateTime.fromMillisecondsSinceEpoch(decoded['expiration']!);
              } else {
                _tokenExpiration = null;
              }
            });
          }
        }
      } catch (e) {
        // Handle file reading or JSON parsing errors silently
        debugPrint('Error loading OAuth2 credentials: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    // Watch for changes in the selected request model's HTTP response
    ref.listen<RequestModel?>(selectedRequestModelProvider, (previous, next) {
      // Check if the HTTP response has changed (new response received)
      if (previous?.httpResponseModel != next?.httpResponseModel &&
          next?.httpResponseModel != null) {
        // Only reload if this request uses OAuth2 auth and has credentials file path
        final authModel = next?.httpRequestModel?.authModel;
        if (authModel?.type == APIAuthType.oauth2 &&
            authModel?.oauth2?.credentialsFilePath != null) {
          // Small delay to ensure file is written before reading
          Future.delayed(const Duration(milliseconds: 100), () {
            _loadCredentialsFromFile();
          });
        }
      }
    });

    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Text(
          kLabelOAuth2GrantType,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        kVSpacer5(ds.scaleFactor),
        ADPopupMenu<OAuth2GrantType>(
          value: _grantType.displayType,
          values: OAuth2GrantType.values.map((e) => (e, e.displayType)),
          tooltip: kTooltipOAuth2GrantType,
          isOutlined: true,
          onChanged: widget.readOnly
              ? null
              : (OAuth2GrantType? newGrantType) {
                  if (newGrantType != null && newGrantType != _grantType) {
                    setState(() {
                      _grantType = newGrantType;
                    });

                    _updateOAuth2();
                  }
                },
        ),
        kVSpacer16(),
        if (_shouldShowField(OAuth2Field.authorizationUrl))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _authorizationUrl,
              hintText: kHintOAuth2AuthorizationUrl,
              infoText: kInfoOAuth2AuthorizationUrl,
              onChanged: (value) {
                _authorizationUrl = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.username))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _username,
              hintText: kHintOAuth2Username,
              infoText: kInfoOAuth2Username,
              onChanged: (value) {
                _username = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.password))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _password,
              hintText: kHintOAuth2Password,
              infoText: kInfoOAuth2Password,
              isObscureText: true,
              onChanged: (value) {
                _password = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.accessTokenUrl))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _accessTokenUrl,
              hintText: kHintOAuth2AccessTokenUrl,
              infoText: kInfoOAuth2AccessTokenUrl,
              onChanged: (value) {
                _accessTokenUrl = value;
                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.clientId))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _clientId,
              hintText: kHintOAuth2ClientId,
              infoText: kInfoOAuth2ClientId,
              onChanged: (value) {
                _clientId = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.clientSecret))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _clientSecret,
              hintText: kHintOAuth2ClientSecret,
              infoText: kInfoOAuth2ClientSecret,
              isObscureText: true,
              onChanged: (value) {
                _clientSecret = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.codeChallengeMethod)) ...[
          Text(
            kLabelOAuth2CodeChallengeMethod,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          kVSpacer5(ds.scaleFactor),
          ADPopupMenu<String>(
            value: _codeChallengeMethod.toUpperCase(),
            values: const [
              ('SHA-256', 'sha-256'),
              ('Plaintext', 'plaintext'),
            ],
            tooltip: kTooltipOAuth2CodeChallengeMethod,
            isOutlined: true,
            onChanged: widget.readOnly
                ? null
                : (String? newMethod) {
                    if (newMethod != null &&
                        newMethod != _codeChallengeMethod) {
                      setState(() {
                        _codeChallengeMethod = newMethod;
                      });

                      _updateOAuth2();
                    }
                  },
          ),
          kVSpacer16(ds.scaleFactor),
        ],
        if (_shouldShowField(OAuth2Field.redirectUrl))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _redirectUrl,
              hintText: kHintOAuth2RedirectUrl,
              infoText: kInfoOAuth2RedirectUrl,
              onChanged: (value) {
                _redirectUrl = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.scope))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _scope,
              hintText: kHintOAuth2Scope,
              infoText: kInfoOAuth2Scope,
              onChanged: (value) {
                _scope = value;

                _updateOAuth2();
              },
            ),
          ),
        if (_shouldShowField(OAuth2Field.state))
          ..._buildFieldWithSpacing(
            EnvAuthField(
              readOnly: widget.readOnly,
              initialValue: _state,
              hintText: kHintOAuth2State,
              infoText: kInfoOAuth2State,
              onChanged: (value) {
                _state = value;

                _updateOAuth2();
              },
            ),
          ),
        ..._buildFieldWithSpacing(
          Align(
            alignment: Alignment.centerRight,
            child: ADTextButton(
              label: kButtonClearOAuth2Session,
              onPressed: clearStoredCredentials,
            ),
          ),
        ),
        Divider(),
        kVSpacer16(ds.scaleFactor),
        ..._buildFieldWithSpacing(
          EnvAuthField(
            readOnly: widget.readOnly,
            initialValue: _refreshToken,
            hintText: kHintOAuth2RefreshToken,
            infoText: kInfoOAuth2RefreshToken,
            onChanged: (value) {
              _refreshToken = value;

              _updateOAuth2();
            },
          ),
        ),
        ..._buildFieldWithSpacing(
          EnvAuthField(
            readOnly: widget.readOnly,
            initialValue: _identityToken,
            hintText: kHintOAuth2IdentityToken,
            infoText: kInfoOAuth2IdentityToken,
            onChanged: (value) {
              _identityToken = value;

              _updateOAuth2();
            },
          ),
        ),
        ..._buildFieldWithSpacing(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnvAuthField(
                readOnly: widget.readOnly,
                initialValue: _accessToken,
                hintText: kHintOAuth2AccessToken,
                infoText: kInfoOAuth2AccessToken,
                onChanged: (value) {
                  _accessToken = value;

                  _updateOAuth2();
                },
              ),
              if (_tokenExpiration != null) ...[
                SizedBox(height: 4*ds.scaleFactor),
                Text(
                  getExpirationText(_tokenExpiration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _tokenExpiration!.isBefore(DateTime.now())
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
        kVSpacer16(ds.scaleFactor),
      ],
    );
  }

  List<Widget> _buildFieldWithSpacing(Widget field) {
    final ds = DesignSystemProvider.of(context);
    return [
      field,
      kVSpacer16(ds.scaleFactor),
    ];
  }

  bool _shouldShowField(OAuth2Field field) {
    const alwaysShownFields = {
      OAuth2Field.accessTokenUrl,
      OAuth2Field.clientId,
      OAuth2Field.clientSecret,
      OAuth2Field.scope,
      OAuth2Field.refreshToken,
      OAuth2Field.identityToken,
      OAuth2Field.accessToken,
      OAuth2Field.clearSession,
    };

    if (alwaysShownFields.contains(field)) {
      return true;
    }

    switch (_grantType) {
      case OAuth2GrantType.authorizationCode:
        return const {
          OAuth2Field.authorizationUrl,
          OAuth2Field.redirectUrl,
          OAuth2Field.codeChallengeMethod,
          OAuth2Field.state,
        }.contains(field);

      case OAuth2GrantType.resourceOwnerPassword:
        return const {
          OAuth2Field.username,
          OAuth2Field.password,
        }.contains(field);

      case OAuth2GrantType.clientCredentials:
        return false;
    }
  }

  void _updateOAuth2() async {
    final String? credentialsFilePath =
        ref.read(settingsProvider).workspaceFolderPath;

    final updatedOAuth2 = AuthOAuth2Model(
      grantType: _grantType,
      authorizationUrl: _authorizationUrl.trim(),
      clientId: _clientId.trim(),
      accessTokenUrl: _accessTokenUrl.trim(),
      clientSecret: _clientSecret.trim(),
      credentialsFilePath: credentialsFilePath != null
          ? "$credentialsFilePath/oauth2_credentials.json"
          : null,
      codeChallengeMethod: _codeChallengeMethod,
      redirectUrl: _redirectUrl.trim(),
      scope: _scope.trim(),
      state: _state.trim(),
      username: _username.trim(),
      password: _password.trim(),
      refreshToken: _refreshToken.trim(),
      identityToken: _identityToken.trim(),
      accessToken: _accessToken.trim(),
    );

    widget.updateAuth?.call(
      widget.authData?.copyWith(
            type: APIAuthType.oauth2,
            oauth2: updatedOAuth2,
          ) ??
          AuthModel(
            type: APIAuthType.oauth2,
            oauth2: updatedOAuth2,
          ),
    );
  }

  Future<void> clearStoredCredentials() async {
    final credentialsFilePath = widget.authData?.oauth2?.credentialsFilePath;
    if (credentialsFilePath != null && credentialsFilePath.isNotEmpty) {
      await deleteFileFromPath(credentialsFilePath);
    }
    setState(() {
      _refreshToken = "";
      _accessToken = "";
      _identityToken = "";
      _tokenExpiration = null;
    });
  }
}
