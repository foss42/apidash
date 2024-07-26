import 'package:apidash/consts.dart';
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
          icon: const Icon(Icons.edit_rounded),
          iconColor: Theme.of(context).colorScheme.primary,
          title: Text(dialogTitle),
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
                  onRename(val);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 100), () {
                    controller.dispose();
                  });
                },
                child: const Text('Ok')),
          ],
        );
      });
}
