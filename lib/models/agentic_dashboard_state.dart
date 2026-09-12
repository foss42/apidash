class AgenticDashboardState {
  final bool isAiThinking;
  final String? error;
  final Map<String, dynamic>? dashboardData;
  final List<Map<String, dynamic>> testResults;
  final bool isExecuting;
  final bool isComplete;

  AgenticDashboardState({
    this.isAiThinking = false,
    this.error,
    this.dashboardData,
    this.testResults = const [],
    this.isExecuting = false,
    this.isComplete = false,
  });

  AgenticDashboardState copyWith({
    bool? isAiThinking,
    String? error,
    Map<String, dynamic>? dashboardData,
    List<Map<String, dynamic>>? testResults,
    bool? isExecuting,
    bool? isComplete,
  }) {
    return AgenticDashboardState(
      isAiThinking: isAiThinking ?? this.isAiThinking,
      error: error, // Null out error if not explicitly provided
      dashboardData: dashboardData ?? this.dashboardData,
      testResults: testResults ?? this.testResults,
      isExecuting: isExecuting ?? this.isExecuting,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}