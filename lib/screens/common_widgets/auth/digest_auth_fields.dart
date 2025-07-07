import 'package:apidash/screens/common_widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DigestAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?) updateAuth;

  const DigestAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<DigestAuthFields> createState() => _DigestAuthFieldsState();
}

class _DigestAuthFieldsState extends State<DigestAuthFields> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _realmController;
  late TextEditingController _nonceController;
  late String _algorithmController;
  late TextEditingController _qopController;
  late TextEditingController _opaqueController;

  @override
  void initState() {
    super.initState();
    final digest = widget.authData?.digest;
    _usernameController = TextEditingController(text: digest?.username ?? '');
    _passwordController = TextEditingController(text: digest?.password ?? '');
    _realmController = TextEditingController(text: digest?.realm ?? '');
    _nonceController = TextEditingController(text: digest?.nonce ?? '');
    _algorithmController = digest?.algorithm ?? 'MD5';
    _qopController = TextEditingController(text: digest?.qop ?? 'auth');
    _opaqueController = TextEditingController(text: digest?.opaque ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _usernameController,
            hintText: "Username",
            infoText:
                "Your username for digest authentication. This will be sent to the server for credential verification.",
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _passwordController,
            hintText: "Password",
            isObscureText: true,
            infoText:
                "Your password for digest authentication. This is hashed and not sent in plain text to the server.",
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _realmController,
            hintText: "Realm",
            infoText:
                "Authentication realm as specified by the server. This defines the protection space for the credentials.",
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _nonceController,
            hintText: "Nonce",
            infoText:
                "Server-generated random value used to prevent replay attacks.",
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          Text(
            "Algorithm",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          ADPopupMenu<String>(
            value: _algorithmController.trim(),
            values: const [
              ('MD5', 'MD5'),
              ('MD5-sess', 'MD5-sess'),
              ('SHA-256', 'SHA-256'),
              ('SHA-256-sess', 'SHA-256-sess'),
            ],
            tooltip: "Algorithm that will be used to produce the digest",
            isOutlined: true,
            onChanged: (String? newLocation) {
              if (newLocation != null) {
                setState(() {
                  _algorithmController = newLocation;
                });
                _updateDigestAuth();
              }
            },
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _qopController,
            hintText: "QOP",
            infoText:
                "Quality of Protection. Typically 'auth' for authentication only, or 'auth-int' for authentication with integrity protection.",
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _opaqueController,
            hintText: "Opaque",
            infoText:
                "Server-specified data string that should be returned unchanged in the authorization header. Usually obtained from server's 401 response.",
            onChanged: (_) => _updateDigestAuth(),
          ),
        ],
      ),
    );
  }

  void _updateDigestAuth() {
    widget.updateAuth(widget.authData?.copyWith(
          type: APIAuthType.digest,
          digest: AuthDigestModel(
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
            realm: _realmController.text.trim(),
            nonce: _nonceController.text.trim(),
            algorithm: _algorithmController.trim(),
            qop: _qopController.text.trim(),
            opaque: _opaqueController.text.trim(),
          ),
        ) ??
        AuthModel(
          type: APIAuthType.digest,
          digest: AuthDigestModel(
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
            realm: _realmController.text.trim(),
            nonce: _nonceController.text.trim(),
            algorithm: _algorithmController.trim(),
            qop: _qopController.text.trim(),
            opaque: _opaqueController.text.trim(),
          ),
        ));
  }
}
