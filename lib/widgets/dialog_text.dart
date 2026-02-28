import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

showTextDialog(
  BuildContext context, {
  String? dialogTitle,
  String? content,
  String? buttonLabel,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.edit_rounded),
          iconColor: Theme.of(context).colorScheme.primary,
          title: Text(dialogTitle ?? ""),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          content: Container(
            padding: kPt20,
            width: 300,
            child: Text(content ?? ""),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(buttonLabel ?? kLabelOk)),
          ],
        );
      });
}
