import 'package:flutter/material.dart';
// import 'postman_collection.dart';
import 'package:postman/postman.dart';

// Helper class to track request items with unique IDs
class _RequestItem {
  final String id;
  final Item item;
  final String name;
  final String method;
  final String url;

  _RequestItem({
    required this.id,
    required this.item,
    required this.name,
    required this.method,
    required this.url,
  });
}

class RequestSelector extends StatefulWidget {
  final PostmanCollection collection;
  final Function(List<Item>) onSelectionChanged;

  const RequestSelector({
    Key? key,
    required this.collection,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<RequestSelector> createState() => _RequestSelectorState();
}

class _RequestSelectorState extends State<RequestSelector> {
  final Set<String> _selectedRequestIds = {};
  final List<_RequestItem> _orderedRequests = [];

  @override
  void initState() {
    super.initState();
    _initializeRequests();
  }

  void _initializeRequests() {
    // Process all items from the Postman collection
    if (widget.collection.item != null) {
      _processItems(widget.collection.item!);
    }

    // Initially select all requests
    _selectedRequestIds.addAll(_orderedRequests.map((r) => r.id));
    widget.onSelectionChanged(_getSelectedRequests());
  }

  void _processItems(List<Item> items, [String parentPath = '']) {
    for (var item in items) {
      if (item.request != null) {
        // This is a request item
        final method = item.request?.method ?? 'GET';
        final urlRaw = item.request?.url?.raw ?? '';
        final name = item.name ?? 'Unnamed Request';
        final id = '${parentPath}_${name}_$method';

        _orderedRequests.add(_RequestItem(
          id: id,
          item: item,
          name: name,
          method: method,
          url: urlRaw,
        ));
      } else if (item.item != null) {
        // This is a folder
        final folderName = item.name ?? 'Unnamed Folder';
        final newPath = parentPath.isEmpty ? folderName : '$parentPath/$folderName';
        _processItems(item.item!, newPath);
      }
    }
  }

  List<Item> _getSelectedRequests() {
    return _orderedRequests
        .where((request) => _selectedRequestIds.contains(request.id))
        .map((request) => request.item)
        .toList();
  }

  void _selectAll() {
    setState(() {
      _selectedRequestIds.addAll(_orderedRequests.map((r) => r.id));
      widget.onSelectionChanged(_getSelectedRequests());
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedRequestIds.clear();
      widget.onSelectionChanged(_getSelectedRequests());
    });
  }

  void _reset() {
    setState(() {
      _orderedRequests.clear();
      _initializeRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _selectAll,
                child: const Text('Select All'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _deselectAll,
                child: const Text('Deselect All'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _reset,
                child: const Text('Reset Order'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: _orderedRequests.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final request = _orderedRequests.removeAt(oldIndex);
                _orderedRequests.insert(newIndex, request);
                widget.onSelectionChanged(_getSelectedRequests());
              });
            },
            itemBuilder: (context, index) {
              final request = _orderedRequests[index];
              final isSelected = _selectedRequestIds.contains(request.id);

              return Card(
                key: ValueKey(request.id),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedRequestIds.add(request.id);
                            } else {
                              _selectedRequestIds.remove(request.id);
                            }
                            widget.onSelectionChanged(_getSelectedRequests());
                          });
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getMethodColor(request.method),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          request.method.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(request.name),
                  subtitle: Text(
                    request.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.drag_handle),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.orange;
      case 'PUT':
        return Colors.blue;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}