import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
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

Color getAPIColor(
  APIType apiType, {
  HTTPVerb? method,
  Brightness? brightness,
}) {
  Color col = switch (apiType) {
    APIType.rest => getHTTPMethodColor(
        method,
      ),
    APIType.graphql => kColorGQL,
  };
  if (brightness == Brightness.dark) {
    col = getDarkModeColor(col);
  }
  return col;
}

Color getHTTPMethodColor(HTTPVerb? method) {
  Color col = switch (method) {
    HTTPVerb.get => kColorHttpMethodGet,
    HTTPVerb.head => kColorHttpMethodHead,
    HTTPVerb.post => kColorHttpMethodPost,
    HTTPVerb.put => kColorHttpMethodPut,
    HTTPVerb.patch => kColorHttpMethodPatch,
    HTTPVerb.delete => kColorHttpMethodDelete,
    _ => kColorHttpMethodGet,
  };
  return col;
}

Color getDarkModeColor(Color col) {
  return Color.alphaBlend(
    col.withValues(alpha: kOpacityDarkModeBlend),
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

GlobalKey<ScaffoldState> getScaffoldKey(int railIdx) {
  return switch (railIdx) {
    1 => kEnvScaffoldKey,
    2 => kHisScaffoldKey,
    _ => kHomeScaffoldKey,
  };
}
