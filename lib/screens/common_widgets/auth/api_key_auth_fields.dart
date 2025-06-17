import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/auth/api_auth_model.dart';
import 'package:apidash_core/models/auth/auth_api_key_model.dart';
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
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        DropdownButtonFormField<String>(
          value: _addKeyTo,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 100,
            ),
            contentPadding: const EdgeInsets.all(18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: [
            DropdownMenuItem(
              value: 'header',
              child: Text('Header'),
            ),
            DropdownMenuItem(
              value: 'query',
              child: Text('Query Params'),
            ),
          ],
          onChanged: (String? newLocation) {
            if (newLocation != null) {
              _updateApiKeyAuth();
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          "Header/Query Param Name",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 100,
            ),
            contentPadding: const EdgeInsets.all(18),
            hintText: "Header/Query Param Name",
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) => _updateApiKeyAuth(),
        ),
        const SizedBox(height: 16),
        Text(
          "API Key",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        TextField(
          controller: _keyController,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 100,
            ),
            contentPadding: const EdgeInsets.all(18),
            hintText: "API Key",
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
