import 'package:apidash/widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'consts.dart';

class ApiKeyAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?) updateAuth;

  const ApiKeyAuthFields(
      {super.key,
      required this.authData,
      required this.updateAuth,
      this.readOnly = false});

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
    _nameController =
        TextEditingController(text: apiAuth?.name ?? kApiKeyHeaderName);
    _addKeyTo = apiAuth?.location ?? kAddToDefaultLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kLabelAddTo,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ADPopupMenu<String>(
          value: kAddToLocationsMap[_addKeyTo],
          values: kAddToLocations,
          tooltip: kTooltipApiKeyAuth,
          isOutlined: true,
          onChanged: widget.readOnly
              ? null
              : (String? newLocation) {
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
          readOnly: widget.readOnly,
          controller: _nameController,
          hintText: kHintTextFieldName,
          onChanged: (value) => _updateApiKeyAuth(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _keyController,
          title: kLabelApiKey,
          hintText: kHintTextKey,
          isObscureText: true,
          onChanged: (value) => _updateApiKeyAuth(),
        ),
      ],
    );
  }

  void _updateApiKeyAuth() {
    final apiKey = AuthApiKeyModel(
      key: _keyController.text.trim(),
      name: _nameController.text.trim(),
      location: _addKeyTo,
    );
    widget.updateAuth(widget.authData?.copyWith(
          type: APIAuthType.apiKey,
          apikey: apiKey,
        ) ??
        AuthModel(
          type: APIAuthType.apiKey,
          apikey: apiKey,
        ));
  }
}
