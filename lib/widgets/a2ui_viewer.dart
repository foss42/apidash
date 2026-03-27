import 'package:flutter/material.dart';
import 'package:apidash/utils/genui_adapter.dart';

class A2UIViewer extends StatelessWidget {
  const A2UIViewer({
    super.key,
    required this.uiSpec,
  });

  final Map<String, dynamic> uiSpec;

  @override
  Widget build(BuildContext context) {
    return GenUIAdapter.build(uiSpec);
  }
}
