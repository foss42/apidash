import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'name_value_model.freezed.dart';

part 'name_value_model.g.dart';

@freezed
class NameValueModel with _$NameValueModel {
  const factory NameValueModel({
    required String name,
    required dynamic value,
  }) = _NameValueModel;

  factory NameValueModel.fromJson(Map<String, Object?> json) =>
      _$NameValueModelFromJson(json);
}

const kNameValueEmptyModel = NameValueModel(name: "", value: "");
