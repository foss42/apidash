import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart' as window_size;
import '../consts.dart';

Future<void> setupInitialWindow(Size? sz) async {
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await window_size.getWindowInfo().then((window) {
        final screen = window.screen;
        if (screen != null) {
          final screenFrame = screen.visibleFrame;
          double width, height;
          if (sz == null) {
            width = math.max((screenFrame.width / 2).roundToDouble(),
                kMinInitialWindowWidth);
            height = math.max((screenFrame.height / 2).roundToDouble(),
                kMinInitialWindowHeight);
          } else {
            width = sz.width;
            height = sz.height;
          }
          final left = ((screenFrame.width - width) / 2).roundToDouble();
          final top = ((screenFrame.height - height) / 3).roundToDouble();
          final frame = Rect.fromLTWH(left, top, width, height);
          window_size.setWindowFrame(frame);
          window_size.setWindowMinSize(kMinWindowSize);
          window_size.setWindowMaxSize(Size.infinite);
          window_size.setWindowTitle(kWindowTitle);
        }
      });
    }
  }
}

Future<void> resetWindowSize() async {
  await setupInitialWindow(null);
}
