import 'package:flutter/material.dart';
import 'package:genai/llm_provider.dart';
import 'package:genai/llm_saveobject.dart';
import 'package:genai/providers/ollama.dart';

class DefaultLLMSelectorButton extends StatelessWidget {
  final LLMSaveObject? defaultLLM;
  final Function(LLMSaveObject) onDefaultLLMUpdated;
  const DefaultLLMSelectorButton({
    super.key,
    this.defaultLLM,
    required this.onDefaultLLMUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(label: Text(defaultLLM?.selectedLLM.modelName ?? 'none')),
        SizedBox(height: 10),
        IconButton(
          onPressed: () async {
            final saveObject = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  content: DefaultLLMSelectorDialog(defaultLLM: defaultLLM),
                  contentPadding: EdgeInsets.all(10),
                );
              },
            );
            if (saveObject == null) return;
            onDefaultLLMUpdated(saveObject);
          },
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }
}

class DefaultLLMSelectorDialog extends StatefulWidget {
  final LLMSaveObject? defaultLLM;

  const DefaultLLMSelectorDialog({super.key, this.defaultLLM});

  @override
  State<DefaultLLMSelectorDialog> createState() =>
      _DefaultLLMSelectorDialogState();
}

class _DefaultLLMSelectorDialogState extends State<DefaultLLMSelectorDialog> {
  late LLMProvider selectedLLMProvider;
  late LLMSaveObject llmSaveObject;

  @override
  void initState() {
    super.initState();

    final oC = OllamaModelController().inputPayload;

    llmSaveObject =
        widget.defaultLLM ??
        LLMSaveObject(
          endpoint: oC.endpoint,
          credential: '',
          configMap: oC.configMap,
          selectedLLM: LLMProvider.gemini.getLLMByIdentifier(
            'gemini-2.0-flash',
          ),
          provider: LLMProvider.ollama,
        );

    selectedLLMProvider = llmSaveObject.provider;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left panel - Provider List
          Container(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Providers'),
                const SizedBox(height: 10),
                ...LLMProvider.values.map(
                  (provider) => ListTile(
                    title: Text(provider.displayName),
                    trailing: llmSaveObject.provider == provider
                        ? const CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.green,
                          )
                        : null,
                    onTap: () {
                      final input = provider.modelController.inputPayload;
                      setState(() {
                        selectedLLMProvider = provider;
                        llmSaveObject = LLMSaveObject(
                          endpoint: input.endpoint,
                          credential: '',
                          configMap: input.configMap,
                          selectedLLM: provider.models.first,
                          provider: provider,
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // Right panel - Configuration and Save
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedLLMProvider.displayName,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 20),

                if (selectedLLMProvider != LLMProvider.ollama) ...[
                  const Text('API Key / Credential'),
                  const SizedBox(height: 10),
                  BoundedTextField(
                    onChanged: (x) {
                      llmSaveObject.credential = x;
                    },
                    value: llmSaveObject.credential,
                  ),
                  const SizedBox(height: 10),
                ],

                const Text('Endpoint'),
                const SizedBox(height: 10),
                BoundedTextField(
                  key: ValueKey(llmSaveObject.provider),
                  onChanged: (x) => llmSaveObject.endpoint = x,
                  value: llmSaveObject.endpoint,
                ),

                const SizedBox(height: 20),
                const Text('Models'),
                const SizedBox(height: 8),

                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(27, 0, 0, 0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: selectedLLMProvider.models
                          .map(
                            (model) => ListTile(
                              title: Text(model.modelName),
                              subtitle: Text(model.identifier),
                              trailing: llmSaveObject.selectedLLM == model
                                  ? const CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  llmSaveObject.selectedLLM = model;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      llmSaveObject.provider = selectedLLMProvider;
                      Navigator.of(context).pop(llmSaveObject);
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoundedTextField extends StatefulWidget {
  const BoundedTextField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  State<BoundedTextField> createState() => _BoundedTextFieldState();
}

class _BoundedTextFieldState extends State<BoundedTextField> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoundedTextField oldWidget) {
    //Assisting in Resetting on Change
    if (widget.value == '') {
      controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // final double width = context.isCompactWindow ? 150 : 220;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Container(
        transform: Matrix4.translationValues(0, -5, 0),
        child: TextField(
          controller: controller,
          // obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
