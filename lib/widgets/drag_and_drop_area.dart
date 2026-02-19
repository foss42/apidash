import 'package:apidash_design_system/ui/design_system_provider.dart';
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
    final ds = DesignSystemProvider.of(context);
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
        width: 600*ds.scaleFactor,
        height: 400*ds.scaleFactor,
        child: _list.isEmpty
            ? Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 150*ds.scaleFactor,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.snippet_folder_rounded,
                        size: 20*ds.scaleFactor,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(kDataTableRowHeight*ds.scaleFactor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6*ds.scaleFactor),
                        ),
                      ),
                      onPressed: () async {
                        var pickedResult = await pickFile();
                        if (pickedResult != null &&
                            pickedResult.path.isNotEmpty) {
                          widget.onFileDropped?.call(pickedResult);
                        }
                      },
                      label: Text(
                        kLabelSelectFile,
                        overflow: TextOverflow.ellipsis,
                        style: kFormDataButtonLabelTextStyle(ds.scaleFactor),
                      ),
                    ),
                  ),
                  kVSpacer10(ds.scaleFactor),
                  const Text("Select or drop the file here"),
                ],
              ))
            : Text(_list.map((e) => e.path).join("\n")),
      ),
    );
  }
}
