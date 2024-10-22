import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class DragAndDropArea extends StatefulWidget {
  final Function(XFile)? onFileDropped;

  const DragAndDropArea({
    super.key,
    this.onFileDropped,
  });

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
        widget.onFileDropped?.call(detail.files[0]);
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
            ? Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.snippet_folder_rounded,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(kDataTableRowHeight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        var pickedResult = await pickFile();
                        if (pickedResult != null &&
                            pickedResult.path.isNotEmpty) {
                          widget.onFileDropped?.call(pickedResult);
                        }
                      },
                      label: const Text(
                        kLabelSelectFile,
                        overflow: TextOverflow.ellipsis,
                        style: kFormDataButtonLabelTextStyle,
                      ),
                    ),
                  ),
                  kVSpacer10,
                  const Text("Select or drop the file here"),
                ],
              ))
            : Text(_list.map((e) => e.path).join("\n")),
      ),
    );
  }
}
