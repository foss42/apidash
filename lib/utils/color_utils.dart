import 'package:apidash_design_system/tokens/colors.dart';
import 'package:flutter/material.dart';

Color getMethodColor(String method) {
  switch (method.toUpperCase()) {
    case 'POST':
      return kColorHttpMethodPost;
    case 'PUT':
      return kColorHttpMethodPut;
    case 'DELETE':
      return kColorHttpMethodDelete;
    case 'PATCH':
      return kColorHttpMethodPatch;
    default:
      return kColorHttpMethodGet;
  }
}

Color getParamTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'path':
      return const Color(0xFFEF6C00);
    case 'query':
      return const Color(0xFF0277BD);
    case 'header':
      return const Color(0xFF7B1FA2);
    case 'body':
      return const Color(0xFF2E7D32);
    default:
      return const Color(0xFF424242);
  }
}

Color getStatusCodeColor(String statusCode) {
  final code = int.tryParse(statusCode) ?? 0;
  if (code >= 200 && code < 300) return kColorStatusCode200;
  if (code >= 300 && code < 400) return kColorStatusCode300;
  if (code >= 400 && code < 500) return kColorStatusCode400;
  if (code >= 500) return kColorStatusCode500;
  return kColorStatusCodeDefault;
}
