// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WebSocketRequestModel _$WebSocketRequestModelFromJson(
    Map<String, dynamic> json) {
  return _WebSocketRequestModel.fromJson(json);
}

/// @nodoc
mixin _$WebSocketRequestModel {
  String get url => throw _privateConstructorUsedError;
  ContentTypeWebSocket get contentType => throw _privateConstructorUsedError;
  bool? get isConnected => throw _privateConstructorUsedError;
  List<NameValueModel>? get headers => throw _privateConstructorUsedError;
  List<bool>? get isHeaderEnabledList => throw _privateConstructorUsedError;
  List<NameValueModel>? get params => throw _privateConstructorUsedError;
  List<bool>? get isParamEnabledList => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this WebSocketRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketRequestModelCopyWith<WebSocketRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketRequestModelCopyWith<$Res> {
  factory $WebSocketRequestModelCopyWith(WebSocketRequestModel value,
          $Res Function(WebSocketRequestModel) then) =
      _$WebSocketRequestModelCopyWithImpl<$Res, WebSocketRequestModel>;
  @useResult
  $Res call(
      {String url,
      ContentTypeWebSocket contentType,
      bool? isConnected,
      List<NameValueModel>? headers,
      List<bool>? isHeaderEnabledList,
      List<NameValueModel>? params,
      List<bool>? isParamEnabledList,
      String? message});
}

/// @nodoc
class _$WebSocketRequestModelCopyWithImpl<$Res,
        $Val extends WebSocketRequestModel>
    implements $WebSocketRequestModelCopyWith<$Res> {
  _$WebSocketRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? contentType = null,
    Object? isConnected = freezed,
    Object? headers = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? params = freezed,
    Object? isParamEnabledList = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ContentTypeWebSocket,
      isConnected: freezed == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value.isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _value.isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebSocketRequestModelImplCopyWith<$Res>
    implements $WebSocketRequestModelCopyWith<$Res> {
  factory _$$WebSocketRequestModelImplCopyWith(
          _$WebSocketRequestModelImpl value,
          $Res Function(_$WebSocketRequestModelImpl) then) =
      __$$WebSocketRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url,
      ContentTypeWebSocket contentType,
      bool? isConnected,
      List<NameValueModel>? headers,
      List<bool>? isHeaderEnabledList,
      List<NameValueModel>? params,
      List<bool>? isParamEnabledList,
      String? message});
}

/// @nodoc
class __$$WebSocketRequestModelImplCopyWithImpl<$Res>
    extends _$WebSocketRequestModelCopyWithImpl<$Res,
        _$WebSocketRequestModelImpl>
    implements _$$WebSocketRequestModelImplCopyWith<$Res> {
  __$$WebSocketRequestModelImplCopyWithImpl(_$WebSocketRequestModelImpl _value,
      $Res Function(_$WebSocketRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? contentType = null,
    Object? isConnected = freezed,
    Object? headers = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? params = freezed,
    Object? isParamEnabledList = freezed,
    Object? message = freezed,
  }) {
    return _then(_$WebSocketRequestModelImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as ContentTypeWebSocket,
      isConnected: freezed == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value._isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _value._isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$WebSocketRequestModelImpl extends _WebSocketRequestModel {
  const _$WebSocketRequestModelImpl(
      {this.url = "",
      this.contentType = ContentTypeWebSocket.text,
      this.isConnected,
      final List<NameValueModel>? headers,
      final List<bool>? isHeaderEnabledList,
      final List<NameValueModel>? params,
      final List<bool>? isParamEnabledList,
      this.message})
      : _headers = headers,
        _isHeaderEnabledList = isHeaderEnabledList,
        _params = params,
        _isParamEnabledList = isParamEnabledList,
        super._();

  factory _$WebSocketRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final ContentTypeWebSocket contentType;
  @override
  final bool? isConnected;
  final List<NameValueModel>? _headers;
  @override
  List<NameValueModel>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isHeaderEnabledList;
  @override
  List<bool>? get isHeaderEnabledList {
    final value = _isHeaderEnabledList;
    if (value == null) return null;
    if (_isHeaderEnabledList is EqualUnmodifiableListView)
      return _isHeaderEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<NameValueModel>? _params;
  @override
  List<NameValueModel>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableListView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isParamEnabledList;
  @override
  List<bool>? get isParamEnabledList {
    final value = _isParamEnabledList;
    if (value == null) return null;
    if (_isParamEnabledList is EqualUnmodifiableListView)
      return _isParamEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'WebSocketRequestModel(url: $url, contentType: $contentType, isConnected: $isConnected, headers: $headers, isHeaderEnabledList: $isHeaderEnabledList, params: $params, isParamEnabledList: $isParamEnabledList, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketRequestModelImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._isHeaderEnabledList, _isHeaderEnabledList) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality()
                .equals(other._isParamEnabledList, _isParamEnabledList) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      contentType,
      isConnected,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_isHeaderEnabledList),
      const DeepCollectionEquality().hash(_params),
      const DeepCollectionEquality().hash(_isParamEnabledList),
      message);

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketRequestModelImplCopyWith<_$WebSocketRequestModelImpl>
      get copyWith => __$$WebSocketRequestModelImplCopyWithImpl<
          _$WebSocketRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketRequestModelImplToJson(
      this,
    );
  }
}

abstract class _WebSocketRequestModel extends WebSocketRequestModel {
  const factory _WebSocketRequestModel(
      {final String url,
      final ContentTypeWebSocket contentType,
      final bool? isConnected,
      final List<NameValueModel>? headers,
      final List<bool>? isHeaderEnabledList,
      final List<NameValueModel>? params,
      final List<bool>? isParamEnabledList,
      final String? message}) = _$WebSocketRequestModelImpl;
  const _WebSocketRequestModel._() : super._();

  factory _WebSocketRequestModel.fromJson(Map<String, dynamic> json) =
      _$WebSocketRequestModelImpl.fromJson;

  @override
  String get url;
  @override
  ContentTypeWebSocket get contentType;
  @override
  bool? get isConnected;
  @override
  List<NameValueModel>? get headers;
  @override
  List<bool>? get isHeaderEnabledList;
  @override
  List<NameValueModel>? get params;
  @override
  List<bool>? get isParamEnabledList;
  @override
  String? get message;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketRequestModelImplCopyWith<_$WebSocketRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
