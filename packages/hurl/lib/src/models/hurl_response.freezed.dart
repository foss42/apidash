// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hurl_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HurlResponse _$HurlResponseFromJson(Map<String, dynamic> json) {
  return _HurlResponse.fromJson(json);
}

/// @nodoc
mixin _$HurlResponse {
  /// HTTP status code
  int? get status => throw _privateConstructorUsedError;

  /// HTTP version (e.g., "HTTP/1.1", "HTTP/2")
  String? get version => throw _privateConstructorUsedError;

  /// Response headers
  List<Header>? get headers => throw _privateConstructorUsedError;

  /// Captures to extract values from the response
  List<Capture>? get captures => throw _privateConstructorUsedError;

  /// Assertions to validate the response
  List<HurlAssert>? get asserts => throw _privateConstructorUsedError;

  /// Response body (can be JSON object, string, byte data, etc.)
  @JsonKey(includeIfNull: false)
  dynamic get body =>
      throw _privateConstructorUsedError; // Changed from String to dynamic
  /// Type of the body content (json, xml, text, etc.)
  @JsonKey(name: 'body_type')
  String? get bodyType => throw _privateConstructorUsedError;

  /// Serializes this HurlResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HurlResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HurlResponseCopyWith<HurlResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HurlResponseCopyWith<$Res> {
  factory $HurlResponseCopyWith(
          HurlResponse value, $Res Function(HurlResponse) then) =
      _$HurlResponseCopyWithImpl<$Res, HurlResponse>;
  @useResult
  $Res call(
      {int? status,
      String? version,
      List<Header>? headers,
      List<Capture>? captures,
      List<HurlAssert>? asserts,
      @JsonKey(includeIfNull: false) dynamic body,
      @JsonKey(name: 'body_type') String? bodyType});
}

/// @nodoc
class _$HurlResponseCopyWithImpl<$Res, $Val extends HurlResponse>
    implements $HurlResponseCopyWith<$Res> {
  _$HurlResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HurlResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? version = freezed,
    Object? headers = freezed,
    Object? captures = freezed,
    Object? asserts = freezed,
    Object? body = freezed,
    Object? bodyType = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      captures: freezed == captures
          ? _value.captures
          : captures // ignore: cast_nullable_to_non_nullable
              as List<Capture>?,
      asserts: freezed == asserts
          ? _value.asserts
          : asserts // ignore: cast_nullable_to_non_nullable
              as List<HurlAssert>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as dynamic,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HurlResponseImplCopyWith<$Res>
    implements $HurlResponseCopyWith<$Res> {
  factory _$$HurlResponseImplCopyWith(
          _$HurlResponseImpl value, $Res Function(_$HurlResponseImpl) then) =
      __$$HurlResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? status,
      String? version,
      List<Header>? headers,
      List<Capture>? captures,
      List<HurlAssert>? asserts,
      @JsonKey(includeIfNull: false) dynamic body,
      @JsonKey(name: 'body_type') String? bodyType});
}

/// @nodoc
class __$$HurlResponseImplCopyWithImpl<$Res>
    extends _$HurlResponseCopyWithImpl<$Res, _$HurlResponseImpl>
    implements _$$HurlResponseImplCopyWith<$Res> {
  __$$HurlResponseImplCopyWithImpl(
      _$HurlResponseImpl _value, $Res Function(_$HurlResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of HurlResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? version = freezed,
    Object? headers = freezed,
    Object? captures = freezed,
    Object? asserts = freezed,
    Object? body = freezed,
    Object? bodyType = freezed,
  }) {
    return _then(_$HurlResponseImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      captures: freezed == captures
          ? _value._captures
          : captures // ignore: cast_nullable_to_non_nullable
              as List<Capture>?,
      asserts: freezed == asserts
          ? _value._asserts
          : asserts // ignore: cast_nullable_to_non_nullable
              as List<HurlAssert>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as dynamic,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HurlResponseImpl implements _HurlResponse {
  const _$HurlResponseImpl(
      {this.status,
      this.version,
      final List<Header>? headers,
      final List<Capture>? captures,
      final List<HurlAssert>? asserts,
      @JsonKey(includeIfNull: false) this.body,
      @JsonKey(name: 'body_type') this.bodyType})
      : _headers = headers,
        _captures = captures,
        _asserts = asserts;

  factory _$HurlResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HurlResponseImplFromJson(json);

  /// HTTP status code
  @override
  final int? status;

  /// HTTP version (e.g., "HTTP/1.1", "HTTP/2")
  @override
  final String? version;

  /// Response headers
  final List<Header>? _headers;

  /// Response headers
  @override
  List<Header>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Captures to extract values from the response
  final List<Capture>? _captures;

  /// Captures to extract values from the response
  @override
  List<Capture>? get captures {
    final value = _captures;
    if (value == null) return null;
    if (_captures is EqualUnmodifiableListView) return _captures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Assertions to validate the response
  final List<HurlAssert>? _asserts;

  /// Assertions to validate the response
  @override
  List<HurlAssert>? get asserts {
    final value = _asserts;
    if (value == null) return null;
    if (_asserts is EqualUnmodifiableListView) return _asserts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Response body (can be JSON object, string, byte data, etc.)
  @override
  @JsonKey(includeIfNull: false)
  final dynamic body;
// Changed from String to dynamic
  /// Type of the body content (json, xml, text, etc.)
  @override
  @JsonKey(name: 'body_type')
  final String? bodyType;

  @override
  String toString() {
    return 'HurlResponse(status: $status, version: $version, headers: $headers, captures: $captures, asserts: $asserts, body: $body, bodyType: $bodyType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HurlResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other._captures, _captures) &&
            const DeepCollectionEquality().equals(other._asserts, _asserts) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      version,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_captures),
      const DeepCollectionEquality().hash(_asserts),
      const DeepCollectionEquality().hash(body),
      bodyType);

  /// Create a copy of HurlResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HurlResponseImplCopyWith<_$HurlResponseImpl> get copyWith =>
      __$$HurlResponseImplCopyWithImpl<_$HurlResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HurlResponseImplToJson(
      this,
    );
  }
}

abstract class _HurlResponse implements HurlResponse {
  const factory _HurlResponse(
      {final int? status,
      final String? version,
      final List<Header>? headers,
      final List<Capture>? captures,
      final List<HurlAssert>? asserts,
      @JsonKey(includeIfNull: false) final dynamic body,
      @JsonKey(name: 'body_type') final String? bodyType}) = _$HurlResponseImpl;

  factory _HurlResponse.fromJson(Map<String, dynamic> json) =
      _$HurlResponseImpl.fromJson;

  /// HTTP status code
  @override
  int? get status;

  /// HTTP version (e.g., "HTTP/1.1", "HTTP/2")
  @override
  String? get version;

  /// Response headers
  @override
  List<Header>? get headers;

  /// Captures to extract values from the response
  @override
  List<Capture>? get captures;

  /// Assertions to validate the response
  @override
  List<HurlAssert>? get asserts;

  /// Response body (can be JSON object, string, byte data, etc.)
  @override
  @JsonKey(includeIfNull: false)
  dynamic get body; // Changed from String to dynamic
  /// Type of the body content (json, xml, text, etc.)
  @override
  @JsonKey(name: 'body_type')
  String? get bodyType;

  /// Create a copy of HurlResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HurlResponseImplCopyWith<_$HurlResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
