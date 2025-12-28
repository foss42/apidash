import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/evaluation_model.dart';
import 'package:apidash/providers/evaluation_providers.dart';

class EvaluationsPage extends ConsumerWidget {
  const EvaluationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evaluations = ref.watch(evaluationsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "AI Evaluations",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FilledButton.icon(
                  onPressed: () {
                    _showCreateDialog(context, ref);
                  },
                  label: const Text('New Evaluation'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            kVSpacer20,
            Expanded(
              child: evaluations.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      itemCount: evaluations.length,
                      separatorBuilder: (ctx, idx) => const SizedBox(height: 10), 
                      itemBuilder: (context, index) {
                        final eval = evaluations[index];
                        return _EvaluationCard(eval: eval);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          kVSpacer20,
          Text(
            "No evaluations yet",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          kVSpacer10,
          Text(
            "Create a new evaluation to benchmark your AI models.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final datasetController = TextEditingController(text: "MMLU_Sample.json");
    final selectedModels = <String>{};
    String selectedType = "Text Generation";
    String selectedScoring = "Exact Match";
    double batchSize = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("New Evaluation Task"),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Task Name",
                          hintText: "e.g., GPT-4 vs Gemini",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      kVSpacer10,
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(labelText: "Task Type", border: OutlineInputBorder()),
                        items: ["Text Generation", "Multimedia", "Classification"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => selectedType = val!),
                      ),
                      kVSpacer10,
                       TextField(
                        controller: datasetController,
                        decoration: const InputDecoration(
                          labelText: "Dataset Path / Import",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.folder_open),
                        ),
                      ),
                      kVSpacer10,
                      DropdownButtonFormField<String>(
                        value: selectedScoring,
                        decoration: const InputDecoration(labelText: "Scoring Mechanism", border: OutlineInputBorder()),
                        items: ["Exact Match", "LLM-as-a-Judge", "Custom Script"]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => selectedScoring = val!),
                      ),
                       kVSpacer10,
                       Text("Batch Size: ${batchSize.round()}"),
                       Slider(
                         value: batchSize,
                         min: 1,
                         max: 50,
                         divisions: 49,
                         label: batchSize.round().toString(),
                         onChanged: (val) => setState (() => batchSize = val),
                       ),
                      kVSpacer20,
                      const Text("Select Models:", style: TextStyle(fontWeight: FontWeight.bold)),
                      kVSpacer5,
                      Wrap(
                        spacing: 8,
                        children: ["gpt-4", "claude-3", "gemini-pro", "llama3-local"]
                            .map((m) => FilterChip(
                                  label: Text(m),
                                  selected: selectedModels.contains(m),
                                  onSelected: (val) {
                                    setState(() {
                                      if (val) {
                                        selectedModels.add(m);
                                      } else {
                                        selectedModels.remove(m);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                FilledButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        selectedModels.isNotEmpty) {
                      ref.read(evaluationsProvider.notifier).addEvaluation(
                        nameController.text,
                        datasetController.text,
                        selectedModels.toList(),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _EvaluationCard extends ConsumerWidget {
  final EvaluationModel eval;

  const _EvaluationCard({required this.eval});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eval.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Dataset: ${eval.datasetPath}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                _buildStatusBadge(context, eval.status),
              ],
            ),
            kVSpacer10,
            const Divider(),
            kVSpacer10,
            if (eval.status == EvaluationStatus.completed)
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(
                            text: "Table",
                            icon: Icon(Icons.table_chart_outlined, size: 16)),
                        Tab(
                            text: "Charts",
                            icon: Icon(Icons.bar_chart_outlined, size: 16)),
                      ],
                    ),
                    kVSpacer10,
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(child: _buildResultsTable(context)),
                          _buildChartsPlaceholder(context),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Text("Models: ${eval.models.join(', ')}"),
                  const Spacer(),
                  if (eval.status == EvaluationStatus.pending)
                    FilledButton.icon(
                      onPressed: () {
                        ref
                            .read(evaluationsProvider.notifier)
                            .runEvaluation(eval.id);
                      },
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text("Run Eval"),
                    )
                  else if (eval.status == EvaluationStatus.running)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            if (eval.status != EvaluationStatus.running)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      ref
                          .read(evaluationsProvider.notifier)
                          .deleteEvaluation(eval.id);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, EvaluationStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case EvaluationStatus.pending:
        color = Colors.orange;
        label = "Pending";
        icon = Icons.schedule;
        break;
      case EvaluationStatus.running:
        color = Colors.blue;
        label = "Running";
        icon = Icons.sync;
        break;
      case EvaluationStatus.completed:
        color = Colors.green;
        label = "Completed";
        icon = Icons.check_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTable(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(
              color: Theme.of(context).colorScheme.outlineVariant),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
              children: const [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Model",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Score",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Latency",
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            ...eval.results.map((r) => TableRow(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(r.modelId)),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${(r.score * 100).toStringAsFixed(1)}%")),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${r.latencyMs} ms")),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildChartsPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text("Score Distribution (Mock)"),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.end,
               children: eval.results.map((r) {
                 return Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Container(
                         width: 20,
                         height: r.score * 100, // naive height
                         color: Colors.blueAccent,
                       ),
                       const SizedBox(height: 4),
                       Text(r.modelId.substring(0, 3)), // short name
                     ],
                   ),
                 );
               }).toList(),
             )
          ],
        ),
      ),
    );
  }
}
