import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'schema_parser.dart';
import 'llm_service.dart';
import 'widget_factory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schema Extractor',
      home: SchemaExtractorPage(),
    );
  }
}

class SchemaExtractorPage extends StatefulWidget {
  const SchemaExtractorPage({super.key});
  @override
  State<SchemaExtractorPage> createState() => _SchemaExtractorPageState();
}

class _SchemaExtractorPageState extends State<SchemaExtractorPage> {
  String status = 'Loading...';
  Schema? _schema;

  final llm = LLMService('sk-xxxx'); // GPT API Key

  @override
  void initState() {
    super.initState();
    _loadAndParse();
  }

  Future<void> _loadAndParse() async {
    try {
      String jsonString = await rootBundle.loadString('assets/test_users.json');
      List<dynamic> data = jsonDecode(jsonString);

      if (data.isNotEmpty && data.first is Map<String, dynamic>) {
        Schema schema = parseJsonToSchema(data.first);
        print('[DEBUG] Parsed schema (before LLM): ${jsonEncode(schema.toJson())}');

        try {
          // try GPT generate widget
          List<FieldSchema> aiEnhanced = await llm.getWidgetSuggestions(schema);
          setState(() {
            _schema = Schema(type: schema.type, fields: aiEnhanced);
            status = 'AI-enhanced schema loaded';
          });
        } catch (e) {
          // fallback：rulebased inferWidget
          print('[WARN] LLM failed, fallback: $e');
          List<FieldSchema> fallbackFields = schema.fields.map((f) {
            return FieldSchema(
              key: f.key,
              type: f.type,
              suggestedWidget: inferWidget(f),
            );
          }).toList();
          setState(() {
            _schema = Schema(type: schema.type, fields: fallbackFields);
            status = 'LLM failed. Using fallback widget mapping';
          });
        }
      } else {
        setState(() {
          status = 'Invalid JSON format.';
        });
      }
    } catch (e) {
      setState(() {
        status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('AI Form Generator'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _schema == null
              ? Center(child: Text(status))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🧠 Detected Fields:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ..._schema!.fields.map((field) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.label_outline),
                              title: Text(field.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Type: ${field.type}\nWidget: ${field.suggestedWidget}'),
                            ),
                          )),
                      const SizedBox(height: 32),
                      const Divider(),
                      const Text(
                        '🧩 Rendered UI Preview:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: WidgetFactory.buildWidgetsFromSchema(_schema!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    }
  }
