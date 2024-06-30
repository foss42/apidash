import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';

class ScreenSize {
  const ScreenSize(this.name, this.width, this.height, this.pixelDensity);
  final String name;
  final double width, height, pixelDensity;
}

const compactWidthDevice = ScreenSize('compact__width_device', 500, 600, 1);
const mediumWidthDevice = ScreenSize('medium__width_device', 800, 800, 1);
const largeWidthDevice = ScreenSize('large_width_device', 1300, 800, 1);

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
