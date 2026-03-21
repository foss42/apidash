import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../eval_consts.dart';
import '../../../consts.dart';

class DatasetConfig extends ConsumerStatefulWidget {
  const DatasetConfig({super.key});

  @override
  ConsumerState<DatasetConfig> createState() => _DatasetConfigState();
}

class _DatasetConfigState extends ConsumerState<DatasetConfig> {
  DatasetSource _selectedSource = DatasetSource.huggingFace;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSourceSelector(context),
          kVSpacer20,
          _buildSourceSpecificConfig(context),
          kVSpacer20,
          _buildDatasetPreview(context),
        ],
      ),
    );
  }

  Widget _buildSourceSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dataset Source",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        kVSpacer10,
        Row(
          children: DatasetSource.values.map((source) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(source.label),
                selected: _selectedSource == source,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedSource = source);
                },
                avatar: Icon(source.icon, size: 16),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSourceSpecificConfig(BuildContext context) {
    switch (_selectedSource) {
      case DatasetSource.huggingFace:
        return _buildHuggingFaceConfig(context);
      case DatasetSource.localFile:
        return _buildLocalFileConfig(context);
      case DatasetSource.manualEntry:
        return _buildManualEntryConfig(context);
    }
  }

  Widget _buildHuggingFaceConfig(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: "Repo / Dataset ID",
                hintText: "e.g. glue, super_glue",
              ),
            ),
            kVSpacer10,
            const TextField(
              decoration: InputDecoration(
                labelText: "Subset / Config Name",
                hintText: "e.g. sst2, cola",
              ),
            ),
            kVSpacer20,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text("Fetch Metadata"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalFileConfig(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "File Path",
                      hintText: "Select a JSON, CSV or Parquet file",
                    ),
                  ),
                ),
                kHSpacer20,
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_open),
                  label: const Text(kLabelSelectFile),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntryConfig(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             TextField(
              maxLines: 10,
              minLines: 5,
              decoration: const InputDecoration(
                labelText: "JSON Input",
                hintText: '[{"prompt": "Hello", "completion": "World"}]',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: "monospace"),
            ),
            kVSpacer10,
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text("Save Dataset"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatasetPreview(BuildContext context) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preview",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        kVSpacer10,
        Container(
           height: 200,
           width: double.infinity,
           decoration: BoxDecoration(
             border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
             borderRadius: BorderRadius.circular(8),
           ),
           child: const Center(
             child: Text("Empty dataset or preview not available."),
           ),
        ),
      ],
    );
  }
}
