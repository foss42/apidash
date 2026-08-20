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
  explainWsConnection,
  debugWsConnection,
  summarizeWsMessages,
  generateWsCode,
  findInWsMessages,
  generateWsDoc,
  generateWsTest,
  explainWsMessage,
  debugWsMessage,
  wsConnectionHealth,
  explainMqttConnection,
  debugMqttConnection,
  whyNoMqttMessages,
  summarizeMqttMessages,
  explainMqttTopics,
  mqttSessionAdvisor,
  generateMqttCode,
  explainMqttLwt,
  explainMqttV5,
  findInMqttMessages,
  general,
}

enum ChatActionType {
  updateField('update_field'),
  addHeader('add_header'),
  updateHeader('update_header'),
  deleteHeader('delete_header'),
  updateBody('update_body'),
  updateUrl('update_url'),
  updateMethod('update_method'),
  showLanguages('show_languages'),
  applyCurl('apply_curl'),
  applyOpenApi('apply_openapi'),
  downloadDoc('download_doc'),
  other('other'),
  noAction('no_action'),
  uploadAsset('upload_asset');

  const ChatActionType(this.text);
  final String text;
}

enum ChatActionTarget {
  httpRequestModel,
  wsRequestModel,
  mqttRequestModel,
  codegen,
  test,
  code,
  attachment,
  documentation,
}

ChatActionType chatActionTypeFromString(String s) {
  return ChatActionType.values.firstWhere(
    (type) => type.text == s,
    orElse: () => ChatActionType.other,
  );
}

ChatActionTarget chatActionTargetFromString(String s) {
  return ChatActionTarget.values.firstWhere(
    (target) => target.name == s,
    orElse: () => ChatActionTarget.httpRequestModel,
  );
}
