import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart' as window_size;

bool _isValidPlatform() {
  if (kIsWeb) {
    return false;
  }
  return Platform.isLinux || Platform.isWindows || Platform.isMacOS;
}

/// Sets the position, size and title of the window.
Future<void> setInitialWindowProperties() async {
  if (!_isValidPlatform()) {
    return;
  }
  final window = await window_size.getWindowInfo();
  final screen = window.screen;
  if (screen == null) {
    return;
  }
  final screenFrame = screen.visibleFrame;
  final width = max((screenFrame.width / 2).roundToDouble(), 1200.0);
  final height = max((screenFrame.height / 2).roundToDouble(), 800.0);
  final left = ((screenFrame.width - width) / 2).roundToDouble();
  final top = ((screenFrame.height - height) / 3).roundToDouble();
  final frame = Rect.fromLTWH(left, top, width, height);
  window_size.setWindowFrame(frame);
  window_size.setWindowMinSize(const Size(900, 600));
  window_size.setWindowMaxSize(Size.infinite);
  window_size.setWindowTitle("API Dash");
}
