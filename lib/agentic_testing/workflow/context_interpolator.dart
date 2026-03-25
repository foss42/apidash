import '../models/workflow_context.dart';

/// Interpolates {{variableName}} placeholders in a template string
/// using values from a [WorkflowContext].
class ContextInterpolator {
  const ContextInterpolator();

  /// Replaces all {{key}} occurrences in [template] with values from [context].
  String interpolate(String template, WorkflowContext context) {
    return template.replaceAllMapped(
      RegExp(r'\{\{(\w+)\}\}'),
      (match) {
        final key = match.group(1)!;
        final value = context.state[key];
        return value?.toString() ?? match.group(0)!;
      },
    );
  }

  /// Interpolates all values in a map (keys are not interpolated).
  Map<String, String> interpolateMap(
    Map<String, String> map,
    WorkflowContext context,
  ) {
    return map.map((k, v) => MapEntry(k, interpolate(v, context)));
  }
}
