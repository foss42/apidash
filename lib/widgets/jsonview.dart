import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';

final jsonViewTheme = JsonViewTheme(
  defaultTextStyle: codeStyle,
  viewType: JsonViewType.collapsible,
  backgroundColor: colorBg,
  stringStyle: const TextStyle(color: Colors.brown),
  closeIcon: const Icon(
    Icons.arrow_drop_up,
    size: 18,
  ),
  openIcon: const Icon(
    Icons.arrow_drop_down,
    size: 18,
  ),
);
