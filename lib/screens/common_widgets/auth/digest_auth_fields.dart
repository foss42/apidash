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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _usernameController,
          hintText: "Username",
          onChanged: (_) => _updateDigestAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _passwordController,
          hintText: "Password",
          isObscureText: true,
          onChanged: (_) => _updateDigestAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _realmController,
          hintText: "Realm",
          onChanged: (_) => _updateDigestAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _nonceController,
          hintText: "Nonce",
          onChanged: (_) => _updateDigestAuth(),
        ),
        const SizedBox(height: 16),
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
          tooltip: "this algorithm will be used to produce the digest",
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
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _qopController,
          hintText: "QOP (e.g. auth)",
          onChanged: (_) => _updateDigestAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _opaqueController,
          hintText: "Opaque",
          onChanged: (_) => _updateDigestAuth(),
        ),
      ],
    );
  }

  void _updateDigestAuth() {
    widget.updateAuth(
      widget.authData?.copyWith(
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
      ),
    );
  }
}
