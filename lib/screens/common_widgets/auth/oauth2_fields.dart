import 'package:apidash/screens/common_widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

class OAuth2Fields extends StatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?) updateAuth;

  const OAuth2Fields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<OAuth2Fields> createState() => _OAuth2FieldsState();
}

class _OAuth2FieldsState extends State<OAuth2Fields> {
  late String _grantType;
  late TextEditingController _authorizationUrlController;
  late TextEditingController _accessTokenUrlController;
  late TextEditingController _clientIdController;
  late TextEditingController _clientSecretController;
  late TextEditingController _redirectUrlController;
  late TextEditingController _scopeController;
  late TextEditingController _stateController;
  late String _codeChallengeMethodController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _refreshTokenController;
  late TextEditingController _identityTokenController;
  late TextEditingController _accessTokenController;

  @override
  void initState() {
    super.initState();
    final oauth1 = widget.authData?.oauth1;
    _authorizationUrlController =
        TextEditingController(text: oauth1?.consumerKey ?? '');
    _accessTokenUrlController =
        TextEditingController(text: oauth1?.accessToken ?? '');
    _clientIdController =
        TextEditingController(text: oauth1?.consumerSecret ?? '');
    _clientSecretController =
        TextEditingController(text: oauth1?.tokenSecret ?? '');
    _redirectUrlController =
        TextEditingController(text: oauth1?.callbackUrl ?? '');
    _scopeController = TextEditingController(text: oauth1?.realm ?? '');
    _stateController = TextEditingController(text: oauth1?.nonce ?? '');
    _usernameController = TextEditingController(text: oauth1?.verifier ?? '');
    _passwordController = TextEditingController(text: oauth1?.timestamp ?? '');
    _refreshTokenController = TextEditingController(text: '');
    _identityTokenController = TextEditingController(text: '');
    _accessTokenController = TextEditingController(text: '');
    _codeChallengeMethodController = oauth1?.signatureMethod ?? 'sha-256';
    _grantType = oauth1?.parameterLocation ?? 'authorization_code';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Grant Type",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ADPopupMenu<String>(
          value: _grantType,
          values: const [
            ('Authorization Code', 'authorization_code'),
            (
              'Resource Owner Password Credentials',
              'resource_owner_password_credentials'
            ),
            ('Client Credentials', 'client_credentials'),
          ],
          tooltip: "Select OAuth 2.0 grant type",
          isOutlined: true,
          onChanged: (String? newGrantType) {
            if (newGrantType != null) {
              setState(() {
                _grantType = newGrantType;
              });
              _updateOAuth2();
            }
          },
        ),
        const SizedBox(height: 16),
        if (_shouldShowField('authorizationUrl'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _authorizationUrlController,
              hintText: "Authorization URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        if (_shouldShowField('accessTokenUrl'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _accessTokenUrlController,
              hintText: "Access Token URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        ..._buildFieldWithSpacing(
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _clientIdController,
            hintText: "Client ID",
            onChanged: (_) => _updateOAuth2(),
          ),
        ),
        ..._buildFieldWithSpacing(
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _clientSecretController,
            hintText: "Client Secret",
            isObscureText: true,
            onChanged: (_) => _updateOAuth2(),
          ),
        ),
        if (_shouldShowField('redirectUrl'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _redirectUrlController,
              hintText: "Redirect URL",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        if (_shouldShowField('codeChallengeMethod')) ...[
          Text(
            "Code Challenge Method",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          ADPopupMenu<String>(
            value: _codeChallengeMethodController,
            values: const [
              ('SHA-256', 'sha-256'),
              ('Plaintext', 'plaintext'),
            ],
            tooltip: "Code challenge method for PKCE",
            isOutlined: true,
            onChanged: (String? newMethod) {
              if (newMethod != null) {
                setState(() {
                  _codeChallengeMethodController = newMethod;
                });
                _updateOAuth2();
              }
            },
          ),
          const SizedBox(height: 16),
        ],
        if (_shouldShowField('username'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _usernameController,
              hintText: "Username",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        if (_shouldShowField('password'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _passwordController,
              hintText: "Password",
              isObscureText: true,
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        if (_shouldShowField('scope'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _scopeController,
              hintText: "Scope",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
        if (_shouldShowField('state'))
          ..._buildFieldWithSpacing(
            AuthTextField(
              readOnly: widget.readOnly,
              controller: _stateController,
              hintText: "State",
              onChanged: (_) => _updateOAuth2(),
            ),
          ),
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
        const SizedBox(height: 16),
      ],
    );
  }

  List<Widget> _buildFieldWithSpacing(Widget field) {
    return [
      field,
      const SizedBox(height: 16),
    ];
  }

  bool _shouldShowField(String fieldName) {
    switch (_grantType) {
      case 'authorization_code':
        return [
          'authorizationUrl',
          'accessTokenUrl',
          'redirectUrl',
          'codeChallengeMethod',
          'scope',
          'state'
        ].contains(fieldName);
      case 'resource_owner_password_credentials':
        return ['accessTokenUrl', 'username', 'password', 'scope']
            .contains(fieldName);
      case 'client_credentials':
        return ['accessTokenUrl', 'scope'].contains(fieldName);
      default:
        return true;
    }
  }

  void _updateOAuth2() {
    widget.updateAuth(
      widget.authData?.copyWith(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          authorizationUrl: _authorizationUrlController.text.trim(),
          clientId: _clientIdController.text.trim(),
          accessTokenUrl: _accessTokenUrlController.text.trim(),
          clientSecret: _clientSecretController.text.trim(),
          codeChallenge: _codeChallengeMethodController,
          grantType: _grantType,
          redirectUrl: _redirectUrlController.text.trim(),
          scope: _scopeController.text.trim(),
          state: _stateController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
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
    super.dispose();
  }
}
