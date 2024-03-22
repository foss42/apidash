import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a Provider to hold the message
final messageProvider = StateProvider((ref) => 'Coming Soon...');

class WorkflowBuilder extends ConsumerWidget {
  const WorkflowBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(messageProvider);

    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.grey
          ),
        ),
      ),
    );
  }
}
