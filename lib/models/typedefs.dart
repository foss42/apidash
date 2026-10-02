import 'package:apidash_core/apidash_core.dart';
import 'grpc_request_model.dart';
import 'mqtt_request_model.dart';
import 'ws_request_model.dart';

typedef RequestUpdater =
    void Function({
      APIType? apiType,
      String? id,
      HTTPVerb? method,
      AuthModel? authModel,
      String? url,
      String? name,
      String? description,
      int? requestTabIndex,
      List<NameValueModel>? headers,
      List<NameValueModel>? params,
      List<bool>? isHeaderEnabledList,
      List<bool>? isParamEnabledList,
      ContentType? bodyContentType,
      String? body,
      String? query,
      List<FormDataModel>? formData,
      int? responseStatus,
      String? message,
      HttpResponseModel? httpResponseModel,
      String? preRequestScript,
      String? postRequestScript,
      AIRequestModel? aiRequestModel,
      WebSocketRequestModel? wsRequestModel,
      MQTTRequestModel? mqttRequestModel,
      GrpcRequestModel? grpcRequestModel,
      bool? isStreaming,
      bool? isWorking,
    });
