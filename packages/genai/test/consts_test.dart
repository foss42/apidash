import 'package:flutter_test/flutter_test.dart';
import 'package:genai/consts.dart';

void main() {
  test('consts test', () {
    expect(kKeyStream, 'stream');
    expect(kAvailableModels, isNotNull);
    expect(kModelRemoteUrl, 'https://raw.githubusercontent.com/foss42/apidash/refs/heads/main/packages/genai/models.json');
    expect(kBaseOllamaUrl, 'http://localhost:11434');
  });
}
