import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import '../common_widgets.dart';
import 'consts.dart';

class BasicAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?)? updateAuth;
  final bool readOnly;

  const BasicAuthFields({
    super.key,
    required this.authData,
    this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<BasicAuthFields> createState() => _BasicAuthFieldsState();
}

class _BasicAuthFieldsState extends State<BasicAuthFields> {
  late String _username;
  late String _password;

  @override
  void initState() {
    super.initState();
    _username = widget.authData?.basic?.username ?? '';
    _password = widget.authData?.basic?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        EnvAuthField(
          readOnly: widget.readOnly,
          hintText: kHintUsername,
          initialValue: _username,
          onChanged: (value) {
            _username = value;
            _updateBasicAuth();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          hintText: kHintPassword,
          isObscureText: true,
          initialValue: _password,
          onChanged: (value) {
            _password = value;
            _updateBasicAuth();
          },
        ),
      ],
    );
  }

  void _updateBasicAuth() {
    final basicAuth = AuthBasicAuthModel(
      username: _username.trim(),
      password: _password.trim(),
    );
    widget.updateAuth?.call(widget.authData?.copyWith(
          type: APIAuthType.basic,
          basic: basicAuth,
        ) ??
        AuthModel(
          type: APIAuthType.basic,
          basic: basicAuth,
        ));
  }
}
