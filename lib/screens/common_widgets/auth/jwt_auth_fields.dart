import 'package:apidash/widgets/auth_textfield.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';

class JwtAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final Function(AuthModel?) updateAuth;
  final bool readOnly;

  const JwtAuthFields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<JwtAuthFields> createState() => _JwtAuthFieldsState();
}

class _JwtAuthFieldsState extends State<JwtAuthFields> {
  late TextEditingController _secretController;
  late TextEditingController _privateKeyController;
  late TextEditingController _payloadController;
  late String _addTokenTo;
  late String _algorithm;
  late bool _isSecretBase64Encoded;

  @override
  void initState() {
    super.initState();
    final jwt = widget.authData?.jwt;
    _secretController = TextEditingController(text: jwt?.secret ?? '');
    _privateKeyController = TextEditingController(text: jwt?.privateKey ?? '');
    _payloadController = TextEditingController(text: jwt?.payload ?? '');
    _addTokenTo = jwt?.addTokenTo ?? 'header';
    _algorithm = jwt?.algorithm ?? 'HS256';
    _isSecretBase64Encoded = jwt?.isSecretBase64Encoded ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add JWT token to",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        ADPopupMenu<String>(
          value:
              _addTokenTo == 'header' ? 'Request Header' : 'Query Parameters',
          values: const [
            ('header', 'Request Header'),
            ('query', 'Query Parameters'),
          ],
          tooltip: "Select where to add JWT token",
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
        const SizedBox(height: 16),
        Text(
          "Algorithm",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        ADPopupMenu<String>(
          value: _algorithm,
          values: const [
            ('HS256', 'HS256'),
            ('HS384', 'HS384'),
            ('HS512', 'HS512'),
            ('RS256', 'RS256'),
            ('RS384', 'RS384'),
            ('RS512', 'RS512'),
            ('PS256', 'PS256'),
            ('PS384', 'PS384'),
            ('PS512', 'PS512'),
            ('ES256', 'ES256'),
            ('ES256K', 'ES256K'),
            ('ES384', 'ES384'),
            ('ES512', 'ES512'),
            ('EdDSA', 'EdDSA'),
          ],
          tooltip: "Select JWT algorithm",
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
        const SizedBox(height: 16),
        if (_algorithm.startsWith('HS')) ...[
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _secretController,
            isObscureText: true,
            hintText: "Secret key",
            infoText:
                "The secret key used to sign the JWT token. Keep this secure and match it with your server configuration.",
            onChanged: (value) => _updateJwtAuth(),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text(
              "Secret is Base64 encoded",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
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
            "Private Key",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
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
              hintText: '''
-----BEGIN RSA PRIVATE KEY-----
Private Key in PKCS#8 PEM Format
-----END RSA PRIVATE KEY-----
''',
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

        const SizedBox(height: 16),
        Text(
          "Payload (JSON format)",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
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
            hintText:
                '{"sub": "1234567890", "name": "John Doe", "iat": 1516239022}',
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
        // const SizedBox(height: 16),
        // if (currentAddTokenTo == 'header') ...[
        //   Text(
        //     "Header Prefix",
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   SizedBox(height: 4),
        //   TextField(
        //     controller: jwtHeaderPrefixController,
        //     decoration: InputDecoration(
        //       constraints: BoxConstraints(
        //         maxWidth: MediaQuery.sizeOf(context).width - 100,
        //       ),
        //       contentPadding: const EdgeInsets.all(18),
        //       hintText: "Bearer",
        //       hintStyle: Theme.of(context).textTheme.bodyMedium,
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     onChanged: (value) => updateAuth(ApiAuthModel(
        //       type: APIAuthType.jwt,
        //       jwt: AuthJwtModel(
        //         secret: jwtSecretController.text.trim(),
        //         payload: jwtPayloadController.text.trim(),
        //         addTokenTo: currentAddTokenTo,
        //         algorithm: currentAlgorithm,
        //         isSecretBase64Encoded: isSecretBase64Encoded,
        //         headerPrefix: jwtHeaderPrefixController.text.trim(),
        //         queryParamKey: jwtQueryParamKeyController.text.trim(),
        //         header: jwtHeaderController.text.trim(),
        //       ),
        //     )),
        //   ),
        //   const SizedBox(height: 16),
        // ],
        // if (currentAddTokenTo == 'query') ...[
        //   Text(
        //     "Query Parameter Key",
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   SizedBox(height: 4),
        //   TextField(
        //     controller: jwtQueryParamKeyController,
        //     decoration: InputDecoration(
        //       constraints: BoxConstraints(
        //         maxWidth: MediaQuery.sizeOf(context).width - 100,
        //       ),
        //       contentPadding: const EdgeInsets.all(18),
        //       hintText: "token",
        //       hintStyle: Theme.of(context).textTheme.bodyMedium,
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     onChanged: (value) => updateAuth(ApiAuthModel(
        //       type: APIAuthType.jwt,
        //       jwt: AuthJwtModel(
        //         secret: jwtSecretController.text.trim(),
        //         payload: jwtPayloadController.text.trim(),
        //         addTokenTo: currentAddTokenTo,
        //         algorithm: currentAlgorithm,
        //         isSecretBase64Encoded: isSecretBase64Encoded,
        //         headerPrefix: jwtHeaderPrefixController.text.trim(),
        //         queryParamKey: jwtQueryParamKeyController.text.trim(),
        //         header: jwtHeaderController.text.trim(),
        //       ),
        //     )),
        //   ),
        //   const SizedBox(height: 16),
        // ],
        // Text(
        //   "JWT Headers (JSON format)",
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // SizedBox(height: 4),
        // TextField(
        //   controller: jwtHeaderController,
        //   maxLines: 3,
        //   decoration: InputDecoration(
        //     constraints: BoxConstraints(
        //       maxWidth: MediaQuery.sizeOf(context).width - 100,
        //     ),
        //     contentPadding: const EdgeInsets.all(18),
        //     hintText: '{"typ": "JWT", "alg": "HS256"}',
        //     hintStyle: Theme.of(context).textTheme.bodyMedium,
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        //   onChanged: (value) => updateAuth(
        //     ApiAuthModel(
        //       type: APIAuthType.jwt,
        //       jwt: AuthJwtModel(
        //         secret: jwtSecretController.text.trim(),
        //         payload: jwtPayloadController.text.trim(),
        //         addTokenTo: currentAddTokenTo,
        //         algorithm: currentAlgorithm,
        //         isSecretBase64Encoded: isSecretBase64Encoded,
        //         headerPrefix: jwtHeaderPrefixController.text.trim(),
        //         queryParamKey: jwtQueryParamKeyController.text.trim(),
        //         header: jwtHeaderController.text.trim(),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void _updateJwtAuth() {
    widget.updateAuth(
      widget.authData?.copyWith(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: _secretController.text.trim(),
          privateKey: _privateKeyController.text.trim(),
          payload: _payloadController.text.trim(),
          addTokenTo: _addTokenTo,
          algorithm: _algorithm,
          isSecretBase64Encoded: _isSecretBase64Encoded,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: '',
        ),
      ),
    );
  }
}
