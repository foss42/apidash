import 'package:apidash/screens/dashflow/dashflow_builder/workflow_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class DashflowBuilder extends ConsumerWidget {
  const DashflowBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return WorkflowCanvas();
    } else {
      return WorkflowCanvas();
    }
  }
}



