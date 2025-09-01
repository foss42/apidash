import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashbot/dashbot.dart';

import 'providers.dart';

/// Derives the DashbotRequestContext from the app's current selection.
final appDashbotRequestContextProvider =
    Provider<DashbotRequestContext?>((ref) {
  final req = ref.watch(selectedRequestModelProvider);
  if (req == null) return null;
  return DashbotRequestContext(
    apiType: req.apiType,
    requestId: req.id,
    requestName: req.name,
    requestDescription: req.description,
    aiRequestModel: req.aiRequestModel,
    httpRequestModel: req.httpRequestModel,
    responseStatus: req.responseStatus,
    responseMessage: req.message,
    httpResponseModel: req.httpResponseModel,
  );
});
