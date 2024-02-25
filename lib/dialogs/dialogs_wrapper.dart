import 'package:apidash/dialogs/import/imports_dialog_wrapper.dart';
import 'package:flutter/material.dart';

class DialogsWrapper {
  /// To import API requests from a Archive File
  static importRequestsDialog(BuildContext context) => showAdaptiveDialog(
        context: context,
        builder: (context) => const ImportDialogWrapper(),
      );
}
