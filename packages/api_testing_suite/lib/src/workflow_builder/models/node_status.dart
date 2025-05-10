import 'package:flutter/material.dart';

/// Enum representing the different states a workflow node can be in
enum NodeStatus {
  inactive,
  running,
  success,
  failure,
  pending,
}

extension NodeStatusExtension on NodeStatus {
  Color get color {
    switch (this) {
      case NodeStatus.running:
        return Colors.blue;
      case NodeStatus.success:
        return Colors.green;
      case NodeStatus.failure:
        return Colors.red;
      case NodeStatus.pending:
        return Colors.orange;
      case NodeStatus.inactive:
        return Colors.grey;
    }
  }
}
