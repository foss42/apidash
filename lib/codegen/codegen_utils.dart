import 'package:apidash_core/models/http_request_model.dart';
import 'package:seed/models/name_value_model.dart';

String jsonToPyDict(String jsonString) {
  Map<String, String> replaceWithMap = {
    "null": "None",
    "true": "True",
    "false": "False"
  };
  String pyDict = jsonString;
  for (var k in replaceWithMap.keys) {
    RegExp regExp = RegExp(k + r'(?=([^"]*"[^"]*")*[^"]*$)');
    pyDict = pyDict.replaceAllMapped(regExp, (match) {
      return replaceWithMap[match.group(0)] ?? match.group(0)!;
    });
  }
  return pyDict;
}

/// Utility to extract OAuth headers from a request model
List<NameValueModel> extractOAuthHeaders(HttpRequestModel requestModel) {
  final headers = requestModel.enabledHeaders ?? [];
  return headers.where((header) {
    final lowerName = header.name.toLowerCase();
    return lowerName == 'authorization' || 
           lowerName.startsWith('oauth-') || 
           lowerName.contains('token');
  }).toList();
}

/// Utility to generate language-specific OAuth header representation
String generateOAuthHeaderString(
  List<NameValueModel> oauthHeaders, 
  String langType,
) {
  switch (langType) {
    case 'python':
      return _generatePythonOAuthHeaders(oauthHeaders);
    case 'javascript':
      return _generateJavaScriptOAuthHeaders(oauthHeaders);
    case 'curl':
      return _generateCurlOAuthHeaders(oauthHeaders);
    default:
      return '';
  }
}

String _generatePythonOAuthHeaders(List<NameValueModel> headers) {
  if (headers.isEmpty) return '';
  
  final buffer = StringBuffer('headers = {\n');
  for (final header in headers) {
    buffer.writeln("    '${header.name}': '${header.value.replaceAll("'", "\\'")}'");
  }
  buffer.writeln('}');
  
  return buffer.toString();
}

String _generateJavaScriptOAuthHeaders(List<NameValueModel> headers) {
  if (headers.isEmpty) return '';
  
  final buffer = StringBuffer('const headers = {\n');
  for (final header in headers) {
    buffer.writeln("  '${header.name}': '${header.value.replaceAll("'", "\\'")}'");
  }
  buffer.writeln('};');
  
  return buffer.toString();
}

String _generateCurlOAuthHeaders(List<NameValueModel> headers) {
  if (headers.isEmpty) return '';
  
  final buffer = StringBuffer();
  for (final header in headers) {
    buffer.writeln(' -H "${header.name}: ${header.value.replaceAll('"', '\\"')}"');
  }
  
  return buffer.toString();
}
