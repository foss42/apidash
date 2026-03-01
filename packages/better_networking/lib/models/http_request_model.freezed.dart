// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HttpRequestModel {

 HTTPVerb get method; String get url; List<NameValueModel>? get headers; List<NameValueModel>? get params; AuthModel? get authModel; List<bool>? get isHeaderEnabledList; List<bool>? get isParamEnabledList; ContentType get bodyContentType; String? get body; String? get query; List<FormDataModel>? get formData;
/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpRequestModelCopyWith<HttpRequestModel> get copyWith => _$HttpRequestModelCopyWithImpl<HttpRequestModel>(this as HttpRequestModel, _$identity);

  /// Serializes this HttpRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpRequestModel&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.params, params)&&(identical(other.authModel, authModel) || other.authModel == authModel)&&const DeepCollectionEquality().equals(other.isHeaderEnabledList, isHeaderEnabledList)&&const DeepCollectionEquality().equals(other.isParamEnabledList, isParamEnabledList)&&(identical(other.bodyContentType, bodyContentType) || other.bodyContentType == bodyContentType)&&(identical(other.body, body) || other.body == body)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.formData, formData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(params),authModel,const DeepCollectionEquality().hash(isHeaderEnabledList),const DeepCollectionEquality().hash(isParamEnabledList),bodyContentType,body,query,const DeepCollectionEquality().hash(formData));

@override
String toString() {
  return 'HttpRequestModel(method: $method, url: $url, headers: $headers, params: $params, authModel: $authModel, isHeaderEnabledList: $isHeaderEnabledList, isParamEnabledList: $isParamEnabledList, bodyContentType: $bodyContentType, body: $body, query: $query, formData: $formData)';
}


}

/// @nodoc
abstract mixin class $HttpRequestModelCopyWith<$Res>  {
  factory $HttpRequestModelCopyWith(HttpRequestModel value, $Res Function(HttpRequestModel) _then) = _$HttpRequestModelCopyWithImpl;
@useResult
$Res call({
 HTTPVerb method, String url, List<NameValueModel>? headers, List<NameValueModel>? params, AuthModel? authModel, List<bool>? isHeaderEnabledList, List<bool>? isParamEnabledList, ContentType bodyContentType, String? body, String? query, List<FormDataModel>? formData
});


$AuthModelCopyWith<$Res>? get authModel;

}
/// @nodoc
class _$HttpRequestModelCopyWithImpl<$Res>
    implements $HttpRequestModelCopyWith<$Res> {
  _$HttpRequestModelCopyWithImpl(this._self, this._then);

  final HttpRequestModel _self;
  final $Res Function(HttpRequestModel) _then;

/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? url = null,Object? headers = freezed,Object? params = freezed,Object? authModel = freezed,Object? isHeaderEnabledList = freezed,Object? isParamEnabledList = freezed,Object? bodyContentType = null,Object? body = freezed,Object? query = freezed,Object? formData = freezed,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HTTPVerb,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,authModel: freezed == authModel ? _self.authModel : authModel // ignore: cast_nullable_to_non_nullable
as AuthModel?,isHeaderEnabledList: freezed == isHeaderEnabledList ? _self.isHeaderEnabledList : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>?,isParamEnabledList: freezed == isParamEnabledList ? _self.isParamEnabledList : isParamEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>?,bodyContentType: null == bodyContentType ? _self.bodyContentType : bodyContentType // ignore: cast_nullable_to_non_nullable
as ContentType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,formData: freezed == formData ? _self.formData : formData // ignore: cast_nullable_to_non_nullable
as List<FormDataModel>?,
  ));
}
/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
    return null;
  }

  return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
    return _then(_self.copyWith(authModel: value));
  });
}
}


/// Adds pattern-matching-related methods to [HttpRequestModel].
extension HttpRequestModelPatterns on HttpRequestModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HttpRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HttpRequestModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HttpRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _HttpRequestModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HttpRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _HttpRequestModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HTTPVerb method,  String url,  List<NameValueModel>? headers,  List<NameValueModel>? params,  AuthModel? authModel,  List<bool>? isHeaderEnabledList,  List<bool>? isParamEnabledList,  ContentType bodyContentType,  String? body,  String? query,  List<FormDataModel>? formData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HttpRequestModel() when $default != null:
return $default(_that.method,_that.url,_that.headers,_that.params,_that.authModel,_that.isHeaderEnabledList,_that.isParamEnabledList,_that.bodyContentType,_that.body,_that.query,_that.formData);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HTTPVerb method,  String url,  List<NameValueModel>? headers,  List<NameValueModel>? params,  AuthModel? authModel,  List<bool>? isHeaderEnabledList,  List<bool>? isParamEnabledList,  ContentType bodyContentType,  String? body,  String? query,  List<FormDataModel>? formData)  $default,) {final _that = this;
switch (_that) {
case _HttpRequestModel():
return $default(_that.method,_that.url,_that.headers,_that.params,_that.authModel,_that.isHeaderEnabledList,_that.isParamEnabledList,_that.bodyContentType,_that.body,_that.query,_that.formData);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HTTPVerb method,  String url,  List<NameValueModel>? headers,  List<NameValueModel>? params,  AuthModel? authModel,  List<bool>? isHeaderEnabledList,  List<bool>? isParamEnabledList,  ContentType bodyContentType,  String? body,  String? query,  List<FormDataModel>? formData)?  $default,) {final _that = this;
switch (_that) {
case _HttpRequestModel() when $default != null:
return $default(_that.method,_that.url,_that.headers,_that.params,_that.authModel,_that.isHeaderEnabledList,_that.isParamEnabledList,_that.bodyContentType,_that.body,_that.query,_that.formData);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _HttpRequestModel extends HttpRequestModel {
  const _HttpRequestModel({this.method = HTTPVerb.get, this.url = "", final  List<NameValueModel>? headers, final  List<NameValueModel>? params, this.authModel = const AuthModel(type: APIAuthType.none), final  List<bool>? isHeaderEnabledList, final  List<bool>? isParamEnabledList, this.bodyContentType = ContentType.json, this.body, this.query, final  List<FormDataModel>? formData}): _headers = headers,_params = params,_isHeaderEnabledList = isHeaderEnabledList,_isParamEnabledList = isParamEnabledList,_formData = formData,super._();
  factory _HttpRequestModel.fromJson(Map<String, dynamic> json) => _$HttpRequestModelFromJson(json);

@override@JsonKey() final  HTTPVerb method;
@override@JsonKey() final  String url;
 final  List<NameValueModel>? _headers;
@override List<NameValueModel>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<NameValueModel>? _params;
@override List<NameValueModel>? get params {
  final value = _params;
  if (value == null) return null;
  if (_params is EqualUnmodifiableListView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  AuthModel? authModel;
 final  List<bool>? _isHeaderEnabledList;
@override List<bool>? get isHeaderEnabledList {
  final value = _isHeaderEnabledList;
  if (value == null) return null;
  if (_isHeaderEnabledList is EqualUnmodifiableListView) return _isHeaderEnabledList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<bool>? _isParamEnabledList;
@override List<bool>? get isParamEnabledList {
  final value = _isParamEnabledList;
  if (value == null) return null;
  if (_isParamEnabledList is EqualUnmodifiableListView) return _isParamEnabledList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  ContentType bodyContentType;
@override final  String? body;
@override final  String? query;
 final  List<FormDataModel>? _formData;
@override List<FormDataModel>? get formData {
  final value = _formData;
  if (value == null) return null;
  if (_formData is EqualUnmodifiableListView) return _formData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HttpRequestModelCopyWith<_HttpRequestModel> get copyWith => __$HttpRequestModelCopyWithImpl<_HttpRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HttpRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HttpRequestModel&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other._params, _params)&&(identical(other.authModel, authModel) || other.authModel == authModel)&&const DeepCollectionEquality().equals(other._isHeaderEnabledList, _isHeaderEnabledList)&&const DeepCollectionEquality().equals(other._isParamEnabledList, _isParamEnabledList)&&(identical(other.bodyContentType, bodyContentType) || other.bodyContentType == bodyContentType)&&(identical(other.body, body) || other.body == body)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._formData, _formData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(_params),authModel,const DeepCollectionEquality().hash(_isHeaderEnabledList),const DeepCollectionEquality().hash(_isParamEnabledList),bodyContentType,body,query,const DeepCollectionEquality().hash(_formData));

@override
String toString() {
  return 'HttpRequestModel(method: $method, url: $url, headers: $headers, params: $params, authModel: $authModel, isHeaderEnabledList: $isHeaderEnabledList, isParamEnabledList: $isParamEnabledList, bodyContentType: $bodyContentType, body: $body, query: $query, formData: $formData)';
}


}

/// @nodoc
abstract mixin class _$HttpRequestModelCopyWith<$Res> implements $HttpRequestModelCopyWith<$Res> {
  factory _$HttpRequestModelCopyWith(_HttpRequestModel value, $Res Function(_HttpRequestModel) _then) = __$HttpRequestModelCopyWithImpl;
@override @useResult
$Res call({
 HTTPVerb method, String url, List<NameValueModel>? headers, List<NameValueModel>? params, AuthModel? authModel, List<bool>? isHeaderEnabledList, List<bool>? isParamEnabledList, ContentType bodyContentType, String? body, String? query, List<FormDataModel>? formData
});


@override $AuthModelCopyWith<$Res>? get authModel;

}
/// @nodoc
class __$HttpRequestModelCopyWithImpl<$Res>
    implements _$HttpRequestModelCopyWith<$Res> {
  __$HttpRequestModelCopyWithImpl(this._self, this._then);

  final _HttpRequestModel _self;
  final $Res Function(_HttpRequestModel) _then;

/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? url = null,Object? headers = freezed,Object? params = freezed,Object? authModel = freezed,Object? isHeaderEnabledList = freezed,Object? isParamEnabledList = freezed,Object? bodyContentType = null,Object? body = freezed,Object? query = freezed,Object? formData = freezed,}) {
  return _then(_HttpRequestModel(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HTTPVerb,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,params: freezed == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,authModel: freezed == authModel ? _self.authModel : authModel // ignore: cast_nullable_to_non_nullable
as AuthModel?,isHeaderEnabledList: freezed == isHeaderEnabledList ? _self._isHeaderEnabledList : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>?,isParamEnabledList: freezed == isParamEnabledList ? _self._isParamEnabledList : isParamEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>?,bodyContentType: null == bodyContentType ? _self.bodyContentType : bodyContentType // ignore: cast_nullable_to_non_nullable
as ContentType,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,formData: freezed == formData ? _self._formData : formData // ignore: cast_nullable_to_non_nullable
as List<FormDataModel>?,
  ));
}

/// Create a copy of HttpRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
    return null;
  }

  return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
    return _then(_self.copyWith(authModel: value));
  });
}
}

// dart format on
