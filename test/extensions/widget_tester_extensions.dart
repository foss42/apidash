import 'dart:async';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import '../test_consts.dart';

extension ScreenSizeManager on WidgetTester {
  Future<void> setScreenSize(ScreenSize screenSize) async {
    return _setScreenSize(
      width: screenSize.width,
      height: screenSize.height,
      pixelDensity: screenSize.pixelDensity,
    );
  }

  Future<void> _setScreenSize({
    required double width,
    required double height,
    required double pixelDensity,
  }) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    view.physicalSize = size;
    view.devicePixelRatio = pixelDensity;
  }
}

extension PumpUntilFound on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    bool found = false;
    final timer = Timer(
        timeout, () => throw TimeoutException("Pump until has timed out"));
    while (found != true) {
      await pump();
      found = any(finder);
    }
    timer.cancel();
  }
}
