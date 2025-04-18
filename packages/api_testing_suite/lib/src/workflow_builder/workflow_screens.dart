// Main components
export 'workflow_builder.dart';
export 'components/workflow_builder_screen.dart';
export 'workflow_node.dart';
export 'workflow_connection.dart' hide ConnectionPainter;
export 'execution/workflow_executor.dart';

// Providers
export 'workflow_providers.dart';
export 'workflows_notifier.dart';

// Models
export 'models/models.dart';

// Widgets
export 'widgets/widgets.dart';

// Common widgets with hide
export '../common/widgets/widgets.dart';

// Screens entry points
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/workflow_builder_screen.dart';

/// A wrapper widget that provides an entry point to the workflow builder
class WorkflowBuilderEntry extends ConsumerWidget {
  const WorkflowBuilderEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const WorkflowBuilderScreen();
  }
}
