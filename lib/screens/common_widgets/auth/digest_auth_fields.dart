import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import '../common_widgets.dart';
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
  late String _username;
  late String _password;
  late String _realm;
  late String _nonce;
  late String _algorithmController;
  late String _qop;
  late String _opaque;

  @override
  void initState() {
    super.initState();
    final digest = widget.authData?.digest;
    _username = digest?.username ?? '';
    _password = digest?.password ?? '';
    _realm = digest?.realm ?? '';
    _nonce = digest?.nonce ?? '';
    _algorithmController = digest?.algorithm ?? kDigestAlgos[0];
    _qop = digest?.qop ?? kQop[0];
    _opaque = digest?.opaque ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: [
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintUsername,
            infoText: kInfoDigestUsername,
            initialValue: _username,
            onChanged: (value) {
              _username = value;
              _updateDigestAuth();
            },
          ),
          const SizedBox(height: 12),
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintPassword,
            isObscureText: true,
            infoText: kInfoDigestPassword,
            initialValue: _password,
            onChanged: (value) {
              _password = value;
              _updateDigestAuth();
            },
          ),
          const SizedBox(height: 12),
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintRealm,
            infoText: kInfoDigestRealm,
            initialValue: _realm,
            onChanged: (value) {
              _realm = value;
              _updateDigestAuth();
            },
          ),
          const SizedBox(height: 12),
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintNonce,
            infoText: kInfoDigestNonce,
            initialValue: _nonce,
            onChanged: (value) {
              _nonce = value;
              _updateDigestAuth();
            },
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
            values: kDigestAlgos.map((i) => (i, i)),
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
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintQop,
            infoText: kInfoDigestQop,
            initialValue: _qop,
            onChanged: (value) {
              _qop = value;
              _updateDigestAuth();
            },
          ),
          const SizedBox(height: 12),
          EnvAuthField(
            readOnly: widget.readOnly,
            hintText: kHintDataString,
            infoText: kInfoDigestDataString,
            initialValue: _opaque,
            onChanged: (value) {
              _opaque = value;
              _updateDigestAuth();
            },
          ),
        ],
      ),
    );
  }

  void _updateDigestAuth() {
    final digest = AuthDigestModel(
      username: _username.trim(),
      password: _password.trim(),
      realm: _realm.trim(),
      nonce: _nonce.trim(),
      algorithm: _algorithmController.trim(),
      qop: _qop.trim(),
      opaque: _opaque.trim(),
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
