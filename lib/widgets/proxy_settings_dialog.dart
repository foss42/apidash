import 'package:apidash_core/apidash_core.dart';
import 'package:better_networking/models/proxy_settings_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    final proxy = settings.networkProxy;
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
    if (_formKey.currentState!.validate()) {
      final newProxy = ProxySettings(
        host: _hostController.text,
        port: _portController.text,
        username:
            _usernameController.text.isEmpty ? null : _usernameController.text,
        password:
            _passwordController.text.isEmpty ? null : _passwordController.text,
      );
      _updateProxySettings(newProxy);
      Navigator.of(context).pop();
    }
  }

  void _clearSettings() {
    _updateProxySettings(const ProxySettings(host: '', port: ''));
    Navigator.of(context).pop();
  } 

  void _updateProxySettings(ProxySettings? newProxy) {
    ref.read(settingsProvider.notifier).update(networkProxy: newProxy);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Proxy Settings'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Proxy Host',
                  hintText: 'e.g., localhost',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter host';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Proxy Port',
                  hintText: 'e.g., 8080',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter port';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Optional',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Optional',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearSettings,
          child: const Text('Clear & Disable'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveSettings,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
