// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_request_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApiRequestResult _$ApiRequestResultFromJson(Map<String, dynamic> json) {
  return _ApiRequestResult.fromJson(json);
}

/// @nodoc
mixin _$ApiRequestResult {
  int get statusCode => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ApiRequestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiRequestResultCopyWith<ApiRequestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiRequestResultCopyWith<$Res> {
  factory $ApiRequestResultCopyWith(
          ApiRequestResult value, $Res Function(ApiRequestResult) then) =
      _$ApiRequestResultCopyWithImpl<$Res, ApiRequestResult>;
  @useResult
  $Res call({int statusCode, String body, Duration duration, String? error});
}

/// @nodoc
class _$ApiRequestResultCopyWithImpl<$Res, $Val extends ApiRequestResult>
    implements $ApiRequestResultCopyWith<$Res> {
  _$ApiRequestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? body = null,
    Object? duration = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiRequestResultImplCopyWith<$Res>
    implements $ApiRequestResultCopyWith<$Res> {
  factory _$$ApiRequestResultImplCopyWith(_$ApiRequestResultImpl value,
          $Res Function(_$ApiRequestResultImpl) then) =
      __$$ApiRequestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int statusCode, String body, Duration duration, String? error});
}

/// @nodoc
class __$$ApiRequestResultImplCopyWithImpl<$Res>
    extends _$ApiRequestResultCopyWithImpl<$Res, _$ApiRequestResultImpl>
    implements _$$ApiRequestResultImplCopyWith<$Res> {
  __$$ApiRequestResultImplCopyWithImpl(_$ApiRequestResultImpl _value,
      $Res Function(_$ApiRequestResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? body = null,
    Object? duration = null,
    Object? error = freezed,
  }) {
    return _then(_$ApiRequestResultImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiRequestResultImpl implements _ApiRequestResult {
  const _$ApiRequestResultImpl(
      {required this.statusCode,
      required this.body,
      required this.duration,
      this.error});

  factory _$ApiRequestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiRequestResultImplFromJson(json);

  @override
  final int statusCode;
  @override
  final String body;
  @override
  final Duration duration;
  @override
  final String? error;

  @override
  String toString() {
    return 'ApiRequestResult(statusCode: $statusCode, body: $body, duration: $duration, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiRequestResultImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, statusCode, body, duration, error);

  /// Create a copy of ApiRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiRequestResultImplCopyWith<_$ApiRequestResultImpl> get copyWith =>
      __$$ApiRequestResultImplCopyWithImpl<_$ApiRequestResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiRequestResultImplToJson(
      this,
    );
  }
}

abstract class _ApiRequestResult implements ApiRequestResult {
  const factory _ApiRequestResult(
      {required final int statusCode,
      required final String body,
      required final Duration duration,
      final String? error}) = _$ApiRequestResultImpl;

  factory _ApiRequestResult.fromJson(Map<String, dynamic> json) =
      _$ApiRequestResultImpl.fromJson;

  @override
  int get statusCode;
  @override
  String get body;
  @override
  Duration get duration;
  @override
  String? get error;

  /// Create a copy of ApiRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiRequestResultImplCopyWith<_$ApiRequestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
