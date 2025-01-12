import 'package:apidash/providers/oauth2/oauth_config_provider.dart';
import 'package:apidash/providers/oauth2/oauth_credentials_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/oauth_config_model.dart';

class OAuthHeaderWidget extends ConsumerStatefulWidget {
  const OAuthHeaderWidget({super.key});

  @override
  ConsumerState<OAuthHeaderWidget> createState() => _OAuthHeaderWidgetState();
}

class _OAuthHeaderWidgetState extends ConsumerState<OAuthHeaderWidget> {
  OAuthConfig? _selectedConfig;
  bool _isGeneratingToken = false;
  final _tokenController = TextEditingController();
  final _prefixController = TextEditingController(text: 'Bearer');

  @override
  void dispose() {
    _tokenController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configs = ref.watch(oauthConfigProvider);
    final credentialsState = ref.watch(oauthCredentialsProvider);

    ref.listen(oauthCredentialsProvider, (_, next) {
      next.whenData((credentials) {
        _tokenController.text = credentials.accessToken ?? '';
        _prefixController.text = credentials.tokenType;
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<OAuthConfig>(
          value: _selectedConfig,
          decoration: const InputDecoration(
            labelText: 'Available Tokens',
            hintText: 'Select a configuration',
          ),
          items: configs.map((config) => 
            DropdownMenuItem(
              value: config,
              child: Text(config.name),
            )
          ).toList(),
          onChanged: (config) => setState(() => _selectedConfig = config),
        ),
        const SizedBox(height: 16),
        if (_selectedConfig != null) ...[
          TextFormField(
            readOnly: true,
            controller: _tokenController,
            decoration: const InputDecoration(
              labelText: 'Token',
              hintText: 'No token generated',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: _prefixController,
            decoration: const InputDecoration(
              labelText: 'Header Prefix',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isGeneratingToken ? null : () async {
                    setState(() => _isGeneratingToken = true);
                    try {
                      await ref
                        .read(oauthCredentialsProvider.notifier)
                        .acquireCredentials(_selectedConfig!);
                    } finally {
                      if (mounted) setState(() => _isGeneratingToken = false);
                    }
                  },
                  child: Text(_isGeneratingToken
                    ? 'Generating Token...'
                    : 'Get New Access Token'),
                ),
              ),
              if (credentialsState.asData?.value.accessToken != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => ref
                    .read(oauthCredentialsProvider.notifier)
                    .clearCredentials(_selectedConfig!.id),
                  tooltip: 'Clear Token',
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}