import 'package:api_testing_suite/api_testing_suite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workflowCollectionProvider = Provider<Map<String, dynamic>>((ref) {
  //It is usable when collections are implemented in the future.
  //For now, we return an empty map to avoid errors.
  return {};
});

/// WorkflowBuilderPagePage that uses the implementation from api_testing_suite
class WorkflowBuilder extends StatelessWidget {
  const WorkflowBuilder({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: WorkflowBuilderScreen(),
      ),
    );
  }
}
