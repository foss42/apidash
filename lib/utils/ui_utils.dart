import 'package:flutter/material.dart';
import '../consts.dart';

Color getResponseStatusCodeColor(int? statusCode,
    {Brightness brightness = Brightness.light}) {
  Color col = Colors.grey.shade700;
  if (statusCode != null) {
    if (statusCode >= 200) {
      col = Colors.green.shade800;
    }
    if (statusCode >= 300) {
      col = Colors.blue.shade800;
    }
    if (statusCode >= 400) {
      col = Colors.red.shade800;
    }
    if (statusCode >= 500) {
      col = Colors.amber.shade900;
    }
  }
  if (brightness == Brightness.dark) {
    col = Color.alphaBlend(col.withOpacity(0.4), Colors.white);
  }
  return col;
}

Color getHTTPMethodColor(HTTPVerb method,
    {Brightness brightness = Brightness.light}) {
  Color col;
  switch (method) {
    case HTTPVerb.get:
      col = Colors.green.shade800;
      break;
    case HTTPVerb.head:
      col = Colors.green.shade800;
      break;
    case HTTPVerb.post:
      col = Colors.blue.shade800;
      break;
    case HTTPVerb.put:
      col = Colors.amber.shade900;
      break;
    case HTTPVerb.patch:
      col = Colors.amber.shade900;
      break;
    case HTTPVerb.delete:
      col = Colors.red.shade800;
      break;
  }
  if (brightness == Brightness.dark) {
    col = Color.alphaBlend(col.withOpacity(0.4), Colors.white);
  }
  return col;
}
