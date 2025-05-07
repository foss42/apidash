import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text));
  _showCopySnackbar(context);
}

void _showCopySnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Copied to clipboard'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
