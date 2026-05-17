import 'package:flutter/material.dart';

SnackBar getSnackBar(
  String text, {
  bool small = true,
  Color? color,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 4), 
}) {
  return SnackBar(
    width: small ? 300 : 500,
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    duration: duration,
    content: Text(
      text,
      softWrap: true,
      textAlign: TextAlign.center,
    ),
    action: action,
    showCloseIcon: true,
  );
}
