import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  bool get isCompactWindow =>
      MediaQuery.of(this).size.width < kCompactWindowWidth;

  bool get isMediumWindow =>
      MediaQuery.of(this).size.width < kMediumWindowWidth;

  bool get isExpandedWindow =>
      MediaQuery.of(this).size.width < kExpandedWindowWidth;

  bool get isLargeWindow => MediaQuery.of(this).size.width < kLargeWindowWidth;

  bool get isExtraLargeWindow =>
      MediaQuery.of(this).size.width > kLargeWindowWidth;

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}
