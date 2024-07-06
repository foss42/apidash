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
        final controller = TextEditingController(text: name ?? "");
        controller.selection =
            TextSelection(baseOffset: 0, extentOffset: controller.text.length);
        return AlertDialog(
          title: Text(dialogTitle),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: <Widget>[
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL')),
            FilledButton(
                onPressed: () {
                  final val = controller.text.trim();
                  onRename(val);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    controller.dispose();
                  });
                },
                child: const Text('OK')),
          ],
        );
      });
}
