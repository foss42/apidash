import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';

Future<List<(String?, HttpRequestModel)>?> showOpenApiSelectionDialog({
  required BuildContext context,
  required List<(String?, HttpRequestModel)> requests,
}) async {
  // Start with all selected
  final selectedItems = List<bool>.filled(requests.length, true);
  bool selectAll = true;
  
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(  // Use StatefulBuilder to handle state
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Select API Endpoints'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Found ${requests.length} endpoints in the OpenAPI specification.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                const Text('Select the endpoints you want to import:'),
                const SizedBox(height: 16),
                // Add a "Select All" checkbox
                CheckboxListTile(
                  title: const Text('Select All'),
                  value: selectAll,
                  onChanged: (value) {
                    setState(() {
                      selectAll = value ?? false;
                      for (int i = 0; i < selectedItems.length; i++) {
                        selectedItems[i] = selectAll;
                      }
                    });
                  },
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final name = request.$1 ?? 'Unnamed Request';
                      final method = request.$2.method;
                      
                      return CheckboxListTile(
                        title: Text(name),
                        subtitle: Text('${method.name} ${request.$2.url}'),
                        value: selectedItems[index],
                        onChanged: (value) {
                          setState(() {  // This updates the UI when checkbox changes
                            selectedItems[index] = value ?? false;
                            // Update "Select All" checkbox state
                            selectAll = selectedItems.every((element) => element);
                          });
                        },
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
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Import Selected'),
            ),
          ],
        );
      }
    ),
  );
  
  if (result == true) {
    return [
      for (int i = 0; i < requests.length; i++)
        if (selectedItems[i]) requests[i]
    ];
  }
  
  return null;
}