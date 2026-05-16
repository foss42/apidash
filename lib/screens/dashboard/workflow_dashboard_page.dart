import 'dart:async';
import 'dart:convert';

import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/dashboard/workflow_dashboard_analytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WorkflowDashboardPage extends ConsumerStatefulWidget {
  const WorkflowDashboardPage({super.key});

  @override
  ConsumerState<WorkflowDashboardPage> createState() => _WorkflowDashboardPageState();
}

class _WorkflowDashboardPageState extends ConsumerState<WorkflowDashboardPage> {
  String? _pinnedWorkflowId;
  int? _revisionSeen;
  int? _navRailPrev;
  String? _focusApplyToken;

  final TextEditingController _webhookUrlController = TextEditingController();
  final TextEditingController _reportNameController =
      TextEditingController(text: 'Workflow Analytics Report');
  Timer? _timer;
  int _intervalMin = 15;
  String? _status;

  @override
  void dispose() {
    _timer?.cancel();
    _webhookUrlController.dispose();
    _reportNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final revision = ref.watch(workflowRunHistoryRevisionProvider);
    final activeWorkflowId = ref.watch(workflowIdStateProvider);
    final navRail = ref.watch(navRailIndexStateProvider);
    final focusId = ref.watch(workflowDashboardFocusIdProvider);
    final workflows = ref.watch(workflowsStateProvider);

    if (_revisionSeen != revision) {
      final first = _revisionSeen == null;
      _revisionSeen = revision;
      if (!first) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _pinnedWorkflowId = null);
        });
      }
    }
    if (_navRailPrev != navRail) {
      final prev = _navRailPrev;
      _navRailPrev = navRail;
      if (navRail == 5 && prev != null && prev != 5) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() => _pinnedWorkflowId = null);
        });
      }
    }

    if (workflows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No workflows found for analytics.'),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () async {
                final model =
                    await ref.read(workflowsStateProvider.notifier).createDefault();
                if (!mounted) return;
                setState(() => _pinnedWorkflowId = model.id);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Workflow'),
            ),
          ],
        ),
      );
    }

    final ids = workflows.keys.toList(growable: false);

    if (focusId != null &&
        workflows.containsKey(focusId) &&
        _focusApplyToken != focusId) {
      _focusApplyToken = focusId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(workflowDashboardFocusIdProvider.notifier).state = null;
        setState(() {
          _pinnedWorkflowId = focusId;
          _focusApplyToken = null;
        });
      });
    } else if (focusId == null) {
      _focusApplyToken = null;
    }

    String effectiveId() {
      if (focusId != null && workflows.containsKey(focusId)) {
        return focusId;
      }
      if (_pinnedWorkflowId != null && workflows.containsKey(_pinnedWorkflowId)) {
        return _pinnedWorkflowId!;
      }
      if (activeWorkflowId != null && workflows.containsKey(activeWorkflowId)) {
        return activeWorkflowId;
      }
      return ids.first;
    }

    final dropdownWorkflowId =
        ids.contains(effectiveId()) ? effectiveId() : ids.first;
    final selected = workflows[dropdownWorkflowId]!;

    final asyncDashboard =
        ref.watch(workflowDashboardDataProvider(dropdownWorkflowId));

    return asyncDashboard.when(
      skipLoadingOnReload: true,
      data: (data) => SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Workflow Dashboard',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => _openWebhookDialog(context, selected, data),
                icon: const Icon(Icons.hub_outlined),
                label: const Text('Webhook Reports'),
              ),
              const Spacer(),
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  value: dropdownWorkflowId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Workflow', isDense: true),
                  items: ids
                      .asMap()
                      .entries
                      .map((entry) {
                        final idx = entry.key;
                        final id = entry.value;
                        final name = workflows[id]!.name;
                        return DropdownMenuItem(
                          value: id,
                          child: Text(_flowLabel(idx, name)),
                        );
                      })
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _pinnedWorkflowId = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ids.asMap().entries.map((entry) {
              final idx = entry.key;
              final id = entry.value;
              final isSelected = dropdownWorkflowId == id;
              final label = _flowLabel(idx, workflows[id]!.name);
              return ChoiceChip(
                label: Text(label, overflow: TextOverflow.ellipsis),
                selected: isSelected,
                onSelected: (_) => setState(() => _pinnedWorkflowId = id),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _kpi(context, 'Runs', '${data.totalRuns}')),
              const SizedBox(width: 10),
              Expanded(child: _kpi(context, 'Success Rate', data.successRateLabel)),
              const SizedBox(width: 10),
              Expanded(
                child: _kpi(
                  context,
                  'Avg Duration',
                  '${data.avgMs}ms',
                  color: const Color(0xFF8B7DFF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _kpi(context, 'Nodes', '${data.totalNodes}')),
            ],
          ),
          const SizedBox(height: 12),
          _expandableCard(
            context,
            title: 'Trends & Status',
            initiallyExpanded: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _card(
                    context,
                    title: 'Run Duration Trend (${selected.name})',
                    child: SizedBox(height: 230, child: _durationTrend(context, data)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _card(
                    context,
                    title: 'Run Status Split',
                    child: SizedBox(height: 230, child: _statusPie(context, data)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _expandableCard(
            context,
            title: 'Recent Runs',
            subtitle: data.recentRuns.isEmpty
                ? null
                : Text(
                    '${data.recentRuns.length} run${data.recentRuns.length == 1 ? '' : 's'}',
                    style: theme.textTheme.bodySmall,
                  ),
            initiallyExpanded: false,
            child: _runsTable(context, data.recentRuns),
          ),
        ],
      ),
    ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) =>
          const Center(child: Text('Unable to load workflow analytics.')),
    );
  }

  Widget _kpi(BuildContext context, String title, String value, {Color? color}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _expandableCard(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? subtitle,
    bool initiallyExpanded = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: subtitle,
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [child],
      ),
    );
  }

  Widget _durationTrend(BuildContext context, WorkflowDashboardData data) {
    final theme = Theme.of(context);
    if (data.durations.isEmpty) {
      return Center(
        child: Text(
          'No runs yet. Run this workflow from the builder.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }
    return LineChart(
      LineChartData(
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < data.durations.length; i++)
                FlSpot(i.toDouble(), data.durations[i].toDouble()),
            ],
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
          ),
        ],
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  Widget _statusPie(BuildContext context, WorkflowDashboardData data) {
    final theme = Theme.of(context);
    final total = (data.successRuns + data.failedRuns).toDouble();
    if (total == 0) {
      return Center(
        child: Text(
          'No completed runs.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }
    final success = data.successRuns / total;
    final fail = data.failedRuns / total;
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 32,
              sections: [
                PieChartSectionData(
                  value: success * 100,
                  color: theme.colorScheme.primary,
                  title: '${(success * 100).round()}%',
                ),
                PieChartSectionData(
                  value: fail * 100,
                  color: const Color(0xFFFF587A),
                  title: '${(fail * 100).round()}%',
                ),
              ],
            ),
          ),
        ),
        Text('Success ${data.successRuns}  |  Failed ${data.failedRuns}', style: theme.textTheme.bodySmall),
      ],
    );
  }

  static final DateFormat _runStartedFormat = DateFormat('HH:mm:ss');

  String _formatRunStartedAt(DateTime? dt) {
    if (dt == null) return '—';
    return _runStartedFormat.format(dt.toLocal());
  }

  Widget _runsTable(BuildContext context, List<WorkflowDashboardRunRow> rows) {
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
        child: Text('No run history.'),
      );
    }
    final theme = Theme.of(context);
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(3.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text('Time (local)', style: theme.textTheme.labelSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text('Status', style: theme.textTheme.labelSmall),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text('Duration', style: theme.textTheme.labelSmall),
            ),
          ],
        ),
        ...rows.take(10).map(
          (r) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  _formatRunStartedAt(r.startedAt),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  r.success ? 'Success' : 'Failed',
                  style: TextStyle(
                    color: r.success ? theme.colorScheme.primary : const Color(0xFFFF587A),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(6), child: Text('${r.durationMs}ms')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _webhookPanel(
    BuildContext context,
    WorkflowModel workflow,
    WorkflowDashboardData data,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _webhookUrlController,
                decoration: const InputDecoration(labelText: 'Webhook URL', isDense: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _reportNameController,
                decoration: const InputDecoration(labelText: 'Report Name', isDense: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<int>(
                value: _intervalMin,
                isDense: true,
                decoration: const InputDecoration(labelText: 'Interval'),
                items: const [5, 15, 30, 60]
                    .map((e) => DropdownMenuItem<int>(value: e, child: Text('Every $e min')))
                    .toList(),
                onChanged: (v) => setState(() => _intervalMin = v ?? _intervalMin),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: () => _sendReport(workflow, data),
              child: const Text('Send now'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _timer == null ? () => _startAuto(workflow, data) : _stopAuto,
              child: Text(_timer == null ? 'Start auto-send' : 'Stop auto-send'),
            ),
          ],
        ),
        if (_status != null) ...[
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerLeft, child: Text(_status!)),
        ],
      ],
    );
  }

  Future<void> _sendReport(WorkflowModel workflow, WorkflowDashboardData data) async {
    final url = _webhookUrlController.text.trim();
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      setState(() => _status = 'Failed: enter valid webhook URL.');
      return;
    }
    final payload = {
      'reportName': _reportNameController.text.trim().isEmpty
          ? 'Workflow Analytics Report'
          : _reportNameController.text.trim(),
      'generatedAt': DateTime.now().toIso8601String(),
      'workflow': {
        'id': workflow.id,
        'name': workflow.name,
        'runs': data.totalRuns,
        'successRuns': data.successRuns,
        'failedRuns': data.failedRuns,
        'successRate': data.successRate,
        'avgDurationMs': data.avgMs,
      },
    };
    try {
      final res = await http.post(
        uri,
        headers: const {'content-type': 'application/json'},
        body: jsonEncode(payload),
      );
      setState(() => _status = res.statusCode >= 200 && res.statusCode < 300
          ? 'Report sent (${res.statusCode}).'
          : 'Failed (${res.statusCode}).');
    } catch (e) {
      setState(() => _status = 'Failed: $e');
    }
  }

  void _startAuto(WorkflowModel workflow, WorkflowDashboardData data) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: _intervalMin), (_) => _sendReport(workflow, data));
    setState(() => _status = 'Auto-send enabled (every $_intervalMin min).');
  }

  void _stopAuto() {
    _timer?.cancel();
    _timer = null;
    setState(() => _status = 'Auto-send stopped.');
  }

  String _flowLabel(int index, String name) {
    final normalized = name.trim().isEmpty ? 'Untitled' : name.trim();
    return 'Flow ${index + 1} - $normalized';
  }

  Future<void> _openWebhookDialog(
    BuildContext context,
    WorkflowModel workflow,
    WorkflowDashboardData data,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Workflow Webhook Reports'),
          content: SizedBox(
            width: 680,
            child: _webhookPanel(context, workflow, data),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
