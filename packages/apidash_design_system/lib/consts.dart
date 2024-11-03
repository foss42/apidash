import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorTransparentState =
    WidgetStateProperty.all<Color>(Colors.transparent);
const kColorTransparent = Colors.transparent;
const kColorWhite = Colors.white;
const kColorBlack = Colors.black;
const kColorRed = Colors.red;
final kColorLightDanger = Colors.red.withOpacity(0.9);
const kColorDarkDanger = Color(0xffcf6679);

const kColorSchemeSeed = Colors.blue;
final kFontFamily = GoogleFonts.openSans().fontFamily;
final kFontFamilyFallback = !kIsWeb && (Platform.isIOS || Platform.isMacOS)
    ? null
    : <String>[GoogleFonts.notoColorEmoji().fontFamily!];

final kLightMaterialAppTheme = ThemeData(
  fontFamily: kFontFamily,
  fontFamilyFallback: kFontFamilyFallback,
  colorSchemeSeed: kColorSchemeSeed,
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
final kDarkMaterialAppTheme = ThemeData(
  fontFamily: kFontFamily,
  fontFamilyFallback: kFontFamilyFallback,
  colorSchemeSeed: kColorSchemeSeed,
  useMaterial3: true,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final kCodeStyle = TextStyle(
  fontFamily: GoogleFonts.sourceCodePro().fontFamily,
  fontFamilyFallback: kFontFamilyFallback,
);

const kHintOpacity = 0.6;
const kForegroundOpacity = 0.05;
const kOverlayBackgroundOpacity = 0.5;

const kTextStyleButton = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleTab = TextStyle(fontSize: 14);
const kTextStyleButtonSmall = TextStyle(fontSize: 12);
const kFormDataButtonLabelTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);
const kTextStylePopupMenuItem = TextStyle(fontSize: 14);

final kButtonSidebarStyle = ElevatedButton.styleFrom(padding: kPh12);

const kBorderRadius4 = BorderRadius.all(Radius.circular(4));
const kBorderRadius6 = BorderRadius.all(Radius.circular(6));
const kBorderRadius8 = BorderRadius.all(Radius.circular(8));
final kBorderRadius10 = BorderRadius.circular(10);
const kBorderRadius12 = BorderRadius.all(Radius.circular(12));
const kBorderRadius20 = BorderRadius.all(Radius.circular(20));

const kP1 = EdgeInsets.all(1);
const kP4 = EdgeInsets.all(4);
const kP5 = EdgeInsets.all(5);
const kP6 = EdgeInsets.all(6);
const kP8 = EdgeInsets.all(8);
const kPs8 = EdgeInsets.only(left: 8);
const kPs2 = EdgeInsets.only(left: 2);
const kPe4 = EdgeInsets.only(right: 4);
const kPe8 = EdgeInsets.only(right: 8);
const kPh20v5 = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
const kPh20v10 = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
const kP10 = EdgeInsets.all(10);
const kPv2 = EdgeInsets.symmetric(vertical: 2);
const kPv6 = EdgeInsets.symmetric(vertical: 6);
const kPv8 = EdgeInsets.symmetric(vertical: 8);
const kPv10 = EdgeInsets.symmetric(vertical: 10);
const kPv20 = EdgeInsets.symmetric(vertical: 20);
const kPh2 = EdgeInsets.symmetric(horizontal: 2);
const kPt28o8 = EdgeInsets.only(top: 28, left: 8.0, right: 8.0, bottom: 8.0);
const kPt5o10 =
    EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 10.0);
const kPh4 = EdgeInsets.symmetric(horizontal: 4);
const kPh8 = EdgeInsets.symmetric(horizontal: 8);
const kPh12 = EdgeInsets.symmetric(horizontal: 12);
const kPh20 = EdgeInsets.symmetric(horizontal: 20);
const kPh24 = EdgeInsets.symmetric(horizontal: 24);
const kPh20t40 = EdgeInsets.only(
  left: 20,
  right: 20,
  top: 40,
);
const kPs0o6 = EdgeInsets.only(
  left: 0,
  top: 6,
  right: 6,
  bottom: 6,
);
const kPh60 = EdgeInsets.symmetric(horizontal: 60);
const kPh60v60 = EdgeInsets.symmetric(vertical: 60, horizontal: 60);
const kP24CollectionPane = EdgeInsets.only(
  top: 24,
  left: 4.0,
  //right: 4.0,
  // bottom: 8.0,
);
const kP8CollectionPane = EdgeInsets.only(
  top: 8.0,
  left: 4.0,
  //right: 4.0,
  // bottom: 8.0,
);
const kPt8 = EdgeInsets.only(
  top: 8,
);
const kPt20 = EdgeInsets.only(
  top: 20,
);
const kPt24 = EdgeInsets.only(
  top: 24,
);
const kPt28 = EdgeInsets.only(
  top: 28,
);
const kPt32 = EdgeInsets.only(
  top: 32,
);
const kPb10 = EdgeInsets.only(
  bottom: 10,
);
const kPb15 = EdgeInsets.only(
  bottom: 15,
);
const kPb70 = EdgeInsets.only(
  bottom: 70,
);
const kSizedBoxEmpty = SizedBox();
const kHSpacer2 = SizedBox(width: 2);
const kHSpacer4 = SizedBox(width: 4);
const kHSpacer5 = SizedBox(width: 5);
const kHSpacer10 = SizedBox(width: 10);
const kHSpacer12 = SizedBox(width: 12);
const kHSpacer20 = SizedBox(width: 20);
const kHSpacer40 = SizedBox(width: 40);
const kVSpacer5 = SizedBox(height: 5);
const kVSpacer8 = SizedBox(height: 8);
const kVSpacer10 = SizedBox(height: 10);
const kVSpacer16 = SizedBox(height: 16);
const kVSpacer20 = SizedBox(height: 20);
const kVSpacer40 = SizedBox(height: 40);

const kLightCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xffffffff), color: Color(0xff000000)),
  'addition': TextStyle(backgroundColor: Color(0xffbaeeba)),
  'attr': TextStyle(color: Color(0xff836C28)),
  'attribute': TextStyle(color: Color(0xffaa0d91)),
  'built_in': TextStyle(color: Color(0xff5c2699)),
  'builtin-name': TextStyle(color: Color(0xff5c2699)),
  'bullet': TextStyle(color: Color(0xff1c00cf)),
  'code': TextStyle(color: Color(0xffc41a16)),
  'comment': TextStyle(color: Color(0xff007400), fontStyle: FontStyle.italic),
  'deletion': TextStyle(backgroundColor: Color(0xffffc8bd)),
  'doctag': TextStyle(fontWeight: FontWeight.bold),
  'emphasis': TextStyle(fontStyle: FontStyle.italic),
  'formula': TextStyle(
      backgroundColor: Color(0xffeeeeee), fontStyle: FontStyle.italic),
  'keyword': TextStyle(color: Color(0xffaa0d91)),
  'link': TextStyle(color: Color(0xff0E0EFF)),
  'literal': TextStyle(color: Color(0xffaa0d91)),
  'meta': TextStyle(color: Color(0xff643820)),
  'meta-string': TextStyle(color: Color(0xffc41a16)),
  'name': TextStyle(color: Color(0xffaa0d91)),
  'number': TextStyle(color: Color(0xff1c00cf)),
  'params': TextStyle(color: Color(0xff5c2699)),
  'quote': TextStyle(color: Color(0xff007400)),
  'regexp': TextStyle(color: Color(0xff0E0EFF)),
  'section': TextStyle(color: Color(0xff643820)),
  'selector-class': TextStyle(color: Color(0xff9b703f)),
  'selector-id': TextStyle(color: Color(0xff9b703f)),
  'selector-tag': TextStyle(color: Color(0xffaa0d91)),
  'string': TextStyle(color: Color(0xffc41a16)),
  'strong': TextStyle(fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xff000000)),
  'symbol': TextStyle(color: Color(0xff1c00cf)),
  'tag': TextStyle(color: Color(0xffaa0d91)),
  'template-variable': TextStyle(color: Color(0xff3F6E74)),
  'title': TextStyle(color: Color(0xff1c00cf)),
  'type': TextStyle(color: Color(0xff5c2699)),
  'variable': TextStyle(color: Color(0xff3F6E74)),
};

const kDarkCodeTheme = {
  'root':
      TextStyle(backgroundColor: Color(0xff011627), color: Color(0xffd6deeb)),
  'addition': TextStyle(color: Color(0xffaddb67)),
  'attr': TextStyle(color: Color(0xff7fdbca)),
  'attribute': TextStyle(color: Color(0xff80cbc4)),
  'built_in': TextStyle(color: Color(0xffaddb67)),
  'builtin-name': TextStyle(color: Color(0xff7fdbca)),
  'bullet': TextStyle(color: Color(0xffd9f5dd)),
  'class': TextStyle(color: Color(0xffffcb8b)),
  'code': TextStyle(color: Color(0xff80CBC4)),
  'comment': TextStyle(color: Color(0xff637777), fontStyle: FontStyle.italic),
  'deletion': TextStyle(color: Color(0xffef5350)),
  'doctag': TextStyle(color: Color(0xff7fdbca)),
  'emphasis': TextStyle(color: Color(0xffc792ea)),
  'formula': TextStyle(color: Color(0xffc792ea), fontStyle: FontStyle.italic),
  'function': TextStyle(color: Color(0xff82AAFF)),
  'keyword': TextStyle(color: Color(0xffc792ea)),
  'link': TextStyle(color: Color(0xffff869a)),
  'literal': TextStyle(color: Color(0xffff5874)),
  'meta': TextStyle(color: Color(0xff82aaff)),
  'meta-keyword': TextStyle(color: Color(0xff82aaff)),
  'meta-string': TextStyle(color: Color(0xffecc48d)),
  'name': TextStyle(color: Color(0xff7fdbca)),
  'number': TextStyle(color: Color(0xffF78C6C)),
  'params': TextStyle(color: Color(0xff7fdbca)),
  'quote': TextStyle(color: Color(0xff697098)),
  'regexp': TextStyle(color: Color(0xff5ca7e4)),
  'section': TextStyle(color: Color(0xff82b1ff)),
  'selector-attr': TextStyle(color: Color(0xffc792ea)),
  'selector-class': TextStyle(color: Color(0xffaddb67)),
  'selector-id': TextStyle(color: Color(0xfffad430)),
  'selector-pseudo': TextStyle(color: Color(0xffc792ea)),
  'selector-tag': TextStyle(color: Color(0xffff6363)),
  'string': TextStyle(color: Color(0xffecc48d)),
  'strong': TextStyle(color: Color(0xffaddb67), fontWeight: FontWeight.bold),
  'subst': TextStyle(color: Color(0xffd3423e)),
  'symbol': TextStyle(color: Color(0xff82aaff)),
  'tag': TextStyle(color: Color(0xff7fdbca)),
  'template-tag': TextStyle(color: Color(0xffc792ea)),
  'template-variable': TextStyle(color: Color(0xffaddb67)),
  'title': TextStyle(color: Color(0xffDCDCAA)),
  'type': TextStyle(color: Color(0xff82aaff)),
  'variable': TextStyle(color: Color(0xffaddb67)),
};

final kColorStatusCodeDefault = Colors.grey.shade700;
final kColorStatusCode200 = Colors.green.shade800;
final kColorStatusCode300 = Colors.blue.shade800;
final kColorStatusCode400 = Colors.red.shade800;
final kColorStatusCode500 = Colors.amber.shade900;
const kOpacityDarkModeBlend = 0.4;

final kColorHttpMethodGet = Colors.green.shade800;
final kColorHttpMethodHead = kColorHttpMethodGet;
final kColorHttpMethodPost = Colors.blue.shade800;
final kColorHttpMethodPut = Colors.amber.shade900;
final kColorHttpMethodPatch = kColorHttpMethodPut;
final kColorHttpMethodDelete = Colors.red.shade800;
