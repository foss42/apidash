import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/oauth_config_model.dart';
import 'package:apidash/providers/oauth_config_provider.dart';
import 'package:apidash/providers/oauth_credentials_provider.dart';

class OAuthHeaderWidget extends ConsumerStatefulWidget {
  const OAuthHeaderWidget({super.key});

  @override
  ConsumerState<OAuthHeaderWidget> createState() => _OAuthHeaderWidgetState();
}

class _OAuthHeaderWidgetState extends ConsumerState<OAuthHeaderWidget> {
  OAuthConfig? selectedConfig;
  bool isGeneratingToken = false;
  late final TextEditingController tokenController;
  late final TextEditingController prefixController;

  @override
  void initState() {
    super.initState();
    tokenController = TextEditingController();
    prefixController = TextEditingController(text: 'Bearer');
  }

  @override
  void dispose() {
    tokenController.dispose();
    prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configs = ref.watch(oauthConfigProvider);
    final credentialsState = ref.watch(oauthCredentialsProvider);

    // Update controllers when credentials change
    ref.listen(oauthCredentialsProvider, (previous, next) {
      next.whenData((credentials) {
        tokenController.text = credentials.accessToken ?? '';
        prefixController.text = credentials.tokenType;
      });
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<OAuthConfig>(
          value: selectedConfig,
          decoration: const InputDecoration(
            labelText: 'Available Tokens',
            hintText: 'Select a configuration',
          ),
          items: configs.map((config) {
            return DropdownMenuItem(
              value: config,
              child: Text(config.name),
            );
          }).toList(),
          onChanged: (config) {
            setState(() {
              selectedConfig = config;
            });
          },
        ),
        const SizedBox(height: 16),
        if (selectedConfig != null) ...[
          TextFormField(
            readOnly: true,
            controller: tokenController,
            decoration: const InputDecoration(
              labelText: 'Token',
              hintText: 'No token generated',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: prefixController,
            decoration: const InputDecoration(
              labelText: 'Header Prefix',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isGeneratingToken
                      ? null
                      : () async {
                          setState(() {
                            isGeneratingToken = true;
                          });
                          try {
                            await ref
                                .read(oauthCredentialsProvider.notifier)
                                .acquireCredentials(selectedConfig!);
                          } finally {
                            if (mounted) {
                              setState(() {
                                isGeneratingToken = false;
                              });
                            }
                          }
                        },
                  child: Text(isGeneratingToken
                      ? 'Generating Token...'
                      : 'Get New Access Token'),
                ),
              ),
              if (credentialsState.asData?.value.accessToken != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref
                        .read(oauthCredentialsProvider.notifier)
                        .clearCredentials(selectedConfig!.id);
                  },
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
