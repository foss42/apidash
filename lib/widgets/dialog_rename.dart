import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

showRenameDialog(
  BuildContext context,
  String dialogTitle,
  String? name,
  Function(String) onRename,
) {
  showDialog(
      context: context,
      builder: (context) {
        return RenameDialogContent(
          dialogTitle: dialogTitle,
          onRename: onRename,
          name: name,
        );
      });
}

class RenameDialogContent extends StatefulWidget {
  const RenameDialogContent({
    super.key,
    required this.dialogTitle,
    required this.onRename,
    this.name,
  });

  final String dialogTitle;
  final Function(String) onRename;
  final String? name;

  @override
  State<RenameDialogContent> createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name ?? "");
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.edit_rounded),
      iconColor: Theme.of(context).colorScheme.primary,
      title: Text(widget.dialogTitle),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      content: Container(
        padding: kPt20,
        width: 300,
        child: TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(
              hintText: "Enter new name",
              border: OutlineInputBorder(
                borderRadius: kBorderRadius12,
              )),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              final val = controller.text.trim();
              widget.onRename(val);
              Navigator.pop(context);
            },
            child: const Text('Ok')),
      ],
    );
  }
}
