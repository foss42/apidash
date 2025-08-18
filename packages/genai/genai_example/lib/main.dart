import 'package:flutter/material.dart';
import 'package:genai/genai.dart';

void main() {
  runApp(const GenAIExample());
}

class GenAIExample extends StatelessWidget {
  const GenAIExample({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GenAI Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AIExample(),
    );
  }
}

class AIExample extends StatefulWidget {
  const AIExample({super.key});

  @override
  State<AIExample> createState() => _AIExampleState();
}

class _AIExampleState extends State<AIExample> {
  @override
  void initState() {
    super.initState();
    () async {
      await LLMManager.fetchAvailableLLMs(); //fetch latest LLMs
      await LLMManager.loadAvailableLLMs(); //Load Saved LLMs
      setState(() {});
    }();
    LLMManager.fetchAvailableLLMs().then((_) {
      LLMManager.loadAvailableLLMs().then((_) {});
    });
    systemPromptController.text = 'Give me a 200 word essay on the given topic';
    inputPromptController.text = 'Apple';
  }

  generateAIResponse({bool stream = false}) {
    setState(() {
      output = "";
    });
    GenerativeAI.callGenerativeModel(
      LLMProvider.fromName(
        selectedProvider,
      ).getLLMByIdentifier(selectedModel![0]),
      onAnswer: (x) {
        setState(() {
          output += "$x ";
        });
      },
      onError: (e) {
        print(e);
      },
      systemPrompt: systemPromptController.value.text,
      userPrompt: inputPromptController.value.text,
      credential: credentialController.value.text,
      stream: stream,
    );
  }

  String output = "";
  String selectedProvider = 'ollama';
  List? selectedModel;

  TextEditingController systemPromptController = TextEditingController();
  TextEditingController inputPromptController = TextEditingController();
  TextEditingController credentialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GenAI Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Providers'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...LLMManager.avaiableModels.keys.map(
                  (x) => Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedProvider = x;
                        });
                      },
                      child: Chip(
                        label: Text(x),
                        backgroundColor: selectedProvider == x
                            ? Colors.blue[50]
                            : Colors.transparent,
                      ),
                    ),
                    padding: EdgeInsets.only(right: 10),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Models'),
            SizedBox(height: 10),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                ...(LLMManager.avaiableModels[selectedProvider] ?? []).map(
                  (x) => Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedModel = x;
                        });
                      },
                      child: Chip(
                        label: Text(x[1].toString()),
                        backgroundColor: selectedModel == x
                            ? Colors.blue[50]
                            : Colors.transparent,
                      ),
                    ),
                    padding: EdgeInsets.only(right: 10),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Input Prompt'),
                  TextField(controller: inputPromptController),
                  SizedBox(height: 20),
                  Text('System Prompt'),
                  TextField(controller: systemPromptController),
                  SizedBox(height: 20),
                  Text('Credential'),
                  TextField(controller: credentialController),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    generateAIResponse();
                  },
                  child: Text('Generate Response (SINGLE-RESPONSE)'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    generateAIResponse(stream: true);
                  },
                  child: Text('Generate Response (STREAM)'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 20),

            Text(output),
          ],
        ),
      ),
    );
  }
}
