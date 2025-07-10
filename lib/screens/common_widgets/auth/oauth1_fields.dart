import 'package:apidash/screens/common_widgets/auth_textfield.dart';

import 'package:apidash_core/apidash_core.dart';

import 'package:apidash_design_system/widgets/widgets.dart';

import 'package:flutter/material.dart';

class OAuth1Fields extends StatefulWidget {
  final AuthModel? authData;

  final bool readOnly;

  final Function(AuthModel?) updateAuth;

  const OAuth1Fields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<OAuth1Fields> createState() => _OAuth1FieldsState();
}

class _OAuth1FieldsState extends State<OAuth1Fields> {
  late TextEditingController _consumerKeyController;

  late TextEditingController _consumerSecretController;

  late TextEditingController _accessTokenController;

  late TextEditingController _tokenSecretController;

  late TextEditingController _callbackUrlController;

  late TextEditingController _verifierController;

  late TextEditingController _timestampController;

  late TextEditingController _realmController;

  late TextEditingController _nonceController;

  late String _signatureMethodController;

  late String _addAuthDataTo;

  @override
  void initState() {
    super.initState();

    final oauth1 = widget.authData?.oauth1;

    _consumerKeyController =
        TextEditingController(text: oauth1?.consumerKey ?? '');

    _consumerSecretController =
        TextEditingController(text: oauth1?.consumerSecret ?? '');

    _accessTokenController =
        TextEditingController(text: oauth1?.accessToken ?? '');

    _tokenSecretController =
        TextEditingController(text: oauth1?.tokenSecret ?? '');

    _callbackUrlController =
        TextEditingController(text: oauth1?.callbackUrl ?? '');

    _verifierController = TextEditingController(text: oauth1?.verifier ?? '');

    _timestampController = TextEditingController(text: oauth1?.timestamp ?? '');

    _realmController = TextEditingController(text: oauth1?.realm ?? '');

    _nonceController = TextEditingController(text: oauth1?.nonce ?? '');

    _signatureMethodController = oauth1?.signatureMethod ?? 'hmacsha1';

    _addAuthDataTo = oauth1?.parameterLocation ?? 'url';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add auth data to",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ADPopupMenu<String>(
          value: _addAuthDataTo,
          values: const [
            ('URL', 'url'),
            ('Header', 'header'),
            ('Body', 'body'),
          ],
          tooltip: "Select where to add API key",
          isOutlined: true,
          onChanged: (String? newLocation) {
            if (newLocation != null) {
              setState(() {
                _addAuthDataTo = newLocation;
              });

              _updateOAuth1();
            }
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _consumerKeyController,
          hintText: "Consumer Key",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _consumerSecretController,
          hintText: "Consumer Secret",
          isObscureText: true,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        Text(
          "Signature Method",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        ADPopupMenu<String>(
          value: _signatureMethodController.trim(),
          values: const [
            ('HMAC-SHA1', 'hmacsha1'),
            ('HMAC-SHA256', 'hmacsha256'),
            ('HMAC-SHA512', 'hmacsha512'),
            ('Plaintext', 'plaintext'),
          ],
          tooltip: "this algorithm will be used to produce the digest",
          isOutlined: true,
          onChanged: (String? newAlgo) {
            if (newAlgo != null) {
              setState(() {
                _signatureMethodController = newAlgo;
              });

              _updateOAuth1();
            }
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _accessTokenController,
          hintText: "Access Token",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _tokenSecretController,
          hintText: "Token Secret",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _callbackUrlController,
          hintText: "Callback URL",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _verifierController,
          hintText: "Verifier",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _timestampController,
          hintText: "Timestamp",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _nonceController,
          hintText: "Nonce",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _realmController,
          hintText: "Realm",
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _updateOAuth1() {
    widget.updateAuth(
      widget.authData?.copyWith(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: _consumerKeyController.text.trim(),
          consumerSecret: _consumerSecretController.text.trim(),
          accessToken: _accessTokenController.text.trim(),
          tokenSecret: _tokenSecretController.text.trim(),
          signatureMethod: _signatureMethodController,
          parameterLocation: _addAuthDataTo,
          callbackUrl: _callbackUrlController.text.trim(),
          verifier: _verifierController.text.trim(),
          timestamp: _timestampController.text.trim(),
          nonce: _nonceController.text.trim(),
          realm: _realmController.text.trim(),
        ),
      ),
    );
  }
}
