import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

class BearerAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;

  const BearerAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Token",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          controller: _tokenController,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 100,
            ),
            contentPadding: const EdgeInsets.all(18),
            hintText: "Token",
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) => _updateBearerAuth(),
        ),
      ],
    );
  }

  void _updateBearerAuth() {
    widget.updateAuth(
      widget.authData?.copyWith(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(
          token: _tokenController.text.trim(),
        ),
      ),
    );
  }
}
