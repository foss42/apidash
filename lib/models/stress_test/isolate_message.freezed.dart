// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'isolate_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IsolateMessage _$IsolateMessageFromJson(Map<String, dynamic> json) {
  return _IsolateMessage.fromJson(json);
}

/// @nodoc
mixin _$IsolateMessage {
  String get url => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  dynamic get body => throw _privateConstructorUsedError;
  Duration? get timeout => throw _privateConstructorUsedError;

  /// Serializes this IsolateMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IsolateMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IsolateMessageCopyWith<IsolateMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsolateMessageCopyWith<$Res> {
  factory $IsolateMessageCopyWith(
          IsolateMessage value, $Res Function(IsolateMessage) then) =
      _$IsolateMessageCopyWithImpl<$Res, IsolateMessage>;
  @useResult
  $Res call(
      {String url,
      String method,
      Map<String, String>? headers,
      dynamic body,
      Duration? timeout});
}

/// @nodoc
class _$IsolateMessageCopyWithImpl<$Res, $Val extends IsolateMessage>
    implements $IsolateMessageCopyWith<$Res> {
  _$IsolateMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IsolateMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
    Object? headers = freezed,
    Object? body = freezed,
    Object? timeout = freezed,
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
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IsolateMessageImplCopyWith<$Res>
    implements $IsolateMessageCopyWith<$Res> {
  factory _$$IsolateMessageImplCopyWith(_$IsolateMessageImpl value,
          $Res Function(_$IsolateMessageImpl) then) =
      __$$IsolateMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      String method,
      Map<String, String>? headers,
      dynamic body,
      Duration? timeout});
}

/// @nodoc
class __$$IsolateMessageImplCopyWithImpl<$Res>
    extends _$IsolateMessageCopyWithImpl<$Res, _$IsolateMessageImpl>
    implements _$$IsolateMessageImplCopyWith<$Res> {
  __$$IsolateMessageImplCopyWithImpl(
      _$IsolateMessageImpl _value, $Res Function(_$IsolateMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of IsolateMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? method = null,
    Object? headers = freezed,
    Object? body = freezed,
    Object? timeout = freezed,
  }) {
    return _then(_$IsolateMessageImpl(
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
      timeout: freezed == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IsolateMessageImpl implements _IsolateMessage {
  const _$IsolateMessageImpl(
      {required this.url,
      required this.method,
      final Map<String, String>? headers,
      this.body,
      this.timeout})
      : _headers = headers;

  factory _$IsolateMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$IsolateMessageImplFromJson(json);

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
  final Duration? timeout;

  @override
  String toString() {
    return 'IsolateMessage(url: $url, method: $method, headers: $headers, body: $body, timeout: $timeout)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IsolateMessageImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other.body, body) &&
            (identical(other.timeout, timeout) || other.timeout == timeout));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      method,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(body),
      timeout);

  /// Create a copy of IsolateMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IsolateMessageImplCopyWith<_$IsolateMessageImpl> get copyWith =>
      __$$IsolateMessageImplCopyWithImpl<_$IsolateMessageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IsolateMessageImplToJson(
      this,
    );
  }
}

abstract class _IsolateMessage implements IsolateMessage {
  const factory _IsolateMessage(
      {required final String url,
      required final String method,
      final Map<String, String>? headers,
      final dynamic body,
      final Duration? timeout}) = _$IsolateMessageImpl;

  factory _IsolateMessage.fromJson(Map<String, dynamic> json) =
      _$IsolateMessageImpl.fromJson;

  @override
  String get url;
  @override
  String get method;
  @override
  Map<String, String>? get headers;
  @override
  dynamic get body;
  @override
  Duration? get timeout;

  /// Create a copy of IsolateMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IsolateMessageImplCopyWith<_$IsolateMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
