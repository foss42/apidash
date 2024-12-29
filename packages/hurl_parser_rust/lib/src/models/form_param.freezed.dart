// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FormParam _$FormParamFromJson(Map<String, dynamic> json) {
  return _FormParam.fromJson(json);
}

/// @nodoc
mixin _$FormParam {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this FormParam to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FormParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FormParamCopyWith<FormParam> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FormParamCopyWith<$Res> {
  factory $FormParamCopyWith(FormParam value, $Res Function(FormParam) then) =
      _$FormParamCopyWithImpl<$Res, FormParam>;
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class _$FormParamCopyWithImpl<$Res, $Val extends FormParam>
    implements $FormParamCopyWith<$Res> {
  _$FormParamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FormParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FormParamImplCopyWith<$Res>
    implements $FormParamCopyWith<$Res> {
  factory _$$FormParamImplCopyWith(
          _$FormParamImpl value, $Res Function(_$FormParamImpl) then) =
      __$$FormParamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class __$$FormParamImplCopyWithImpl<$Res>
    extends _$FormParamCopyWithImpl<$Res, _$FormParamImpl>
    implements _$$FormParamImplCopyWith<$Res> {
  __$$FormParamImplCopyWithImpl(
      _$FormParamImpl _value, $Res Function(_$FormParamImpl) _then)
      : super(_value, _then);

  /// Create a copy of FormParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$FormParamImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FormParamImpl implements _FormParam {
  const _$FormParamImpl({required this.name, required this.value});

  factory _$FormParamImpl.fromJson(Map<String, dynamic> json) =>
      _$$FormParamImplFromJson(json);

  @override
  final String name;
  @override
  final String value;

  @override
  String toString() {
    return 'FormParam(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormParamImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  /// Create a copy of FormParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormParamImplCopyWith<_$FormParamImpl> get copyWith =>
      __$$FormParamImplCopyWithImpl<_$FormParamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FormParamImplToJson(
      this,
    );
  }
}

abstract class _FormParam implements FormParam {
  const factory _FormParam(
      {required final String name,
      required final String value}) = _$FormParamImpl;

  factory _FormParam.fromJson(Map<String, dynamic> json) =
      _$FormParamImpl.fromJson;

  @override
  String get name;
  @override
  String get value;

  /// Create a copy of FormParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormParamImplCopyWith<_$FormParamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
