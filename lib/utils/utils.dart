import 'package:flutter/material.dart';
import '../consts.dart';

Color getHTTPMethodColor(HTTPVerb method) {
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
  return col;
}

String getRequestTitleFromUrl(String? url) {
  if (url == null || url.trim() == "") {
    return "untitled";
  }
  if (url.contains("://")) {
    String rem = url.split("://")[1];
    if (rem.trim() == "") {
      return "untitled";
    }
    return rem;
  }
  return url;
}
