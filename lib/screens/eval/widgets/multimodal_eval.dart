import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../eval_consts.dart';
import '../../../consts.dart';

class MultimodalEval extends ConsumerStatefulWidget {
  const MultimodalEval({super.key});

  @override
  ConsumerState<MultimodalEval> createState() => _MultimodalEvalState();
}

class _MultimodalEvalState extends ConsumerState<MultimodalEval> {
  MultimodalTaskType _selectedTask = MultimodalTaskType.imageCaptioning;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTaskSelector(context),
          kVSpacer20,
          _buildTaskSpecificConfig(context),
          kVSpacer20,
          _buildTaskExecution(context),
        ],
      ),
    );
  }

  Widget _buildTaskSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Task Selection",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        kVSpacer10,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: MultimodalTaskType.values.map((task) {
            return ChoiceChip(
              label: Text(task.label),
              selected: _selectedTask == task,
              onSelected: (selected) {
                if (selected) setState(() => _selectedTask = task);
              },
              avatar: Icon(task.icon, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTaskSpecificConfig(BuildContext context) {
    switch (_selectedTask) {
      case MultimodalTaskType.imageCaptioning:
      case MultimodalTaskType.visualQA:
        return _buildImageConfig(context);
      case MultimodalTaskType.voiceToText:
      case MultimodalTaskType.textToVoice:
        return _buildVoiceConfig(context);
    }
  }

  Widget _buildImageConfig(BuildContext context) {
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
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate, size: 48),
                          kVSpacer10,
                          const Text("No image selected"),
                          kVSpacer5,
                          TextButton(
                            onPressed: () {},
                            child: const Text(kLabelSelectFile),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_selectedTask == MultimodalTaskType.visualQA) ...[
                  kHSpacer20,
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Question",
                        hintText: "What is in the image?",
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceConfig(BuildContext context) {
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
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.mic, size: 32),
                          kVSpacer5,
                          const Text("No audio selected"),
                          TextButton(
                            onPressed: () {},
                            child: const Text(kLabelSelectFile),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_selectedTask == MultimodalTaskType.textToVoice) ...[
                  kHSpacer20,
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Input Text",
                        hintText: "Hello world!",
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskExecution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Execution results",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow),
              label: const Text("Perform Task"),
            ),
          ],
        ),
        kVSpacer10,
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No results yet."),
          ),
        ),
      ],
    );
  }
}
