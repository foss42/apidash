import '../models/workflow_step.dart';
import '../models/workflow_result.dart';

class WorkflowAgent {
  // Stage 3: plans data bindings between steps
  Future<List<WorkflowStep>> generatePlan(
      List<Map<String, dynamic>> requests) async {
    throw UnimplementedError('Coming in Stage 3');
  }

  // Stage 3: executes steps in order, passing data between them
  Stream<WorkflowStepResult> execute(List<WorkflowStep> steps) async* {
    throw UnimplementedError('Coming in Stage 3');
  }
}