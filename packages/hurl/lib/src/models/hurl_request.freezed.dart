// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hurl_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HurlRequest _$HurlRequestFromJson(Map<String, dynamic> json) {
  return _HurlRequest.fromJson(json);
}

/// @nodoc
mixin _$HurlRequest {
  String get method => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  List<Header>? get headers => throw _privateConstructorUsedError;
  List<String>? get comments => throw _privateConstructorUsedError;
  List<RequestOption>? get options => throw _privateConstructorUsedError;
  RequestBody? get body => throw _privateConstructorUsedError;
  @JsonKey(name: "multipart_form_data")
  List<MultipartFormData>? get multiPartFormData =>
      throw _privateConstructorUsedError;

  /// Serializes this HurlRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HurlRequestCopyWith<HurlRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HurlRequestCopyWith<$Res> {
  factory $HurlRequestCopyWith(
          HurlRequest value, $Res Function(HurlRequest) then) =
      _$HurlRequestCopyWithImpl<$Res, HurlRequest>;
  @useResult
  $Res call(
      {String method,
      String url,
      List<Header>? headers,
      List<String>? comments,
      List<RequestOption>? options,
      RequestBody? body,
      @JsonKey(name: "multipart_form_data")
      List<MultipartFormData>? multiPartFormData});

  $RequestBodyCopyWith<$Res>? get body;
}

/// @nodoc
class _$HurlRequestCopyWithImpl<$Res, $Val extends HurlRequest>
    implements $HurlRequestCopyWith<$Res> {
  _$HurlRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? url = null,
    Object? headers = freezed,
    Object? comments = freezed,
    Object? options = freezed,
    Object? body = freezed,
    Object? multiPartFormData = freezed,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<RequestOption>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as RequestBody?,
      multiPartFormData: freezed == multiPartFormData
          ? _value.multiPartFormData
          : multiPartFormData // ignore: cast_nullable_to_non_nullable
              as List<MultipartFormData>?,
    ) as $Val);
  }

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestBodyCopyWith<$Res>? get body {
    if (_value.body == null) {
      return null;
    }

    return $RequestBodyCopyWith<$Res>(_value.body!, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HurlRequestImplCopyWith<$Res>
    implements $HurlRequestCopyWith<$Res> {
  factory _$$HurlRequestImplCopyWith(
          _$HurlRequestImpl value, $Res Function(_$HurlRequestImpl) then) =
      __$$HurlRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String method,
      String url,
      List<Header>? headers,
      List<String>? comments,
      List<RequestOption>? options,
      RequestBody? body,
      @JsonKey(name: "multipart_form_data")
      List<MultipartFormData>? multiPartFormData});

  @override
  $RequestBodyCopyWith<$Res>? get body;
}

/// @nodoc
class __$$HurlRequestImplCopyWithImpl<$Res>
    extends _$HurlRequestCopyWithImpl<$Res, _$HurlRequestImpl>
    implements _$$HurlRequestImplCopyWith<$Res> {
  __$$HurlRequestImplCopyWithImpl(
      _$HurlRequestImpl _value, $Res Function(_$HurlRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? url = null,
    Object? headers = freezed,
    Object? comments = freezed,
    Object? options = freezed,
    Object? body = freezed,
    Object? multiPartFormData = freezed,
  }) {
    return _then(_$HurlRequestImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      comments: freezed == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<RequestOption>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as RequestBody?,
      multiPartFormData: freezed == multiPartFormData
          ? _value._multiPartFormData
          : multiPartFormData // ignore: cast_nullable_to_non_nullable
              as List<MultipartFormData>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$HurlRequestImpl implements _HurlRequest {
  const _$HurlRequestImpl(
      {required this.method,
      required this.url,
      final List<Header>? headers,
      final List<String>? comments,
      final List<RequestOption>? options,
      this.body,
      @JsonKey(name: "multipart_form_data")
      final List<MultipartFormData>? multiPartFormData})
      : _headers = headers,
        _comments = comments,
        _options = options,
        _multiPartFormData = multiPartFormData;

  factory _$HurlRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$HurlRequestImplFromJson(json);

  @override
  final String method;
  @override
  final String url;
  final List<Header>? _headers;
  @override
  List<Header>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _comments;
  @override
  List<String>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<RequestOption>? _options;
  @override
  List<RequestOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final RequestBody? body;
  final List<MultipartFormData>? _multiPartFormData;
  @override
  @JsonKey(name: "multipart_form_data")
  List<MultipartFormData>? get multiPartFormData {
    final value = _multiPartFormData;
    if (value == null) return null;
    if (_multiPartFormData is EqualUnmodifiableListView)
      return _multiPartFormData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HurlRequest(method: $method, url: $url, headers: $headers, comments: $comments, options: $options, body: $body, multiPartFormData: $multiPartFormData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HurlRequestImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality()
                .equals(other._multiPartFormData, _multiPartFormData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      url,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_comments),
      const DeepCollectionEquality().hash(_options),
      body,
      const DeepCollectionEquality().hash(_multiPartFormData));

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HurlRequestImplCopyWith<_$HurlRequestImpl> get copyWith =>
      __$$HurlRequestImplCopyWithImpl<_$HurlRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HurlRequestImplToJson(
      this,
    );
  }
}

abstract class _HurlRequest implements HurlRequest {
  const factory _HurlRequest(
      {required final String method,
      required final String url,
      final List<Header>? headers,
      final List<String>? comments,
      final List<RequestOption>? options,
      final RequestBody? body,
      @JsonKey(name: "multipart_form_data")
      final List<MultipartFormData>? multiPartFormData}) = _$HurlRequestImpl;

  factory _HurlRequest.fromJson(Map<String, dynamic> json) =
      _$HurlRequestImpl.fromJson;

  @override
  String get method;
  @override
  String get url;
  @override
  List<Header>? get headers;
  @override
  List<String>? get comments;
  @override
  List<RequestOption>? get options;
  @override
  RequestBody? get body;
  @override
  @JsonKey(name: "multipart_form_data")
  List<MultipartFormData>? get multiPartFormData;

  /// Create a copy of HurlRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HurlRequestImplCopyWith<_$HurlRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
