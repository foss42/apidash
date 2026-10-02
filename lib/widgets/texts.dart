import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';

class SidebarRequestCardTextBox extends StatelessWidget {
  const SidebarRequestCardTextBox({super.key, required this.abbr, this.color});
  final String abbr;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Text(
        abbr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class StatusCode extends StatelessWidget {
  const StatusCode({super.key, required this.statusCode, this.style});
  final int statusCode;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final Color color = getResponseStatusCodeColor(
      statusCode,
      brightness: brightness,
    );
    return Text(
      statusCode.toString(),
      style:
          style?.copyWith(color: color) ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: kCodeStyle.fontFamily,
            color: color,
          ),
    );
  }
}
