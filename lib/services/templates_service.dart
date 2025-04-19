import 'dart:convert';
import 'package:flutter/services.dart' show DefaultAssetBundle, rootBundle;
import 'package:apidash/models/models.dart';

class TemplatesService {

  static Future<List<ApiTemplate>> loadTemplates() async {

    const String templatesDir = 'lib/screens/explorer/api_templates/mock';     // Directory containing JSON files

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);

      // Filter for JSON files in the templates directory
      final jsonFiles = manifestMap.keys
          .where((key) => key.startsWith(templatesDir) && key.endsWith('.json'))
          .toList();

      List<ApiTemplate> templates = [];
      for (String filePath in jsonFiles) {
        try {
          final String jsonString = await rootBundle.loadString(filePath);
          final Map<String, dynamic> jsonData = jsonDecode(jsonString);
          templates.add(ApiTemplate.fromJson(jsonData));
        } catch (e) {
          print('Error loading $filePath: $e');
          // Future extensions: Log errors to a monitoring service.
        }
      }

      return templates;
    } catch (e) {
      print('Error loading templates: $e');
      return [];
    }
  }

  static Future<List<ApiTemplate>> fetchTemplatesFromApi() async {
    // Example implementation:
    // final response = await http.get(Uri.parse('https://api.example.com/templates'));
    // final List<dynamic> jsonList = jsonDecode(response.body);
    // return jsonList.map((json) => ApiTemplate.fromJson(json)).toList();
    return [];
  }

}