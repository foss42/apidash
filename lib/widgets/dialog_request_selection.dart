import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

/// Shows a dialog to let user select which requests to import
Future<List<(String?, HttpRequestModel)>?> showRequestSelectionDialog({
  required BuildContext context,
  required List<(String?, HttpRequestModel)> requests,
}) async {
  if (requests.isEmpty) {
    return [];
  }

  // Track which requests are selected (all selected by default)
  final selectedIndices = List.generate(requests.length, (index) => index).toSet();

  return showDialog<List<(String?, HttpRequestModel)>?>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final selectedCount = selectedIndices.length;
          final totalCount = requests.length;

          return AlertDialog(
            title: const Text('Select Requests to Import'),
            content: SizedBox(
              width: 600,
              height: 400,
              child: Column(
                children: [
                  // Select All / Deselect All row
                  Row(
                    children: [
                      Checkbox(
                        value: selectedCount == totalCount,
                        tristate: true,
                        onChanged: (value) {
                          setState(() {
                            if (selectedCount == totalCount) {
                              selectedIndices.clear();
                            } else {
                              selectedIndices.addAll(
                                List.generate(requests.length, (i) => i),
                              );
                            }
                          });
                        },
                      ),
                      Text(
                        'Select All ($selectedCount of $totalCount)',
                        style: kTextStyleButton,
                      ),
                    ],
                  ),
                  kVSpacer8,
                  const Divider(),
                  kVSpacer8,
                  // List of requests
                  Expanded(
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final (name, request) = requests[index];
                        final isSelected = selectedIndices.contains(index);
                        final displayName = name ?? request.url;

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedIndices.add(index);
                              } else {
                                selectedIndices.remove(index);
                              }
                            });
                          },
                          title: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${request.method.name.toUpperCase()}',
                            style: kCodeStyle.copyWith(fontSize: 12),
                          ),
                          secondary: Container(
                            padding: kP8,
                            decoration: BoxDecoration(
                              color: kColorStatusCodeDefault.withOpacity(0.1),
                              borderRadius: kBorderRadius8,
                            ),
                            child: Text(
                              request.method.name.toUpperCase(),
                              style: kCodeStyle.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: selectedCount == 0
                    ? null
                    : () {
                        final selectedRequests = selectedIndices
                            .map((index) => requests[index])
                            .toList();
                        Navigator.of(context).pop(selectedRequests);
                      },
                child: Text('Import $selectedCount Request${selectedCount == 1 ? '' : 's'}'),
              ),
            ],
          );
        },
      );
    },
  );
}
