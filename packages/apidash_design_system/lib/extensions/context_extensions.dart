import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  bool get isCompactWindow =>
      MediaQuery.of(this).size.width < WindowWidth.compact.value;

  bool get isMediumWindow =>
      MediaQuery.of(this).size.width < WindowWidth.medium.value;

  bool get isExpandedWindow =>
      MediaQuery.of(this).size.width < WindowWidth.expanded.value;

  bool get isLargeWindow =>
      MediaQuery.of(this).size.width < WindowWidth.large.value;

  bool get isExtraLargeWindow =>
      MediaQuery.of(this).size.width > WindowWidth.large.value;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}
