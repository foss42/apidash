// import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
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

  @override
  void initState() {
    super.initState();
    selectedProvider = widget.aiRequestModel?.modelApiProvider;
    if (selectedProvider != null && widget.aiRequestModel?.model != null) {
      newAIRequestModel = widget.aiRequestModel?.copyWith();
    }
    aM = ModelManager.fetchAvailableModels();
  }

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    // ref.watch(aiApiCredentialProvider);
    final width = MediaQuery.of(context).size.width * 0.8*ds.scaleFactor;
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
              width: width*ds.scaleFactor,
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
                  kVSpacer10(ds.scaleFactor),
                  Row(
                    children: [
                      Text('Select Model Provider'),
                      kHSpacer20(ds.scaleFactor),
                      Expanded(
                        child: ADDropdownButton<ModelAPIProvider>(
                          onChanged: (x) {
                            setState(() {
                              selectedProvider = x;
                              newAIRequestModel = mappedData[selectedProvider]
                                  ?.toAiRequestModel();
                            });
                          },
                          value: selectedProvider,
                          values: data.modelProviders
                              .map((e) => (e.providerId!, e.providerName)),
                        ),
                      ),
                    ],
                  ),
                  kVSpacer10(ds.scaleFactor),
                  _buildModelSelector(mappedData[selectedProvider]),
                ],
              ),
            );
          }

          return Container(
            padding: kP20,
            width: width*ds.scaleFactor,
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
                        SizedBox(height: 20*ds.scaleFactor),
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
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 40*ds.scaleFactor),
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
    final ds = DesignSystemProvider.of(context);
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
          style: TextStyle(fontSize: 28*ds.scaleFactor),
        ),
        SizedBox(height: 20*ds.scaleFactor),
        if (aiModelProvider.providerId != ModelAPIProvider.ollama) ...[
          Text('API Key / Credential'),
          kVSpacer8(ds.scaleFactor),
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
          kVSpacer10(ds.scaleFactor),
        ],
        Text('Endpoint'),
        kVSpacer8(ds.scaleFactor),
        BoundedTextField(
          key: ValueKey(aiModelProvider.providerName ?? ""),
          onChanged: (x) {
            setState(() {
              newAIRequestModel = newAIRequestModel?.copyWith(url: x);
            });
          },
          value: newAIRequestModel?.url ?? "",
        ),
        kVSpacer20(ds.scaleFactor),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Models'),
            // IconButton(
            //     onPressed: () => addNewModel(context), icon: Icon(Icons.add))
          ],
        ),
        kVSpacer8(ds.scaleFactor),
        Container(
          height: 300*ds.scaleFactor,
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
        kVSpacer10(ds.scaleFactor),
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
