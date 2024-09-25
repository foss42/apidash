import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'convert_utils.dart';

DateTime stripTime(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

RequestModel getRequestModelFromHistoryModel(HistoryRequestModel model) {
  return RequestModel(
    id: model.historyId,
    name: model.metaData.name,
    responseStatus: model.httpResponseModel.statusCode,
    message: kResponseCodeReasons[model.httpResponseModel.statusCode],
    httpRequestModel: model.httpRequestModel,
    httpResponseModel: model.httpResponseModel,
  );
}

String getHistoryRequestName(HistoryMetaModel model) {
  if (model.name.isNotEmpty) {
    return model.name;
  } else {
    return model.url;
  }
}

String getHistoryRequestKey(HistoryMetaModel model) {
  String timeStamp = humanizeDate(model.timeStamp);
  if (model.name.isNotEmpty) {
    return model.name + model.method.name + timeStamp;
  } else {
    return model.url + model.method.name + timeStamp;
  }
}

String? getLatestRequestId(
    Map<DateTime, List<HistoryMetaModel>> temporalGroups) {
  if (temporalGroups.isEmpty) {
    return null;
  }
  List<DateTime> keys = temporalGroups.keys.toList();
  keys.sort((a, b) => b.compareTo(a));
  return temporalGroups[keys.first]!.first.historyId;
}

DateTime getDateTimeKey(List<DateTime> keys, DateTime currentKey) {
  if (keys.isEmpty) return currentKey;
  for (DateTime key in keys) {
    if (key.year == currentKey.year &&
        key.month == currentKey.month &&
        key.day == currentKey.day) {
      return key;
    }
  }
  return stripTime(currentKey);
}

Map<DateTime, List<HistoryMetaModel>> getTemporalGroups(
    List<HistoryMetaModel>? models) {
  Map<DateTime, List<HistoryMetaModel>> temporalGroups = {};
  if (models?.isEmpty ?? true) {
    return temporalGroups;
  }
  for (HistoryMetaModel model in models!) {
    List<DateTime> existingKeys = temporalGroups.keys.toList();
    DateTime key = getDateTimeKey(existingKeys, model.timeStamp);
    if (existingKeys.contains(key)) {
      temporalGroups[key]!.add(model);
    } else {
      temporalGroups[stripTime(key)] = [model];
    }
  }
  temporalGroups.forEach((key, value) {
    value.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  });
  return temporalGroups;
}

Map<String, List<HistoryMetaModel>> getRequestGroups(
    List<HistoryMetaModel>? models) {
  Map<String, List<HistoryMetaModel>> historyGroups = {};
  if (models?.isEmpty ?? true) {
    return historyGroups;
  }
  for (HistoryMetaModel model in models!) {
    String key = getHistoryRequestKey(model);
    if (historyGroups.containsKey(key)) {
      historyGroups[key]!.add(model);
    } else {
      historyGroups[key] = [model];
    }
  }
  historyGroups.forEach((key, value) {
    value.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  });
  return historyGroups;
}

List<HistoryMetaModel> getRequestGroup(
    List<HistoryMetaModel>? models, HistoryMetaModel? selectedModel) {
  List<HistoryMetaModel> requestGroup = [];
  if (selectedModel == null || (models?.isEmpty ?? true)) {
    return requestGroup;
  }
  String selectedModelKey = getHistoryRequestKey(selectedModel);
  for (HistoryMetaModel model in models!) {
    String key = getHistoryRequestKey(model);
    if (key == selectedModelKey) {
      requestGroup.add(model);
    }
  }
  requestGroup.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  return requestGroup;
}

DateTime? getRetentionDate(HistoryRetentionPeriod? retentionPeriod) {
  DateTime now = DateTime.now();
  DateTime today = stripTime(now);

  switch (retentionPeriod) {
    case HistoryRetentionPeriod.oneWeek:
      return today.subtract(const Duration(days: 7));
    case HistoryRetentionPeriod.oneMonth:
      return today.subtract(const Duration(days: 30));
    case HistoryRetentionPeriod.threeMonths:
      return today.subtract(const Duration(days: 90));
    default:
      return null;
  }
}
