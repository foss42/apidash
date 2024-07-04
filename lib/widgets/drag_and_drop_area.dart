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
          color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
          border: Border.all(color: Colors.white24),
        ),
        width: 600,
        height: 400,
        child: _list.isEmpty
            ? const Center(child: Text("Drop here"))
            : Text(_list.map((e) => e.path).join("\n")),
      ),
    );
  }
}
