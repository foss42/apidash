import 'package:apidash/dialogs/import/import_requests_dialog.dart';
import 'package:flutter/material.dart';

class DialogsWrapper {
  /// To import API requests from a HAR Archive File
  static importRequestsDialog(BuildContext context) => showAdaptiveDialog(
        context: context,
        builder: (context) => const ImportRequestsFromHARDialog(),
      );
}
