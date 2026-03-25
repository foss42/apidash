import '../../models/request_model.dart';
import '../execution/apidash_request_executor.dart';
import '../execution/request_patch_applier.dart';
import '../models/workflow_context.dart';
import 'context_interpolator.dart';
import 'models/workflow_definition.dart';
import 'models/workflow_run_result.dart';
import 'models/workflow_step.dart';
import 'response_extractor.dart';

class WorkflowRunner {
  final ApidashRequestExecutor _executor;
  final ResponseExtractor _extractor;
  final ContextInterpolator _interpolator;

  WorkflowRunner({
    ApidashRequestExecutor? executor,
    ResponseExtractor? extractor,
    ContextInterpolator? interpolator,
  })  : _executor = executor ?? ApidashRequestExecutor(),
        _extractor = extractor ?? const ResponseExtractor(),
        _interpolator = interpolator ?? const ContextInterpolator();

  /// Runs all steps in a [WorkflowDefinition] sequentially.
  /// [requestLookup] maps requestId → RequestModel (from the collection).
  Future<List<WorkflowRunResult>> run(
    WorkflowDefinition workflow,
    Map<String, RequestModel> requestLookup, {
    Map<String, String>? initialVariables,
  }) async {
    WorkflowContext context = WorkflowContext(state: initialVariables ?? {});
    final results = <WorkflowRunResult>[];

    for (final step in workflow.steps) {
      final result = await _runStep(step, requestLookup, context);
      results.add(result);

      // Merge extracted values into context for subsequent steps
      if (result.extractedValues.isNotEmpty) {
        context = context.merge(result.extractedValues);
      }

      // Abort chain on step failure
      if (!result.passed && result.error != null) break;
    }

    return results;
  }

  Future<WorkflowRunResult> _runStep(
    WorkflowStep step,
    Map<String, RequestModel> lookup,
    WorkflowContext context,
  ) async {
    final requestModel = lookup[step.requestId];
    if (requestModel == null) {
      return WorkflowRunResult(
        stepId: step.stepId,
        stepName: step.name,
        passed: false,
        error: 'Request "${step.requestId}" not found in collection.',
      );
    }

    final httpReq = requestModel.httpRequestModel;
    if (httpReq == null) {
      return WorkflowRunResult(
        stepId: step.stepId,
        stepName: step.name,
        passed: false,
        error: 'No HTTP request model on "${step.name}".',
      );
    }

    // Build patch from inject rules with context interpolation
    final patch = _buildPatch(step.inject, context);

    // Apply patch to base request
    final patchedReq = RequestPatchApplier.apply(httpReq, patch);

    // Execute
    final stopwatch = Stopwatch()..start();
    final response = await _executor.execute(patchedReq);
    stopwatch.stop();

    final passed = response.isSuccess;

    // Extract values from response
    final extracted = <String, dynamic>{};
    for (final entry in step.extract.entries) {
      final value = _extractor.extract(response, entry.value);
      if (value != null) {
        extracted[entry.key] = value;
      }
    }

    return WorkflowRunResult(
      stepId: step.stepId,
      stepName: step.name,
      statusCode: response.statusCode,
      passed: passed,
      duration: stopwatch.elapsed,
      extractedValues: extracted,
      error: response.error,
    );
  }

  /// Converts inject rules to a RequestPatchApplier-compatible patch map.
  /// Supports:
  ///   header.<Name> → upsertHeaders
  ///   body          → body (full replacement)
  ///   url           → url
  Map<String, dynamic> _buildPatch(
    Map<String, String> inject,
    WorkflowContext context,
  ) {
    final patch = <String, dynamic>{};
    final upsertHeaders = <String, String>{};

    for (final entry in inject.entries) {
      final key = entry.key;
      final value = _interpolator.interpolate(entry.value, context);

      if (key.startsWith('header.')) {
        final headerName = key.substring(7);
        upsertHeaders[headerName] = value;
      } else if (key == 'body') {
        patch['body'] = value;
      } else if (key == 'url') {
        patch['url'] = value;
      }
    }

    if (upsertHeaders.isNotEmpty) {
      patch['upsertHeaders'] = upsertHeaders;
    }

    return patch;
  }
}
