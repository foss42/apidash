import 'package:flutter/material.dart';

enum NodeStatus {
  pending,
  running,
  success,
  error,
  idle,
  failure;

  String get label {
    switch (this) {
      case NodeStatus.pending:
        return 'Pending';
      case NodeStatus.running:
        return 'Running';
      case NodeStatus.success:
        return 'Success';
      case NodeStatus.error:
        return 'Error';
      case NodeStatus.idle:
        return 'Idle';
      case NodeStatus.failure:
        return 'Failure';
    }
  }

  Color get color {
    switch (this) {
      case NodeStatus.pending:
        return Colors.grey;
      case NodeStatus.running:
        return Colors.blue;
      case NodeStatus.success:
        return Colors.green;
      case NodeStatus.error:
        return Colors.red;
      case NodeStatus.idle:
        return Colors.grey;
      case NodeStatus.failure:
        return Colors.red;
    }
  }
}
