import 'dart:async';

import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/ai_provider_utils.dart';

Future<void> showAiLlmSettingsDialog(
  BuildContext context, {
  bool openOnAdd = false,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    barrierDismissible: true,
    builder: (context) => AiLlmSettingsDialog(openOnAdd: openOnAdd),
  );
}

enum _View { list, form }

enum _FormTab { basic, advanced }

class AiLlmSettingsDialog extends ConsumerStatefulWidget {
  final bool openOnAdd;

  const AiLlmSettingsDialog({super.key, this.openOnAdd = false});

  @override
  ConsumerState<AiLlmSettingsDialog> createState() =>
      _AiLlmSettingsDialogState();
}

class _AiLlmSettingsDialogState extends ConsumerState<AiLlmSettingsDialog> {
  late _View _view;
  _FormTab _formTab = _FormTab.basic;
  ConfiguredLLM? _editing;
  bool _obscureKey = true;

  ModelAPIProvider _builtin = ModelAPIProvider.openai;
  String? _selectedCatalogModelId;
  List<Model> _basicModels = const [];
  bool _modelsLoading = false;
  Timer? _modelsDebounce;
  int _modelsFetchGen = 0;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _urlController;
  late final TextEditingController _modelIdController;

  @override
  void initState() {
    super.initState();
    _view = widget.openOnAdd ? _View.form : _View.list;
    _apiKeyController = TextEditingController();
    _urlController = TextEditingController();
    _modelIdController = TextEditingController();
    _basicModels = ModelManager.knownModelsFor(_builtin);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final configured =
          listConfiguredLLMs(ref.read(settingsProvider).aiProviders);
      if (widget.openOnAdd || configured.isEmpty) {
        setState(() => _view = _View.form);
        _scheduleLiveModelFetch();
      }
    });
  }

  @override
  void dispose() {
    _modelsDebounce?.cancel();
    _apiKeyController.dispose();
    _urlController.dispose();
    _modelIdController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _editing = null;
    _formTab = _FormTab.basic;
    _builtin = ModelAPIProvider.openai;
    _selectedCatalogModelId = null;
    _obscureKey = true;
    _apiKeyController.clear();
    _urlController.clear();
    _modelIdController.clear();
    _basicModels = ModelManager.knownModelsFor(_builtin);
    _modelsLoading = false;
  }

  void _openAdd() {
    _resetForm();
    setState(() => _view = _View.form);
    _scheduleLiveModelFetch();
  }

  void _openEdit(ConfiguredLLM llm) {
    _editing = llm;
    _obscureKey = true;
    if (llm.isCustom) {
      _formTab = _FormTab.advanced;
      _apiKeyController.text = llm.apiKey ?? '';
      _urlController.text = llm.url ?? '';
      _modelIdController.text =
          llm.lastModel ?? (llm.models.isNotEmpty ? llm.models.first : '');
      _selectedCatalogModelId = null;
    } else {
      _formTab = _FormTab.basic;
      _builtin = llm.compat;
      _apiKeyController.text = llm.apiKey ?? '';
      _urlController.text = llm.url ?? '';
      if (llm.compat == ModelAPIProvider.ollama &&
          _urlController.text.trim().isEmpty) {
        _urlController.text = kOllamaUrl;
      }
      final model = llm.lastModel ?? '';
      _modelIdController.text = model;
      _selectedCatalogModelId = model.isEmpty ? null : model;
      _basicModels = ModelManager.knownModelsFor(_builtin);
    }
    setState(() => _view = _View.form);
    if (!llm.isCustom) _scheduleLiveModelFetch();
  }

  void _onBuiltinProviderChanged(ModelAPIProvider provider) {
    setState(() {
      _builtin = provider;
      _selectedCatalogModelId = null;
      _modelIdController.clear();
      _apiKeyController.clear();
      _basicModels = ModelManager.knownModelsFor(provider);
      if (provider == ModelAPIProvider.ollama) {
        _urlController.text = kOllamaUrl;
      } else {
        _urlController.clear();
      }
    });
    _refreshLiveModels();
  }

  void _scheduleLiveModelFetch() {
    _modelsDebounce?.cancel();
    _modelsDebounce = Timer(const Duration(milliseconds: 450), () {
      _refreshLiveModels();
    });
  }

  String? _endpointForFetch(ModelAPIProvider provider) {
    final raw = _urlController.text.trim();
    return switch (provider) {
      ModelAPIProvider.ollama || ModelAPIProvider.azureopenai =>
        raw.isEmpty ? null : raw,
      // Cloud Basic form has no URL field — never reuse a leftover Ollama URL.
      _ => null,
    };
  }

  Future<void> _refreshLiveModels() async {
    if (!mounted || _formTab != _FormTab.basic) return;
    final provider = _builtin;
    final key = _apiKeyController.text.trim();
    final url = _endpointForFetch(provider);

    if (providerRequiresApiKey(provider) && key.isEmpty) {
      setState(() {
        _basicModels = ModelManager.knownModelsFor(provider);
        _modelsLoading = false;
      });
      return;
    }

    final gen = ++_modelsFetchGen;
    setState(() => _modelsLoading = true);
    final live = await ModelManager.fetchProviderModels(
      provider: provider,
      apiKey: key,
      url: url,
    );
    if (!mounted || gen != _modelsFetchGen) return;

    final known = ModelManager.knownModelsFor(provider);
    setState(() {
      _modelsLoading = false;
      if (live == null) {
        _basicModels = known;
        return;
      }
      _basicModels = live.isNotEmpty ? live : known;
      if (_selectedCatalogModelId != null &&
          !_basicModels.any((m) => m.id == _selectedCatalogModelId)) {
        _basicModels = [
          Model(id: _selectedCatalogModelId, name: _selectedCatalogModelId),
          ..._basicModels,
        ];
      } else if (_selectedCatalogModelId == null && _basicModels.isNotEmpty) {
        final first = _basicModels.first.id;
        if (first != null && first.isNotEmpty) {
          _selectedCatalogModelId = first;
          _modelIdController.text = first;
        }
      }
    });
  }

  String? _effectiveBasicModel() {
    if (_selectedCatalogModelId != null &&
        _basicModels.any((m) => m.id == _selectedCatalogModelId)) {
      return _selectedCatalogModelId;
    }
    final typed = _modelIdController.text.trim();
    if (typed.isNotEmpty) return typed;
    if (_basicModels.isNotEmpty) return _basicModels.first.id;
    return null;
  }

  bool get _canSave {
    if (_formTab == _FormTab.advanced) {
      return _apiKeyController.text.trim().isNotEmpty &&
          _urlController.text.trim().isNotEmpty &&
          _modelIdController.text.trim().isNotEmpty;
    }
    if (providerRequiresApiKey(_builtin) &&
        _apiKeyController.text.trim().isEmpty) {
      return false;
    }
    final model = _effectiveBasicModel();
    return model != null && model.isNotEmpty;
  }

  Future<void> _persistProviders(
    Map<String, Map<String, Object?>> providers, {
    ConfiguredLLM? makeDefault,
  }) async {
    final settings = ref.read(settingsProvider);
    final configured = listConfiguredLLMs(providers);
    Map<String, Object?>? defaultAIModel = settings.defaultAIModel;

    if (makeDefault != null) {
      defaultAIModel = resolveAIRequestFromLLM(makeDefault)
          .copyWith(
            stream: null,
            systemPrompt: '',
            userPrompt: '',
          )
          .toJson();
    } else if ((defaultAIModel == null || defaultAIModel.isEmpty) &&
        configured.isNotEmpty) {
      defaultAIModel = resolveAIRequestFromLLM(configured.first)
          .copyWith(
            stream: null,
            systemPrompt: '',
            userPrompt: '',
          )
          .toJson();
    } else if (defaultAIModel != null && defaultAIModel.isNotEmpty) {
      final active = safeAIRequestModelFromJson(defaultAIModel);
      defaultAIModel = applyProviderCredentials(active, providers)
          .copyWith(
            stream: null,
            systemPrompt: '',
            userPrompt: '',
          )
          .toJson();
    }

    await ref.read(settingsProvider.notifier).update(
          aiProviders: providers,
          defaultAIModel: defaultAIModel,
        );
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final settings = ref.read(settingsProvider);
    var providers =
        Map<String, Map<String, Object?>>.from(settings.aiProviders ?? {});

    if (_formTab == _FormTab.advanced) {
      final modelId = _modelIdController.text.trim();
      providers = upsertCustomProvider(
        providers,
        id: _editing?.isCustom == true ? _editing!.id : null,
        apiKey: _apiKeyController.text,
        url: _urlController.text,
        models: [modelId],
        lastModel: modelId,
      );
    } else {
      final modelId = _effectiveBasicModel();
      providers = upsertBuiltinProvider(
        providers,
        _builtin,
        apiKey: _apiKeyController.text,
        url: _urlController.text,
        lastModel: modelId,
      );
    }

    await _persistProviders(providers);
    if (!mounted) return;
    _resetForm();
    setState(() => _view = _View.list);
  }

  Future<void> _setAsDefault(ConfiguredLLM llm) async {
    final settings = ref.read(settingsProvider);
    await _persistProviders(
      Map<String, Map<String, Object?>>.from(settings.aiProviders ?? {}),
      makeDefault: llm,
    );
  }

  Future<void> _remove(ConfiguredLLM llm) async {
    final settings = ref.read(settingsProvider);
    final providers = removeProviderCredential(settings.aiProviders, llm.id);
    final remaining = listConfiguredLLMs(providers);
    await ref.read(settingsProvider.notifier).update(
          aiProviders: providers,
          defaultAIModel: remaining.isEmpty
              ? <String, Object?>{}
              : resolveAIRequestFromLLM(remaining.first)
                  .copyWith(
                    stream: null,
                    systemPrompt: '',
                    userPrompt: '',
                  )
                  .toJson(),
        );
  }

  bool _isDefault(ConfiguredLLM llm, AIRequestModel? active) {
    if (active == null || active.modelApiProvider == null) return false;
    if (llm.isCustom) {
      return active.model == llm.lastModel ||
          (active.url == llm.url && active.model == llm.displayName);
    }
    return active.modelApiProvider == llm.compat &&
        (active.model == null ||
            active.model == llm.lastModel ||
            llm.lastModel == null);
  }

  InputDecoration _fieldDecoration(ColorScheme cs) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: cs.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: TextStyle(
        color: cs.onSurfaceVariant.withValues(alpha: 0.55),
      ),
      border: OutlineInputBorder(
        borderRadius: kBorderRadius8,
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kBorderRadius8,
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kBorderRadius8,
        borderSide: BorderSide(color: cs.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final configured = listConfiguredLLMs(settings.aiProviders);
    final active = safeAIRequestModelFromJson(settings.defaultAIModel);
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final width = (size.width * 0.92).clamp(360.0, 720.0);
    final maxHeight = size.height * 0.88;

    return Dialog(
      backgroundColor: colorScheme.surface,
      elevation: 12,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: kBorderRadius12,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, maxHeight: maxHeight),
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
            child: _view == _View.list
                ? _buildList(configured, active, colorScheme)
                : _buildForm(colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    List<ConfiguredLLM> configured,
    AIRequestModel active,
    ColorScheme cs,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          kLabelLlmSettings,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          kLabelConfigureLLMsSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Text(
                kLabelAvailableProfiles,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            OutlinedButton(
              onPressed: _openAdd,
              child: const Text(kLabelAddLlmProfile),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (configured.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              kLabelNoLLMsConfigured,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: kBorderRadius8,
                border: Border.all(color: cs.outlineVariant),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: configured.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, thickness: 1, color: cs.outlineVariant),
                itemBuilder: (context, index) {
                  final llm = configured[index];
                  final isDefault = _isDefault(llm, active);
                  return _ProfileRow(
                    modelId: llm.displayName,
                    providerLabel: llm.isCustom
                        ? kLabelCustom
                        : providerDisplayName(llm.compat),
                    isDefault: isDefault,
                    onEdit: () => _openEdit(llm),
                    onSetDefault: isDefault ? null : () => _setAsDefault(llm),
                    onRemove: () => _remove(llm),
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(kLabelClose),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UnderlineTabs(
          tabs: const [kLabelBasic, kLabelCustom],
          selectedIndex: _formTab == _FormTab.basic ? 0 : 1,
          onChanged: (i) {
            if (_editing != null) return;
            setState(() {
              _formTab = i == 0 ? _FormTab.basic : _FormTab.advanced;
              _apiKeyController.clear();
              _urlController.clear();
              _modelIdController.clear();
              _selectedCatalogModelId = null;
              if (i == 0) {
                _basicModels = ModelManager.knownModelsFor(_builtin);
              }
            });
            if (i == 0) _scheduleLiveModelFetch();
          },
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 420),
          child: SingleChildScrollView(
            child: _formTab == _FormTab.basic
                ? _buildBasicFields(cs)
                : _buildAdvancedFields(cs),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {
                final hasList = listConfiguredLLMs(
                  ref.read(settingsProvider).aiProviders,
                ).isNotEmpty;
                if (hasList || _editing != null) {
                  setState(() {
                    _resetForm();
                    _view = _View.list;
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(kLabelCancel),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _canSave ? _save : null,
              child: Text(kLabelSave, style: kTextStyleButton),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicFields(ColorScheme cs) {
    final models = _basicModels;
    final value = models.isEmpty ? null : _effectiveBasicModel();
    final valueInList =
        value != null && models.any((m) => m.id == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _labeled(
          kLabelProviderType,
          DropdownButtonFormField<ModelAPIProvider>(
            key: ValueKey('provider-$_builtin'),
            initialValue: _builtin,
            isExpanded: true,
            decoration: _fieldDecoration(cs),
            items: ModelAPIProvider.values
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(providerDisplayName(p)),
                  ),
                )
                .toList(),
            onChanged: _editing != null
                ? null
                : (v) {
                    if (v == null) return;
                    _onBuiltinProviderChanged(v);
                  },
          ),
        ),
        if (_builtin == ModelAPIProvider.ollama) ...[
          const SizedBox(height: 20),
          _labeled(
            kLabelBaseUrl,
            TextField(
              controller: _urlController,
              decoration: _fieldDecoration(cs).copyWith(hintText: kOllamaUrl),
              onChanged: (_) {
                setState(() {});
                _scheduleLiveModelFetch();
              },
            ),
          ),
        ],
        if (providerRequiresApiKey(_builtin)) ...[
          const SizedBox(height: 20),
          _labeled(
            kLabelApiKeyField,
            TextField(
              controller: _apiKeyController,
              obscureText: _obscureKey,
              onChanged: (_) {
                setState(() {});
                _scheduleLiveModelFetch();
              },
              decoration: _fieldDecoration(cs).copyWith(
                suffixIcon: IconButton(
                  tooltip: _obscureKey ? 'Show' : 'Hide',
                  icon: Icon(
                    _obscureKey
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscureKey = !_obscureKey),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        _labeled(
          kLabelModel,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_modelsLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  '${_builtin.name}-$valueInList-${models.length}-$_modelsLoading',
                ),
                initialValue: valueInList,
                isExpanded: true,
                decoration: _fieldDecoration(cs),
                items: models
                    .where((m) => m.id != null && m.id!.isNotEmpty)
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(
                          m.name ?? m.id!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: models.isEmpty
                    ? null
                    : (v) {
                        if (v == null) return;
                        setState(() {
                          _selectedCatalogModelId = v;
                          _modelIdController.text = v;
                        });
                      },
              ),
              if (_builtin == ModelAPIProvider.ollama && models.isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  kHintOllamaRunningModels,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFields(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          kLabelCustomOpenAIHint,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        _labeled(
          kLabelModel,
          TextField(
            controller: _modelIdController,
            decoration: _fieldDecoration(cs).copyWith(hintText: kHintModelIds),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 20),
        _labeled(
          kLabelBaseUrl,
          TextField(
            controller: _urlController,
            decoration:
                _fieldDecoration(cs),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 20),
        _labeled(
          kLabelApiKeyField,
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureKey,
            onChanged: (_) => setState(() {}),
            decoration: _fieldDecoration(cs).copyWith(
              suffixIcon: IconButton(
                tooltip: _obscureKey ? 'Show' : 'Hide',
                icon: Icon(
                  _obscureKey
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscureKey = !_obscureKey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _UnderlineTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: 24),
          InkWell(
            onTap: () => onChanged(i),
            borderRadius: kBorderRadius6,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tabs[i],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: selectedIndex == i
                              ? cs.onSurface
                              : cs.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 48,
                    color: selectedIndex == i ? cs.onSurface : Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String modelId;
  final String providerLabel;
  final bool isDefault;
  final VoidCallback onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback onRemove;

  const _ProfileRow({
    required this.modelId,
    required this.providerLabel,
    required this.isDefault,
    required this.onEdit,
    required this.onSetDefault,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      modelId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      providerLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: kBorderRadius6,
                      ),
                      child: Text(
                        kLabelDefaultBadge,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Actions',
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, size: 20, color: cs.onSurfaceVariant),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                  case 'default':
                    onSetDefault?.call();
                  case 'remove':
                    onRemove();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text(kLabelEdit)),
                if (onSetDefault != null)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text(kLabelSetAsDefault),
                  ),
                const PopupMenuItem(value: 'remove', child: Text(kLabelRemove)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings row that opens [showAiLlmSettingsDialog].
class AIProvidersSettingsSection extends ConsumerStatefulWidget {
  const AIProvidersSettingsSection({super.key});

  @override
  ConsumerState<AIProvidersSettingsSection> createState() =>
      _AIProvidersSettingsSectionState();
}

class _AIProvidersSettingsSectionState
    extends ConsumerState<AIProvidersSettingsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeOpenHub(openOnAdd: true);
    });
  }

  void _maybeOpenHub({bool openOnAdd = false}) {
    if (!mounted) return;
    if (!ref.read(openAiLlmSetupProvider)) return;
    ref.read(openAiLlmSetupProvider.notifier).state = false;
    showAiLlmSettingsDialog(context, openOnAdd: openOnAdd);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(openAiLlmSetupProvider, (prev, next) {
      if (next == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _maybeOpenHub(openOnAdd: true);
        });
      }
    });

    final count =
        listConfiguredLLMs(ref.watch(settingsProvider).aiProviders).length;

    return ListTile(
      hoverColor: kColorTransparent,
      title: const Text(kLabelLlmSettings),
      subtitle: Text(
        count == 0 ? kLabelConfigureLLMsSubtitle : '$count configured',
      ),
      trailing: FilledButton.icon(
        onPressed: () => showAiLlmSettingsDialog(context),
        label: const Text(kLabelManageLlms),
        icon: const Icon(Icons.tune_rounded, size: 20),
      ),
    );
  }
}
