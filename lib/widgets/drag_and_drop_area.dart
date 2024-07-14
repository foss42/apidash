import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class DragAndDropArea extends StatefulWidget {
  final Function(XFile) onFileDropped;

  const DragAndDropArea({super.key, required this.onFileDropped});

  @override
  State<DragAndDropArea> createState() => _DragAndDropAreaState();
}

class _DragAndDropAreaState extends State<DragAndDropArea> {
  final List<XFile> _list = [];
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        setState(() {
          _list.addAll(detail.files);
        });
        widget.onFileDropped(detail.files[0]);
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: _dragging
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        width: 600,
        height: 400,
        child: _list.isEmpty
            ? const Center(child: Text("Select or drop the file here"))
            : Text(_list.map((e) => e.path).join("\n")),
      ),
    );
  }
}
