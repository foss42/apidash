import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/models.dart';

class TestModelProvider extends ModelProvider {}

void main() {
  test('ModelProvider throws UnimplementedError by default', () {
    final provider = TestModelProvider();
    
    expect(() => provider.defaultAIRequestModel, throwsUnimplementedError);
    expect(() => provider.createRequest(null), throwsUnimplementedError);
    expect(() => provider.outputFormatter({}), throwsUnimplementedError);
    expect(() => provider.streamOutputFormatter({}), throwsUnimplementedError);
  });
}
