import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

showOkCancelDialog(
  BuildContext context, {
  String? dialogTitle,
  String? content,
  String? buttonLabelOk,
  VoidCallback? onClickOk,
  String? buttonLabelCancel,
  VoidCallback? onClickCancel,
}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                onClickCancel?.call();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(buttonLabelCancel ?? kLabelCancel),
            ),
            TextButton(
              onPressed: () {
                onClickOk?.call();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(buttonLabelOk ?? kLabelOk),
            ),
          ],
        );
      });
}
