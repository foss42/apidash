import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/settings_model.dart';
import 'package:apidash/consts.dart';

void main() {
  const sm = SettingsModel(
    isDark: false,
    alwaysShowCollectionPaneScrollbar: true,
    size: Size(300, 200),
    offset: Offset(100, 150),
    defaultUriScheme: "http",
    defaultCodeGenLang: CodegenLanguage.curl,
    saveResponses: true,
  );

  test('Testing toJson()', () {
    const expectedResult = {
      "isDark": false,
      "alwaysShowCollectionPaneScrollbar": true,
      "width": 300.0,
      "height": 200.0,
      "dx": 100.0,
      "dy": 150.0,
      "defaultUriScheme": "http",
      "defaultCodeGenLang": "curl",
      "saveResponses": true,
    };
    expect(sm.toJson(), expectedResult);
  });

  test('Testing fromJson()', () {
    const input = {
      "isDark": false,
      "alwaysShowCollectionPaneScrollbar": true,
      "width": 300.0,
      "height": 200.0,
      "dx": 100.0,
      "dy": 150.0,
      "defaultUriScheme": "http",
      "defaultCodeGenLang": "curl",
      "saveResponses": true,
    };
    expect(SettingsModel.fromJson(input), sm);
  });

  test('Testing copyWith()', () {
    const expectedResult = SettingsModel(
      isDark: true,
      alwaysShowCollectionPaneScrollbar: true,
      size: Size(300, 200),
      offset: Offset(100, 150),
      defaultUriScheme: "http",
      defaultCodeGenLang: CodegenLanguage.curl,
      saveResponses: false,
    );
    expect(
        sm.copyWith(
          isDark: true,
          saveResponses: false,
        ),
        expectedResult);
  });

  test('Testing toString()', () {
    const expectedResult =
        "{isDark: false, alwaysShowCollectionPaneScrollbar: true, width: 300.0, height: 200.0, dx: 100.0, dy: 150.0, defaultUriScheme: http, defaultCodeGenLang: curl, saveResponses: true}";
    expect(sm.toString(), expectedResult);
  });

  test('Testing hashcode', () {
    expect(sm.hashCode, greaterThan(0));
  });
}
