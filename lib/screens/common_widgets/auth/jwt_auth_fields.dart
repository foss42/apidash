import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../common_widgets.dart';
import 'consts.dart';

class JwtAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?)? updateAuth;
  final bool readOnly;

  const JwtAuthFields({
    super.key,
    required this.authData,
    this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<JwtAuthFields> createState() => _JwtAuthFieldsState();
}

class _JwtAuthFieldsState extends State<JwtAuthFields> {
  late String _secret;
  late TextEditingController _privateKeyController;
  late TextEditingController _payloadController;
  late String _addTokenTo;
  late String _algorithm;
  late bool _isSecretBase64Encoded;

  @override
  void initState() {
    super.initState();
    final jwt = widget.authData?.jwt;
    _secret = jwt?.secret ?? '';
    _privateKeyController = TextEditingController(text: jwt?.privateKey ?? '');
    _payloadController = TextEditingController(text: jwt?.payload ?? '');
    _addTokenTo = jwt?.addTokenTo ?? kAddToDefaultLocation;
    _algorithm = jwt?.algorithm ?? kJwtAlgos[0];
    _isSecretBase64Encoded = jwt?.isSecretBase64Encoded ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        Text(
          kMsgAddToken,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14*ds.scaleFactor,
          ),
        ),
        SizedBox(height: 4*ds.scaleFactor),
        ADPopupMenu<String>(
          value: kAddToLocationsMap[_addTokenTo],
          values: kAddToLocations,
          tooltip: kTooltipTokenAddTo,
          isOutlined: true,
          onChanged: widget.readOnly
              ? null
              : (String? newAddTokenTo) {
                  if (newAddTokenTo != null) {
                    setState(() {
                      _addTokenTo = newAddTokenTo;
                    });
                    _updateJwtAuth();
                  }
                },
        ),
        SizedBox(height: 16*ds.scaleFactor),
        Text(
          kTextAlgo,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14*ds.scaleFactor,
          ),
        ),
        SizedBox(height: 4*ds.scaleFactor),
        ADPopupMenu<String>(
          value: _algorithm,
          values: kJwtAlgos.map((i) => (i, i)),
          tooltip: kTooltipJWTAlgo,
          isOutlined: true,
          onChanged: widget.readOnly
              ? null
              : (String? newAlgorithm) {
                  if (newAlgorithm != null) {
                    setState(() {
                      _algorithm = newAlgorithm;
                    });
                    _updateJwtAuth();
                  }
                },
        ),
        SizedBox(height: 16*ds.scaleFactor),
        if (_algorithm.startsWith(kStartAlgo)) ...[
          EnvAuthField(
            readOnly: widget.readOnly,
            isObscureText: true,
            hintText: kHintSecret,
            infoText: kInfoSecret,
            initialValue: _secret,
            onChanged: (value) {
              _secret = value;
              _updateJwtAuth();
            },
          ),
          SizedBox(height: 16*ds.scaleFactor),
          CheckboxListTile(
            title: Text(
              kMsgSecret,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14*ds.scaleFactor,
              ),
            ),
            value: _isSecretBase64Encoded,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              setState(() {
                _isSecretBase64Encoded = value ?? false;
              });

              _updateJwtAuth();
            },
          ),
        ] else ...[
          Text(
            kMsgPrivateKey,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14*ds.scaleFactor,
            ),
          ),
          SizedBox(height: 4*ds.scaleFactor),
          TextField(
            readOnly: widget.readOnly,
            controller: _privateKeyController,
            maxLines: 5,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 100,
              ),
              contentPadding: const EdgeInsets.all(18),
              hintText: kHintRSA,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            onChanged: (value) => _updateJwtAuth(),
          ),
        ],
        SizedBox(height: 16*ds.scaleFactor),
        Text(
          kMsgPayload,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14*ds.scaleFactor,
          ),
        ),
        SizedBox(height: 4*ds.scaleFactor),
        TextField(
          readOnly: widget.readOnly,
          controller: _payloadController,
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 100,
            ),
            contentPadding: const EdgeInsets.all(18),
            hintText: kHintJson,
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          onChanged: (value) => _updateJwtAuth(),
        ),
      ],
    );
  }

  void _updateJwtAuth() {
    final jwt = AuthJwtModel(
      secret: _secret.trim(),
      privateKey: _privateKeyController.text.trim(),
      payload: _payloadController.text.trim(),
      addTokenTo: _addTokenTo,
      algorithm: _algorithm,
      isSecretBase64Encoded: _isSecretBase64Encoded,
      headerPrefix: kHeaderPrefix,
      queryParamKey: kQueryParamKey,
      header: '',
    );
    widget.updateAuth?.call(
      widget.authData?.copyWith(
            type: APIAuthType.jwt,
            jwt: jwt,
          ) ??
          AuthModel(
            type: APIAuthType.jwt,
            jwt: jwt,
          ),
    );
  }
}
