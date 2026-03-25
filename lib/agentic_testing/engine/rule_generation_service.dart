import 'package:apidash/agentic_testing/models/models.dart';
import 'package:apidash/agentic_testing/rules/rule_engine.dart';
import 'package:apidash/agentic_testing/rules/rule_input_adapter.dart';
import 'package:apidash/models/models.dart';

class RuleGenerationService {
  final RuleInputAdapter _adapter;
  final RuleEngine _engine;

  const RuleGenerationService({
    RuleInputAdapter adapter = const RuleInputAdapter(),
    RuleEngine engine = const RuleEngine(),
  }) : _adapter = adapter,
       _engine = engine;

  List<TestCase> generateForRequest(
    RequestModel requestModel, {
    bool endpointLikelyProtected = false,
  }) {
    final input = _adapter.fromRequestModel(
      requestModel,
      endpointLikelyProtected: endpointLikelyProtected,
    );
    return _engine.generate(input);
  }
}