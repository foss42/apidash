import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:apidash/models/models.dart';

class TemplatesService {
  static const String githubRepoOwner = 'BalaSubramaniam12007'; // Replace with your GitHub username
  static const String githubRepoName = 'api-sample-library'; // Replace with your repository name

  static Future<List<ApiTemplate>> loadTemplates() async {
    const String templatesDir = 'lib/screens/explorer/api_templates/mock'; // Default mock templates directory
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
      final jsonFiles = manifestMap.keys
          .where((key) => key.startsWith(templatesDir) && key.endsWith('.json'))
          .toList();
      List<ApiTemplate> templates = [];
      for (String filePath in jsonFiles) {
        final String jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        templates.add(ApiTemplate.fromJson(jsonData));
      }
      return templates.isNotEmpty ? templates : _getFallbackTemplates();
    } catch (e) {
      print('Error loading mock templates: $e');
      return _getFallbackTemplates();
    }
  }

  static Future<List<ApiTemplate>> fetchTemplatesFromGitHub() async {
    try {
      final releaseUrl = 'https://api.github.com/repos/$githubRepoOwner/$githubRepoName/releases/latest';
      final releaseResponse = await http.get(
        Uri.parse(releaseUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );
      if (releaseResponse.statusCode != 200) {
        throw Exception('Failed to fetch latest release: ${releaseResponse.statusCode}');
      }

      final releaseData = jsonDecode(releaseResponse.body);
      final assets = releaseData['assets'] as List<dynamic>;
      final zipAsset = assets.firstWhere(
        (asset) => asset['name'] == 'api_templates.zip',
        orElse: () => throw Exception('No api_templates.zip found in release'),
      );

      final zipUrl = zipAsset['browser_download_url'] as String;
      final zipResponse = await http.get(Uri.parse(zipUrl));
      if (zipResponse.statusCode != 200) {
        throw Exception('Failed to download zip: ${zipResponse.statusCode}');
      }

      final zipBytes = zipResponse.bodyBytes;
      final archive = ZipDecoder().decodeBytes(zipBytes);
      List<ApiTemplate> templates = [];
      for (final file in archive) {
        if (file.isFile && file.name.endsWith('.json')) {
          final jsonString = utf8.decode(file.content as List<int>);
          final jsonData = jsonDecode(jsonString);
          templates.add(ApiTemplate.fromJson(jsonData));
        }
      }
      return templates.isNotEmpty ? templates : _getFallbackTemplates();
    } catch (e) {
      print('Error fetching templates from GitHub: $e');
      throw Exception('Failed to fetch templates: $e');
    }
  }

  static List<ApiTemplate> _getFallbackTemplates() {
    return [
      ApiTemplate(
        info: Info(
          title: 'Default Template',
          description: 'A fallback template when no templates are available.',
          tags: ['default'],
        ),
        requests: [],
      ),
    ];
  }
}