// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multipart_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MultipartFormData _$MultipartFormDataFromJson(Map<String, dynamic> json) {
  return _MultipartFormData.fromJson(json);
}

/// @nodoc
mixin _$MultipartFormData {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String? get filename => throw _privateConstructorUsedError;
  String? get contentType => throw _privateConstructorUsedError;

  /// Serializes this MultipartFormData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultipartFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultipartFormDataCopyWith<MultipartFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultipartFormDataCopyWith<$Res> {
  factory $MultipartFormDataCopyWith(
          MultipartFormData value, $Res Function(MultipartFormData) then) =
      _$MultipartFormDataCopyWithImpl<$Res, MultipartFormData>;
  @useResult
  $Res call({String name, String value, String? filename, String? contentType});
}

/// @nodoc
class _$MultipartFormDataCopyWithImpl<$Res, $Val extends MultipartFormData>
    implements $MultipartFormDataCopyWith<$Res> {
  _$MultipartFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultipartFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? filename = freezed,
    Object? contentType = freezed,
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
      filename: freezed == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultipartFormDataImplCopyWith<$Res>
    implements $MultipartFormDataCopyWith<$Res> {
  factory _$$MultipartFormDataImplCopyWith(_$MultipartFormDataImpl value,
          $Res Function(_$MultipartFormDataImpl) then) =
      __$$MultipartFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value, String? filename, String? contentType});
}

/// @nodoc
class __$$MultipartFormDataImplCopyWithImpl<$Res>
    extends _$MultipartFormDataCopyWithImpl<$Res, _$MultipartFormDataImpl>
    implements _$$MultipartFormDataImplCopyWith<$Res> {
  __$$MultipartFormDataImplCopyWithImpl(_$MultipartFormDataImpl _value,
      $Res Function(_$MultipartFormDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultipartFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? filename = freezed,
    Object? contentType = freezed,
  }) {
    return _then(_$MultipartFormDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      filename: freezed == filename
          ? _value.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MultipartFormDataImpl implements _MultipartFormData {
  const _$MultipartFormDataImpl(
      {required this.name,
      required this.value,
      this.filename,
      this.contentType});

  factory _$MultipartFormDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultipartFormDataImplFromJson(json);

  @override
  final String name;
  @override
  final String value;
  @override
  final String? filename;
  @override
  final String? contentType;

  @override
  String toString() {
    return 'MultipartFormData(name: $name, value: $value, filename: $filename, contentType: $contentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultipartFormDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, value, filename, contentType);

  /// Create a copy of MultipartFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultipartFormDataImplCopyWith<_$MultipartFormDataImpl> get copyWith =>
      __$$MultipartFormDataImplCopyWithImpl<_$MultipartFormDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MultipartFormDataImplToJson(
      this,
    );
  }
}

abstract class _MultipartFormData implements MultipartFormData {
  const factory _MultipartFormData(
      {required final String name,
      required final String value,
      final String? filename,
      final String? contentType}) = _$MultipartFormDataImpl;

  factory _MultipartFormData.fromJson(Map<String, dynamic> json) =
      _$MultipartFormDataImpl.fromJson;

  @override
  String get name;
  @override
  String get value;
  @override
  String? get filename;
  @override
  String? get contentType;

  /// Create a copy of MultipartFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultipartFormDataImplCopyWith<_$MultipartFormDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
