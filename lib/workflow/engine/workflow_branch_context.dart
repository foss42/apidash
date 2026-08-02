
class WorkflowBranchContext {
  WorkflowBranchContext({
    Map<String, String>? scopedVariables,
    this.lastStatusCode,
  }) : scopedVariables = scopedVariables ?? <String, String>{};

  final Map<String, String> scopedVariables;
  int? lastStatusCode;

  /// Same map reference — use for a single next step or loop continuation.
  WorkflowBranchContext share({int? lastStatusCode}) {
    if (lastStatusCode != null) {
      this.lastStatusCode = lastStatusCode;
    }
    return this;
  }

  /// Isolated copy for a sibling branch.
  WorkflowBranchContext fork({int? lastStatusCode}) {
    return WorkflowBranchContext(
      scopedVariables: Map<String, String>.from(scopedVariables),
      lastStatusCode: lastStatusCode ?? this.lastStatusCode,
    );
  }
}

/// Thrown when AND-join merges branches that wrote different values to one key.
class WorkflowMergeConflict implements Exception {
  WorkflowMergeConflict({
    required this.key,
    required this.left,
    required this.right,
  });

  final String key;
  final String left;
  final String right;

  @override
  String toString() =>
      'Variable "$key" conflict on join: "$left" vs "$right". '
      'Use distinct extraction names per parallel branch.';
}

/// One context per successor: share when [count] is 1, fork when fan-out.
List<WorkflowBranchContext> contextsForSuccessors(
  WorkflowBranchContext current, {
  required int count,
}) {
  if (count <= 0) {
    return const [];
  }
  if (count == 1) {
    return [current];
  }
  return List<WorkflowBranchContext>.generate(
    count,
    (_) => current.fork(),
  );
}

/// AND-join merge: union of maps; identical values for a key are fine;
/// differing values throw [WorkflowMergeConflict].
///
/// `lastStatusCode` is kept only when every branch agrees; otherwise cleared
/// (status-based conditions should follow a request after a join).
WorkflowBranchContext mergeBranchContexts(
  Iterable<WorkflowBranchContext> contexts,
) {
  final list = contexts.toList(growable: false);
  if (list.isEmpty) {
    return WorkflowBranchContext();
  }
  if (list.length == 1) {
    return list.first;
  }

  final merged = <String, String>{};
  for (final ctx in list) {
    for (final entry in ctx.scopedVariables.entries) {
      final existing = merged[entry.key];
      if (existing != null && existing != entry.value) {
        throw WorkflowMergeConflict(
          key: entry.key,
          left: existing,
          right: entry.value,
        );
      }
      merged[entry.key] = entry.value;
    }
  }

  final firstStatus = list.first.lastStatusCode;
  final statusAgreed =
      list.every((ctx) => ctx.lastStatusCode == firstStatus);

  return WorkflowBranchContext(
    scopedVariables: merged,
    lastStatusCode: statusAgreed ? firstStatus : null,
  );
}
