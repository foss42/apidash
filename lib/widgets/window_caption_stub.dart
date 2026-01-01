import 'package:flutter/material.dart';

class WindowCaption extends StatelessWidget {
  const WindowCaption({
    super.key,
    this.backgroundColor,
    this.brightness,
  });

  final Color? backgroundColor;
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
