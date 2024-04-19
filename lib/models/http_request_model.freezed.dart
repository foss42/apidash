// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HttpRequestModel _$HttpRequestModelFromJson(Map<String, dynamic> json) {
  return _HttpRequestModel.fromJson(json);
}

/// @nodoc
mixin _$HttpRequestModel {
  HTTPVerb get method => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  List<NameValueModel>? get headers => throw _privateConstructorUsedError;
  List<NameValueModel>? get params => throw _privateConstructorUsedError;
  List<bool>? get isHeaderEnabledList => throw _privateConstructorUsedError;
  List<bool>? get isParamEnabledList => throw _privateConstructorUsedError;
  ContentType get bodyContentType => throw _privateConstructorUsedError;
  String? get body => throw _privateConstructorUsedError;
  List<FormDataModel>? get formData => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HttpRequestModelCopyWith<HttpRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HttpRequestModelCopyWith<$Res> {
  factory $HttpRequestModelCopyWith(
          HttpRequestModel value, $Res Function(HttpRequestModel) then) =
      _$HttpRequestModelCopyWithImpl<$Res, HttpRequestModel>;
  @useResult
  $Res call(
      {HTTPVerb method,
      String url,
      List<NameValueModel>? headers,
      List<NameValueModel>? params,
      List<bool>? isHeaderEnabledList,
      List<bool>? isParamEnabledList,
      ContentType bodyContentType,
      String? body,
      List<FormDataModel>? formData});
}

/// @nodoc
class _$HttpRequestModelCopyWithImpl<$Res, $Val extends HttpRequestModel>
    implements $HttpRequestModelCopyWith<$Res> {
  _$HttpRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? url = null,
    Object? headers = freezed,
    Object? params = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? isParamEnabledList = freezed,
    Object? bodyContentType = null,
    Object? body = freezed,
    Object? formData = freezed,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value.isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _value.isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      bodyContentType: null == bodyContentType
          ? _value.bodyContentType
          : bodyContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      formData: freezed == formData
          ? _value.formData
          : formData // ignore: cast_nullable_to_non_nullable
              as List<FormDataModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HttpRequestModelImplCopyWith<$Res>
    implements $HttpRequestModelCopyWith<$Res> {
  factory _$$HttpRequestModelImplCopyWith(_$HttpRequestModelImpl value,
          $Res Function(_$HttpRequestModelImpl) then) =
      __$$HttpRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HTTPVerb method,
      String url,
      List<NameValueModel>? headers,
      List<NameValueModel>? params,
      List<bool>? isHeaderEnabledList,
      List<bool>? isParamEnabledList,
      ContentType bodyContentType,
      String? body,
      List<FormDataModel>? formData});
}

/// @nodoc
class __$$HttpRequestModelImplCopyWithImpl<$Res>
    extends _$HttpRequestModelCopyWithImpl<$Res, _$HttpRequestModelImpl>
    implements _$$HttpRequestModelImplCopyWith<$Res> {
  __$$HttpRequestModelImplCopyWithImpl(_$HttpRequestModelImpl _value,
      $Res Function(_$HttpRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? url = null,
    Object? headers = freezed,
    Object? params = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? isParamEnabledList = freezed,
    Object? bodyContentType = null,
    Object? body = freezed,
    Object? formData = freezed,
  }) {
    return _then(_$HttpRequestModelImpl(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _value._isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _value._isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      bodyContentType: null == bodyContentType
          ? _value.bodyContentType
          : bodyContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
      body: freezed == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      formData: freezed == formData
          ? _value._formData
          : formData // ignore: cast_nullable_to_non_nullable
              as List<FormDataModel>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HttpRequestModelImpl extends _HttpRequestModel {
  const _$HttpRequestModelImpl(
      {this.method = HTTPVerb.get,
      this.url = "",
      final List<NameValueModel>? headers,
      final List<NameValueModel>? params,
      final List<bool>? isHeaderEnabledList,
      final List<bool>? isParamEnabledList,
      this.bodyContentType = ContentType.json,
      this.body,
      final List<FormDataModel>? formData})
      : _headers = headers,
        _params = params,
        _isHeaderEnabledList = isHeaderEnabledList,
        _isParamEnabledList = isParamEnabledList,
        _formData = formData,
        super._();

  factory _$HttpRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HttpRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final HTTPVerb method;
  @override
  @JsonKey()
  final String url;
  final List<NameValueModel>? _headers;
  @override
  List<NameValueModel>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
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
  @JsonKey()
  final ContentType bodyContentType;
  @override
  final String? body;
  final List<FormDataModel>? _formData;
  @override
  List<FormDataModel>? get formData {
    final value = _formData;
    if (value == null) return null;
    if (_formData is EqualUnmodifiableListView) return _formData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HttpRequestModel(method: $method, url: $url, headers: $headers, params: $params, isHeaderEnabledList: $isHeaderEnabledList, isParamEnabledList: $isParamEnabledList, bodyContentType: $bodyContentType, body: $body, formData: $formData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HttpRequestModelImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality()
                .equals(other._isHeaderEnabledList, _isHeaderEnabledList) &&
            const DeepCollectionEquality()
                .equals(other._isParamEnabledList, _isParamEnabledList) &&
            (identical(other.bodyContentType, bodyContentType) ||
                other.bodyContentType == bodyContentType) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality().equals(other._formData, _formData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      url,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_params),
      const DeepCollectionEquality().hash(_isHeaderEnabledList),
      const DeepCollectionEquality().hash(_isParamEnabledList),
      bodyContentType,
      body,
      const DeepCollectionEquality().hash(_formData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HttpRequestModelImplCopyWith<_$HttpRequestModelImpl> get copyWith =>
      __$$HttpRequestModelImplCopyWithImpl<_$HttpRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HttpRequestModelImplToJson(
      this,
    );
  }
}

abstract class _HttpRequestModel extends HttpRequestModel {
  const factory _HttpRequestModel(
      {final HTTPVerb method,
      final String url,
      final List<NameValueModel>? headers,
      final List<NameValueModel>? params,
      final List<bool>? isHeaderEnabledList,
      final List<bool>? isParamEnabledList,
      final ContentType bodyContentType,
      final String? body,
      final List<FormDataModel>? formData}) = _$HttpRequestModelImpl;
  const _HttpRequestModel._() : super._();

  factory _HttpRequestModel.fromJson(Map<String, dynamic> json) =
      _$HttpRequestModelImpl.fromJson;

  @override
  HTTPVerb get method;
  @override
  String get url;
  @override
  List<NameValueModel>? get headers;
  @override
  List<NameValueModel>? get params;
  @override
  List<bool>? get isHeaderEnabledList;
  @override
  List<bool>? get isParamEnabledList;
  @override
  ContentType get bodyContentType;
  @override
  String? get body;
  @override
  List<FormDataModel>? get formData;
  @override
  @JsonKey(ignore: true)
  _$$HttpRequestModelImplCopyWith<_$HttpRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
