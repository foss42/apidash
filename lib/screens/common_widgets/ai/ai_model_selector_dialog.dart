import 'dart:math' as math;

// import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool useCompactAiModelSelectorDialogLayout(Size screenSize) {
  return screenSize.width < 600 || screenSize.height < 700;
}

class AIModelSelectorDialog extends ConsumerStatefulWidget {
  final AIRequestModel? aiRequestModel;
  final Future<AvailableModels>? availableModelsFuture;

  const AIModelSelectorDialog({
    super.key,
    this.aiRequestModel,
    this.availableModelsFuture,
  });

  @override
  ConsumerState<AIModelSelectorDialog> createState() =>
      _AIModelSelectorDialogState();
}

class _AIModelSelectorDialogState extends ConsumerState<AIModelSelectorDialog> {
  late final Future<AvailableModels> aM;
  final ScrollController _compactScrollController = ScrollController();
  ModelAPIProvider? selectedProvider;
  AIRequestModel? newAIRequestModel;
  String? _lastCompactLayoutSignature;

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.aiRequestModel?.modelApiProvider;
    if (selectedProvider != null && widget.aiRequestModel?.model != null) {
      newAIRequestModel = widget.aiRequestModel?.copyWith();
    }
    aM = widget.availableModelsFuture ?? ModelManager.fetchAvailableModels();
  }

  @override
  void dispose() {
    _compactScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: aM,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          final data = snapshot.data!;
          final mappedData = data.map;
          final screenSize = MediaQuery.sizeOf(context);
          final isCompactDialog = useCompactAiModelSelectorDialogLayout(
            screenSize,
          );

          if (isCompactDialog) {
            _resetCompactScrollForLayout(screenSize);
            return _buildCompactDialog(data: data, mappedData: mappedData);
          }

          final dialogWidth = math.min(screenSize.width * 0.9, 960.0);
          final dialogHeight = math.min(screenSize.height * 0.85, 720.0);

          return SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Padding(
              padding: kP20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUpdateModelsButton(),
                          const SizedBox(height: 20),
                          ...data.modelProviders.map(
                            (x) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(x.providerName ?? ""),
                              trailing: selectedProvider != x.providerId
                                  ? null
                                  : const CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                              onTap: () =>
                                  _selectProvider(mappedData, x.providerId),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Flexible(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: _buildModelSelector(
                        mappedData[selectedProvider],
                        modelsHeight: 300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void Function(ModelAPIProvider?) _onProviderChanged(
    Map<ModelAPIProvider, AIModelProvider> mappedData,
  ) {
    return (provider) => _selectProvider(mappedData, provider);
  }

  void _selectProvider(
    Map<ModelAPIProvider, AIModelProvider> mappedData,
    ModelAPIProvider? provider,
  ) {
    setState(() {
      selectedProvider = provider;
      newAIRequestModel = mappedData[selectedProvider]?.toAiRequestModel();
    });
    _scheduleCompactScrollReset();
  }

  void _resetCompactScrollForLayout(Size screenSize) {
    final layoutSignature =
        '${screenSize.width.round()}x${screenSize.height.round()}-${selectedProvider?.name ?? 'none'}';
    if (_lastCompactLayoutSignature == layoutSignature) {
      return;
    }
    _lastCompactLayoutSignature = layoutSignature;
    _scheduleCompactScrollReset();
  }

  void _scheduleCompactScrollReset() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_compactScrollController.hasClients) {
        return;
      }
      _compactScrollController.jumpTo(0);
    });
  }

  Widget _buildUpdateModelsButton() {
    return ElevatedButton(
      onPressed: null,
      // TODO: Add update model logic
      //() async {
      // await LLMManager.fetchAvailableLLMs();
      // setState(() {});
      //},
      child: Text(kLabelUpdateModels),
    );
  }

  Widget _buildCompactDialog({
    required AvailableModels data,
    required Map<ModelAPIProvider, AIModelProvider> mappedData,
  }) {
    final selectedModelProvider = mappedData[selectedProvider];
    final screenSize = MediaQuery.sizeOf(context);
    final isShortHeight = screenSize.height < 500;
    final compactTitleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontSize: isShortHeight ? 18 : null);
    final sectionGap = isShortHeight ? 8.0 : 16.0;
    final smallGap = isShortHeight ? 6.0 : 8.0;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, isShortHeight ? 12 : 20, 20, 20),
        child: selectedModelProvider == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          kLabelSelectModel,
                          style: compactTitleStyle,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                      TextButton(onPressed: null, child: Text(kLabelSave)),
                    ],
                  ),
                  SizedBox(height: smallGap),
                  Text(kLabelSelectModelProvider),
                  SizedBox(height: smallGap),
                  ADDropdownButton<ModelAPIProvider>(
                    onChanged: _onProviderChanged(mappedData),
                    value: selectedProvider,
                    values: data.modelProviders.map(
                      (e) => (e.providerId!, e.providerName),
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  Center(child: Text(kLabelSelectAIProvider)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          kLabelSelectModel,
                          style: compactTitleStyle,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(newAIRequestModel);
                        },
                        child: Text(kLabelSave),
                      ),
                    ],
                  ),
                  SizedBox(height: smallGap),
                  Text(kLabelSelectModelProvider),
                  SizedBox(height: smallGap),
                  ADDropdownButton<ModelAPIProvider>(
                    onChanged: _onProviderChanged(mappedData),
                    value: selectedProvider,
                    values: data.modelProviders.map(
                      (e) => (e.providerId!, e.providerName),
                    ),
                  ),
                  SizedBox(height: sectionGap),
                  Expanded(
                    child: _buildCompactModelSelector(selectedModelProvider),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCompactModelSelector(AIModelProvider aiModelProvider) {
    final isShortHeight = MediaQuery.sizeOf(context).height < 500;
    final fieldGap = isShortHeight ? 6.0 : 8.0;
    final sectionGap = isShortHeight ? 10.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShortHeight)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _showCompactAdvancedSettingsSheet(
                aiModelProvider,
                fieldGap: fieldGap,
                sectionGap: sectionGap,
              ),
              icon: const Icon(Icons.tune),
              label: const Text('Advanced settings'),
            ),
          )
        else
          ..._buildCompactAdvancedSettingsFields(
            aiModelProvider,
            fieldGap: fieldGap,
            sectionGap: sectionGap,
          ),
        Text(kLabelModels),
        SizedBox(height: fieldGap),
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(27, 0, 0, 0),
            ),
            child: ListView(
              key: ValueKey(_lastCompactLayoutSignature),
              controller: _compactScrollController,
              padding: EdgeInsets.zero,
              children: [
                ...(aiModelProvider.models ?? []).map(
                  (x) => ListTile(
                    dense: true,
                    title: Text(x.name ?? ""),
                    trailing: newAIRequestModel?.model == x.id
                        ? const CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.green,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        newAIRequestModel = newAIRequestModel?.copyWith(
                          model: x.id,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCompactAdvancedSettingsSheet(
    AIModelProvider aiModelProvider, {
    required double fieldGap,
    required double sectionGap,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomInset + 20),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Advanced settings',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ..._buildCompactAdvancedSettingsFields(
                  aiModelProvider,
                  fieldGap: fieldGap,
                  sectionGap: sectionGap,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCompactAdvancedSettingsFields(
    AIModelProvider aiModelProvider, {
    required double fieldGap,
    required double sectionGap,
  }) {
    final widgets = <Widget>[];

    if (aiModelProvider.providerId != ModelAPIProvider.ollama) {
      widgets.addAll([
        Text(kLabelApiKeyCredential),
        SizedBox(height: fieldGap),
        BoundedTextField(
          onChanged: (x) {
            setState(() {
              newAIRequestModel = newAIRequestModel?.copyWith(apiKey: x);
            });
          },
          value: newAIRequestModel?.apiKey ?? "",
        ),
        SizedBox(height: sectionGap),
      ]);
    }

    widgets.addAll([
      Text(kLabelEndpoint),
      SizedBox(height: fieldGap),
      BoundedTextField(
        key: ValueKey(aiModelProvider.providerName ?? ""),
        onChanged: (x) {
          setState(() {
            newAIRequestModel = newAIRequestModel?.copyWith(url: x);
          });
        },
        value: newAIRequestModel?.url ?? "",
      ),
      SizedBox(height: sectionGap),
    ]);

    return widgets;
  }

  Widget _buildModelSelector(
    AIModelProvider? aiModelProvider, {
    required double modelsHeight,
    bool showSaveButton = true,
  }) {
    if (aiModelProvider == null) {
      return Center(child: Text(kLabelSelectAIProvider));
    }
    // final currentCredential =
    //     ref.watch(aiApiCredentialProvider)[aiModelProvider.providerId!] ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          aiModelProvider.providerName ?? "",
          style: TextStyle(fontSize: 28),
        ),
        SizedBox(height: 20),
        if (aiModelProvider.providerId != ModelAPIProvider.ollama) ...[
          Text(kLabelApiKeyCredential),
          kVSpacer8,
          BoundedTextField(
            onChanged: (x) {
              // ref.read(aiApiCredentialProvider.notifier).state = {
              //   ...ref.read(aiApiCredentialProvider),
              //   aiModelProvider.providerId!: x
              // };
              setState(() {
                newAIRequestModel = newAIRequestModel?.copyWith(apiKey: x);
              });
            },
            value: newAIRequestModel?.apiKey ?? "",
            // value: currentCredential,
          ),
          kVSpacer10,
        ],
        Text(kLabelEndpoint),
        kVSpacer8,
        BoundedTextField(
          key: ValueKey(aiModelProvider.providerName ?? ""),
          onChanged: (x) {
            setState(() {
              newAIRequestModel = newAIRequestModel?.copyWith(url: x);
            });
          },
          value: newAIRequestModel?.url ?? "",
        ),
        kVSpacer20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(kLabelModels),
            // IconButton(
            //     onPressed: () => addNewModel(context), icon: Icon(Icons.add))
          ],
        ),
        kVSpacer8,
        Container(
          height: modelsHeight,
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
                          newAIRequestModel = newAIRequestModel?.copyWith(
                            model: x.id,
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showSaveButton) ...[
          kVSpacer10,
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(newAIRequestModel);
              },
              child: Text(kLabelSave),
            ),
          ),
        ],
      ],
    );
  }
}
