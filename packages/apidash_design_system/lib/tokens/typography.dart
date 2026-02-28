import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

final kFontFamily = GoogleFonts.openSans().fontFamily;
final kFontFamilyFallback =
    !kIsWeb && (Platform.isIOS || Platform.isMacOS || Platform.isWindows)
        ? null
        : <String>[GoogleFonts.notoColorEmoji().fontFamily!];

final kCodeStyle = TextStyle(
  fontFamily: GoogleFonts.sourceCodePro().fontFamily,
  fontFamilyFallback: kFontFamilyFallback,
);

// const kTextStyleButton = TextStyle(fontWeight: FontWeight.bold);
TextStyle kTextStyleButton([double? scaleFactor = 1.0]) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14 * (scaleFactor ?? 1.0), // base fontSize 14
  );
}

kTextStyleTab(double? scaleFactor){
  return TextStyle(fontSize: 14 * (scaleFactor ?? 1));
}
kTextStyleButtonSmall(double? scaleFactor){
  return TextStyle(fontSize: 12 * (scaleFactor ?? 1));
}
kFormDataButtonLabelTextStyle(double? scaleFactor){
  return TextStyle(
  fontSize: 12 * (scaleFactor ?? 1),
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.ellipsis,);
}
kTextStylePopupMenuItem(double? scaleFactor){
  return TextStyle(fontSize: 14 * (scaleFactor ?? 1));
}
kTextStyleSmall(double? scaleFactor){
  return TextStyle(fontSize: 12 * (scaleFactor ?? 1));
}
kTextStyleMedium(double? scaleFactor){
  return TextStyle(fontSize: 14 * (scaleFactor ?? 1));
}
kTextStyleLarge(double? scaleFactor){
  return TextStyle(fontSize: 16 * (scaleFactor ?? 1));
}
kTextStyleXLarge(double? scaleFactor){
  return TextStyle(fontSize: 18 * (scaleFactor ?? 1));
}
kTextStyleXXLarge(double? scaleFactor){
  return TextStyle(fontSize: 20 * (scaleFactor ?? 1));
}
kTextStyleXXXLarge(double? scaleFactor){
  return TextStyle(fontSize: 22 * (scaleFactor ?? 1));
}
