import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';

Future<void> saveCollection(
  Map<String, dynamic> data,
  ScaffoldMessengerState sm,
) async {
  var message = "";
  try {
    var pth = await getFileDownloadpath(null, "har");
    if (pth != null) {
      await saveFile(pth, jsonMapToBytes(data));
      var sp = getShortPath(pth);
      message = 'Saved to $sp';
    }
  } catch (e) {
    message = "An error occurred while exporting.";
  }
  sm.hideCurrentSnackBar();
  sm.showSnackBar(getSnackBar(message, small: false));
}

Future<void> saveToDownloads(
  ScaffoldMessengerState sm, {
  Uint8List? content,
  String? mimeType,
  String? ext,
  String? name,
}) async {
  var message = "";
  var path = await getFileDownloadpath(
    name,
    ext ?? getFileExtension(mimeType),
  );
  if (path != null) {
    try {
      await saveFile(path, content!);
      var sp = getShortPath(path);
      message = 'Saved to $sp';
    } catch (e) {
      debugPrint("$e");
      message = "An error occurred while saving file.";
    }
  } else {
    message = "Unable to determine the download path.";
  }
  sm.hideCurrentSnackBar();
  sm.showSnackBar(getSnackBar(message, small: false));
}

Future<void> saveAndShowDialog(
  BuildContext context, {
  AsyncCallback? onSave,
}) async {
  final overlayWidget = OverlayWidgetTemplate(context: context);
  overlayWidget.show(widget: const SavingOverlay(saveCompleted: false));
  await onSave?.call();
  overlayWidget.hide();
  overlayWidget.show(widget: const SavingOverlay(saveCompleted: true));
  await Future.delayed(const Duration(seconds: 1));
  overlayWidget.hide();
}
