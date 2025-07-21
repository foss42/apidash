import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../common_widgets.dart';
import 'consts.dart';

class ApiKeyAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?)? updateAuth;

  const ApiKeyAuthFields(
      {super.key,
      required this.authData,
      this.updateAuth,
      this.readOnly = false});

  @override
  State<ApiKeyAuthFields> createState() => _ApiKeyAuthFieldsState();
}

class _ApiKeyAuthFieldsState extends State<ApiKeyAuthFields> {
  late String _key;
  late String _name;
  late String _addKeyTo;

  @override
  void initState() {
    super.initState();
    final apiAuth = widget.authData?.apikey;
    _key = apiAuth?.key ?? '';
    _name = (apiAuth?.name != null && apiAuth!.name.isNotEmpty)
        ? apiAuth.name
        : kApiKeyHeaderName;
    _addKeyTo = apiAuth?.location ?? kAddToDefaultLocation;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
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
        EnvAuthField(
          readOnly: widget.readOnly,
          hintText: kHintTextFieldName,
          initialValue: _name,
          onChanged: (value) {
            _name = value;
            _updateApiKeyAuth();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          title: kLabelApiKey,
          hintText: kHintTextKey,
          isObscureText: true,
          initialValue: _key,
          onChanged: (value) {
            _key = value;
            _updateApiKeyAuth();
          },
        ),
      ],
    );
  }

  void _updateApiKeyAuth() {
    final apiKey = AuthApiKeyModel(
      key: _key.trim(),
      name: _name.trim(),
      location: _addKeyTo,
    );
    widget.updateAuth?.call(widget.authData?.copyWith(
          type: APIAuthType.apiKey,
          apikey: apiKey,
        ) ??
        AuthModel(
          type: APIAuthType.apiKey,
          apikey: apiKey,
        ));
  }
}
