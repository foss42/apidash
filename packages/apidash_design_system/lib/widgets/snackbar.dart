import 'package:flutter/material.dart';

SnackBar getSnackBar(
  String text, {
  bool small = true,
}) {
  return SnackBar(
    width: small ? 300 : 500,
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      softWrap: true,
      textAlign: TextAlign.center,
    ),
    showCloseIcon: true,
  );
}
