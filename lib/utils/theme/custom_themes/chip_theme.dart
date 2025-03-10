import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TChipTheme{
  TChipTheme._();

  static ChipThemeData lightChipTheme =  ChipThemeData(
    deleteIconColor: TColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: TColors.primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
  checkmarkColor: Colors.white,
  );

  static ChipThemeData darkChipTheme =  const ChipThemeData(
    deleteIconColor: TColors.darkerGrey,
    labelStyle: TextStyle(color: Colors.white),
    selectedColor: TColors.primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
    checkmarkColor: Colors.white,
  );
}