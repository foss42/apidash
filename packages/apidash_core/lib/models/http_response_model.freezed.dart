// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HttpResponseModel _$HttpResponseModelFromJson(Map<String, dynamic> json) {
  return _HttpResponseModel.fromJson(json);
}

/// @nodoc
mixin _$HttpResponseModel {
  int? get statusCode => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  Map<String, String>? get requestHeaders => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get formattedBody => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get bodyBytes => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration? get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HttpResponseModelCopyWith<HttpResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpResponseModelCopyWith<$Res> {
  factory $HttpResponseModelCopyWith(
          HttpResponseModel value, $Res Function(HttpResponseModel) then) =
      _$HttpResponseModelCopyWithImpl<$Res, HttpResponseModel>;
  @useResult
  $Res call(
      {int? statusCode,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders,
      String? body,
      String? formattedBody,
      @Uint8ListConverter() Uint8List? bodyBytes,
      @DurationConverter() Duration? time});
}

/// @nodoc
class _$HttpResponseModelCopyWithImpl<$Res, $Val extends HttpResponseModel>
    implements $HttpResponseModelCopyWith<$Res> {
  _$HttpResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
    Object? body = freezed,
    Object? formattedBody = freezed,
    Object? bodyBytes = freezed,
    Object? time = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      requestHeaders: freezed == requestHeaders
          ? _value.requestHeaders
          : requestHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedBody: freezed == formattedBody
          ? _value.formattedBody
          : formattedBody // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyBytes: freezed == bodyBytes
          ? _value.bodyBytes
          : bodyBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HttpResponseModelImplCopyWith<$Res>
    implements $HttpResponseModelCopyWith<$Res> {
  factory _$$HttpResponseModelImplCopyWith(_$HttpResponseModelImpl value,
          $Res Function(_$HttpResponseModelImpl) then) =
      __$$HttpResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statusCode,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders,
      String? body,
      String? formattedBody,
      @Uint8ListConverter() Uint8List? bodyBytes,
      @DurationConverter() Duration? time});
}

/// @nodoc
class __$$HttpResponseModelImplCopyWithImpl<$Res>
    extends _$HttpResponseModelCopyWithImpl<$Res, _$HttpResponseModelImpl>
    implements _$$HttpResponseModelImplCopyWith<$Res> {
  __$$HttpResponseModelImplCopyWithImpl(_$HttpResponseModelImpl _value,
      $Res Function(_$HttpResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
    Object? body = freezed,
    Object? formattedBody = freezed,
    Object? bodyBytes = freezed,
    Object? time = freezed,
  }) {
    return _then(_$HttpResponseModelImpl(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      requestHeaders: freezed == requestHeaders
          ? _value._requestHeaders
          : requestHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedBody: freezed == formattedBody
          ? _value.formattedBody
          : formattedBody // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyBytes: freezed == bodyBytes
          ? _value.bodyBytes
          : bodyBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HttpResponseModelImpl extends _HttpResponseModel {
  const _$HttpResponseModelImpl(
      {this.statusCode,
      final Map<String, String>? headers,
      final Map<String, String>? requestHeaders,
      this.body,
      this.formattedBody,
      @Uint8ListConverter() this.bodyBytes,
      @DurationConverter() this.time})
      : _headers = headers,
        _requestHeaders = requestHeaders,
        super._();

  factory _$HttpResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HttpResponseModelImplFromJson(json);

  @override
  final int? statusCode;
  final Map<String, String>? _headers;
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, String>? _requestHeaders;
  @override
  Map<String, String>? get requestHeaders {
    final value = _requestHeaders;
    if (value == null) return null;
    if (_requestHeaders is EqualUnmodifiableMapView) return _requestHeaders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? body;
  @override
  final String? formattedBody;
  @override
  @Uint8ListConverter()
  final Uint8List? bodyBytes;
  @override
  @DurationConverter()
  final Duration? time;

  @override
  String toString() {
    return 'HttpResponseModel(statusCode: $statusCode, headers: $headers, requestHeaders: $requestHeaders, body: $body, formattedBody: $formattedBody, bodyBytes: $bodyBytes, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpResponseModelImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._requestHeaders, _requestHeaders) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.formattedBody, formattedBody) ||
                other.formattedBody == formattedBody) &&
            const DeepCollectionEquality().equals(other.bodyBytes, bodyBytes) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      statusCode,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_requestHeaders),
      body,
      formattedBody,
      const DeepCollectionEquality().hash(bodyBytes),
      time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpResponseModelImplCopyWith<_$HttpResponseModelImpl> get copyWith =>
      __$$HttpResponseModelImplCopyWithImpl<_$HttpResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HttpResponseModelImplToJson(
      this,
    );
  }
}

abstract class _HttpResponseModel extends HttpResponseModel {
  const factory _HttpResponseModel(
      {final int? statusCode,
      final Map<String, String>? headers,
      final Map<String, String>? requestHeaders,
      final String? body,
      final String? formattedBody,
      @Uint8ListConverter() final Uint8List? bodyBytes,
      @DurationConverter() final Duration? time}) = _$HttpResponseModelImpl;
  const _HttpResponseModel._() : super._();

  factory _HttpResponseModel.fromJson(Map<String, dynamic> json) =
      _$HttpResponseModelImpl.fromJson;

  @override
  int? get statusCode;
  @override
  Map<String, String>? get headers;
  @override
  Map<String, String>? get requestHeaders;
  @override
  String? get body;
  @override
  String? get formattedBody;
  @override
  @Uint8ListConverter()
  Uint8List? get bodyBytes;
  @override
  @DurationConverter()
  Duration? get time;
  @override
  @JsonKey(ignore: true)
  _$$HttpResponseModelImplCopyWith<_$HttpResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
