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
    isDashBotEnabled: true,
    defaultAIModel: {"model": "llama"},
    aiProviders: {
      "openai": {"apiKey": "sk-test"},
    },
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
      "isDashBotEnabled": true,
      "defaultAIModel": {"model": "llama"},
      "aiProviders": {
        "openai": {"apiKey": "sk-test"},
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
      "isDashBotEnabled": true,
      "defaultAIModel": {"model": "llama"},
      "aiProviders": {
        "openai": {"apiKey": "sk-test"},
      },
    };
    expect(SettingsModel.fromJson(input), sm);
  });

  test('Testing fromJson migrates aiProviders from defaultAIModel', () {
    const input = {
      "isDark": false,
      "defaultAIModel": {
        "modelApiProvider": "openai",
        "apiKey": "legacy-key",
        "model": "gpt-4o",
      },
    };
    final result = SettingsModel.fromJson(input);
    expect(result.aiProviders?['openai']?['apiKey'], 'legacy-key');
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
      isDashBotEnabled: false,
      defaultAIModel: {"model": "llama"},
      aiProviders: {
        "openai": {"apiKey": "sk-test"},
      },
    );
    expect(
      sm.copyWith(
        isDark: true,
        saveResponses: false,
        isSSLDisabled: false,
        isDashBotEnabled: false,
      ),
      expectedResult,
    );
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
  "isDashBotEnabled": true,
  "defaultAIModel": {
    "model": "llama"
  },
  "aiProviders": {
    "openai": {
      "apiKey": "sk-test"
    }
  }
}''';
    expect(sm.toString(), expectedResult);
  });

  test('Testing fromJson with custom aiProviders entry', () {
    const input = {
      "aiProviders": {
        "custom_abc": {
          "compat": "openai",
          "displayName": "OpenRouter",
          "apiKey": "or-key",
          "url": "https://openrouter.ai/api/v1/chat/completions",
          "models": ["anthropic/claude-sonnet"],
          "lastModel": "anthropic/claude-sonnet",
        },
      },
    };
    final result = SettingsModel.fromJson(input);
    expect(result.aiProviders?['custom_abc']?['displayName'], 'OpenRouter');
    expect(result.aiProviders?['custom_abc']?['compat'], 'openai');
  });

  test('Testing hashcode', () {
    expect(sm.hashCode, greaterThan(0));
  });
}
