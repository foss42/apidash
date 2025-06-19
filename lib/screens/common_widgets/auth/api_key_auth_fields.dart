import 'package:apidash/screens/common_widgets/auth_textfield.dart';
import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/auth/api_auth_model.dart';
import 'package:apidash_core/models/auth/auth_api_key_model.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class ApiKeyAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;

  const ApiKeyAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
  });

  @override
  State<ApiKeyAuthFields> createState() => _ApiKeyAuthFieldsState();
}

class _ApiKeyAuthFieldsState extends State<ApiKeyAuthFields> {
  late TextEditingController _keyController;
  late TextEditingController _nameController;
  late String _addKeyTo;

  @override
  void initState() {
    super.initState();
    final apiAuth = widget.authData?.apikey;
    _keyController = TextEditingController(text: apiAuth?.key ?? '');
    _nameController = TextEditingController(text: apiAuth?.name ?? '');
    _addKeyTo = apiAuth?.location ?? 'header';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add to",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ADPopupMenu<String>(
          value: _addKeyTo == 'header' ? 'Header' : 'Query Params',
          values: const [
            ('header', 'Header'),
            ('query', 'Query Params'),
          ],
          tooltip: "Select where to add API key",
          isOutlined: true,
          onChanged: (String? newLocation) {
            if (newLocation != null) {
              setState(() {
                _addKeyTo = newLocation;
              });
              _updateApiKeyAuth();
            }
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _nameController,
          hintText: "Header/Query Param Name",
          onChanged: (value) => _updateApiKeyAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _keyController,
          hintText: "API Key",
          isObscureText: true,
          onChanged: (value) => _updateApiKeyAuth(),
        ),
      ],
    );
  }

  void _updateApiKeyAuth() {
    widget.updateAuth(
      widget.authData?.copyWith(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: _keyController.text.trim(),
          name: _nameController.text.trim(),
          location: _addKeyTo,
        ),
      ),
    );
  }
}
