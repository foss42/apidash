import 'dart:math' as math;

import 'package:flutter/material.dart';

extension TextEditingControllerExtension on TextEditingController {
  void insert(String string) {
    int offset = math.min(selection.baseOffset, selection.extentOffset);
    String text =
        this.text.substring(0, offset) + string + this.text.substring(offset);
    value = TextEditingValue(
      text: text,
      selection: selection.copyWith(
        baseOffset: selection.baseOffset + string.length,
        extentOffset: selection.extentOffset + string.length,
      ),
    );
  }
}
