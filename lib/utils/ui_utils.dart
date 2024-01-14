import 'package:flutter/material.dart';
import '../consts.dart';

Color getResponseStatusCodeColor(int? statusCode,
    {Brightness brightness = Brightness.light}) {
  Color col = kColorStatusCodeDefault;
  if (statusCode != null) {
    if (statusCode >= 200) {
      col = kColorStatusCode200;
    }
    if (statusCode >= 300) {
      col = kColorStatusCode300;
    }
    if (statusCode >= 400) {
      col = kColorStatusCode400;
    }
    if (statusCode >= 500) {
      col = kColorStatusCode500;
    }
  }
  if (brightness == Brightness.dark) {
    col = getDarkModeColor(col);
  }
  return col;
}

Color getHTTPMethodColor(HTTPVerb method,
    {Brightness brightness = Brightness.light}) {
  Color col;
  switch (method) {
    case HTTPVerb.get:
      col = kColorHttpMethodGet;
      break;
    case HTTPVerb.head:
      col = kColorHttpMethodHead;
      break;
    case HTTPVerb.post:
      col = kColorHttpMethodPost;
      break;
    case HTTPVerb.put:
      col = kColorHttpMethodPut;
      break;
    case HTTPVerb.patch:
      col = kColorHttpMethodPatch;
      break;
    case HTTPVerb.delete:
      col = kColorHttpMethodDelete;
      break;
  }
  if (brightness == Brightness.dark) {
    col = getDarkModeColor(col);
  }
  return col;
}

Color getDarkModeColor(Color col) {
  return Color.alphaBlend(
    col.withOpacity(kOpacityDarkModeBlend),
    kColorWhite,
  );
}

double? getJsonPreviewerMaxRootNodeWidth(double w) {
  if (w < 300) {
    return 150;
  }
  if (w < 400) {
    return 200;
  }
  return w - 150;
}
