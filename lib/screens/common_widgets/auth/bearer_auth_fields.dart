import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/widgets/widgets.dart';
import 'consts.dart';

class BearerAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?)? updateAuth;
  final bool readOnly;

  const BearerAuthFields({
    super.key,
    required this.authData,
    this.updateAuth,
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
      hintText: kHintToken,
      isObscureText: true,
      onChanged: (value) => _updateBearerAuth(),
    );
  }

  void _updateBearerAuth() {
    final bearer = AuthBearerModel(
      token: _tokenController.text.trim(),
    );
    widget.updateAuth?.call(widget.authData?.copyWith(
          type: APIAuthType.bearer,
          bearer: bearer,
        ) ??
        AuthModel(
          type: APIAuthType.bearer,
          bearer: bearer,
        ));
  }
}
