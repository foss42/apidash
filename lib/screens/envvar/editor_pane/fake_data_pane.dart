import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/utils/fake_data_provider.dart';

class FakeDataProvidersPane extends ConsumerWidget {
  const FakeDataProvidersPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: kBorderRadius12,
      ),
      margin: kP10,
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
    final fakeDataTags = [
      _FakeDataItem(
        name: 'randomUsername',
        description: 'Random username (e.g., user123, test_dev)',
        example: FakeDataProvider.randomUsername(),
      ),
      _FakeDataItem(
        name: 'randomEmail',
        description: 'Random email address',
        example: FakeDataProvider.randomEmail(),
      ),
      _FakeDataItem(
        name: 'randomId',
        description: 'Random numeric ID',
        example: FakeDataProvider.randomId(),
      ),
      _FakeDataItem(
        name: 'randomUuid',
        description: 'Random UUID',
        example: FakeDataProvider.randomUuid(),
      ),
      _FakeDataItem(
        name: 'randomName',
        description: 'Random full name',
        example: FakeDataProvider.randomName(),
      ),
      _FakeDataItem(
        name: 'randomPhone',
        description: 'Random phone number',
        example: FakeDataProvider.randomPhone(),
      ),
      _FakeDataItem(
        name: 'randomAddress',
        description: 'Random address',
        example: FakeDataProvider.randomAddress(),
      ),
      _FakeDataItem(
        name: 'randomDate',
        description: 'Random date (YYYY-MM-DD)',
        example: FakeDataProvider.randomDate(),
      ),
      _FakeDataItem(
        name: 'randomDateTime',
        description: 'Random date and time (ISO format)',
        example: FakeDataProvider.randomDateTime(),
      ),
      _FakeDataItem(
        name: 'randomBoolean',
        description: 'Random boolean value (true/false)',
        example: FakeDataProvider.randomBoolean(),
      ),
      _FakeDataItem(
        name: 'randomNumber',
        description: 'Random number between 0-1000',
        example: FakeDataProvider.randomNumber(),
      ),
      _FakeDataItem(
        name: 'randomJson',
        description: 'Random JSON object with basic fields',
        example: FakeDataProvider.randomJson(),
      ),
    ];

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

  Widget _buildTableCell(BuildContext context, String text, {bool isHeader = false}) {
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
