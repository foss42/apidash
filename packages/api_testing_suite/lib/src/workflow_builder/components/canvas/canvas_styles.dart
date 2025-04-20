import 'package:flutter/material.dart';

class CanvasStyles {
  static const EdgeInsets methodBadgePadding = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  static const double methodBadgeBorderRadius = 4;
  static const TextStyle methodBadgeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static Color methodBadgeColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
