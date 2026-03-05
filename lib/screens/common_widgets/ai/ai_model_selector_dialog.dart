// import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:better_networking/better_networking.dart';

class AIModelSelectorDialog extends ConsumerStatefulWidget {
  final AIRequestModel? aiRequestModel;
  const AIModelSelectorDialog({super.key, this.aiRequestModel});

  @override
  ConsumerState<AIModelSelectorDialog> createState() =>
      _AIModelSelectorDialogState();
}

class _AIModelSelectorDialogState extends ConsumerState<AIModelSelectorDialog> {
  late final Future<AvailableModels> aM;
  ModelAPIProvider? selectedProvider;
  AIRequestModel? newAIRequestModel;
  final _formKey = GlobalKey<FormState>();
  final _apiKeyController = TextEditingController();
  final _endpointController = TextEditingController();
  bool _obscureApiKey = true;
  bool _isTestingConnection = false;

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.aiRequestModel?.modelApiProvider;
    if (selectedProvider != null && widget.aiRequestModel?.model != null) {
      newAIRequestModel = widget.aiRequestModel?.copyWith();
      // Fix API key persistence: populate controllers with existing values
      _apiKeyController.text = widget.aiRequestModel?.apiKey ?? '';
      _endpointController.text = widget.aiRequestModel?.url ?? '';
    }
    aM = ModelManager.fetchAvailableModels();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(aiApiCredentialProvider);
    final width = MediaQuery.of(context).size.width * 0.8;
    return FutureBuilder(
      future: aM,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          final data = snapshot.data!;
          final mappedData = data.map;
          if (context.isMediumWindow) {
            return Container(
              padding: kP20,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: null,
                    // TODO: Add update model logic
                    //() async {
                    // await LLMManager.fetchAvailableLLMs();
                    // setState(() {});
                    //},
                    child: Text('Update Models'),
                  ),
                  kVSpacer10,
                  Row(
                    children: [
                      Text('Select Model Provider'),
                      kHSpacer20,
                      Expanded(
                        child: ADDropdownButton<ModelAPIProvider>(
                          onChanged: (x) {
                            setState(() {
                              selectedProvider = x;
                              newAIRequestModel = mappedData[selectedProvider]
                                  ?.toAiRequestModel();
                              // Auto-fill endpoint URL for known providers
                              _endpointController.text = newAIRequestModel?.url ?? '';
                              // Preserve API key when switching providers
                              if (_apiKeyController.text.isNotEmpty) {
                                newAIRequestModel = newAIRequestModel?.copyWith(
                                  apiKey: _apiKeyController.text,
                                );
                              }
                            });
                          },
                          value: selectedProvider,
                          values: data.modelProviders
                              .map((e) => (e.providerId!, e.providerName)),
                        ),
                      ),
                    ],
                  ),
                  kVSpacer10,
                  _buildModelSelector(mappedData[selectedProvider]),
                ],
              ),
            );
          }

          return Container(
            padding: kP20,
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: null,
                          // TODO: Add update model logic
                          //() async {
                          // await LLMManager.fetchAvailableLLMs();
                          // setState(() {});
                          //},
                          child: Text('Update Models'),
                        ),
                        SizedBox(height: 20),
                        ...data.modelProviders.map(
                          (x) => ListTile(
                            title: Text(x.providerName ?? ""),
                            trailing: selectedProvider != x.providerId
                                ? null
                                : CircleAvatar(
                                    radius: 5,
                                    backgroundColor: Colors.green,
                                  ),
                            onTap: () {
                              setState(() {
                                selectedProvider = x.providerId;
                                newAIRequestModel = mappedData[selectedProvider]
                                    ?.toAiRequestModel();
                                // Auto-fill endpoint URL for known providers
                                _endpointController.text = newAIRequestModel?.url ?? '';
                                // Preserve API key when switching providers
                                if (_apiKeyController.text.isNotEmpty) {
                                  newAIRequestModel = newAIRequestModel?.copyWith(
                                    apiKey: _apiKeyController.text,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40),
                Flexible(
                  flex: 3,
                  child: _buildModelSelector(mappedData[selectedProvider]),
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildModelSelector(AIModelProvider? aiModelProvider) {
    if (aiModelProvider == null) {
      return Center(child: Text("Please select an AI API Provider"));
    }
    
    final requiresApiKey = aiModelProvider.providerId != ModelAPIProvider.ollama;
    
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            aiModelProvider.providerName ?? "",
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 20),
          if (requiresApiKey) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('API Key / Credential'),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _obscureApiKey = !_obscureApiKey;
                    });
                  },
                  icon: Icon(
                    _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                    size: 16,
                  ),
                  label: Text(_obscureApiKey ? 'Show' : 'Hide'),
                ),
              ],
            ),
            kVSpacer8,
            _buildValidatedTextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'API Key is required';
                }
                return null;
              },
              onChanged: (x) {
                setState(() {
                  newAIRequestModel = newAIRequestModel?.copyWith(apiKey: x);
                });
              },
            ),
            kVSpacer10,
          ],
          Text('Endpoint URL'),
          kVSpacer8,
          _buildValidatedTextField(
            controller: _endpointController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Endpoint URL is required';
              }
              if (!value.startsWith('http://') && !value.startsWith('https://')) {
                return 'URL must start with http:// or https://';
              }
              return null;
            },
            onChanged: (x) {
              setState(() {
                newAIRequestModel = newAIRequestModel?.copyWith(url: x);
              });
            },
          ),
          kVSpacer10,
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _isTestingConnection ? null : _testConnection,
              icon: _isTestingConnection
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.wifi_protected_setup, size: 16),
              label: Text('Test Connection'),
            ),
          ),
          kVSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Models'),
            ],
          ),
          kVSpacer8,
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(27, 0, 0, 0),
            ),
            child: Material(
              color: Colors.transparent,
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    ...(aiModelProvider.models ?? []).map(
                      (x) => ListTile(
                        title: Text(x.name ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (newAIRequestModel?.model == x.id)
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.green,
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            newAIRequestModel =
                                newAIRequestModel?.copyWith(model: x.id);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          kVSpacer10,
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _canSave() ? () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(newAIRequestModel);
                }
              } : null,
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required void Function(String) onChanged,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius8,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          errorStyle: TextStyle(fontSize: 11),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  bool _canSave() {
    // Basic check before form validation
    return newAIRequestModel != null;
  }

  Future<void> _testConnection() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isTestingConnection = true;
    });

    try {
      final testRequest = newAIRequestModel?.copyWith(
        userPrompt: 'test',
        model: newAIRequestModel?.model ?? '',
      );

      if (testRequest?.httpRequestModel == null) {
        _showSnackBar('Cannot create test request', isError: true);
        return;
      }

      final (response, _, error) = await sendHttpRequest(
        'TEST_CONNECTION',
        APIType.rest,
        testRequest!.httpRequestModel!,
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () => (null, null, 'Connection timeout'),
      );

      if (mounted) {
        if (response != null && response.statusCode >= 200 && response.statusCode < 300) {
          _showSnackBar('✓ Connection successful', isError: false);
        } else {
          _showSnackBar(
            error ?? 'Connection failed (${response?.statusCode ?? "unknown"})',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Connection error: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
