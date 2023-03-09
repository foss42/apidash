import 'package:flutter/material.dart';
import 'package:davi/davi.dart';
import 'package:google_fonts/google_fonts.dart';

final codeStyle = GoogleFonts.sourceCodePro();

const textStyleButton = TextStyle(fontWeight: FontWeight.bold);

const colorBg = Colors.white;
final colorGrey50 = Colors.grey.shade50;
final colorGrey100 = Colors.grey.shade100;
final colorGrey200 = Colors.grey.shade200;
final colorGrey300 = Colors.grey.shade300;
final colorGrey400 = Colors.grey.shade400;
final colorGrey500 = Colors.grey.shade500;
final colorErrorMsg = colorGrey500;

final borderRadius10 = BorderRadius.circular(10);
const border12 = BorderRadius.all(Radius.circular(12));

const tableContainerDecoration = BoxDecoration(
  color: colorBg,
  borderRadius: border12,
);

const p5 = EdgeInsets.all(5);
const p10 = EdgeInsets.all(10);
