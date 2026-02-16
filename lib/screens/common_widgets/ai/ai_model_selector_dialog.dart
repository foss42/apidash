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

    // --- VALIDATION LOGIC START ---
    
    // 1. Identify Provider Types
    final isOllama = aiModelProvider.providerId == ModelAPIProvider.ollama;
    // Using string check for safety, as 'azure' constant might vary
    final isAzure = aiModelProvider.providerName == 'Azure OpenAI';

    // 2. Validate API Key (Mandatory for everyone EXCEPT Ollama)
    final apiKey = newAIRequestModel?.apiKey ?? "";
    final isApiKeyRequired = !isOllama; 
    final isApiKeyEmpty = apiKey.trim().isEmpty;

    // 3. Validate URL (Mandatory ONLY for Azure)
    final url = newAIRequestModel?.url ?? "";
    final isUrlRequired = isAzure;
    final isUrlEmpty = url.trim().isEmpty;

    // 4. Validate Model Selection (Must always pick a model)
    final isModelEmpty = newAIRequestModel?.model?.isEmpty ?? true;

    // 5. Final Invalid State
    final bool isInvalidConfig = isModelEmpty ||
        (isApiKeyRequired && isApiKeyEmpty) ||
        (isUrlRequired && isUrlEmpty);

    // --- VALIDATION LOGIC END ---

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          aiModelProvider.providerName ?? "",
          style: TextStyle(fontSize: 28),
        ),
        SizedBox(height: 20),

        // API Key Field (Shown for everyone except Ollama)
        if (!isOllama) ...[
          Row(
            children: [
              Text('API Key / Credential'),
              Text(' *', style: TextStyle(color: kColorRed)), // Mark as required
            ],
          ),
          kVSpacer8,
          BoundedTextField(
            onChanged: (x) {
              setState(() {
                newAIRequestModel = newAIRequestModel?.copyWith(apiKey: x);
              });
            },
            value: newAIRequestModel?.apiKey ?? "",
          ),
          // Validation Error for API Key
          if (isApiKeyEmpty) ...[
            kVSpacer5,
            Text(
              "API Key is required",
              style: TextStyle(color: kColorRed, fontSize: 12),
            ),
          ],
          kVSpacer10,
        ],

        // Endpoint URL Field
        Row(
          children: [
            Text('Endpoint'),
            if (isAzure)
              Text(' *', style: TextStyle(color: kColorRed)), // Mark as required for Azure
          ],
        ),
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
        // Validation Error for URL
        if (isAzure && isUrlEmpty) ...[
          kVSpacer5,
          Text(
            "Endpoint URL is required for Azure OpenAI",
            style: TextStyle(color: kColorRed, fontSize: 12),
          ),
        ],

        kVSpacer20,

        // Model List
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
        
        // Save Button (Disabled if Invalid)
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: isInvalidConfig
                ? null
                : () {
                    Navigator.of(context).pop(newAIRequestModel);
                  },
            child: Text('Save'),
          ),
        ),
      ],
    );
  }
}