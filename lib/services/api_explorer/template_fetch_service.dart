import 'dart:convert';
import 'package:http/http.dart' as http;

class TemplateFetchService {
  static const String templateUrl =
      'https://raw.githubusercontent.com/rishav-singh15/api-explorer-pipeline/main/sample_output.json';

  static Future<Map<String, dynamic>?> fetchTemplate() async {
    try {
      final response = await http.get(Uri.parse(templateUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}

// NOTE: This is a minimal PoC to demonstrate remote template fetching.
// Integration with ApiTemplate model and UI will be done in future steps.