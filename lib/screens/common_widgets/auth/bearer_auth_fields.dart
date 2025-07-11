import 'package:apidash/screens/common_widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

class BearerAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;
  final bool readOnly;

  const BearerAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<BearerAuthFields> createState() => _BearerAuthFieldsState();
}

class _BearerAuthFieldsState extends State<BearerAuthFields> {
  late TextEditingController _tokenController;

  @override
  void initState() {
    super.initState();
    final bearerAuth = widget.authData?.bearer;
    _tokenController = TextEditingController(text: bearerAuth?.token ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      readOnly: widget.readOnly,
      controller: _tokenController,
      hintText: "Token",
      isObscureText: true,
      onChanged: (value) => _updateBearerAuth(),
    );
  }

  void _updateBearerAuth() {
    widget.updateAuth(widget.authData?.copyWith(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(
            token: _tokenController.text.trim(),
          ),
        ) ??
        AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(
            token: _tokenController.text.trim(),
          ),
        ));
  }
}
