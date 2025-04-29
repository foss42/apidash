import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/services.dart';

class TemplatesService {
  static const String githubRepoOwner = 'BalaSubramaniam12007';
  static const String githubRepoName = 'api-sample-library'; 

  static Future<List<ApiTemplate>> loadTemplates() async {
    // Load cached or default (mock) templates from Hive
    final cachedTemplates = await loadCachedTemplates();
    if (cachedTemplates.isNotEmpty) {
      return cachedTemplates;
    }
    // Fallback to mock templates (initializes Hive with mocks)
    return await _loadMockTemplates();
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
      List<ApiTemplate> newTemplates = [];
      for (final file in archive) {
        if (file.isFile && file.name.endsWith('.json')) {
          final jsonString = utf8.decode(file.content as List<int>);
          final jsonData = jsonDecode(jsonString);
          newTemplates.add(ApiTemplate.fromJson(jsonData));
        }
      }

      if (newTemplates.isNotEmpty) {
        final existingTemplates = await loadCachedTemplates();
        final combinedTemplates = _appendTemplates(existingTemplates, newTemplates);
        await _cacheTemplates(combinedTemplates);
        return combinedTemplates;
      }
      return await loadCachedTemplates(); // Fallback to cached/mock
    } catch (e) {
      print('Error fetching templates from GitHub: $e');
      // Fallback to cached or mock templates
      return await loadCachedTemplates();
    }
  }

  static Future<List<ApiTemplate>> loadCachedTemplates() async {
    try {
      final templateJsons = hiveHandler.getTemplates();
      if (templateJsons != null && templateJsons is List) {
        return templateJsons
            .map((json) => ApiTemplate.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      // If no templates in Hive, initialize with mocks
      return await _loadMockTemplates();
    } catch (e) {
      print('Error loading cached templates: $e');
      return await _loadMockTemplates();
    }
  }

  static Future<bool> hasCachedTemplates() async {
    final templates = await loadCachedTemplates();
    return templates.isNotEmpty;
  }

  static Future<void> _cacheTemplates(List<ApiTemplate> templates) async {
    try {
      final templateJsons = templates.map((t) => t.toJson()).toList();
      await hiveHandler.setTemplates(templateJsons);
    } catch (e) {
      print('Error caching templates: $e');
    }
  }

  static Future<List<ApiTemplate>> _loadMockTemplates() async {
    const String templatesDir = 'lib/screens/explorer/api_templates/mock';
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

      if (templates.isNotEmpty) {
        await _cacheTemplates(templates);
        return templates;
      }
      return _getFallbackTemplates();
    } catch (e) {
      print('Error loading mock templates: $e');
      return _getFallbackTemplates();
    }
  }

  static List<ApiTemplate> _appendTemplates(
      List<ApiTemplate> existing, List<ApiTemplate> newTemplates) {
    final existingTitles = existing.map((t) => t.info.title.toLowerCase()).toSet();
    final combined = [...existing];
    for (final template in newTemplates) {
      if (!existingTitles.contains(template.info.title.toLowerCase())) {
        combined.add(template);
        existingTitles.add(template.info.title.toLowerCase());
      }
    }
    return combined;
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