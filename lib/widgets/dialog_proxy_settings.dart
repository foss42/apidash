import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/models/models.dart';
import 'package:apidash/providers/settings_providers.dart';

class ProxySettingsDialog extends ConsumerStatefulWidget {
  const ProxySettingsDialog({super.key});

  @override
  ConsumerState<ProxySettingsDialog> createState() =>
      _ProxySettingsDialogState();
}

class _ProxySettingsDialogState extends ConsumerState<ProxySettingsDialog> {
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    final proxy = settings.proxySettings;
    _hostController = TextEditingController(text: proxy?.host ?? '');
    _portController = TextEditingController(text: proxy?.port ?? '');
    _usernameController = TextEditingController(text: proxy?.username ?? '');
    _passwordController = TextEditingController(text: proxy?.password ?? '');
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_hostController.text.isNotEmpty && _portController.text.isNotEmpty) {
      final newProxy = ProxySettings(
        host: _hostController.text,
        port: _portController.text,
        username: _usernameController.text.isEmpty ? null : _usernameController.text,
        password: _passwordController.text.isEmpty ? null : _passwordController.text,
      );
      _updateProxySettings(newProxy);
      Navigator.of(context).pop();
    }
    else{
      _updateProxySettings(null);
    }
  }

  void _updateProxySettings(ProxySettings? newProxy) {
    ref.read(settingsProvider.notifier).update(proxySettings: newProxy);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Proxy Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Proxy Host',
                hintText: 'e.g., localhost',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(
                labelText: 'Proxy Port',
                hintText: 'e.g., 8080',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username (Optional)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password (Optional)',
              ),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _saveSettings,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
