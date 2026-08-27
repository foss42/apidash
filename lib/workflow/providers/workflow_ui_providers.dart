import 'package:flutter_riverpod/legacy.dart';

final selectedWorkflowNodeIdProvider = StateProvider<String?>((ref) => null);

final selectedWorkflowRunResultKeyProvider =
    StateProvider<String?>((ref) => null);

final workflowRunInspectorExpandedProvider = StateProvider<bool>((ref) => false);