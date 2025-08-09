import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:genai/genai.dart';
import 'package:flutter/material.dart';

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
    return ElevatedButton(
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
      child: Text(defaultLLM?.selectedLLM.modelName ?? 'Select Model'),
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
  bool initialized = false;

  initialize() async {
    final iP = LLMProvider.gemini.modelController.inputPayload;
    llmSaveObject = widget.defaultLLM ??
        LLMSaveObject(
          endpoint: iP.endpoint,
          credential: '',
          configMap: iP.configMap,
          selectedLLM:
              LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash'),
          provider: LLMProvider.ollama,
        );
    selectedLLMProvider = llmSaveObject.provider;
    initialized = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return SizedBox();
    return Container(
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.8,
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
                      await LLMManager.fetchAvailableLLMs();
                      setState(() {});
                    },
                    child: Text('Fetch Models'),
                  ),
                  SizedBox(height: 20),
                  ...LLMProvider.values.where(((e) => e.models.isNotEmpty)).map(
                        (x) => ListTile(
                          title: Text(x.displayName),
                          trailing: llmSaveObject.provider != x
                              ? null
                              : CircleAvatar(
                                  radius: 5,
                                  backgroundColor: Colors.green,
                                ),
                          onTap: () {
                            selectedLLMProvider = x;
                            final models = x.models;
                            final mC = x.modelController;
                            final p = mC.inputPayload;
                            llmSaveObject = LLMSaveObject(
                              endpoint: p.endpoint,
                              credential: '',
                              configMap: p.configMap,
                              selectedLLM: models.first,
                              provider: x,
                            );
                            setState(() {});
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    selectedLLMProvider.displayName,
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(height: 20),
                  if (selectedLLMProvider != LLMProvider.ollama) ...[
                    Text('API Key / Credential'),
                    kVSpacer8,
                    BoundedTextField(
                      onChanged: (x) {
                        llmSaveObject.credential = x;
                        setState(() {});
                      },
                      value: llmSaveObject.credential,
                    ),
                    kVSpacer10,
                  ],
                  Text('Endpoint'),
                  kVSpacer8,
                  BoundedTextField(
                    key: ValueKey(llmSaveObject.provider),
                    onChanged: (x) {
                      llmSaveObject.endpoint = x;
                      setState(() {});
                    },
                    value: llmSaveObject.endpoint,
                  ),
                  kVSpacer20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Models'),
                      IconButton(onPressed: addNewModel, icon: Icon(Icons.add))
                    ],
                  ),
                  kVSpacer8,
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(27, 0, 0, 0),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...selectedLLMProvider.models.map(
                            (x) => ListTile(
                              title: Text(x.modelName),
                              subtitle: Text(x.identifier),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (llmSaveObject.selectedLLM.identifier ==
                                      x.identifier)
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                                  IconButton(
                                      onPressed: () => removeModel(x),
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                      ))
                                ],
                              ),
                              onTap: () {
                                llmSaveObject.selectedLLM = x;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kVSpacer10,
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        llmSaveObject.provider = selectedLLMProvider;
                        Navigator.of(context).pop(llmSaveObject);
                      },
                      child: Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  removeModel(LLMModel model) async {
    await LLMManager.removeLLM(
        selectedLLMProvider.name, model.identifier, model.modelName);
    setState(() {});
  }

  addNewModel() async {
    TextEditingController iC = TextEditingController();
    TextEditingController nC = TextEditingController();
    final z = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Custom Model'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ADOutlinedTextField(
                    controller: iC,
                    hintText: 'Model ID',
                  ),
                  kVSpacer10,
                  ADOutlinedTextField(
                    controller: nC,
                    hintText: 'Model Display Name',
                  ),
                  kVSpacer10,
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop([
                          iC.value.text,
                          nC.value.text,
                        ]);
                      },
                      child: Text('Add Model'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
    if (z == null) return;
    await LLMManager.addLLM(selectedLLMProvider.name, z[0], z[1]);
    setState(() {});
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
        borderRadius: kBorderRadius8,
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
