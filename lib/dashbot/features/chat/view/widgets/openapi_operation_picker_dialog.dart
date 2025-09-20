import 'package:flutter/material.dart';
import 'package:openapi_spec/openapi_spec.dart';


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

  return showDialog<List<OpenApiOperationItem>>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setState) {
        return AlertDialog(
          title: Text('Import from $title'),
          content: SizedBox(
            width: 520,
            height: 420,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text('Available operations'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CheckboxListTile(
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
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: ops.length,
                        itemBuilder: (c, i) {
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
                  ],
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
}
