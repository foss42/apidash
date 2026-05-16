import 'package:apidash/models/models.dart';
import 'package:apidash/screens/workflow/workflow_canvas_constants.dart';
import 'package:apidash/screens/workflow/workflow_page_local_models.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';

class WorkflowNodeInspector extends StatelessWidget {
  const WorkflowNodeInspector({
    super.key,
    required this.node,
    required this.availableRequests,
    required this.output,
    required this.runHistory,
    required this.templateVariablesForRequest,
    required this.requestVariableValues,
    required this.onRequestVariableValueChanged,
    required this.onUpdate,
  });

  final Node<WorkflowNodeData> node;
  final Map<String, RequestModel> availableRequests;
  final WorkflowNodeRunOutput? output;
  final List<WorkflowRunRecord> runHistory;
  final List<String> templateVariablesForRequest;
  final Map<String, String> requestVariableValues;
  final void Function(String key, String value) onRequestVariableValueChanged;
  final void Function(WorkflowNodeData data) onUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = node.data;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.dividerColor)),
      ),
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          Text('Node Inspector', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(text: data.label),
            decoration: const InputDecoration(
              labelText: 'Label',
              isDense: true,
            ),
            onSubmitted: (value) => onUpdate(data.copyWith(label: value.trim())),
          ),
          const SizedBox(height: 10),
          if (data.nodeType == WorkflowNodeType.request)
            DropdownButtonFormField<String>(
              value: data.linkedRequestId != null &&
                      availableRequests.containsKey(data.linkedRequestId)
                  ? data.linkedRequestId
                  : null,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Linked Request',
                isDense: true,
              ),
              items: availableRequests.values
                  .map(
                    (req) => DropdownMenuItem<String>(
                      value: req.id,
                      child: Text(
                        req.name.isEmpty ? req.id : req.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                onUpdate(data.copyWith(linkedRequestId: value));
              },
            ),
          if (data.nodeType == WorkflowNodeType.request) ...[
            const SizedBox(height: 8),
            if (templateVariablesForRequest.isNotEmpty) ...[
              Text(
                'Request Variable Values',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              ...templateVariablesForRequest.map(
                (key) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: TextEditingController(
                      text: requestVariableValues[key] ?? '',
                    ),
                    decoration: InputDecoration(
                      labelText: key,
                      hintText: 'Value or json:path (e.g. json:refreshToken)',
                      isDense: true,
                    ),
                    onChanged: (value) => onRequestVariableValueChanged(key, value),
                  ),
                ),
              ),
            ],
          ],
          if (data.nodeType == WorkflowNodeType.condition)
            TextField(
              controller:
                  TextEditingController(text: data.conditionExpression ?? ''),
              decoration: const InputDecoration(
                labelText: 'Condition',
                hintText: 'status>=200&&status<300',
                isDense: true,
              ),
              onSubmitted: (value) =>
                  onUpdate(data.copyWith(conditionExpression: value.trim())),
            ),
          if (data.nodeType == WorkflowNodeType.variable)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: TextEditingController(text: data.variableKey ?? ''),
                  decoration: const InputDecoration(
                    labelText: 'Variable key',
                    isDense: true,
                  ),
                  onSubmitted: (value) =>
                      onUpdate(data.copyWith(variableKey: value.trim())),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller:
                      TextEditingController(text: data.variableValue ?? ''),
                  decoration: const InputDecoration(
                    labelText: 'Literal value',
                    hintText: 'token-value',
                    isDense: true,
                  ),
                  onSubmitted: (value) =>
                      onUpdate(data.copyWith(variableValue: value)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller:
                      TextEditingController(text: data.variableSource ?? ''),
                  decoration: const InputDecoration(
                    labelText: 'Source (optional)',
                    hintText: 'json:refreshToken',
                    isDense: true,
                  ),
                  onSubmitted: (value) =>
                      onUpdate(data.copyWith(variableSource: value.trim())),
                ),
              ],
            ),
          if (data.nodeType == WorkflowNodeType.delay)
            TextField(
              controller: TextEditingController(text: '${data.delayMs ?? 0}'),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Delay (ms)',
                isDense: true,
              ),
              onSubmitted: (value) =>
                  onUpdate(data.copyWith(delayMs: int.tryParse(value) ?? 0)),
            ),
          if (data.nodeType == WorkflowNodeType.loop)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller:
                      TextEditingController(text: data.loopExpression ?? ''),
                  decoration: const InputDecoration(
                    labelText: 'Loop expression',
                    hintText: 'var:items',
                    isDense: true,
                  ),
                  onSubmitted: (value) =>
                      onUpdate(data.copyWith(loopExpression: value.trim())),
                ),
                const SizedBox(height: 6),
                Text(
                  'Current format: var:<name> where variable is a List.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          if (output != null) ...[
            const SizedBox(height: 16),
            Text('Last Output', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            if (output!.requestId.isNotEmpty) Text('Request: ${output!.requestId}'),
            if (output!.statusCode != null) Text('Status: ${output!.statusCode}'),
            if (output!.timeMs != null) Text('Time: ${output!.timeMs} ms'),
            if ((output!.responseBody ?? '').isNotEmpty)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  'Response',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          output!.responseBody!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Text(
                'No response body yet.',
                style: theme.textTheme.bodySmall,
              ),
          ],
          if (runHistory.isNotEmpty) ...[
            const SizedBox(height: 16),
            ExpansionTile(
              initiallyExpanded: false,
              tilePadding: EdgeInsets.zero,
              title: Text('Recent Runs', style: theme.textTheme.titleSmall),
              subtitle: Text(
                '${runHistory.length} run${runHistory.length == 1 ? '' : 's'}',
                style: theme.textTheme.bodySmall,
              ),
              shape: const RoundedRectangleBorder(),
              collapsedShape: const RoundedRectangleBorder(),
              children: [
                ...runHistory.take(5).map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${r.success ? 'OK' : 'FAIL'} · ${r.durationMs}ms · ${kWorkflowRunTimeOnly.format(r.startedAt.toLocal())}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
