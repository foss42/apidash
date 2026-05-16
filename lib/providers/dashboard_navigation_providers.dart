import 'package:flutter_riverpod/legacy.dart';

enum DashboardMainTab {
  collections,
  workflows,
}

class DashboardOpenIntent {
  const DashboardOpenIntent({
    required this.tab,
    this.workflowId,
  });

  final DashboardMainTab tab;
  final String? workflowId;
}

final dashboardOpenIntentProvider = StateProvider<DashboardOpenIntent?>((ref) => null);

final workflowDashboardFocusIdProvider = StateProvider<String?>((ref) => null);
