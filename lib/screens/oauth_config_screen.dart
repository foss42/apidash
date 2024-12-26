import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/oauth_config_model.dart';
import 'package:apidash/providers/oauth_config_provider.dart';

class OAuthConfigScreen extends ConsumerStatefulWidget {
  final OAuthConfig? config;
  final bool isEditing;

  const OAuthConfigScreen({super.key, this.config, this.isEditing = false});

  @override
  ConsumerState<OAuthConfigScreen> createState() => _OAuthConfigScreenState();
}

class _OAuthConfigScreenState extends ConsumerState<OAuthConfigScreen> {
  late OAuthConfig editingConfig;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editingConfig = widget.config ?? OAuthConfig.empty();
  }

  Future<void> _saveConfig() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await ref.read(oauthConfigProvider.notifier).saveConfig(editingConfig);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit OAuth Configuration' : 'New OAuth Configuration'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: editingConfig.name,
                decoration: const InputDecoration(
                  labelText: 'Configuration Name',
                  hintText: 'Enter a name for this configuration',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(name: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.clientId,
                decoration: const InputDecoration(
                  labelText: 'Client ID',
                  hintText: 'Enter your OAuth client ID',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter client ID' : null,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(clientId: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.clientSecret,
                decoration: const InputDecoration(
                  labelText: 'Client Secret',
                  hintText: 'Enter your OAuth client secret',
                ),
                obscureText: true,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(clientSecret: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.authUrl,
                decoration: const InputDecoration(
                  labelText: 'Auth URL',
                  hintText: 'https://example.com/login/oauth/authorize',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter auth URL' : null,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(authUrl: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.tokenEndpoint,
                decoration: const InputDecoration(
                  labelText: 'Access Token URL',
                  hintText: 'https://example.com/login/oauth/access_token',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter token endpoint' : null,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(tokenEndpoint: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.callbackUrl,
                decoration: const InputDecoration(
                  labelText: 'Callback URL',
                  hintText: 'http://your-application.com/callback',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter callback URL' : null,
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(callbackUrl: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.scope,
                decoration: const InputDecoration(
                  labelText: 'Scope',
                  hintText: 'e.g. read:org',
                ),
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(scope: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: editingConfig.state,
                decoration: const InputDecoration(
                  labelText: 'State',
                  hintText: 'Optional state parameter',
                ),
                onSaved: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(state: value ?? '');
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Auto-refresh Token'),
                subtitle: const Text('Your expired token will be auto-refreshed before sending a request'),
                value: editingConfig.autoRefresh,
                onChanged: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(autoRefresh: value);
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Share Token'),
                subtitle: const Text('This will allow anyone with access to this request to view and use it'),
                value: editingConfig.shareToken,
                onChanged: (value) {
                  setState(() {
                    editingConfig = editingConfig.copyWith(shareToken: value);
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveConfig,
                  child: const Text('Save Configuration'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}