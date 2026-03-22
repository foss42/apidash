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
  late final Future<AvailableModels> aM;

  @override
  void initState() {
    super.initState();
    aM = ModelManager.fetchAvailableModels(); //fetch latest LLMs
    systemPromptController.text = 'Give me a 200 word essay on the given topic';
    inputPromptController.text = 'Apple';
  }

  generateAIResponse({bool stream = false}) {
    setState(() {
      output = "";
    });
    callGenerativeModel(
      kModelProvidersMap[selectedProvider]?.defaultAIRequestModel.copyWith(
        model: selectedModel,
        apiKey: credentialController.value.text,
        systemPrompt: systemPromptController.value.text,
        userPrompt: inputPromptController.value.text,
        stream: stream,
      ),
      onAnswer: (x) {
        setState(() {
          output += "$x ";
        });
      },
      onError: (e) {
        debugPrint(e);
      },
    );
  }

  String output = "";
  ModelAPIProvider selectedProvider = ModelAPIProvider.ollama;
  String selectedModel = "";

  TextEditingController systemPromptController = TextEditingController();
  TextEditingController inputPromptController = TextEditingController();
  TextEditingController credentialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GenAI Example')),
      body: FutureBuilder(
        future: aM,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            final data = snapshot.data!;
            final mappedData = data.map;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Providers'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...data.modelProviders.map(
                        (x) => Container(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProvider = x.providerId!;
                              });
                            },
                            child: Chip(
                              label: Text(x.providerName ?? ""),
                              backgroundColor: selectedProvider == x.providerId
                                  ? Colors.blue[50]
                                  : Colors.transparent,
                            ),
                          ),
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
                      ...(mappedData[selectedProvider]?.models ?? []).map(
                        (x) => Container(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedModel = x.id!;
                              });
                            },
                            child: Chip(
                              label: Text(x.name ?? ""),
                              backgroundColor: selectedModel == x.id
                                  ? Colors.blue[50]
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
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
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
