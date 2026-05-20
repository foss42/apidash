import 'ai.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIModelSelectorDialog extends ConsumerStatefulWidget {
  final AIRequestModel? aiRequestModel;
  const AIModelSelectorDialog({super.key, this.aiRequestModel});

  @override
  ConsumerState<AIModelSelectorDialog> createState() =>
      _AIModelSelectorDialogState();
}

class _AIModelSelectorDialogState extends ConsumerState<AIModelSelectorDialog> {
  AvailableModels? availableModels;
  bool isLoading = true;
  ModelAPIProvider? selectedProvider;
  AIRequestModel? newAIRequestModel;

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.aiRequestModel?.modelApiProvider;
    if (selectedProvider != null && widget.aiRequestModel?.model != null) {
      newAIRequestModel = widget.aiRequestModel?.copyWith();
    }
    ModelManager.fetchAvailableModels().then((value) {
      if (mounted) {
        setState(() {
          availableModels = value;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (availableModels == null) {
      return const Center(child: Text("Error loading models"));
    }

    final data = availableModels!;
    final mappedData = data.map;
    final width = MediaQuery.of(context).size.width * 0.8;

    if (context.isMediumWindow) {
      return Container(
        padding: kP20,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final models = await ModelManager.fetchAvailableModels();
                if (mounted) {
                  setState(() {
                    availableModels = models;
                    isLoading = false;
                  });
                }
              },
              child: Text(kLabelUpdateModels),
            ),
            kVSpacer10,
            Row(
              children: [
                Text(kLabelSelectModelProvider),
                kHSpacer20,
                Expanded(
                  child: ADDropdownButton<ModelAPIProvider>(
                    onChanged: (x) {
                      setState(() {
                        selectedProvider = x;
                        newAIRequestModel =
                            mappedData[selectedProvider]?.toAiRequestModel();
                      });
                    },
                    value: selectedProvider,
                    values: data.modelProviders.map(
                      (e) => (e.providerId!, e.providerName),
                    ),
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final models = await ModelManager.fetchAvailableModels();
                      if (mounted) {
                        setState(() {
                          availableModels = models;
                          isLoading = false;
                        });
                      }
                    },
                    child: Text(kLabelUpdateModels),
                  ),
                  SizedBox(height: 20),
                  ...data.modelProviders.map(
                    (x) => ListTile(
                      title: Text(x.providerName ?? ""),
                      trailing: selectedProvider != x.providerId
                          ? null
                          : const CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ),
                      onTap: () {
                        setState(() {
                          selectedProvider = x.providerId;
                          newAIRequestModel =
                              mappedData[selectedProvider]?.toAiRequestModel();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 40),
          Flexible(
            flex: 3,
            child: _buildModelSelector(mappedData[selectedProvider]),
          ),
        ],
      ),
    );
  }

  Widget _buildModelSelector(AIModelProvider? aiModelProvider) {
    if (aiModelProvider == null) {
      return const Center(child: Text(kLabelSelectAIProvider));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          aiModelProvider.providerName ?? "",
          style: const TextStyle(fontSize: 28),
        ),
        const SizedBox(height: 20),
        if (aiModelProvider.providerId != ModelAPIProvider.ollama) ...[
          Text(kLabelApiKeyCredential),
          kVSpacer8,
          BoundedTextField(
            onChanged: (x) {
              setState(() {
                newAIRequestModel = newAIRequestModel?.copyWith(apiKey: x);
              });
            },
            value: newAIRequestModel?.apiKey ?? "",
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
            IconButton(
              onPressed: () async {
                final newModel = await addNewModel(context);
                if (!mounted) return;
                if (newModel != null && availableModels != null) {
                  setState(() {
                    final providerId = selectedProvider;
                    final providers = availableModels!.modelProviders.map((p) {
                      if (p.providerId == providerId) {
                        return p.copyWith(
                            models: [...(p.models ?? []), newModel]);
                      }
                      return p;
                    }).toList();
                    availableModels =
                        availableModels!.copyWith(modelProviders: providers);
                  });
                }
              },
              icon: const Icon(Icons.add),
            )
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
                            const CircleAvatar(
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
    );
  }
}
