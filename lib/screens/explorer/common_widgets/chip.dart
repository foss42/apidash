import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import "package:apidash/consts.dart";

class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final VisualDensity visualDensity;

  const CustomChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.visualDensity = VisualDensity.compact,
  });

  factory CustomChip.httpMethod(String method) {
    Color color;
    switch (method.toUpperCase()) {
      case 'GET':
        color = kColorHttpMethodGet;
        break;
      case 'HEAD':
        color = kColorHttpMethodHead;
        break;
      case 'POST':
        color = kColorHttpMethodPost;
        break;
      case 'PUT':
        color = kColorHttpMethodPut;
        break;
      case 'PATCH':
        color = kColorHttpMethodPatch;
        break;
      case 'DELETE':
        color = kColorHttpMethodDelete;
        break;
      default:
        color = Colors.grey.shade700;
    }
    return CustomChip(
      label: method.toUpperCase(),
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      borderColor: color,
    );
  }

  factory CustomChip.statusCode(int status) {
    Color color;
    if (status >= 200 && status < 300) {
      color = kColorStatusCode200;
    } else if (status >= 300 && status < 400) {
      color = kColorStatusCode300;
    } else if (status >= 400 && status < 500) {
      color = kColorStatusCode400;
    } else if (status >= 500) {
      color = kColorStatusCode500;
    } else {
      color = kColorStatusCodeDefault;
    }

    String reason = kResponseCodeReasons[status] ?? '';
    String label = reason.isNotEmpty ? '$status - $reason' : '$status';
    return CustomChip(
      label: label,
      backgroundColor: color.withOpacity(0.1),
      textColor: color,
      borderColor: color,
    );
  }

  factory CustomChip.contentType(String contentType) {
    return CustomChip(
      label: contentType,
      backgroundColor: Colors.blue.withOpacity(0.1),
      textColor: Colors.blue, 
      borderColor: Colors.blue,
    );
  }

  factory CustomChip.tag(String tag, ColorScheme colorScheme) {
    return CustomChip(
      label: tag,
      fontSize: 10, 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
      backgroundColor: colorScheme.primary.withOpacity(0.1),
      textColor: colorScheme.primary,
      borderColor: colorScheme.primary.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.outline,
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: fontWeight,
          color: textColor ?? Theme.of(context).colorScheme.onSurface,
          fontSize: fontSize,
        ),
      ),
    );
  }
}