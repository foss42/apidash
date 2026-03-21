import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../eval_consts.dart';
import '../../../providers/eval_providers.dart';
import '../../../consts.dart';

class BenchmarkRunner extends ConsumerStatefulWidget {
  const BenchmarkRunner({super.key});

  @override
  ConsumerState<BenchmarkRunner> createState() => _BenchmarkRunnerState();
}

class _BenchmarkRunnerState extends ConsumerState<BenchmarkRunner> {
  late TextEditingController _modelController;
  late TextEditingController _concurrencyController;
  late TextEditingController _totalController;
  late TextEditingController _workflowController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(benchmarkProvider);
    _modelController = TextEditingController(text: state.selectedModel);
    _concurrencyController = TextEditingController(text: state.concurrency.toString());
    _totalController = TextEditingController(text: state.total.toString());
    _workflowController = TextEditingController(text: state.workflowPlan);
  }

  @override
  void dispose() {
    _modelController.dispose();
    _concurrencyController.dispose();
    _totalController.dispose();
    _workflowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final benchmarkState = ref.watch(benchmarkProvider);
    final benchmarkNotifier = ref.read(benchmarkProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRunnerConfig(context, benchmarkState, benchmarkNotifier),
          kVSpacer20,
          if (benchmarkState.isRunning || (benchmarkState.logs.isNotEmpty))
            _buildLogs(context, benchmarkState),
          kVSpacer20,
          if (benchmarkState.errorMessage != null)
            _buildError(context, benchmarkState),
          kVSpacer20,
          if (benchmarkState.result != null)
            _buildResults(context, benchmarkState),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, BenchmarkState state) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            kHSpacer10,
            Expanded(
              child: Text(
                state.errorMessage ?? "",
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunnerConfig(BuildContext context, BenchmarkState state, BenchmarkNotifier notifier) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<BenchmarkType>(
                    decoration: const InputDecoration(
                      labelText: kLabelSelectBenchmark,
                    ),
                    items: BenchmarkType.values.map((benchmark) {
                      return DropdownMenuItem(
                        value: benchmark,
                        child: Text(benchmark.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) notifier.selectBenchmark(value);
                    },
                    value: state.selectedBenchmark,
                  ),
                ),
                kHSpacer20,
                Expanded(
                  child: TextField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: state.selectedBenchmark == BenchmarkType.stressTest 
                          ? "Target URL" 
                          : "Model Name / Path",
                      hintText: state.selectedBenchmark == BenchmarkType.stressTest 
                          ? "https://api.example.com/v1" 
                          : "e.g. gpt-2, facebook/opt-1.3b, /path/to/model",
                    ),
                    onChanged: (value) => notifier.selectModel(value),
                  ),
                ),
              ],
            ),
            if (state.selectedBenchmark == BenchmarkType.stressTest) ...[
              kVSpacer20,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _concurrencyController,
                      decoration: const InputDecoration(
                        labelText: "Concurrency",
                        hintText: "e.g. 5, 10, 50",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final val = int.tryParse(value);
                        if (val != null) notifier.updateConcurrency(val);
                      },
                    ),
                  ),
                  kHSpacer20,
                  Expanded(
                    child: TextField(
                      controller: _totalController,
                      decoration: const InputDecoration(
                        labelText: "Total Requests",
                        hintText: "e.g. 20, 100, 500",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final val = int.tryParse(value);
                        if (val != null) notifier.updateTotal(val);
                      },
                    ),
                  ),
                ],
              ),
            ],
            if (state.selectedBenchmark == BenchmarkType.agenticWorkflow) ...[
              kVSpacer20,
              TextField(
                controller: _workflowController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Workflow Plan (JSON)",
                  hintText: '[{"url": "https://google.com"}, {"url": "https://github.com"}]',
                ),
                onChanged: (value) => notifier.updateWorkflowPlan(value),
              ),
            ],
            kVSpacer20,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: state.isRunning ? null : () => notifier.runBenchmark(),
                  icon: state.isRunning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(state.isRunning ? kLabelBusy : kLabelRunBenchmark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context, BenchmarkState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Execution Logs",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        kVSpacer10,
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: ListView.builder(
            itemCount: state.logs.length,
            reverse: true,
            itemBuilder: (context, index) {
              return Text(
                state.logs[state.logs.length - 1 - index],
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: "monospace",
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, BenchmarkState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kLabelBenchmarkResults,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        kVSpacer10,
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              state.result ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: "monospace",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
