// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketResponseModel _$WebSocketResponseModelFromJson(
    Map<String, dynamic> json) {
  return _WebSocketResponseModel.fromJson(json);
}

/// @nodoc
mixin _$WebSocketResponseModel {
  int? get statusCode => throw _privateConstructorUsedError;
  List<WebSocketFrameModel> get frames => throw _privateConstructorUsedError;
  Map<String, String>? get headers => throw _privateConstructorUsedError;
  Map<String, String>? get requestHeaders => throw _privateConstructorUsedError;

  /// Serializes this WebSocketResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketResponseModelCopyWith<WebSocketResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketResponseModelCopyWith<$Res> {
  factory $WebSocketResponseModelCopyWith(WebSocketResponseModel value,
          $Res Function(WebSocketResponseModel) then) =
      _$WebSocketResponseModelCopyWithImpl<$Res, WebSocketResponseModel>;
  @useResult
  $Res call(
      {int? statusCode,
      List<WebSocketFrameModel> frames,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders});
}

/// @nodoc
class _$WebSocketResponseModelCopyWithImpl<$Res,
        $Val extends WebSocketResponseModel>
    implements $WebSocketResponseModelCopyWith<$Res> {
  _$WebSocketResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? frames = null,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      frames: null == frames
          ? _value.frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<WebSocketFrameModel>,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      requestHeaders: freezed == requestHeaders
          ? _value.requestHeaders
          : requestHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketResponseModelImplCopyWith<$Res>
    implements $WebSocketResponseModelCopyWith<$Res> {
  factory _$$WebSocketResponseModelImplCopyWith(
          _$WebSocketResponseModelImpl value,
          $Res Function(_$WebSocketResponseModelImpl) then) =
      __$$WebSocketResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statusCode,
      List<WebSocketFrameModel> frames,
      Map<String, String>? headers,
      Map<String, String>? requestHeaders});
}

/// @nodoc
class __$$WebSocketResponseModelImplCopyWithImpl<$Res>
    extends _$WebSocketResponseModelCopyWithImpl<$Res,
        _$WebSocketResponseModelImpl>
    implements _$$WebSocketResponseModelImplCopyWith<$Res> {
  __$$WebSocketResponseModelImplCopyWithImpl(
      _$WebSocketResponseModelImpl _value,
      $Res Function(_$WebSocketResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? frames = null,
    Object? headers = freezed,
    Object? requestHeaders = freezed,
  }) {
    return _then(_$WebSocketResponseModelImpl(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      frames: null == frames
          ? _value._frames
          : frames // ignore: cast_nullable_to_non_nullable
              as List<WebSocketFrameModel>,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      requestHeaders: freezed == requestHeaders
          ? _value._requestHeaders
          : requestHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$WebSocketResponseModelImpl extends _WebSocketResponseModel {
  const _$WebSocketResponseModelImpl(
      {this.statusCode,
      final List<WebSocketFrameModel> frames = const [],
      final Map<String, String>? headers,
      final Map<String, String>? requestHeaders})
      : _frames = frames,
        _headers = headers,
        _requestHeaders = requestHeaders,
        super._();

  factory _$WebSocketResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketResponseModelImplFromJson(json);

  @override
  final int? statusCode;
  final List<WebSocketFrameModel> _frames;
  @override
  @JsonKey()
  List<WebSocketFrameModel> get frames {
    if (_frames is EqualUnmodifiableListView) return _frames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_frames);
  }

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
  String toString() {
    return 'WebSocketResponseModel(statusCode: $statusCode, frames: $frames, headers: $headers, requestHeaders: $requestHeaders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketResponseModelImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other._frames, _frames) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._requestHeaders, _requestHeaders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      statusCode,
      const DeepCollectionEquality().hash(_frames),
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_requestHeaders));

  /// Create a copy of WebSocketResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketResponseModelImplCopyWith<_$WebSocketResponseModelImpl>
      get copyWith => __$$WebSocketResponseModelImplCopyWithImpl<
          _$WebSocketResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketResponseModelImplToJson(
      this,
    );
  }
}

abstract class _WebSocketResponseModel extends WebSocketResponseModel {
  const factory _WebSocketResponseModel(
          {final int? statusCode,
          final List<WebSocketFrameModel> frames,
          final Map<String, String>? headers,
          final Map<String, String>? requestHeaders}) =
      _$WebSocketResponseModelImpl;
  const _WebSocketResponseModel._() : super._();

  factory _WebSocketResponseModel.fromJson(Map<String, dynamic> json) =
      _$WebSocketResponseModelImpl.fromJson;

  @override
  int? get statusCode;
  @override
  List<WebSocketFrameModel> get frames;
  @override
  Map<String, String>? get headers;
  @override
  Map<String, String>? get requestHeaders;

  /// Create a copy of WebSocketResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketResponseModelImplCopyWith<_$WebSocketResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
