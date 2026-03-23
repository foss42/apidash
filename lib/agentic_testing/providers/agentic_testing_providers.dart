import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/workflow_context.dart';
import '../services/state_machine.dart';
import '../services/test_generator.dart';

final agenticTestGeneratorProvider = Provider<AgenticTestGenerator>((ref) {
  return AgenticTestGenerator(
    readDefaultModel: () => ref.read(settingsProvider).defaultAIModel,
  );
});

final agenticTestingStateMachineProvider =
    StateNotifierProvider<AgenticTestingStateMachine, AgenticWorkflowContext>(
  (ref) {
    return AgenticTestingStateMachine(
      testGenerator: ref.read(agenticTestGeneratorProvider),
    );
  },
);
