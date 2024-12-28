// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graphql_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphqlResponseModel _$GraphqlResponseModelFromJson(Map<String, dynamic> json) {
  return _GraphqlResponseModel.fromJson(json);
}

/// @nodoc
mixin _$GraphqlResponseModel {
  int? get statusCode => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  Map<String, String>? get requestHeaders => throw _privateConstructorUsedError;
  GraphqlRequestModel? get graphqlRequestModel =>
      throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  String? get formattedBody => throw _privateConstructorUsedError;
  @Uint8ListConverter()
  Uint8List? get bodyBytes => throw _privateConstructorUsedError;
  @DurationConverter()
  Duration? get time => throw _privateConstructorUsedError;

  /// Serializes this GraphqlResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphqlResponseModelCopyWith<GraphqlResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphqlResponseModelCopyWith<$Res> {
  factory $GraphqlResponseModelCopyWith(GraphqlResponseModel value,
          $Res Function(GraphqlResponseModel) then) =
      _$GraphqlResponseModelCopyWithImpl<$Res, GraphqlResponseModel>;
  @useResult
  $Res call(
      {int? statusCode,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders,
      GraphqlRequestModel? graphqlRequestModel,
      String? body,
      String? formattedBody,
      @Uint8ListConverter() Uint8List? bodyBytes,
      @DurationConverter() Duration? time});

  $GraphqlRequestModelCopyWith<$Res>? get graphqlRequestModel;
}

/// @nodoc
class _$GraphqlResponseModelCopyWithImpl<$Res,
        $Val extends GraphqlResponseModel>
    implements $GraphqlResponseModelCopyWith<$Res> {
  _$GraphqlResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
    Object? graphqlRequestModel = freezed,
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
      graphqlRequestModel: freezed == graphqlRequestModel
          ? _value.graphqlRequestModel
          : graphqlRequestModel // ignore: cast_nullable_to_non_nullable
              as GraphqlRequestModel?,
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

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GraphqlRequestModelCopyWith<$Res>? get graphqlRequestModel {
    if (_value.graphqlRequestModel == null) {
      return null;
    }

    return $GraphqlRequestModelCopyWith<$Res>(_value.graphqlRequestModel!,
        (value) {
      return _then(_value.copyWith(graphqlRequestModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GraphqlResponseModelImplCopyWith<$Res>
    implements $GraphqlResponseModelCopyWith<$Res> {
  factory _$$GraphqlResponseModelImplCopyWith(_$GraphqlResponseModelImpl value,
          $Res Function(_$GraphqlResponseModelImpl) then) =
      __$$GraphqlResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statusCode,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders,
      GraphqlRequestModel? graphqlRequestModel,
      String? body,
      String? formattedBody,
      @Uint8ListConverter() Uint8List? bodyBytes,
      @DurationConverter() Duration? time});

  @override
  $GraphqlRequestModelCopyWith<$Res>? get graphqlRequestModel;
}

/// @nodoc
class __$$GraphqlResponseModelImplCopyWithImpl<$Res>
    extends _$GraphqlResponseModelCopyWithImpl<$Res, _$GraphqlResponseModelImpl>
    implements _$$GraphqlResponseModelImplCopyWith<$Res> {
  __$$GraphqlResponseModelImplCopyWithImpl(_$GraphqlResponseModelImpl _value,
      $Res Function(_$GraphqlResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
    Object? graphqlRequestModel = freezed,
    Object? body = freezed,
    Object? formattedBody = freezed,
    Object? bodyBytes = freezed,
    Object? time = freezed,
  }) {
    return _then(_$GraphqlResponseModelImpl(
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
      graphqlRequestModel: freezed == graphqlRequestModel
          ? _value.graphqlRequestModel
          : graphqlRequestModel // ignore: cast_nullable_to_non_nullable
              as GraphqlRequestModel?,
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

@json_annotation.JsonSerializable(explicitToJson: true, anyMap: true)
class _$GraphqlResponseModelImpl extends _GraphqlResponseModel {
  const _$GraphqlResponseModelImpl(
      {this.statusCode,
      final Map<String, String>? headers,
      final Map<String, String>? requestHeaders,
      this.graphqlRequestModel,
      this.body,
      this.formattedBody,
      @Uint8ListConverter() this.bodyBytes,
      @DurationConverter() this.time})
      : _headers = headers,
        _requestHeaders = requestHeaders,
        super._();

  factory _$GraphqlResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphqlResponseModelImplFromJson(json);

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
  final GraphqlRequestModel? graphqlRequestModel;
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
    return 'GraphqlResponseModel(statusCode: $statusCode, headers: $headers, requestHeaders: $requestHeaders, graphqlRequestModel: $graphqlRequestModel, body: $body, formattedBody: $formattedBody, bodyBytes: $bodyBytes, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphqlResponseModelImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._requestHeaders, _requestHeaders) &&
            (identical(other.graphqlRequestModel, graphqlRequestModel) ||
                other.graphqlRequestModel == graphqlRequestModel) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.formattedBody, formattedBody) ||
                other.formattedBody == formattedBody) &&
            const DeepCollectionEquality().equals(other.bodyBytes, bodyBytes) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      statusCode,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_requestHeaders),
      graphqlRequestModel,
      body,
      formattedBody,
      const DeepCollectionEquality().hash(bodyBytes),
      time);

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphqlResponseModelImplCopyWith<_$GraphqlResponseModelImpl>
      get copyWith =>
          __$$GraphqlResponseModelImplCopyWithImpl<_$GraphqlResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphqlResponseModelImplToJson(
      this,
    );
  }
}

abstract class _GraphqlResponseModel extends GraphqlResponseModel {
  const factory _GraphqlResponseModel(
      {final int? statusCode,
      final Map<String, String>? headers,
      final Map<String, String>? requestHeaders,
      final GraphqlRequestModel? graphqlRequestModel,
      final String? body,
      final String? formattedBody,
      @Uint8ListConverter() final Uint8List? bodyBytes,
      @DurationConverter() final Duration? time}) = _$GraphqlResponseModelImpl;
  const _GraphqlResponseModel._() : super._();

  factory _GraphqlResponseModel.fromJson(Map<String, dynamic> json) =
      _$GraphqlResponseModelImpl.fromJson;

  @override
  int? get statusCode;
  @override
  Map<String, String>? get headers;
  @override
  Map<String, String>? get requestHeaders;
  @override
  GraphqlRequestModel? get graphqlRequestModel;
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

  /// Create a copy of GraphqlResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphqlResponseModelImplCopyWith<_$GraphqlResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
