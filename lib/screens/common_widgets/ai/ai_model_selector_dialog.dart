// import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
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
  late final Future<AvailableModels> aM;
  ModelAPIProvider? selectedProvider;
  AIRequestModel? newAIRequestModel;
  final Map<ModelAPIProvider, AIRequestModel> _providerDrafts = {};

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.aiRequestModel?.modelApiProvider;
    final initialModel = widget.aiRequestModel;
    if (selectedProvider != null && initialModel != null) {
      final draft = initialModel.copyWith();
      newAIRequestModel = draft;
      _providerDrafts[selectedProvider!] = draft;
    }
    aM = ModelManager.fetchAvailableModels();
  }

  void _selectProvider(
      ModelAPIProvider? provider, Map<ModelAPIProvider, AIModelProvider> data) {
    if (provider == null) {
      return;
    }

    final nextModel =
        _providerDrafts[provider] ?? data[provider]?.toAiRequestModel();

    setState(() {
      selectedProvider = provider;
      if (nextModel != null) {
        newAIRequestModel = nextModel;
        _providerDrafts[provider] = nextModel;
      }
    });
  }

  void _updateCurrentRequestModel(AIRequestModel updated) {
    setState(() {
      newAIRequestModel = updated;
      final provider = updated.modelApiProvider;
      if (provider != null) {
        _providerDrafts[provider] = updated;
      }
    });
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
                            _selectProvider(x, mappedData);
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
                              _selectProvider(x.providerId, mappedData);
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
          Text('API Key / Credential'),
          kVSpacer8,
          BoundedTextField(
            onChanged: (x) {
              final updated = newAIRequestModel?.copyWith(apiKey: x);
              if (updated != null) {
                _updateCurrentRequestModel(updated);
              }
            },
            value: newAIRequestModel?.apiKey ?? "",
            // value: currentCredential,
          ),
          kVSpacer10,
        ],
        Text('Endpoint'),
        kVSpacer8,
        BoundedTextField(
          key: ValueKey(aiModelProvider.providerName ?? ""),
          onChanged: (x) {
            final updated = newAIRequestModel?.copyWith(url: x);
            if (updated != null) {
              _updateCurrentRequestModel(updated);
            }
          },
          value: newAIRequestModel?.url ?? "",
        ),
        kVSpacer20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Models'),
            // IconButton(
            //     onPressed: () => addNewModel(context), icon: Icon(Icons.add))
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
                        final updated =
                            newAIRequestModel?.copyWith(model: x.id);
                        if (updated != null) {
                          _updateCurrentRequestModel(updated);
                        }
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
            child: Text('Save'),
          ),
        ),
      ],
    );
  }
}
