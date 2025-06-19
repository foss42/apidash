import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';

class SidebarRequestCardTextBox extends StatelessWidget {
  const SidebarRequestCardTextBox({
    super.key,
    required this.apiType,
    required this.method,
  });
  final APIType apiType;
  final HTTPVerb method;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Text(
        switch (apiType) {
          APIType.rest => method.abbr,
          APIType.graphql => apiType.abbr,
        },
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: getAPIColor(
            apiType,
            method: method,
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
