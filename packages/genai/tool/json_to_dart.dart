import 'dart:convert';
import 'dart:io';

void main() {
  final inputFile = File('models.json');
  final outputFile = File('lib/models/models_data.g.dart');

  final jsonData = jsonDecode(inputFile.readAsStringSync());
  final dartCode =
      '''
// GENERATED CODE - DO NOT MODIFY BY HAND
const kModelsData = ${jsonEncode(jsonData)};
''';

  outputFile.writeAsStringSync(dartCode);
  print('✅ Generated data.g.dart from data.json');
}
