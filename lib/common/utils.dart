import 'package:flutter/material.dart';
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
