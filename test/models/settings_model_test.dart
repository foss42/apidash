import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:apidash/models/settings_model.dart';
import 'package:apidash/consts.dart';

void main() {
  const proxySettings = ProxySettings(
    host: 'localhost',
    port: '8080',
    username: 'user',
    password: 'pass',
  );

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
    proxySettings: proxySettings,
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
      "proxySettings": {
        "host": "localhost",
        "port": "8080",
        "username": "user",
        "password": "pass",
      },
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
      "proxySettings": {
        "host": "localhost",
        "port": "8080",
        "username": "user",
        "password": "pass",
      },
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
      proxySettings: null,
    );
    expect(
        sm.copyWith(
          isDark: true,
          saveResponses: false,
          isSSLDisabled: false,
          proxySettings: null,
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
  "isSSLDisabled": true,
  "proxySettings": {
    "host": "localhost",
    "port": "8080",
    "username": "user",
    "password": "pass"
  }
}''';
    expect(sm.toString(), expectedResult);
  });

  test('Testing proxy settings update', () {
    const newProxySettings = ProxySettings(
      host: 'proxy.example.com',
      port: '3128',
    );
    final updatedSettings = sm.copyWith(proxySettings: newProxySettings);
    expect(updatedSettings.proxySettings, newProxySettings);
  });

  test('Testing proxy settings disable', () {
    final disabledSettings = sm.copyWith(proxySettings: null);
    expect(disabledSettings.proxySettings, null);
  });

  test('Testing hashcode', () {
    expect(sm.hashCode, greaterThan(0));
  });
}
