// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestBody _$RequestBodyFromJson(Map<String, dynamic> json) {
  return _RequestBody.fromJson(json);
}

/// @nodoc
mixin _$RequestBody {
  String get type => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  /// Serializes this RequestBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestBodyCopyWith<RequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestBodyCopyWith<$Res> {
  factory $RequestBodyCopyWith(
          RequestBody value, $Res Function(RequestBody) then) =
      _$RequestBodyCopyWithImpl<$Res, RequestBody>;
  @useResult
  $Res call({String type, dynamic value});
}

/// @nodoc
class _$RequestBodyCopyWithImpl<$Res, $Val extends RequestBody>
    implements $RequestBodyCopyWith<$Res> {
  _$RequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestBodyImplCopyWith<$Res>
    implements $RequestBodyCopyWith<$Res> {
  factory _$$RequestBodyImplCopyWith(
          _$RequestBodyImpl value, $Res Function(_$RequestBodyImpl) then) =
      __$$RequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, dynamic value});
}

/// @nodoc
class __$$RequestBodyImplCopyWithImpl<$Res>
    extends _$RequestBodyCopyWithImpl<$Res, _$RequestBodyImpl>
    implements _$$RequestBodyImplCopyWith<$Res> {
  __$$RequestBodyImplCopyWithImpl(
      _$RequestBodyImpl _value, $Res Function(_$RequestBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_$RequestBodyImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$RequestBodyImpl implements _RequestBody {
  const _$RequestBodyImpl({required this.type, required this.value});

  factory _$RequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestBodyImplFromJson(json);

  @override
  final String type;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'RequestBody(type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestBodyImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(value));

  /// Create a copy of RequestBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestBodyImplCopyWith<_$RequestBodyImpl> get copyWith =>
      __$$RequestBodyImplCopyWithImpl<_$RequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestBodyImplToJson(
      this,
    );
  }
}

abstract class _RequestBody implements RequestBody {
  const factory _RequestBody(
      {required final String type,
      required final dynamic value}) = _$RequestBodyImpl;

  factory _RequestBody.fromJson(Map<String, dynamic> json) =
      _$RequestBodyImpl.fromJson;

  @override
  String get type;
  @override
  dynamic get value;

  /// Create a copy of RequestBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestBodyImplCopyWith<_$RequestBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
