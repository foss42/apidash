import 'dart:math';
import 'package:flutter/material.dart';

/// Generate a random color that is visually distinct from existing colors
String generateRandomDistinctColor(List<String> existingColors) {
  final Random random = Random();
  
  // Convert existing colors to HSV for better comparison
  final List<HSVColor> existingHsvColors = existingColors
      .where((color) => color.isNotEmpty)
      .map((colorHex) {
        try {
          final Color color = Color(int.parse(colorHex.replaceFirst('#', ''), radix: 16) | 0xFF000000);
          return HSVColor.fromColor(color);
        } catch (e) {
          // Return a default color if parsing fails
          return HSVColor.fromColor(Colors.grey);
        }
      })
      .toList();
  
  // Parameters to ensure good color diversity
  const double minSaturation = 0.5;
  const double maxSaturation = 0.9;
  const double minValue = 0.7;
  const double maxValue = 0.9;
  
  // Number of attempts to find a distinct color
  const int maxAttempts = 20;
  
  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    // Generate a random HSV color with good saturation and value
    double hue = random.nextDouble() * 360;
    double saturation = minSaturation + random.nextDouble() * (maxSaturation - minSaturation);
    double value = minValue + random.nextDouble() * (maxValue - minValue);
    
    HSVColor newColor = HSVColor.fromAHSV(1.0, hue, saturation, value);
    
    // Check if the color is distinct enough from existing colors
    bool isDistinct = true;
    for (HSVColor existingColor in existingHsvColors) {
      // Calculate distance in hue space (0-360)
      double hueDiff = (existingColor.hue - newColor.hue).abs();
      if (hueDiff > 180) hueDiff = 360 - hueDiff; // Take the shorter arc on the color wheel
      
      // If colors are too similar, mark as not distinct
      if (hueDiff < 30 && 
          (existingColor.saturation - newColor.saturation).abs() < 0.2 &&
          (existingColor.value - newColor.value).abs() < 0.2) {
        isDistinct = false;
        break;
      }
    }
    
    if (isDistinct || existingHsvColors.isEmpty) {
      // Convert to hex without alpha channel
      String hex = newColor.toColor().value.toRadixString(16).padLeft(8, '0').substring(2);
      return hex;
    }
  }
  
  // If we couldn't find a distinct color, generate a random one as fallback
  final Color randomColor = Color.fromRGBO(
    random.nextInt(200) + 55, // Avoid very dark colors
    random.nextInt(200) + 55,
    random.nextInt(200) + 55,
    1.0,
  );
  
  return randomColor.value.toRadixString(16).padLeft(8, '0').substring(2);
}

/// Convert a color hex string to a Color object
Color hexToColor(String hexString) {
  if (hexString.isEmpty) {
    return Colors.transparent;
  }
  
  try {
    final hexCode = hexString.replaceFirst('#', '');
    return Color(int.parse(hexCode, radix: 16) | 0xFF000000);
  } catch (e) {
    return Colors.grey;
  }
}

/// Convert a Color object to a hex string
String colorToHex(Color color) {
  return color.value.toRadixString(16).padLeft(8, '0').substring(2);
}
