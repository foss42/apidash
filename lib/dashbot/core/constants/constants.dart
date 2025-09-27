/// Role of a chat message author.
enum MessageRole { user, system }

enum ChatMessageType {
  explainResponse,
  debugError,
  generateTest,
  generateDoc,
  generateCode,
  importCurl,
  importOpenApi,
  general
}

enum ChatActionType {
  updateField,
  addHeader,
  updateHeader,
  deleteHeader,
  updateBody,
  updateUrl,
  updateMethod,
  showLanguages,
  applyCurl,
  applyOpenApi,
  downloadDoc,
  other,
  noAction,
  uploadAsset,
}

enum ChatActionTarget {
  httpRequestModel,
  codegen,
  test,
  code,
  attachment,
  documentation,
}

ChatActionType chatActionTypeFromString(String s) {
  switch (s) {
    case 'update_field':
      return ChatActionType.updateField;
    case 'add_header':
      return ChatActionType.addHeader;
    case 'update_header':
      return ChatActionType.updateHeader;
    case 'delete_header':
      return ChatActionType.deleteHeader;
    case 'update_body':
      return ChatActionType.updateBody;
    case 'update_url':
      return ChatActionType.updateUrl;
    case 'update_method':
      return ChatActionType.updateMethod;
    case 'show_languages':
      return ChatActionType.showLanguages;
    case 'apply_curl':
      return ChatActionType.applyCurl;
    case 'apply_openapi':
      return ChatActionType.applyOpenApi;
    case 'download_doc':
      return ChatActionType.downloadDoc;
    case 'upload_asset':
      return ChatActionType.uploadAsset;
    case 'no_action':
      return ChatActionType.noAction;
    case 'other':
      return ChatActionType.other;
    default:
      return ChatActionType.other;
  }
}

String chatActionTypeToString(ChatActionType t) {
  switch (t) {
    case ChatActionType.updateField:
      return 'update_field';
    case ChatActionType.addHeader:
      return 'add_header';
    case ChatActionType.updateHeader:
      return 'update_header';
    case ChatActionType.deleteHeader:
      return 'delete_header';
    case ChatActionType.updateBody:
      return 'update_body';
    case ChatActionType.updateUrl:
      return 'update_url';
    case ChatActionType.updateMethod:
      return 'update_method';
    case ChatActionType.showLanguages:
      return 'show_languages';
    case ChatActionType.applyCurl:
      return 'apply_curl';
    case ChatActionType.applyOpenApi:
      return 'apply_openapi';
    case ChatActionType.downloadDoc:
      return 'download_doc';
    case ChatActionType.other:
      return 'other';
    case ChatActionType.noAction:
      return 'no_action';
    case ChatActionType.uploadAsset:
      return 'upload_asset';
  }
}

ChatActionTarget chatActionTargetFromString(String s) {
  switch (s) {
    case 'httpRequestModel':
      return ChatActionTarget.httpRequestModel;
    case 'codegen':
      return ChatActionTarget.codegen;
    case 'test':
      return ChatActionTarget.test;
    case 'code':
      return ChatActionTarget.code;
    case 'attachment':
      return ChatActionTarget.attachment;
    case 'documentation':
      return ChatActionTarget.documentation;
    default:
      return ChatActionTarget.httpRequestModel;
  }
}

String chatActionTargetToString(ChatActionTarget t) {
  switch (t) {
    case ChatActionTarget.httpRequestModel:
      return 'httpRequestModel';
    case ChatActionTarget.codegen:
      return 'codegen';
    case ChatActionTarget.test:
      return 'test';
    case ChatActionTarget.code:
      return 'code';
    case ChatActionTarget.attachment:
      return 'attachment';
    case ChatActionTarget.documentation:
      return 'documentation';
  }
}
