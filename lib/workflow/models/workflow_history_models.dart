import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash_core/apidash_core.dart';

class FlowHistoryMeta {
  const FlowHistoryMeta({
    required this.runId,
    required this.workflowId,
    required this.workflowName,
    required this.success,
    required this.startedAt,
    required this.endedAt,
    required this.stepCount,
    this.error,
  });

  final String runId;
  final String workflowId;
  final String workflowName;
  final bool success;
  final DateTime startedAt;
  final DateTime endedAt;
  final int stepCount;
  final String? error;

  int get durationMs => endedAt.difference(startedAt).inMilliseconds;

  Map<String, dynamic> toJson() => {
        'runId': runId,
        'workflowId': workflowId,
        'workflowName': workflowName,
        'success': success,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt.toIso8601String(),
        'stepCount': stepCount,
        if (error != null && error!.isNotEmpty) 'error': error,
      };

  factory FlowHistoryMeta.fromJson(Map<String, dynamic> json) =>
      FlowHistoryMeta(
        runId: json['runId'] as String? ?? '',
        workflowId: json['workflowId'] as String? ?? '',
        workflowName: json['workflowName'] as String? ?? '',
        success: json['success'] as bool? ?? false,
        startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        endedAt: DateTime.tryParse(json['endedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        stepCount: (json['stepCount'] as num?)?.toInt() ?? 0,
        error: json['error'] as String?,
      );
}

/// Full persisted workflow run (meta + step results).
class FlowHistoryRecord {
  const FlowHistoryRecord({
    required this.meta,
    required this.nodeResults,
    this.scopedVariables = const {},
  });

  final FlowHistoryMeta meta;
  final List<WorkflowNodeRunResult> nodeResults;
  final Map<String, String> scopedVariables;

  Map<String, dynamic> toJson() => {
        'meta': meta.toJson(),
        'scopedVariables': scopedVariables,
        'nodeResults': [
          for (final r in nodeResults) workflowNodeRunResultToJson(r),
        ],
      };

  factory FlowHistoryRecord.fromJson(Map<String, dynamic> json) {
    final metaRaw = json['meta'];
    final meta = metaRaw is Map
        ? FlowHistoryMeta.fromJson(Map<String, dynamic>.from(metaRaw))
        : FlowHistoryMeta(
            runId: '',
            workflowId: '',
            workflowName: '',
            success: false,
            startedAt: DateTime.fromMillisecondsSinceEpoch(0),
            endedAt: DateTime.fromMillisecondsSinceEpoch(0),
            stepCount: 0,
          );
    final varsRaw = json['scopedVariables'];
    final vars = <String, String>{};
    if (varsRaw is Map) {
      for (final e in varsRaw.entries) {
        vars['${e.key}'] = '${e.value}';
      }
    }
    final stepsRaw = json['nodeResults'];
    final steps = <WorkflowNodeRunResult>[];
    if (stepsRaw is List) {
      for (final item in stepsRaw) {
        if (item is Map) {
          steps.add(
            workflowNodeRunResultFromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return FlowHistoryRecord(
      meta: meta,
      nodeResults: steps,
      scopedVariables: vars,
    );
  }

  factory FlowHistoryRecord.fromRunResult({
    required String runId,
    required String workflowName,
    required WorkflowRunResult result,
  }) {
    return FlowHistoryRecord(
      meta: FlowHistoryMeta(
        runId: runId,
        workflowId: result.workflowId,
        workflowName: workflowName,
        success: result.success,
        startedAt: result.startedAt,
        endedAt: result.endedAt,
        stepCount: result.nodeResults.length,
        error: result.error,
      ),
      nodeResults: List<WorkflowNodeRunResult>.from(result.nodeResults),
      scopedVariables: Map<String, String>.from(result.scopedVariables),
    );
  }
}

Map<String, dynamic> workflowNodeRunResultToJson(WorkflowNodeRunResult r) {
  Map<String, Object?>? responseJson;
  if (r.httpResponseModel != null) {
    responseJson = Map<String, Object?>.from(r.httpResponseModel!.toJson());
    responseJson.remove('bodyBytes');
  }
  return {
    'nodeId': r.nodeId,
    'label': r.label,
    'status': r.status.name,
    if (r.message != null) 'message': r.message,
    if (r.durationMs != null) 'durationMs': r.durationMs,
    if (r.statusCode != null) 'statusCode': r.statusCode,
    if (r.loopIndex != null) 'loopIndex': r.loopIndex,
    if (r.nodeType != null) 'nodeType': r.nodeType!.name,
    if (r.detail != null) 'detail': r.detail,
    if (r.branch != null) 'branch': r.branch,
    if (r.apiType != null) 'apiType': r.apiType!.name,
    if (r.method != null) 'method': r.method!.name,
    if (r.url != null) 'url': r.url,
    if (r.requestHeaders != null) 'requestHeaders': r.requestHeaders,
    if (r.requestBody != null) 'requestBody': r.requestBody,
    if (responseJson != null) 'httpResponseModel': responseJson,
    if (r.extractedVariables.isNotEmpty)
      'extractedVariables': r.extractedVariables,
  };
}

WorkflowNodeRunResult workflowNodeRunResultFromJson(Map<String, dynamic> json) {
  final statusName = json['status'] as String? ?? 'skipped';
  final status = WorkflowNodeRunStatus.values.firstWhere(
    (s) => s.name == statusName,
    orElse: () => WorkflowNodeRunStatus.skipped,
  );
  final typeName = json['nodeType'] as String?;
  final nodeType = typeName == null
      ? null
      : WorkflowNodeType.values.firstWhere(
          (t) => t.name == typeName,
          orElse: () => WorkflowNodeType.request,
        );
  final apiTypeName = json['apiType'] as String?;
  final apiType = apiTypeName == null
      ? null
      : APIType.values.firstWhere(
          (t) => t.name == apiTypeName,
          orElse: () => APIType.rest,
        );
  final methodName = json['method'] as String?;
  final method = methodName == null
      ? null
      : HTTPVerb.values.firstWhere(
          (m) => m.name == methodName,
          orElse: () => HTTPVerb.get,
        );
  HttpResponseModel? response;
  final responseRaw = json['httpResponseModel'];
  if (responseRaw is Map) {
    final responseMap = <String, Object?>{
      for (final e in responseRaw.entries) '${e.key}': e.value,
    };
    // jsonDecode yields List<dynamic>; HttpResponseModel expects List<int>.
    final bytes = responseMap['bodyBytes'];
    if (bytes is List && bytes is! List<int>) {
      responseMap['bodyBytes'] = [
        for (final b in bytes) (b as num).toInt(),
      ];
    }
    try {
      response = HttpResponseModel.fromJson(responseMap);
    } catch (_) {
      // Prefer text body over failing the whole history record.
      responseMap.remove('bodyBytes');
      try {
        response = HttpResponseModel.fromJson(responseMap);
      } catch (_) {
        response = null;
      }
    }
  }
  final headersRaw = json['requestHeaders'];
  Map<String, String>? headers;
  if (headersRaw is Map) {
    headers = {
      for (final e in headersRaw.entries) '${e.key}': '${e.value}',
    };
  }
  final extractedRaw = json['extractedVariables'];
  final extracted = <String, String>{};
  if (extractedRaw is Map) {
    for (final e in extractedRaw.entries) {
      extracted['${e.key}'] = '${e.value}';
    }
  }
  return WorkflowNodeRunResult(
    nodeId: json['nodeId'] as String? ?? '',
    label: json['label'] as String? ?? '',
    status: status,
    message: json['message'] as String?,
    durationMs: (json['durationMs'] as num?)?.toInt(),
    statusCode: (json['statusCode'] as num?)?.toInt(),
    loopIndex: json['loopIndex'] as String?,
    nodeType: nodeType,
    detail: json['detail'] as String?,
    branch: json['branch'] as String?,
    apiType: apiType,
    method: method,
    url: json['url'] as String?,
    requestHeaders: headers,
    requestBody: json['requestBody'] as String?,
    httpResponseModel: response,
    extractedVariables: extracted,
  );
}
