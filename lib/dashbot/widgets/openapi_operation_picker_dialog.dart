import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';

typedef OpenApiOperationItem = ({String method, String path, Operation op});

Future<List<OpenApiOperationItem>?> showOpenApiOperationPickerDialog({
  required BuildContext context,
  required OpenApi spec,
  String? sourceName,
}) async {
  final title = (spec.info.title.trim().isNotEmpty
          ? spec.info.title.trim()
          : (sourceName ?? 'OpenAPI'))
      .trim();

  final ops = <OpenApiOperationItem>[];
  (spec.paths ?? const {}).forEach((path, item) {
    final map = <String, Operation?>{
      'GET': item.get,
      'POST': item.post,
      'PUT': item.put,
      'DELETE': item.delete,
      'PATCH': item.patch,
      'HEAD': item.head,
      'OPTIONS': item.options,
      'TRACE': item.trace,
    };
    map.forEach((method, op) {
      if (op != null) {
        ops.add((method: method, path: path, op: op));
      }
    });
  });

  if (ops.isEmpty) {
    // Nothing to select; return empty selection.
    return [];
  }

  // Multi-select: default select all
  final selected = <int>{for (var i = 0; i < ops.length; i++) i};
  bool selectAll = ops.isNotEmpty;
  String searchQuery = '';

  final scrollController = ScrollController();
  try {
    return await showDialog<List<OpenApiOperationItem>>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        final ds = DesignSystemProvider.of(context);
        return StatefulBuilder(builder: (ctx, setState) {
          // Filter operations based on search query
          final filteredOps = <int>[];
          for (int i = 0; i < ops.length; i++) {
            final o = ops[i];
            final label = '${o.method} ${o.path}'.toLowerCase();
            if (searchQuery.isEmpty ||
                label.contains(searchQuery.toLowerCase())) {
              filteredOps.add(i);
            }
          }

          return AlertDialog(
            title: Text('Import from $title'),
            content: SizedBox(
              width: 520*ds.scaleFactor,
              height: 420*ds.scaleFactor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TODO: Create a common Search field widget
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search routes',
                        hintText: 'Type to filter routes...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // Select all checkbox
                  CheckboxListTile(
                    value: selectAll,
                    onChanged: (v) {
                      setState(() {
                        selectAll = v ?? false;
                        selected
                          ..clear()
                          ..addAll(selectAll
                              ? List<int>.generate(ops.length, (i) => i)
                              : const <int>{});
                      });
                    },
                    title: const Text('Select all'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  // Routes list
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredOps.length,
                        itemBuilder: (c, index) {
                          final i = filteredOps[index];
                          final o = ops[i];
                          final label = '${o.method} ${o.path}';
                          final checked = selected.contains(i);
                          return CheckboxListTile(
                            value: checked,
                            onChanged: (v) {
                              setState(() {
                                if (v == true) {
                                  selected.add(i);
                                } else {
                                  selected.remove(i);
                                }
                                selectAll = selected.length == ops.length;
                              });
                            },
                            title: Text(label),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: selected.isEmpty
                    ? null
                    : () {
                        final result = selected.map((i) => ops[i]).toList();
                        Navigator.of(ctx).pop(result);
                      },
                child: const Text('Import'),
              ),
            ],
          );
        });
      },
    );
  } finally {
    scrollController.dispose();
  }
}
