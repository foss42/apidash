import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_widgets.dart';
import 'consts.dart';

class OAuth1Fields extends ConsumerStatefulWidget {
  final AuthModel? authData;

  final bool readOnly;

  final Function(AuthModel?)? updateAuth;

  const OAuth1Fields({
    super.key,
    required this.authData,
    required this.updateAuth,
    this.readOnly = false,
  });

  @override
  ConsumerState<OAuth1Fields> createState() => _OAuth1FieldsState();
}

class _OAuth1FieldsState extends ConsumerState<OAuth1Fields> {
  late String _consumerKey;
  late String _consumerSecret;
  late String _accessToken;
  late String _tokenSecret;
  late String _callbackUrl;
  late String _verifier;
  late String _timestamp;
  late String _realm;
  late String _nonce;
  late OAuth1SignatureMethod _signatureMethodController;
  late String _addAuthDataTo;

  @override
  void initState() {
    super.initState();
    final oauth1 = widget.authData?.oauth1;
    _consumerKey = oauth1?.consumerKey ?? '';
    _consumerSecret = oauth1?.consumerSecret ?? '';
    _accessToken = oauth1?.accessToken ?? '';
    _tokenSecret = oauth1?.tokenSecret ?? '';
    _callbackUrl = oauth1?.callbackUrl ?? '';
    _verifier = oauth1?.verifier ?? '';
    _timestamp = oauth1?.timestamp ?? '';
    _realm = oauth1?.realm ?? '';
    _nonce = oauth1?.nonce ?? '';
    _signatureMethodController =
        oauth1?.signatureMethod ?? OAuth1SignatureMethod.hmacSha1;
    _addAuthDataTo = oauth1?.parameterLocation ?? 'url';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        // Text(
        //   "Add auth data to",
        //   style: TextStyle(
        //     fontWeight: FontWeight.normal,
        //     fontSize: 14,
        //   ),
        // ),
        // SizedBox(
        //   height: 4,
        // ),
        // ADPopupMenu<String>(
        //   value: _addAuthDataTo,
        //   values: const [
        //     ('Request URL / Request Body', 'url'),
        //     ('Request Header', 'header'),
        //   ],
        //   tooltip: "Select where to add API key",
        //   isOutlined: true,
        //   onChanged: (String? newLocation) {
        //     if (newLocation != null) {
        //       setState(() {
        //         _addAuthDataTo = newLocation;
        //       });

        //       _updateOAuth1();
        //     }
        //   },
        // ),
        // const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _consumerKey,
          hintText: kHintOAuth1ConsumerKey,
          infoText: kInfoOAuth1ConsumerKey,
          onChanged: (value) {
            _consumerKey = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _consumerSecret,
          hintText: kHintOAuth1ConsumerSecret,
          infoText: kInfoOAuth1ConsumerSecret,
          isObscureText: true,
          onChanged: (value) {
            _consumerSecret = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        Text(
          kLabelOAuth1SignatureMethod,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        ADPopupMenu<OAuth1SignatureMethod>(
          value: _signatureMethodController.displayType,
          values: OAuth1SignatureMethod.values.map((e) => (e, e.displayType)),
          tooltip: kTooltipOAuth1SignatureMethod,
          isOutlined: true,
          onChanged: widget.readOnly
              ? null
              : (OAuth1SignatureMethod? newAlgo) {
                  if (newAlgo != null) {
                    setState(() {
                      _signatureMethodController = newAlgo;
                    });
                    _updateOAuth1();
                  }
                },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _accessToken,
          hintText: kHintOAuth1AccessToken,
          infoText: kInfoOAuth1AccessToken,
          onChanged: (value) {
            _accessToken = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _tokenSecret,
          hintText: kHintOAuth1TokenSecret,
          infoText: kInfoOAuth1TokenSecret,
          isObscureText: true,
          onChanged: (value) {
            _tokenSecret = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _callbackUrl,
          hintText: kHintOAuth1CallbackUrl,
          infoText: kInfoOAuth1CallbackUrl,
          onChanged: (value) {
            _callbackUrl = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _verifier,
          hintText: kHintOAuth1Verifier,
          infoText: kInfoOAuth1Verifier,
          onChanged: (value) {
            _verifier = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _timestamp,
          hintText: kHintOAuth1Timestamp,
          infoText: kInfoOAuth1Timestamp,
          onChanged: (value) {
            _timestamp = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _nonce,
          hintText: kHintOAuth1Nonce,
          infoText: kInfoOAuth1Nonce,
          onChanged: (value) {
            _nonce = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
        EnvAuthField(
          readOnly: widget.readOnly,
          initialValue: _realm,
          hintText: kHintOAuth1Realm,
          infoText: kInfoOAuth1Realm,
          onChanged: (value) {
            _realm = value;
            _updateOAuth1();
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _updateOAuth1() async {
    final settingsModel = ref.read(settingsProvider);
    final credentialsFilePath = settingsModel.workspaceFolderPath != null
        ? "${settingsModel.workspaceFolderPath}/oauth1_credentials.json"
        : null;

    widget.updateAuth?.call(
      widget.authData?.copyWith(
            type: APIAuthType.oauth1,
            oauth1: AuthOAuth1Model(
              consumerKey: _consumerKey.trim(),
              consumerSecret: _consumerSecret.trim(),
              accessToken: _accessToken.trim(),
              tokenSecret: _tokenSecret.trim(),
              signatureMethod: _signatureMethodController,
              parameterLocation: _addAuthDataTo,
              callbackUrl: _callbackUrl.trim(),
              verifier: _verifier.trim(),
              timestamp: _timestamp.trim(),
              nonce: _nonce.trim(),
              realm: _realm.trim(),
              credentialsFilePath: credentialsFilePath,
            ),
          ) ??
          AuthModel(
            type: APIAuthType.oauth1,
            oauth1: AuthOAuth1Model(
              consumerKey: _consumerKey.trim(),
              consumerSecret: _consumerSecret.trim(),
              accessToken: _accessToken.trim(),
              tokenSecret: _tokenSecret.trim(),
              signatureMethod: _signatureMethodController,
              parameterLocation: _addAuthDataTo,
              callbackUrl: _callbackUrl.trim(),
              verifier: _verifier.trim(),
              timestamp: _timestamp.trim(),
              nonce: _nonce.trim(),
              realm: _realm.trim(),
              credentialsFilePath: credentialsFilePath,
            ),
          ),
    );
  }
}
