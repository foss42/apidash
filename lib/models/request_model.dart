import 'package:apidash/models/llm_models/all_models.dart';
import 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
import 'package:apidash/models/llm_models/llm_model.dart';
import 'package:apidash_core/apidash_core.dart';

part 'request_model.freezed.dart';

part 'request_model.g.dart';

@freezed
class RequestModel with _$RequestModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory RequestModel({
    required String id,
    @Default(APIType.rest) APIType apiType,
    @Default("") String name,
    @Default("") String description,
    @JsonKey(includeToJson: false) @Default(0) requestTabIndex,
    HttpRequestModel? httpRequestModel,
    int? responseStatus,
    String? message,
    HttpResponseModel? httpResponseModel,
    @JsonKey(includeToJson: false) @Default(false) bool isWorking,
    @JsonKey(includeToJson: false) DateTime? sendingTime,

    //ExtraDetails for anything else that can be included
    @JsonKey(fromJson: customMapFromJson, toJson: customMapToJson)
    @Default({})
    Map extraDetails,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, Object?> json) =>
      _$RequestModelFromJson(json);
}

// ----------------- Custom SerDes --------------

// Map converter
Map customMapFromJson(Map json) {
  Map result = {};
  for (var entry in json.entries) {
    if (entry.key == 'model' && entry.value is String) {
      result[entry.key] = getLLMModelFromID(entry.value, json);
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}

Map customMapToJson(Map map) {
  Map<String, dynamic>? result = {};
  for (var entry in map.entries) {
    if (entry.key == 'model' && entry.value is LLMModel) {
      result[entry.key] = (entry.value as LLMModel).modelIdentifier;
    } else {
      result[entry.key] = entry.value;
    }
  }
  return result;
}
