// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FormDataModel _$FormDataModelFromJson(Map<String, dynamic> json) {
  return _FormDataModel.fromJson(json);
}

/// @nodoc
mixin _$FormDataModel {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  FormDataType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FormDataModelCopyWith<FormDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormDataModelCopyWith<$Res> {
  factory $FormDataModelCopyWith(
          FormDataModel value, $Res Function(FormDataModel) then) =
      _$FormDataModelCopyWithImpl<$Res, FormDataModel>;
  @useResult
  $Res call({String name, String value, FormDataType type});
}

/// @nodoc
class _$FormDataModelCopyWithImpl<$Res, $Val extends FormDataModel>
    implements $FormDataModelCopyWith<$Res> {
  _$FormDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FormDataType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormDataModelImplCopyWith<$Res>
    implements $FormDataModelCopyWith<$Res> {
  factory _$$FormDataModelImplCopyWith(
          _$FormDataModelImpl value, $Res Function(_$FormDataModelImpl) then) =
      __$$FormDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value, FormDataType type});
}

/// @nodoc
class __$$FormDataModelImplCopyWithImpl<$Res>
    extends _$FormDataModelCopyWithImpl<$Res, _$FormDataModelImpl>
    implements _$$FormDataModelImplCopyWith<$Res> {
  __$$FormDataModelImplCopyWithImpl(
      _$FormDataModelImpl _value, $Res Function(_$FormDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_$FormDataModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FormDataType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormDataModelImpl implements _FormDataModel {
  const _$FormDataModelImpl(
      {required this.name, required this.value, required this.type});

  factory _$FormDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormDataModelImplFromJson(json);

  @override
  final String name;
  @override
  final String value;
  @override
  final FormDataType type;

  @override
  String toString() {
    return 'FormDataModel(name: $name, value: $value, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormDataModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FormDataModelImplCopyWith<_$FormDataModelImpl> get copyWith =>
      __$$FormDataModelImplCopyWithImpl<_$FormDataModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormDataModelImplToJson(
      this,
    );
  }
}

abstract class _FormDataModel implements FormDataModel {
  const factory _FormDataModel(
      {required final String name,
      required final String value,
      required final FormDataType type}) = _$FormDataModelImpl;

  factory _FormDataModel.fromJson(Map<String, dynamic> json) =
      _$FormDataModelImpl.fromJson;

  @override
  String get name;
  @override
  String get value;
  @override
  FormDataType get type;
  @override
  @JsonKey(ignore: true)
  _$$FormDataModelImplCopyWith<_$FormDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
