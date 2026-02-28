import 'package:flutter/material.dart';
import 'package:json_field_editor/json_field_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = JsonTextFieldController();
  bool isFormating = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('JSON Text Field Example')),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                width: 300,
                height: 300,
                child: JsonField(
                  onError: (error) => debugPrint(error),
                  showErrorMessage: true,
                  controller: controller,
                  isFormatting: isFormating,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Enter JSON",
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.6),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    filled: true,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => controller.formatJson(sortJson: false),
                child: const Text('Format JSON'),
              ),
              ElevatedButton(
                onPressed: () => controller.formatJson(sortJson: true),
                child: const Text('Format JSON (sort)'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Format as JSON'),
                  Switch(
                    value: isFormating,
                    onChanged: (value) => setState(() => isFormating = value),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
