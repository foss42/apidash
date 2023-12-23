import 'package:apidash/consts.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_data_model.freezed.dart';
part 'form_data_model.g.dart';

@freezed
class FormDataModel with _$FormDataModel {
  const factory FormDataModel({
    required String name,
    required String value,
    required FormDataType type,
  }) = _FormDataModel;

  factory FormDataModel.fromJson(Map<String, Object?> json) =>
      _$FormDataModelFromJson(json);
}

const kFormDataEmptyModel = FormDataModel(
  name: "",
  value: "",
  type: FormDataType.text,
);
