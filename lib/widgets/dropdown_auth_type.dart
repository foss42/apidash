import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';

class DropdownButtonAuthType extends StatelessWidget {
  final AuthType authType;
  final ValueChanged<AuthType?> onChanged;

  const DropdownButtonAuthType({
    super.key,
    required this.authType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AuthType>(
      value: authType,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
      underline: Container(height: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      borderRadius: BorderRadius.circular(8.0),
      elevation: 4,
      items: const [
        DropdownMenuItem(
          value: AuthType.none,
          child: Text('None'),
        ),
        DropdownMenuItem(
          value: AuthType.basic,
          child: Text('Basic'),
        ),
        DropdownMenuItem(
          value: AuthType.apiKey,
          child: Text('API Key'),
        ),
        DropdownMenuItem(
          value: AuthType.bearer,
          child: Text('Bearer Token'),
        ),
        DropdownMenuItem(
          value: AuthType.jwtBearer,
          child: Text('JWT Bearer'),
        ),
        DropdownMenuItem(
          value: AuthType.digest,
          child: Text('Digest Auth'),
        ),
        DropdownMenuItem(
          value: AuthType.oAuth1,
          child: Text('OAuth1.0'),
        ),
        DropdownMenuItem(
          value: AuthType.oAuth2,
          child: Text('OAuth2.0'),
        ),
      ],
    );
  }
}
