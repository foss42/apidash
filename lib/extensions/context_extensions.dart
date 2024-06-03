import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  bool get isMobile =>
      kIsMobile && MediaQuery.of(this).size.width < kMinWindowSize.width;
}
