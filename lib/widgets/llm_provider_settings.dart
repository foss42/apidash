import 'dart:developer';

import 'package:apidash/dashbot/features/home/models/llm_provider.dart';
import 'package:apidash/providers/dashbot_llm_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LlmProviderSettings extends ConsumerStatefulWidget {
  const LlmProviderSettings({super.key});

  @override
  LlmProviderSettingsState createState() => LlmProviderSettingsState();
}

class LlmProviderSettingsState extends ConsumerState<LlmProviderSettings> {
  late TextEditingController _remoteModelNameController;
  late TextEditingController _localModelNameController;
  late TextEditingController _baseUrlController;
  late TextEditingController _apiKeyController;
  final _formKey = GlobalKey<FormState>();
  LlmProvider? _currentProvider;

  @override
  void initState() {
    super.initState();
    _currentProvider =
        ref.read(llmProviderNotifierProvider.notifier).getSelectedProvider();
    _initializeControllers();
  }

  void _saveForm() {
    if (_currentProvider == null) return;

    final newProvider = _currentProvider!.type == LlmProviderType.local
        ? _currentProvider!.copyWith(
            localConfig: LocalLlmConfig(
              modelName: _localModelNameController.text,
              baseUrl: _baseUrlController.text,
            ),
          )
        : _currentProvider!.copyWith(
            remoteConfig: RemoteLlmConfig(
              apiKey: _apiKeyController.text,
              modelName: _remoteModelNameController.text,
            ),
          );
    _updateProvider(newProvider);
  }

  void _initializeControllers() {
    _localModelNameController = TextEditingController(
      text: _currentProvider?.localConfig?.modelName ?? '',
    );
    _remoteModelNameController = TextEditingController(
      text: _currentProvider?.remoteConfig?.modelName ?? '',
    );
    _baseUrlController = TextEditingController(
      text: _currentProvider?.localConfig?.baseUrl ?? '',
    );
    _apiKeyController = TextEditingController(
      text: _currentProvider?.remoteConfig?.apiKey ?? '',
    );
  }

  void _updateProvider(LlmProvider newProvider) {
    ref
        .read(llmProviderNotifierProvider.notifier)
        .setSelectedProvider(newProvider);
    setState(() => _currentProvider = newProvider);
  }

  @override
  void dispose() {
    _localModelNameController.dispose();
    _remoteModelNameController.dispose();
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providers = ref.watch(llmProviderNotifierProvider);
    LlmProvider selectedProvider =
        ref.read(llmProviderNotifierProvider.notifier).getSelectedProvider();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          PopupMenuButton<LlmProvider>(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.secondary,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            initialValue: selectedProvider,
            onSelected: (LlmProvider item) {
              log(item.localConfig?.baseUrl ?? "");
              log(item.remoteConfig?.modelName ?? "");
              _updateProvider(item);
            },
            itemBuilder: (BuildContext context) =>
                providers.map((LlmProvider item) {
              return PopupMenuItem<LlmProvider>(
                value: item,
                child: ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(item.logo),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.subtitle),
                  dense: true,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
              );
            }).toList(),
            offset: Offset(0, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(selectedProvider.logo),
              ),
              title: Text(selectedProvider.name),
              subtitle: Text(selectedProvider.subtitle),
              trailing: Icon(Icons.arrow_drop_down),
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (selectedProvider.type == LlmProviderType.local) ...[
                Column(
                  children: [
                    TextFormField(
                      controller: _localModelNameController,
                      decoration: const InputDecoration(
                        labelText: 'Model Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _baseUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Base URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ],
              if (selectedProvider.type == LlmProviderType.remote) ...[
                Column(
                  children: [
                    TextFormField(
                      controller: _apiKeyController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'API Key',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _remoteModelNameController,
                      decoration: const InputDecoration(
                        labelText: 'Model Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                )
              ]
            ],
          ),
          TextButton(
            onPressed: () => _saveForm(),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
