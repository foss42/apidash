class WorkflowContext {
  final Map<String, dynamic> state;

  const WorkflowContext({
    this.state = const {},
  });

  WorkflowContext copyWith({
    Map<String, dynamic>? state,
  }) {
    return WorkflowContext(
      state: state ?? this.state,
    );
  }

  WorkflowContext setValue(String key, dynamic value) {
    return WorkflowContext(
      state: {
        ...state,
        key: value,
      },
    );
  }

  WorkflowContext merge(Map<String, dynamic> values) {
    return WorkflowContext(
      state: {
        ...state,
        ...values,
      },
    );
  }

  T? getTyped<T>(String key) {
    final value = state[key];
    if (value is T) return value;
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
    };
  }

  factory WorkflowContext.fromJson(Map<String, dynamic> json) {
    return WorkflowContext(
      state: Map<String, dynamic>.from(
        json['state'] as Map? ?? const {},
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkflowContext && _mapEquals(other.state, state);
  }

  @override
  int get hashCode {
    return Object.hashAll(
      state.entries.map((e) => Object.hash(e.key, e.value)),
    );
  }

  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}