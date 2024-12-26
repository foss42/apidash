import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

final kFontFamily = GoogleFonts.openSans().fontFamily;
final kFontFamilyFallback = !kIsWeb && (Platform.isIOS || Platform.isMacOS)
    ? null
    : <String>[GoogleFonts.notoColorEmoji().fontFamily!];

final kCodeStyle = TextStyle(
  fontFamily: GoogleFonts.sourceCodePro().fontFamily,
  fontFamilyFallback: kFontFamilyFallback,
);

const kTextStyleButton = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleTab = TextStyle(fontSize: 14);
const kTextStyleButtonSmall = TextStyle(fontSize: 12);
const kFormDataButtonLabelTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  overflow: TextOverflow.ellipsis,
);
const kTextStylePopupMenuItem = TextStyle(fontSize: 14);
