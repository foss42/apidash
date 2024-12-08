import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/widgets.dart';

Future<void> saveCollection(
    Map<String, dynamic> data, ScaffoldMessengerState sm) async {
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

Future<void> saveData(BuildContext context, WidgetRef ref) async {
  final overlayWidget = OverlayWidgetTemplate(context: context);
  overlayWidget.show(widget: const SavingOverlay(saveCompleted: false));
  await ref.read(collectionStateNotifierProvider.notifier).saveData();
  await ref.read(environmentsStateNotifierProvider.notifier).saveEnvironments();
  overlayWidget.hide();
  overlayWidget.show(widget: const SavingOverlay(saveCompleted: true));
  await Future.delayed(const Duration(seconds: 1));
  overlayWidget.hide();
}
