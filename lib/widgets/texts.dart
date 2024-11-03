import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';

class MethodBox extends StatelessWidget {
  const MethodBox({super.key, required this.method});
  final HTTPVerb method;

  @override
  Widget build(BuildContext context) {
    String text = method.name.toUpperCase();
    if (method == HTTPVerb.delete) {
      text = "DEL";
    }
    if (method == HTTPVerb.patch) {
      text = "PAT";
    }
    return SizedBox(
      width: 24,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: getHTTPMethodColor(
            method,
            brightness: Theme.of(context).brightness,
          ),
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
    final Color color =
        getResponseStatusCodeColor(statusCode, brightness: brightness);
    return Text(
      statusCode.toString(),
      style: style?.copyWith(color: color) ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: kCodeStyle.fontFamily,
                color: color,
              ),
    );
  }
}
