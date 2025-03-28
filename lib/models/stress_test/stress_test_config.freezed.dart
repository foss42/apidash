// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stress_test_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StressTestConfig _$StressTestConfigFromJson(Map<String, dynamic> json) {
  return _StressTestConfig.fromJson(json);
}

/// @nodoc
mixin _$StressTestConfig {
  String get url => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  dynamic get body => throw _privateConstructorUsedError;
  int get concurrentRequests => throw _privateConstructorUsedError;
  Duration? get timeout => throw _privateConstructorUsedError;
  bool get useIsolates => throw _privateConstructorUsedError;

  /// Serializes this StressTestConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StressTestConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StressTestConfigCopyWith<StressTestConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StressTestConfigCopyWith<$Res> {
  factory $StressTestConfigCopyWith(
          StressTestConfig value, $Res Function(StressTestConfig) then) =
      _$StressTestConfigCopyWithImpl<$Res, StressTestConfig>;
  @useResult
  $Res call(
      {String url,
      String method,
      Map<String, String>? headers,
      dynamic body,
      int concurrentRequests,
      Duration? timeout,
      bool useIsolates});
}

/// @nodoc
class _$StressTestConfigCopyWithImpl<$Res, $Val extends StressTestConfig>
    implements $StressTestConfigCopyWith<$Res> {
  _$StressTestConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StressTestConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
    Object? headers = freezed,
    Object? body = freezed,
    Object? concurrentRequests = null,
    Object? timeout = freezed,
    Object? useIsolates = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as dynamic,
      concurrentRequests: null == concurrentRequests
          ? _value.concurrentRequests
          : concurrentRequests // ignore: cast_nullable_to_non_nullable
              as int,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      useIsolates: null == useIsolates
          ? _value.useIsolates
          : useIsolates // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StressTestConfigImplCopyWith<$Res>
    implements $StressTestConfigCopyWith<$Res> {
  factory _$$StressTestConfigImplCopyWith(_$StressTestConfigImpl value,
          $Res Function(_$StressTestConfigImpl) then) =
      __$$StressTestConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      String method,
      Map<String, String>? headers,
      dynamic body,
      int concurrentRequests,
      Duration? timeout,
      bool useIsolates});
}

/// @nodoc
class __$$StressTestConfigImplCopyWithImpl<$Res>
    extends _$StressTestConfigCopyWithImpl<$Res, _$StressTestConfigImpl>
    implements _$$StressTestConfigImplCopyWith<$Res> {
  __$$StressTestConfigImplCopyWithImpl(_$StressTestConfigImpl _value,
      $Res Function(_$StressTestConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of StressTestConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
    Object? headers = freezed,
    Object? body = freezed,
    Object? concurrentRequests = null,
    Object? timeout = freezed,
    Object? useIsolates = null,
  }) {
    return _then(_$StressTestConfigImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as dynamic,
      concurrentRequests: null == concurrentRequests
          ? _value.concurrentRequests
          : concurrentRequests // ignore: cast_nullable_to_non_nullable
              as int,
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
      useIsolates: null == useIsolates
          ? _value.useIsolates
          : useIsolates // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StressTestConfigImpl implements _StressTestConfig {
  const _$StressTestConfigImpl(
      {required this.url,
      required this.method,
      final Map<String, String>? headers,
      this.body,
      required this.concurrentRequests,
      this.timeout,
      this.useIsolates = false})
      : _headers = headers;

  factory _$StressTestConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StressTestConfigImplFromJson(json);

  @override
  final String url;
  @override
  final String method;
  final Map<String, String>? _headers;
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final dynamic body;
  @override
  final int concurrentRequests;
  @override
  final Duration? timeout;
  @override
  @JsonKey()
  final bool useIsolates;

  @override
  String toString() {
    return 'StressTestConfig(url: $url, method: $method, headers: $headers, body: $body, concurrentRequests: $concurrentRequests, timeout: $timeout, useIsolates: $useIsolates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StressTestConfigImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            (identical(other.concurrentRequests, concurrentRequests) ||
                other.concurrentRequests == concurrentRequests) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.useIsolates, useIsolates) ||
                other.useIsolates == useIsolates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      method,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(body),
      concurrentRequests,
      timeout,
      useIsolates);

  /// Create a copy of StressTestConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StressTestConfigImplCopyWith<_$StressTestConfigImpl> get copyWith =>
      __$$StressTestConfigImplCopyWithImpl<_$StressTestConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StressTestConfigImplToJson(
      this,
    );
  }
}

abstract class _StressTestConfig implements StressTestConfig {
  const factory _StressTestConfig(
      {required final String url,
      required final String method,
      final Map<String, String>? headers,
      final dynamic body,
      required final int concurrentRequests,
      final Duration? timeout,
      final bool useIsolates}) = _$StressTestConfigImpl;

  factory _StressTestConfig.fromJson(Map<String, dynamic> json) =
      _$StressTestConfigImpl.fromJson;

  @override
  String get url;
  @override
  String get method;
  @override
  Map<String, String>? get headers;
  @override
  dynamic get body;
  @override
  int get concurrentRequests;
  @override
  Duration? get timeout;
  @override
  bool get useIsolates;

  /// Create a copy of StressTestConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StressTestConfigImplCopyWith<_$StressTestConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
