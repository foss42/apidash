import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import '../common_widgets.dart';
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
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = widget.authData?.bearer?.token ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return EnvAuthField(
      readOnly: widget.readOnly,
      hintText: kHintToken,
      isObscureText: true,
      initialValue: _token,
      onChanged: (value) {
        _token = value;
        _updateBearerAuth();
      },
    );
  }

  void _updateBearerAuth() {
    final bearer = AuthBearerModel(
      token: _token.trim(),
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
