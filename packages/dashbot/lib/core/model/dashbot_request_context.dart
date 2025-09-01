import 'package:apidash_core/apidash_core.dart';

/// Context object that Dashbot needs from the host app.
///
/// Host apps should create/override a provider that returns this object
/// so Dashbot can react to changes in the current request selection.
class DashbotRequestContext {
  final String? requestId;
  final String? requestName;
  final String? requestDescription;
  final APIType apiType;
  final AIRequestModel? aiRequestModel;
  final HttpRequestModel? httpRequestModel;
  final int? responseStatus;
  final String? responseMessage;
  final HttpResponseModel? httpResponseModel;

  const DashbotRequestContext({
    required this.apiType,
    this.requestId,
    this.requestName,
    this.requestDescription,
    this.aiRequestModel,
    this.httpRequestModel,
    this.responseStatus,
    this.responseMessage,
    this.httpResponseModel,
  });
}
