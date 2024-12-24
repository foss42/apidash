import 'package:apidash_core/apidash_core.dart';
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
    defaultUriScheme: SupportedUriSchemes.http,
    defaultCodeGenLang: CodegenLanguage.curl,
    saveResponses: true,
    promptBeforeClosing: true,
    activeEnvironmentId: null,
    historyRetentionPeriod: HistoryRetentionPeriod.oneWeek,
    workspaceFolderPath: null,
    isSSLDisabled: true,
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
      "promptBeforeClosing": true,
      "activeEnvironmentId": null,
      "historyRetentionPeriod": "oneWeek",
      "workspaceFolderPath": null,
      "isSSLDisabled": true,
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
      "promptBeforeClosing": true,
      "activeEnvironmentId": null,
      "historyRetentionPeriod": "oneWeek",
      "workspaceFolderPath": null,
      "isSSLDisabled": true,
    };
    expect(SettingsModel.fromJson(input), sm);
  });

  test('Testing copyWith()', () {
    const expectedResult = SettingsModel(
      isDark: true,
      alwaysShowCollectionPaneScrollbar: true,
      size: Size(300, 200),
      offset: Offset(100, 150),
      defaultUriScheme: SupportedUriSchemes.http,
      defaultCodeGenLang: CodegenLanguage.curl,
      saveResponses: false,
      promptBeforeClosing: true,
      activeEnvironmentId: null,
      historyRetentionPeriod: HistoryRetentionPeriod.oneWeek,
      isSSLDisabled: false,
    );
    expect(
        sm.copyWith(
          isDark: true,
          saveResponses: false,
          isSSLDisabled: false,
        ),
        expectedResult);
  });

  test('Testing toString()', () {
    const expectedResult = '''{
  "isDark": false,
  "alwaysShowCollectionPaneScrollbar": true,
  "width": 300.0,
  "height": 200.0,
  "dx": 100.0,
  "dy": 150.0,
  "defaultUriScheme": "http",
  "defaultCodeGenLang": "curl",
  "saveResponses": true,
  "promptBeforeClosing": true,
  "activeEnvironmentId": null,
  "historyRetentionPeriod": "oneWeek",
  "workspaceFolderPath": null,
  "isSSLDisabled": true
}''';
    expect(sm.toString(), expectedResult);
  });

  test('Testing hashcode', () {
    expect(sm.hashCode, greaterThan(0));
  });
}
