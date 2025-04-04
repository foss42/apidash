import 'package:flutter/material.dart';
import 'mock_schema.dart';
import 'ui_renderer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("AI UI Generator POC")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DynamicTable(schema: mockSchema, data: mockData),

        ),
      ),
    );
  }
}
