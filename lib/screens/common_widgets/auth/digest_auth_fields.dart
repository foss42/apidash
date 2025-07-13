import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/widgets/widgets.dart';
import 'consts.dart';

class DigestAuthFields extends StatefulWidget {
  final AuthModel? authData;
  final bool readOnly;
  final Function(AuthModel?)? updateAuth;

  const DigestAuthFields({
    super.key,
    required this.authData,
    this.updateAuth,
    this.readOnly = false,
  });

  @override
  State<DigestAuthFields> createState() => _DigestAuthFieldsState();
}

class _DigestAuthFieldsState extends State<DigestAuthFields> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _realmController;
  late TextEditingController _nonceController;
  late String _algorithmController;
  late TextEditingController _qopController;
  late TextEditingController _opaqueController;

  @override
  void initState() {
    super.initState();
    final digest = widget.authData?.digest;
    _usernameController = TextEditingController(text: digest?.username ?? '');
    _passwordController = TextEditingController(text: digest?.password ?? '');
    _realmController = TextEditingController(text: digest?.realm ?? '');
    _nonceController = TextEditingController(text: digest?.nonce ?? '');
    _algorithmController = digest?.algorithm ?? kDigestAlgos[0];
    _qopController = TextEditingController(text: digest?.qop ?? kQop[0]);
    _opaqueController = TextEditingController(text: digest?.opaque ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _usernameController,
            hintText: kHintUsername,
            infoText: kInfoDigestUsername,
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _passwordController,
            hintText: kHintPassword,
            isObscureText: true,
            infoText: kInfoDigestPassword,
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _realmController,
            hintText: kHintRealm,
            infoText: kInfoDigestRealm,
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _nonceController,
            hintText: kHintNonce,
            infoText: kInfoDigestNonce,
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          Text(
            kAlgorithm,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          ADPopupMenu<String>(
            value: _algorithmController.trim(),
            values: kDigestAlgos.map((i) => (i, null)),
            tooltip: kTooltipAlgorithm,
            isOutlined: true,
            onChanged: widget.readOnly
                ? null
                : (String? newLocation) {
                    if (newLocation != null) {
                      setState(() {
                        _algorithmController = newLocation;
                      });
                      _updateDigestAuth();
                    }
                  },
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _qopController,
            hintText: kHintQop,
            infoText: kInfoDigestQop,
            onChanged: (_) => _updateDigestAuth(),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            readOnly: widget.readOnly,
            controller: _opaqueController,
            hintText: kHintDataString,
            infoText: kInfoDigestDataString,
            onChanged: (_) => _updateDigestAuth(),
          ),
        ],
      ),
    );
  }

  void _updateDigestAuth() {
    final digest = AuthDigestModel(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      realm: _realmController.text.trim(),
      nonce: _nonceController.text.trim(),
      algorithm: _algorithmController.trim(),
      qop: _qopController.text.trim(),
      opaque: _opaqueController.text.trim(),
    );
    widget.updateAuth?.call(widget.authData?.copyWith(
          type: APIAuthType.digest,
          digest: digest,
        ) ??
        AuthModel(
          type: APIAuthType.digest,
          digest: digest,
        ));
  }
}
