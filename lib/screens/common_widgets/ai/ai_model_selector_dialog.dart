// import 'package:apidash/providers/providers.dart';
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
    // ref.watch(aiApiCredentialProvider);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width * 0.8;
    final maxContentHeight = mediaQuery.size.height * 0.75;
    return FutureBuilder(
      future: aM,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          final data = snapshot.data!;
          final mappedData = data.map;
          if (context.isMediumWindow) {
            return SizedBox(
              width: width,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxContentHeight),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: kP20,
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
                                        mappedData[selectedProvider]
                                            ?.toAiRequestModel();
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
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            width: width,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxContentHeight),
              child: Padding(
                padding: kP20,
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
                              child: Text(kLabelUpdateModels),
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
                                    newAIRequestModel =
                                        mappedData[selectedProvider]
                                            ?.toAiRequestModel();
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
                      child: SingleChildScrollView(
                        child: _buildModelSelector(
                          mappedData[selectedProvider],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _buildModelSelector(AIModelProvider? aiModelProvider) {
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
