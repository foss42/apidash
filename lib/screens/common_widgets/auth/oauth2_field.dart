import 'package:apidash/widgets/field_auth.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class OAuth2Fields extends StatefulWidget {
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
  State<OAuth2Fields> createState() => _OAuth2FieldsState();
}

class _OAuth2FieldsState extends State<OAuth2Fields> {
  late OAuth2GrantType _grantType;

  late TextEditingController _authorizationUrlController;

  late TextEditingController _accessTokenUrlController;

  late TextEditingController _clientIdController;

  late TextEditingController _clientSecretController;

  late TextEditingController _redirectUrlController;

  late TextEditingController _scopeController;

  late TextEditingController _stateController;

  late String _codeChallengeMethod;

  late TextEditingController _usernameController;

  late TextEditingController _passwordController;

  late TextEditingController _refreshTokenController;

  late TextEditingController _identityTokenController;

  late TextEditingController _accessTokenController;

// late TextEditingController _headerPrefixController;

// late TextEditingController _audienceController;

  @override
  void initState() {
    super.initState();

    final oauth2 = widget.authData?.oauth2;

    _grantType = oauth2?.grantType ?? OAuth2GrantType.authorizationCode;

    _authorizationUrlController =
        TextEditingController(text: oauth2?.authorizationUrl ?? '');

    _accessTokenUrlController =
        TextEditingController(text: oauth2?.accessTokenUrl ?? '');

    _clientIdController = TextEditingController(text: oauth2?.clientId ?? '');

    _clientSecretController =
        TextEditingController(text: oauth2?.clientSecret ?? '');

    _redirectUrlController =
        TextEditingController(text: oauth2?.redirectUrl ?? '');

    _scopeController = TextEditingController(text: oauth2?.scope ?? '');

    _stateController = TextEditingController(text: oauth2?.state ?? '');

    _usernameController = TextEditingController(text: oauth2?.username ?? '');

    _passwordController = TextEditingController(text: oauth2?.password ?? '');

    _refreshTokenController =
        TextEditingController(text: oauth2?.refreshToken ?? '');

    _identityTokenController =
        TextEditingController(text: oauth2?.identityToken ?? '');

    _accessTokenController =
        TextEditingController(text: oauth2?.accessToken ?? '');

// _headerPrefixController = TextEditingController(text: oauth2?.headerPrefix ?? '');

// _audienceController = TextEditingController(text: oauth2?.audience ?? '');

    _codeChallengeMethod = oauth2?.codeChallengeMethod ?? 'sha-256';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Grant Type",
          style: Theme.of(context).textTheme.labelLarge,
        ),

        kVSpacer5,

        ADPopupMenu<OAuth2GrantType>(
          value: _grantType.displayType,
          values: OAuth2GrantType.values.map((e) => (e, e.displayType)),
          tooltip: "Select OAuth 2.0 grant type",
          isOutlined: true,
          onChanged: (OAuth2GrantType? newGrantType) {
            if (newGrantType != null && newGrantType != _grantType) {
              setState(() {
                _grantType = newGrantType;
              });

              _updateOAuth2();
            }
          },
        ),

        kVSpacer16,

        if (_shouldShowField(OAuth2Field.authorizationUrl))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _authorizationUrlController,
              hintText: "Authorization URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.username))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _usernameController,
              hintText: "Username",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.password))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _passwordController,
              hintText: "Password",
              isObscureText: true,
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.accessTokenUrl))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _accessTokenUrlController,
              hintText: "Access Token URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.clientId))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _clientIdController,
              hintText: "Client ID",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.clientSecret))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _clientSecretController,
              hintText: "Client Secret",
              isObscureText: true,
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.codeChallengeMethod)) ...[
          Text(
            "Code Challenge Method",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          kVSpacer5,
          ADPopupMenu<String>(
            value: _codeChallengeMethod.toUpperCase(),
            values: const [
              ('SHA-256', 'sha-256'),
              ('Plaintext', 'plaintext'),
            ],
            tooltip: "Code challenge method for PKCE",
            isOutlined: true,
            onChanged: (String? newMethod) {
              if (newMethod != null && newMethod != _codeChallengeMethod) {
                setState(() {
                  _codeChallengeMethod = newMethod;
                });

                _updateOAuth2();
              }
            },
          ),
          kVSpacer16,
        ],

        if (_shouldShowField(OAuth2Field.redirectUrl))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _redirectUrlController,
              hintText: "Redirect URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(
            OAuth2Field.scope)) // Based on refined list, Scope is always shown

          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _scopeController,
              hintText: "Scope",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

        if (_shouldShowField(OAuth2Field.state))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _stateController,
              hintText: "State",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),

// if (_shouldShowField(OAuth2Field

// .headerPrefix))

// ..._buildFieldWithSpacing(

// AuthTextField(

// readOnly: widget.readOnly,

// controller: _headerPrefixController,

// hintText: "Header Prefix",

// onChanged: (_) => _updateOAuth2(),

// ),

// ),

// if (_shouldShowField(OAuth2Field

// .audience))

// ..._buildFieldWithSpacing(

// AuthTextField(

// readOnly: widget.readOnly,

// controller: _audienceController,

// hintText: "Audience",

// onChanged: (_) => _updateOAuth2(),

// ),

// ),

        Divider(),

        kVSpacer16,

        ..._buildFieldWithSpacing(
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _refreshTokenController,
            hintText: "Refresh Token",
            onChanged: (_) => _updateOAuth2(),
          ),
        ),

        ..._buildFieldWithSpacing(
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _identityTokenController,
            hintText: "Identity Token",
            onChanged: (_) => _updateOAuth2(),
          ),
        ),

        ..._buildFieldWithSpacing(
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _accessTokenController,
            hintText: "Access Token",
            onChanged: (_) => _updateOAuth2(),
          ),
        ),

        kVSpacer16,
      ],
    );
  }

  List<Widget> _buildFieldWithSpacing(Widget field) {
    return [
      field,
      kVSpacer16,
    ];
  }

  bool _shouldShowField(OAuth2Field field) {
    const alwaysShownFields = {
      OAuth2Field.accessTokenUrl,
      OAuth2Field.clientId,
      OAuth2Field.clientSecret,
      OAuth2Field.scope,
      OAuth2Field.headerPrefix,
      OAuth2Field.audience,
      OAuth2Field.refreshToken,
      OAuth2Field.identityToken,
      OAuth2Field.accessToken,
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

  void _updateOAuth2() {
    final updatedOAuth2 = AuthOAuth2Model(
      grantType: _grantType,

      authorizationUrl: _authorizationUrlController.text.trim(),

      clientId: _clientIdController.text.trim(),

      accessTokenUrl: _accessTokenUrlController.text.trim(),

      clientSecret: _clientSecretController.text.trim(),

      codeChallengeMethod: _codeChallengeMethod,

      redirectUrl: _redirectUrlController.text.trim(),

      scope: _scopeController.text.trim(),

      state: _stateController.text.trim(),

      username: _usernameController.text.trim(),

      password: _passwordController.text.trim(),

      refreshToken: _refreshTokenController.text.trim(),

      identityToken: _identityTokenController.text.trim(),

      accessToken: _accessTokenController.text.trim(),

// headerPrefix: _headerPrefixController.text.trim(),

// audience: _audienceController.text.trim(),
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

  @override
  void dispose() {
    _authorizationUrlController.dispose();

    _accessTokenUrlController.dispose();

    _clientIdController.dispose();

    _clientSecretController.dispose();

    _redirectUrlController.dispose();

    _scopeController.dispose();

    _stateController.dispose();

    _usernameController.dispose();

    _passwordController.dispose();

    _refreshTokenController.dispose();

    _identityTokenController.dispose();

    _accessTokenController.dispose();

// _headerPrefixController.dispose();

// _audienceController.dispose();

    super.dispose();
  }
}

enum OAuth2Field {
  authorizationUrl,

  accessTokenUrl,

  clientId,

  clientSecret,

  redirectUrl,

  scope,

  state,

  codeChallengeMethod,

  username,

  password,

  refreshToken,

  identityToken,

  accessToken,

  headerPrefix,

  audience
}
