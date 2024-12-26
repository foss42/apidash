import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/oauth_config_model.dart';
import '../models/oauth_credentials_model.dart';
import '../providers/oauth_config_provider.dart';
import '../providers/oauth_credentials_provider.dart';

class OAuthTokenAcquisitionDialog extends ConsumerStatefulWidget {
  final OAuthConfig? initialConfig;

  const OAuthTokenAcquisitionDialog({
    super.key, 
    this.initialConfig,
  });

  @override
  ConsumerState<OAuthTokenAcquisitionDialog> createState() => _OAuthTokenAcquisitionDialogState();
}

class _OAuthTokenAcquisitionDialogState extends ConsumerState<OAuthTokenAcquisitionDialog> {
  OAuthConfig? _selectedConfig;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedConfig = widget.initialConfig;
  }

  Future<void> _acquireToken() async {
    if (_selectedConfig == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credentials = await ref
          .read(oauthCredentialsProvider.notifier)
          .acquireCredentials(_selectedConfig!);
      
      if (mounted) {
        Navigator.of(context).pop(credentials);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final configs = ref.watch(oauthConfigProvider);

    return AlertDialog(
      title: const Text('Acquire OAuth Token'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<OAuthConfig>(
            value: _selectedConfig,
            hint: const Text('Select OAuth Configuration'),
            items: configs
                .map((config) => DropdownMenuItem(
                      value: config,
                      child: Text(config.name ?? config.clientId),
                    ))
                .toList(),
            onChanged: _isLoading 
                ? null 
                : (config) {
                    setState(() {
                      _selectedConfig = config;
                    });
                  },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedConfig == null || _isLoading 
              ? null 
              : _acquireToken,
          child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Acquire Token'),
        ),
      ],
    );
  }
}
