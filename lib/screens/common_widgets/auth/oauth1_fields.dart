import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late TextEditingController _consumerKeyController;
  late TextEditingController _consumerSecretController;
  late TextEditingController _accessTokenController;
  late TextEditingController _tokenSecretController;
  late TextEditingController _callbackUrlController;
  late TextEditingController _verifierController;
  late TextEditingController _timestampController;
  late TextEditingController _realmController;
  late TextEditingController _nonceController;
  late OAuth1SignatureMethod _signatureMethodController;
  late String _addAuthDataTo;

  @override
  void initState() {
    super.initState();
    final oauth1 = widget.authData?.oauth1;
    _consumerKeyController =
        TextEditingController(text: oauth1?.consumerKey ?? '');
    _consumerSecretController =
        TextEditingController(text: oauth1?.consumerSecret ?? '');
    _accessTokenController =
        TextEditingController(text: oauth1?.accessToken ?? '');
    _tokenSecretController =
        TextEditingController(text: oauth1?.tokenSecret ?? '');
    _callbackUrlController =
        TextEditingController(text: oauth1?.callbackUrl ?? '');
    _verifierController = TextEditingController(text: oauth1?.verifier ?? '');
    _timestampController = TextEditingController(text: oauth1?.timestamp ?? '');
    _realmController = TextEditingController(text: oauth1?.realm ?? '');
    _nonceController = TextEditingController(text: oauth1?.nonce ?? '');
    _signatureMethodController =
        oauth1?.signatureMethod ?? OAuth1SignatureMethod.hmacSha1;
    _addAuthDataTo = oauth1?.parameterLocation ?? 'url';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _consumerKeyController,
          hintText: kHintOAuth1ConsumerKey,
          infoText: kInfoOAuth1ConsumerKey,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _consumerSecretController,
          hintText: kHintOAuth1ConsumerSecret,
          infoText: kInfoOAuth1ConsumerSecret,
          isObscureText: true,
          onChanged: (_) => _updateOAuth1(),
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
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _accessTokenController,
          hintText: kHintOAuth1AccessToken,
          infoText: kInfoOAuth1AccessToken,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _tokenSecretController,
          hintText: kHintOAuth1TokenSecret,
          infoText: kInfoOAuth1TokenSecret,
          isObscureText: true,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _callbackUrlController,
          hintText: kHintOAuth1CallbackUrl,
          infoText: kInfoOAuth1CallbackUrl,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _verifierController,
          hintText: kHintOAuth1Verifier,
          infoText: kInfoOAuth1Verifier,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _timestampController,
          hintText: kHintOAuth1Timestamp,
          infoText: kInfoOAuth1Timestamp,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _nonceController,
          hintText: kHintOAuth1Nonce,
          infoText: kInfoOAuth1Nonce,
          onChanged: (_) => _updateOAuth1(),
        ),
        const SizedBox(height: 16),
        AuthTextField(
          readOnly: widget.readOnly,
          controller: _realmController,
          hintText: kHintOAuth1Realm,
          infoText: kInfoOAuth1Realm,
          onChanged: (_) => _updateOAuth1(),
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
              consumerKey: _consumerKeyController.text.trim(),
              consumerSecret: _consumerSecretController.text.trim(),
              accessToken: _accessTokenController.text.trim(),
              tokenSecret: _tokenSecretController.text.trim(),
              signatureMethod: _signatureMethodController,
              parameterLocation: _addAuthDataTo,
              callbackUrl: _callbackUrlController.text.trim(),
              verifier: _verifierController.text.trim(),
              timestamp: _timestampController.text.trim(),
              nonce: _nonceController.text.trim(),
              realm: _realmController.text.trim(),
              credentialsFilePath: credentialsFilePath,
            ),
          ) ??
          AuthModel(
            type: APIAuthType.oauth1,
            oauth1: AuthOAuth1Model(
              consumerKey: _consumerKeyController.text.trim(),
              consumerSecret: _consumerSecretController.text.trim(),
              accessToken: _accessTokenController.text.trim(),
              tokenSecret: _tokenSecretController.text.trim(),
              signatureMethod: _signatureMethodController,
              parameterLocation: _addAuthDataTo,
              callbackUrl: _callbackUrlController.text.trim(),
              verifier: _verifierController.text.trim(),
              timestamp: _timestampController.text.trim(),
              nonce: _nonceController.text.trim(),
              realm: _realmController.text.trim(),
              credentialsFilePath: credentialsFilePath,
            ),
          ),
    );
  }
}
