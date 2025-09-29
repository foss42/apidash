import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/models.dart';
import 'dashbot_action_buttons/dashbot_actions_buttons.dart';

/// Base mixin for action widgets.
mixin DashbotActionMixin {
  ChatAction get action;
}

/// Factory to map an action to a widget.
class DashbotActionWidgetFactory {
  static Widget? build(ChatAction action) {
    switch (action.actionType) {
      case ChatActionType.other:
        if (action.action == 'import_now_openapi') {
          return DashbotImportNowButton(action: action);
        }
        if (action.field == 'select_operation') {
          return DashbotSelectOperationButton(action: action);
        }
        if (action.targetType == ChatActionTarget.test) {
          return DashbotAddTestButton(action: action);
        }
        if (action.targetType == ChatActionTarget.code) {
          return DashbotGeneratedCodeBlock(action: action);
        }
        break;
      case ChatActionType.showLanguages:
        if (action.targetType == ChatActionTarget.codegen) {
          return DashbotGenerateLanguagePicker(action: action);
        }
        break;
      case ChatActionType.applyCurl:
        return DashbotApplyCurlButton(action: action);
      case ChatActionType.applyOpenApi:
        if (action.action == 'import_now_openapi') {
          return DashbotImportNowButton(action: action);
        }
        return null;
      case ChatActionType.downloadDoc:
        return DashbotDownloadDocButton(action: action);
      case ChatActionType.noAction:
        if (action.action == 'import_now_openapi') {
          return DashbotImportNowButton(action: action);
        }
        return null;
      case ChatActionType.updateField:
      case ChatActionType.addHeader:
      case ChatActionType.updateHeader:
      case ChatActionType.deleteHeader:
      case ChatActionType.updateBody:
      case ChatActionType.updateUrl:
      case ChatActionType.updateMethod:
        return DashbotAutoFixButton(action: action);

      case ChatActionType.uploadAsset:
        if (action.targetType == ChatActionTarget.attachment) {
          return DashbotUploadRequestButton(action: action);
        }
        return null;
    }

    if (action.action == 'other' && action.target == 'test') {
      return DashbotAddTestButton(action: action);
    }
    if (action.action == 'other' && action.target == 'code') {
      return DashbotGeneratedCodeBlock(action: action);
    }
    if (action.action == 'show_languages' && action.target == 'codegen') {
      return DashbotGenerateLanguagePicker(action: action);
    }
    if (action.action == 'apply_curl') {
      return DashbotApplyCurlButton(action: action);
    }
    if (action.action.contains('update') ||
        action.action.contains('add') ||
        action.action.contains('delete')) {
      return DashbotAutoFixButton(action: action);
    }
    return null;
  }
}
