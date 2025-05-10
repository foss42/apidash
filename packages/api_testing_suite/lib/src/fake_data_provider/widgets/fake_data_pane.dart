import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/fake_data_provider.dart';

class FakeDataProvidersPane extends ConsumerWidget {
  const FakeDataProvidersPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fake Data Providers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Use these placeholders in your API requests to generate random test data automatically.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'How to use:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Type {{\$tagName}} in any field where you want to use random data.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'For example: {{\$randomEmail}} will be replaced with a randomly generated email address.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Available Placeholders:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20),
                    _buildFakeDataTable(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeDataTable(BuildContext context) {
    // Dynamically fetch tag list from FakeDataProvider's registry
    final fakeDataTags = FakeDataProvider.tagRegistry.entries.map((entry) {
      final tag = entry.key;
      final example = entry.value();
      // For localization, use a lookup or resource map for descriptions
      final description = _localizedDescription(tag, context);
      return _FakeDataItem(
        name: tag,
        description: description,
        example: example,
      );
    }).toList();

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(0.5),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outline,
        width: 1,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          children: [
            _buildTableCell(context, 'Placeholder', isHeader: true),
            _buildTableCell(context, 'Description', isHeader: true),
            _buildTableCell(context, 'Example Output', isHeader: true),
            _buildTableCell(context, 'Copy', isHeader: true),
          ],
        ),
        for (var item in fakeDataTags)
          TableRow(
            children: [
              _buildTableCell(context, '{{\$${item.name}}}'),
              _buildTableCell(context, item.description),
              _buildTableCell(context, item.example),
              _buildCopyButton(context, '{{\$${item.name}}}'),
            ],
          ),
      ],
    );
  }

  Widget _buildTableCell(BuildContext context, String text,
      {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: isHeader
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context, String textToCopy) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: IconButton(
        icon: const Icon(Icons.copy, size: 18),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: textToCopy));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied $textToCopy to clipboard'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        tooltip: 'Copy to clipboard',
      ),
    );
  }

  String _localizedDescription(String tag, BuildContext context) {
    switch (tag) {
      case 'randomusername':
        return 'Random username (e.g., user123, test_dev)';
      case 'randomemail':
        return 'Random email address';
      case 'randomid':
        return 'Random numeric ID';
      case 'randomuuid':
        return 'Random UUID';
      case 'randomname':
        return 'Random full name';
      case 'randomphone':
        return 'Random US phone number';
      case 'randomaddress':
        return 'Random US address';
      case 'randomdate':
        return 'Random date (ISO 8601)';
      case 'randomdatetime':
        return 'Random date & time (ISO 8601)';
      case 'randomboolean':
        return 'Random boolean (true/false)';
      case 'randomnumber':
        return 'Random number (0-1000)';
      case 'randomjson':
        return 'Random JSON object';
      default:
        return tag;
    }
  }
}

class _FakeDataItem {
  final String name;
  final String description;
  final String example;

  _FakeDataItem({
    required this.name,
    required this.description,
    required this.example,
  });
}
