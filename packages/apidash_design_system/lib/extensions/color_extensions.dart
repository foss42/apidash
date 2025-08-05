import 'package:flutter/material.dart';
import '../tokens/colors.dart';

extension ColorExtension on Color {
  Color get toDark => Color.alphaBlend(
        withValues(alpha: kOpacityDarkModeBlend),
        kColorWhite,
      );
}
