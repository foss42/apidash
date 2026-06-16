// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insomnia_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InsomniaCollection {

@JsonKey(name: '_type') String? get type;@JsonKey(name: '__export_format') num? get exportFormat;@JsonKey(name: '__export_date') String? get exportDate;@JsonKey(name: '__export_source') String? get exportSource; List<Resource>? get resources;
/// Create a copy of InsomniaCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InsomniaCollectionCopyWith<InsomniaCollection> get copyWith => _$InsomniaCollectionCopyWithImpl<InsomniaCollection>(this as InsomniaCollection, _$identity);

  /// Serializes this InsomniaCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InsomniaCollection&&(identical(other.type, type) || other.type == type)&&(identical(other.exportFormat, exportFormat) || other.exportFormat == exportFormat)&&(identical(other.exportDate, exportDate) || other.exportDate == exportDate)&&(identical(other.exportSource, exportSource) || other.exportSource == exportSource)&&const DeepCollectionEquality().equals(other.resources, resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,exportFormat,exportDate,exportSource,const DeepCollectionEquality().hash(resources));

@override
String toString() {
  return 'InsomniaCollection(type: $type, exportFormat: $exportFormat, exportDate: $exportDate, exportSource: $exportSource, resources: $resources)';
}


}

/// @nodoc
abstract mixin class $InsomniaCollectionCopyWith<$Res>  {
  factory $InsomniaCollectionCopyWith(InsomniaCollection value, $Res Function(InsomniaCollection) _then) = _$InsomniaCollectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_type') String? type,@JsonKey(name: '__export_format') num? exportFormat,@JsonKey(name: '__export_date') String? exportDate,@JsonKey(name: '__export_source') String? exportSource, List<Resource>? resources
});




}
/// @nodoc
class _$InsomniaCollectionCopyWithImpl<$Res>
    implements $InsomniaCollectionCopyWith<$Res> {
  _$InsomniaCollectionCopyWithImpl(this._self, this._then);

  final InsomniaCollection _self;
  final $Res Function(InsomniaCollection) _then;

/// Create a copy of InsomniaCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? exportFormat = freezed,Object? exportDate = freezed,Object? exportSource = freezed,Object? resources = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,exportFormat: freezed == exportFormat ? _self.exportFormat : exportFormat // ignore: cast_nullable_to_non_nullable
as num?,exportDate: freezed == exportDate ? _self.exportDate : exportDate // ignore: cast_nullable_to_non_nullable
as String?,exportSource: freezed == exportSource ? _self.exportSource : exportSource // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as List<Resource>?,
  ));
}

}


/// Adds pattern-matching-related methods to [InsomniaCollection].
extension InsomniaCollectionPatterns on InsomniaCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InsomniaCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InsomniaCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InsomniaCollection value)  $default,){
final _that = this;
switch (_that) {
case _InsomniaCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InsomniaCollection value)?  $default,){
final _that = this;
switch (_that) {
case _InsomniaCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_type')  String? type, @JsonKey(name: '__export_format')  num? exportFormat, @JsonKey(name: '__export_date')  String? exportDate, @JsonKey(name: '__export_source')  String? exportSource,  List<Resource>? resources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InsomniaCollection() when $default != null:
return $default(_that.type,_that.exportFormat,_that.exportDate,_that.exportSource,_that.resources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_type')  String? type, @JsonKey(name: '__export_format')  num? exportFormat, @JsonKey(name: '__export_date')  String? exportDate, @JsonKey(name: '__export_source')  String? exportSource,  List<Resource>? resources)  $default,) {final _that = this;
switch (_that) {
case _InsomniaCollection():
return $default(_that.type,_that.exportFormat,_that.exportDate,_that.exportSource,_that.resources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_type')  String? type, @JsonKey(name: '__export_format')  num? exportFormat, @JsonKey(name: '__export_date')  String? exportDate, @JsonKey(name: '__export_source')  String? exportSource,  List<Resource>? resources)?  $default,) {final _that = this;
switch (_that) {
case _InsomniaCollection() when $default != null:
return $default(_that.type,_that.exportFormat,_that.exportDate,_that.exportSource,_that.resources);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _InsomniaCollection implements InsomniaCollection {
  const _InsomniaCollection({@JsonKey(name: '_type') this.type, @JsonKey(name: '__export_format') this.exportFormat, @JsonKey(name: '__export_date') this.exportDate, @JsonKey(name: '__export_source') this.exportSource, final  List<Resource>? resources}): _resources = resources;
  factory _InsomniaCollection.fromJson(Map<String, dynamic> json) => _$InsomniaCollectionFromJson(json);

@override@JsonKey(name: '_type') final  String? type;
@override@JsonKey(name: '__export_format') final  num? exportFormat;
@override@JsonKey(name: '__export_date') final  String? exportDate;
@override@JsonKey(name: '__export_source') final  String? exportSource;
 final  List<Resource>? _resources;
@override List<Resource>? get resources {
  final value = _resources;
  if (value == null) return null;
  if (_resources is EqualUnmodifiableListView) return _resources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of InsomniaCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InsomniaCollectionCopyWith<_InsomniaCollection> get copyWith => __$InsomniaCollectionCopyWithImpl<_InsomniaCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InsomniaCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InsomniaCollection&&(identical(other.type, type) || other.type == type)&&(identical(other.exportFormat, exportFormat) || other.exportFormat == exportFormat)&&(identical(other.exportDate, exportDate) || other.exportDate == exportDate)&&(identical(other.exportSource, exportSource) || other.exportSource == exportSource)&&const DeepCollectionEquality().equals(other._resources, _resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,exportFormat,exportDate,exportSource,const DeepCollectionEquality().hash(_resources));

@override
String toString() {
  return 'InsomniaCollection(type: $type, exportFormat: $exportFormat, exportDate: $exportDate, exportSource: $exportSource, resources: $resources)';
}


}

/// @nodoc
abstract mixin class _$InsomniaCollectionCopyWith<$Res> implements $InsomniaCollectionCopyWith<$Res> {
  factory _$InsomniaCollectionCopyWith(_InsomniaCollection value, $Res Function(_InsomniaCollection) _then) = __$InsomniaCollectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_type') String? type,@JsonKey(name: '__export_format') num? exportFormat,@JsonKey(name: '__export_date') String? exportDate,@JsonKey(name: '__export_source') String? exportSource, List<Resource>? resources
});




}
/// @nodoc
class __$InsomniaCollectionCopyWithImpl<$Res>
    implements _$InsomniaCollectionCopyWith<$Res> {
  __$InsomniaCollectionCopyWithImpl(this._self, this._then);

  final _InsomniaCollection _self;
  final $Res Function(_InsomniaCollection) _then;

/// Create a copy of InsomniaCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? exportFormat = freezed,Object? exportDate = freezed,Object? exportSource = freezed,Object? resources = freezed,}) {
  return _then(_InsomniaCollection(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,exportFormat: freezed == exportFormat ? _self.exportFormat : exportFormat // ignore: cast_nullable_to_non_nullable
as num?,exportDate: freezed == exportDate ? _self.exportDate : exportDate // ignore: cast_nullable_to_non_nullable
as String?,exportSource: freezed == exportSource ? _self.exportSource : exportSource // ignore: cast_nullable_to_non_nullable
as String?,resources: freezed == resources ? _self._resources : resources // ignore: cast_nullable_to_non_nullable
as List<Resource>?,
  ));
}


}


/// @nodoc
mixin _$Resource {

@JsonKey(name: '_id') String? get id; String? get parentId; num? get modified; num? get created; String? get url; String? get name; String? get description; String? get method; Body? get body; String? get preRequestScript; List<Parameter>? get parameters; List<Header>? get headers; dynamic get authentication; num? get metaSortKey; bool? get isPrivate; List<dynamic>? get pathParameters; String? get afterResponseScript; bool? get settingStoreCookies; bool? get settingSendCookies; bool? get settingDisableRenderRequestBody; bool? get settingEncodeUrl; bool? get settingRebuildPath; String? get settingFollowRedirects; dynamic get environment; dynamic get environmentPropertyOrder; String? get scope; dynamic get data; dynamic get dataPropertyOrder; dynamic get color; List<Cookie>? get cookies; String? get fileName; String? get contents; String? get contentType; String? get environmentType; List<KVPairDatum>? get kvPairData;@JsonKey(name: '_type') String? get type;
/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceCopyWith<Resource> get copyWith => _$ResourceCopyWithImpl<Resource>(this as Resource, _$identity);

  /// Serializes this Resource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Resource&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.created, created) || other.created == created)&&(identical(other.url, url) || other.url == url)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.method, method) || other.method == method)&&(identical(other.body, body) || other.body == body)&&(identical(other.preRequestScript, preRequestScript) || other.preRequestScript == preRequestScript)&&const DeepCollectionEquality().equals(other.parameters, parameters)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.authentication, authentication)&&(identical(other.metaSortKey, metaSortKey) || other.metaSortKey == metaSortKey)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&const DeepCollectionEquality().equals(other.pathParameters, pathParameters)&&(identical(other.afterResponseScript, afterResponseScript) || other.afterResponseScript == afterResponseScript)&&(identical(other.settingStoreCookies, settingStoreCookies) || other.settingStoreCookies == settingStoreCookies)&&(identical(other.settingSendCookies, settingSendCookies) || other.settingSendCookies == settingSendCookies)&&(identical(other.settingDisableRenderRequestBody, settingDisableRenderRequestBody) || other.settingDisableRenderRequestBody == settingDisableRenderRequestBody)&&(identical(other.settingEncodeUrl, settingEncodeUrl) || other.settingEncodeUrl == settingEncodeUrl)&&(identical(other.settingRebuildPath, settingRebuildPath) || other.settingRebuildPath == settingRebuildPath)&&(identical(other.settingFollowRedirects, settingFollowRedirects) || other.settingFollowRedirects == settingFollowRedirects)&&const DeepCollectionEquality().equals(other.environment, environment)&&const DeepCollectionEquality().equals(other.environmentPropertyOrder, environmentPropertyOrder)&&(identical(other.scope, scope) || other.scope == scope)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.dataPropertyOrder, dataPropertyOrder)&&const DeepCollectionEquality().equals(other.color, color)&&const DeepCollectionEquality().equals(other.cookies, cookies)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.environmentType, environmentType) || other.environmentType == environmentType)&&const DeepCollectionEquality().equals(other.kvPairData, kvPairData)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parentId,modified,created,url,name,description,method,body,preRequestScript,const DeepCollectionEquality().hash(parameters),const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(authentication),metaSortKey,isPrivate,const DeepCollectionEquality().hash(pathParameters),afterResponseScript,settingStoreCookies,settingSendCookies,settingDisableRenderRequestBody,settingEncodeUrl,settingRebuildPath,settingFollowRedirects,const DeepCollectionEquality().hash(environment),const DeepCollectionEquality().hash(environmentPropertyOrder),scope,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(dataPropertyOrder),const DeepCollectionEquality().hash(color),const DeepCollectionEquality().hash(cookies),fileName,contents,contentType,environmentType,const DeepCollectionEquality().hash(kvPairData),type]);

@override
String toString() {
  return 'Resource(id: $id, parentId: $parentId, modified: $modified, created: $created, url: $url, name: $name, description: $description, method: $method, body: $body, preRequestScript: $preRequestScript, parameters: $parameters, headers: $headers, authentication: $authentication, metaSortKey: $metaSortKey, isPrivate: $isPrivate, pathParameters: $pathParameters, afterResponseScript: $afterResponseScript, settingStoreCookies: $settingStoreCookies, settingSendCookies: $settingSendCookies, settingDisableRenderRequestBody: $settingDisableRenderRequestBody, settingEncodeUrl: $settingEncodeUrl, settingRebuildPath: $settingRebuildPath, settingFollowRedirects: $settingFollowRedirects, environment: $environment, environmentPropertyOrder: $environmentPropertyOrder, scope: $scope, data: $data, dataPropertyOrder: $dataPropertyOrder, color: $color, cookies: $cookies, fileName: $fileName, contents: $contents, contentType: $contentType, environmentType: $environmentType, kvPairData: $kvPairData, type: $type)';
}


}

/// @nodoc
abstract mixin class $ResourceCopyWith<$Res>  {
  factory $ResourceCopyWith(Resource value, $Res Function(Resource) _then) = _$ResourceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String? id, String? parentId, num? modified, num? created, String? url, String? name, String? description, String? method, Body? body, String? preRequestScript, List<Parameter>? parameters, List<Header>? headers, dynamic authentication, num? metaSortKey, bool? isPrivate, List<dynamic>? pathParameters, String? afterResponseScript, bool? settingStoreCookies, bool? settingSendCookies, bool? settingDisableRenderRequestBody, bool? settingEncodeUrl, bool? settingRebuildPath, String? settingFollowRedirects, dynamic environment, dynamic environmentPropertyOrder, String? scope, dynamic data, dynamic dataPropertyOrder, dynamic color, List<Cookie>? cookies, String? fileName, String? contents, String? contentType, String? environmentType, List<KVPairDatum>? kvPairData,@JsonKey(name: '_type') String? type
});


$BodyCopyWith<$Res>? get body;

}
/// @nodoc
class _$ResourceCopyWithImpl<$Res>
    implements $ResourceCopyWith<$Res> {
  _$ResourceCopyWithImpl(this._self, this._then);

  final Resource _self;
  final $Res Function(Resource) _then;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? parentId = freezed,Object? modified = freezed,Object? created = freezed,Object? url = freezed,Object? name = freezed,Object? description = freezed,Object? method = freezed,Object? body = freezed,Object? preRequestScript = freezed,Object? parameters = freezed,Object? headers = freezed,Object? authentication = freezed,Object? metaSortKey = freezed,Object? isPrivate = freezed,Object? pathParameters = freezed,Object? afterResponseScript = freezed,Object? settingStoreCookies = freezed,Object? settingSendCookies = freezed,Object? settingDisableRenderRequestBody = freezed,Object? settingEncodeUrl = freezed,Object? settingRebuildPath = freezed,Object? settingFollowRedirects = freezed,Object? environment = freezed,Object? environmentPropertyOrder = freezed,Object? scope = freezed,Object? data = freezed,Object? dataPropertyOrder = freezed,Object? color = freezed,Object? cookies = freezed,Object? fileName = freezed,Object? contents = freezed,Object? contentType = freezed,Object? environmentType = freezed,Object? kvPairData = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,modified: freezed == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as num?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as num?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Body?,preRequestScript: freezed == preRequestScript ? _self.preRequestScript : preRequestScript // ignore: cast_nullable_to_non_nullable
as String?,parameters: freezed == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<Parameter>?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<Header>?,authentication: freezed == authentication ? _self.authentication : authentication // ignore: cast_nullable_to_non_nullable
as dynamic,metaSortKey: freezed == metaSortKey ? _self.metaSortKey : metaSortKey // ignore: cast_nullable_to_non_nullable
as num?,isPrivate: freezed == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool?,pathParameters: freezed == pathParameters ? _self.pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,afterResponseScript: freezed == afterResponseScript ? _self.afterResponseScript : afterResponseScript // ignore: cast_nullable_to_non_nullable
as String?,settingStoreCookies: freezed == settingStoreCookies ? _self.settingStoreCookies : settingStoreCookies // ignore: cast_nullable_to_non_nullable
as bool?,settingSendCookies: freezed == settingSendCookies ? _self.settingSendCookies : settingSendCookies // ignore: cast_nullable_to_non_nullable
as bool?,settingDisableRenderRequestBody: freezed == settingDisableRenderRequestBody ? _self.settingDisableRenderRequestBody : settingDisableRenderRequestBody // ignore: cast_nullable_to_non_nullable
as bool?,settingEncodeUrl: freezed == settingEncodeUrl ? _self.settingEncodeUrl : settingEncodeUrl // ignore: cast_nullable_to_non_nullable
as bool?,settingRebuildPath: freezed == settingRebuildPath ? _self.settingRebuildPath : settingRebuildPath // ignore: cast_nullable_to_non_nullable
as bool?,settingFollowRedirects: freezed == settingFollowRedirects ? _self.settingFollowRedirects : settingFollowRedirects // ignore: cast_nullable_to_non_nullable
as String?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as dynamic,environmentPropertyOrder: freezed == environmentPropertyOrder ? _self.environmentPropertyOrder : environmentPropertyOrder // ignore: cast_nullable_to_non_nullable
as dynamic,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,dataPropertyOrder: freezed == dataPropertyOrder ? _self.dataPropertyOrder : dataPropertyOrder // ignore: cast_nullable_to_non_nullable
as dynamic,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as dynamic,cookies: freezed == cookies ? _self.cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<Cookie>?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contents: freezed == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,environmentType: freezed == environmentType ? _self.environmentType : environmentType // ignore: cast_nullable_to_non_nullable
as String?,kvPairData: freezed == kvPairData ? _self.kvPairData : kvPairData // ignore: cast_nullable_to_non_nullable
as List<KVPairDatum>?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $BodyCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}
}


/// Adds pattern-matching-related methods to [Resource].
extension ResourcePatterns on Resource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Resource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Resource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Resource value)  $default,){
final _that = this;
switch (_that) {
case _Resource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Resource value)?  $default,){
final _that = this;
switch (_that) {
case _Resource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String? parentId,  num? modified,  num? created,  String? url,  String? name,  String? description,  String? method,  Body? body,  String? preRequestScript,  List<Parameter>? parameters,  List<Header>? headers,  dynamic authentication,  num? metaSortKey,  bool? isPrivate,  List<dynamic>? pathParameters,  String? afterResponseScript,  bool? settingStoreCookies,  bool? settingSendCookies,  bool? settingDisableRenderRequestBody,  bool? settingEncodeUrl,  bool? settingRebuildPath,  String? settingFollowRedirects,  dynamic environment,  dynamic environmentPropertyOrder,  String? scope,  dynamic data,  dynamic dataPropertyOrder,  dynamic color,  List<Cookie>? cookies,  String? fileName,  String? contents,  String? contentType,  String? environmentType,  List<KVPairDatum>? kvPairData, @JsonKey(name: '_type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Resource() when $default != null:
return $default(_that.id,_that.parentId,_that.modified,_that.created,_that.url,_that.name,_that.description,_that.method,_that.body,_that.preRequestScript,_that.parameters,_that.headers,_that.authentication,_that.metaSortKey,_that.isPrivate,_that.pathParameters,_that.afterResponseScript,_that.settingStoreCookies,_that.settingSendCookies,_that.settingDisableRenderRequestBody,_that.settingEncodeUrl,_that.settingRebuildPath,_that.settingFollowRedirects,_that.environment,_that.environmentPropertyOrder,_that.scope,_that.data,_that.dataPropertyOrder,_that.color,_that.cookies,_that.fileName,_that.contents,_that.contentType,_that.environmentType,_that.kvPairData,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String? id,  String? parentId,  num? modified,  num? created,  String? url,  String? name,  String? description,  String? method,  Body? body,  String? preRequestScript,  List<Parameter>? parameters,  List<Header>? headers,  dynamic authentication,  num? metaSortKey,  bool? isPrivate,  List<dynamic>? pathParameters,  String? afterResponseScript,  bool? settingStoreCookies,  bool? settingSendCookies,  bool? settingDisableRenderRequestBody,  bool? settingEncodeUrl,  bool? settingRebuildPath,  String? settingFollowRedirects,  dynamic environment,  dynamic environmentPropertyOrder,  String? scope,  dynamic data,  dynamic dataPropertyOrder,  dynamic color,  List<Cookie>? cookies,  String? fileName,  String? contents,  String? contentType,  String? environmentType,  List<KVPairDatum>? kvPairData, @JsonKey(name: '_type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _Resource():
return $default(_that.id,_that.parentId,_that.modified,_that.created,_that.url,_that.name,_that.description,_that.method,_that.body,_that.preRequestScript,_that.parameters,_that.headers,_that.authentication,_that.metaSortKey,_that.isPrivate,_that.pathParameters,_that.afterResponseScript,_that.settingStoreCookies,_that.settingSendCookies,_that.settingDisableRenderRequestBody,_that.settingEncodeUrl,_that.settingRebuildPath,_that.settingFollowRedirects,_that.environment,_that.environmentPropertyOrder,_that.scope,_that.data,_that.dataPropertyOrder,_that.color,_that.cookies,_that.fileName,_that.contents,_that.contentType,_that.environmentType,_that.kvPairData,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String? id,  String? parentId,  num? modified,  num? created,  String? url,  String? name,  String? description,  String? method,  Body? body,  String? preRequestScript,  List<Parameter>? parameters,  List<Header>? headers,  dynamic authentication,  num? metaSortKey,  bool? isPrivate,  List<dynamic>? pathParameters,  String? afterResponseScript,  bool? settingStoreCookies,  bool? settingSendCookies,  bool? settingDisableRenderRequestBody,  bool? settingEncodeUrl,  bool? settingRebuildPath,  String? settingFollowRedirects,  dynamic environment,  dynamic environmentPropertyOrder,  String? scope,  dynamic data,  dynamic dataPropertyOrder,  dynamic color,  List<Cookie>? cookies,  String? fileName,  String? contents,  String? contentType,  String? environmentType,  List<KVPairDatum>? kvPairData, @JsonKey(name: '_type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _Resource() when $default != null:
return $default(_that.id,_that.parentId,_that.modified,_that.created,_that.url,_that.name,_that.description,_that.method,_that.body,_that.preRequestScript,_that.parameters,_that.headers,_that.authentication,_that.metaSortKey,_that.isPrivate,_that.pathParameters,_that.afterResponseScript,_that.settingStoreCookies,_that.settingSendCookies,_that.settingDisableRenderRequestBody,_that.settingEncodeUrl,_that.settingRebuildPath,_that.settingFollowRedirects,_that.environment,_that.environmentPropertyOrder,_that.scope,_that.data,_that.dataPropertyOrder,_that.color,_that.cookies,_that.fileName,_that.contents,_that.contentType,_that.environmentType,_that.kvPairData,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Resource implements Resource {
  const _Resource({@JsonKey(name: '_id') this.id, this.parentId, this.modified, this.created, this.url, this.name, this.description, this.method, this.body, this.preRequestScript, final  List<Parameter>? parameters, final  List<Header>? headers, this.authentication, this.metaSortKey, this.isPrivate, final  List<dynamic>? pathParameters, this.afterResponseScript, this.settingStoreCookies, this.settingSendCookies, this.settingDisableRenderRequestBody, this.settingEncodeUrl, this.settingRebuildPath, this.settingFollowRedirects, this.environment, this.environmentPropertyOrder, this.scope, this.data, this.dataPropertyOrder, this.color, final  List<Cookie>? cookies, this.fileName, this.contents, this.contentType, this.environmentType, final  List<KVPairDatum>? kvPairData, @JsonKey(name: '_type') this.type}): _parameters = parameters,_headers = headers,_pathParameters = pathParameters,_cookies = cookies,_kvPairData = kvPairData;
  factory _Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);

@override@JsonKey(name: '_id') final  String? id;
@override final  String? parentId;
@override final  num? modified;
@override final  num? created;
@override final  String? url;
@override final  String? name;
@override final  String? description;
@override final  String? method;
@override final  Body? body;
@override final  String? preRequestScript;
 final  List<Parameter>? _parameters;
@override List<Parameter>? get parameters {
  final value = _parameters;
  if (value == null) return null;
  if (_parameters is EqualUnmodifiableListView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Header>? _headers;
@override List<Header>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  dynamic authentication;
@override final  num? metaSortKey;
@override final  bool? isPrivate;
 final  List<dynamic>? _pathParameters;
@override List<dynamic>? get pathParameters {
  final value = _pathParameters;
  if (value == null) return null;
  if (_pathParameters is EqualUnmodifiableListView) return _pathParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? afterResponseScript;
@override final  bool? settingStoreCookies;
@override final  bool? settingSendCookies;
@override final  bool? settingDisableRenderRequestBody;
@override final  bool? settingEncodeUrl;
@override final  bool? settingRebuildPath;
@override final  String? settingFollowRedirects;
@override final  dynamic environment;
@override final  dynamic environmentPropertyOrder;
@override final  String? scope;
@override final  dynamic data;
@override final  dynamic dataPropertyOrder;
@override final  dynamic color;
 final  List<Cookie>? _cookies;
@override List<Cookie>? get cookies {
  final value = _cookies;
  if (value == null) return null;
  if (_cookies is EqualUnmodifiableListView) return _cookies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? fileName;
@override final  String? contents;
@override final  String? contentType;
@override final  String? environmentType;
 final  List<KVPairDatum>? _kvPairData;
@override List<KVPairDatum>? get kvPairData {
  final value = _kvPairData;
  if (value == null) return null;
  if (_kvPairData is EqualUnmodifiableListView) return _kvPairData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: '_type') final  String? type;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceCopyWith<_Resource> get copyWith => __$ResourceCopyWithImpl<_Resource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Resource&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.modified, modified) || other.modified == modified)&&(identical(other.created, created) || other.created == created)&&(identical(other.url, url) || other.url == url)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.method, method) || other.method == method)&&(identical(other.body, body) || other.body == body)&&(identical(other.preRequestScript, preRequestScript) || other.preRequestScript == preRequestScript)&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other.authentication, authentication)&&(identical(other.metaSortKey, metaSortKey) || other.metaSortKey == metaSortKey)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&const DeepCollectionEquality().equals(other._pathParameters, _pathParameters)&&(identical(other.afterResponseScript, afterResponseScript) || other.afterResponseScript == afterResponseScript)&&(identical(other.settingStoreCookies, settingStoreCookies) || other.settingStoreCookies == settingStoreCookies)&&(identical(other.settingSendCookies, settingSendCookies) || other.settingSendCookies == settingSendCookies)&&(identical(other.settingDisableRenderRequestBody, settingDisableRenderRequestBody) || other.settingDisableRenderRequestBody == settingDisableRenderRequestBody)&&(identical(other.settingEncodeUrl, settingEncodeUrl) || other.settingEncodeUrl == settingEncodeUrl)&&(identical(other.settingRebuildPath, settingRebuildPath) || other.settingRebuildPath == settingRebuildPath)&&(identical(other.settingFollowRedirects, settingFollowRedirects) || other.settingFollowRedirects == settingFollowRedirects)&&const DeepCollectionEquality().equals(other.environment, environment)&&const DeepCollectionEquality().equals(other.environmentPropertyOrder, environmentPropertyOrder)&&(identical(other.scope, scope) || other.scope == scope)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.dataPropertyOrder, dataPropertyOrder)&&const DeepCollectionEquality().equals(other.color, color)&&const DeepCollectionEquality().equals(other._cookies, _cookies)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contents, contents) || other.contents == contents)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.environmentType, environmentType) || other.environmentType == environmentType)&&const DeepCollectionEquality().equals(other._kvPairData, _kvPairData)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parentId,modified,created,url,name,description,method,body,preRequestScript,const DeepCollectionEquality().hash(_parameters),const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(authentication),metaSortKey,isPrivate,const DeepCollectionEquality().hash(_pathParameters),afterResponseScript,settingStoreCookies,settingSendCookies,settingDisableRenderRequestBody,settingEncodeUrl,settingRebuildPath,settingFollowRedirects,const DeepCollectionEquality().hash(environment),const DeepCollectionEquality().hash(environmentPropertyOrder),scope,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(dataPropertyOrder),const DeepCollectionEquality().hash(color),const DeepCollectionEquality().hash(_cookies),fileName,contents,contentType,environmentType,const DeepCollectionEquality().hash(_kvPairData),type]);

@override
String toString() {
  return 'Resource(id: $id, parentId: $parentId, modified: $modified, created: $created, url: $url, name: $name, description: $description, method: $method, body: $body, preRequestScript: $preRequestScript, parameters: $parameters, headers: $headers, authentication: $authentication, metaSortKey: $metaSortKey, isPrivate: $isPrivate, pathParameters: $pathParameters, afterResponseScript: $afterResponseScript, settingStoreCookies: $settingStoreCookies, settingSendCookies: $settingSendCookies, settingDisableRenderRequestBody: $settingDisableRenderRequestBody, settingEncodeUrl: $settingEncodeUrl, settingRebuildPath: $settingRebuildPath, settingFollowRedirects: $settingFollowRedirects, environment: $environment, environmentPropertyOrder: $environmentPropertyOrder, scope: $scope, data: $data, dataPropertyOrder: $dataPropertyOrder, color: $color, cookies: $cookies, fileName: $fileName, contents: $contents, contentType: $contentType, environmentType: $environmentType, kvPairData: $kvPairData, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ResourceCopyWith<$Res> implements $ResourceCopyWith<$Res> {
  factory _$ResourceCopyWith(_Resource value, $Res Function(_Resource) _then) = __$ResourceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String? id, String? parentId, num? modified, num? created, String? url, String? name, String? description, String? method, Body? body, String? preRequestScript, List<Parameter>? parameters, List<Header>? headers, dynamic authentication, num? metaSortKey, bool? isPrivate, List<dynamic>? pathParameters, String? afterResponseScript, bool? settingStoreCookies, bool? settingSendCookies, bool? settingDisableRenderRequestBody, bool? settingEncodeUrl, bool? settingRebuildPath, String? settingFollowRedirects, dynamic environment, dynamic environmentPropertyOrder, String? scope, dynamic data, dynamic dataPropertyOrder, dynamic color, List<Cookie>? cookies, String? fileName, String? contents, String? contentType, String? environmentType, List<KVPairDatum>? kvPairData,@JsonKey(name: '_type') String? type
});


@override $BodyCopyWith<$Res>? get body;

}
/// @nodoc
class __$ResourceCopyWithImpl<$Res>
    implements _$ResourceCopyWith<$Res> {
  __$ResourceCopyWithImpl(this._self, this._then);

  final _Resource _self;
  final $Res Function(_Resource) _then;

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? parentId = freezed,Object? modified = freezed,Object? created = freezed,Object? url = freezed,Object? name = freezed,Object? description = freezed,Object? method = freezed,Object? body = freezed,Object? preRequestScript = freezed,Object? parameters = freezed,Object? headers = freezed,Object? authentication = freezed,Object? metaSortKey = freezed,Object? isPrivate = freezed,Object? pathParameters = freezed,Object? afterResponseScript = freezed,Object? settingStoreCookies = freezed,Object? settingSendCookies = freezed,Object? settingDisableRenderRequestBody = freezed,Object? settingEncodeUrl = freezed,Object? settingRebuildPath = freezed,Object? settingFollowRedirects = freezed,Object? environment = freezed,Object? environmentPropertyOrder = freezed,Object? scope = freezed,Object? data = freezed,Object? dataPropertyOrder = freezed,Object? color = freezed,Object? cookies = freezed,Object? fileName = freezed,Object? contents = freezed,Object? contentType = freezed,Object? environmentType = freezed,Object? kvPairData = freezed,Object? type = freezed,}) {
  return _then(_Resource(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,modified: freezed == modified ? _self.modified : modified // ignore: cast_nullable_to_non_nullable
as num?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as num?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Body?,preRequestScript: freezed == preRequestScript ? _self.preRequestScript : preRequestScript // ignore: cast_nullable_to_non_nullable
as String?,parameters: freezed == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<Parameter>?,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<Header>?,authentication: freezed == authentication ? _self.authentication : authentication // ignore: cast_nullable_to_non_nullable
as dynamic,metaSortKey: freezed == metaSortKey ? _self.metaSortKey : metaSortKey // ignore: cast_nullable_to_non_nullable
as num?,isPrivate: freezed == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool?,pathParameters: freezed == pathParameters ? _self._pathParameters : pathParameters // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,afterResponseScript: freezed == afterResponseScript ? _self.afterResponseScript : afterResponseScript // ignore: cast_nullable_to_non_nullable
as String?,settingStoreCookies: freezed == settingStoreCookies ? _self.settingStoreCookies : settingStoreCookies // ignore: cast_nullable_to_non_nullable
as bool?,settingSendCookies: freezed == settingSendCookies ? _self.settingSendCookies : settingSendCookies // ignore: cast_nullable_to_non_nullable
as bool?,settingDisableRenderRequestBody: freezed == settingDisableRenderRequestBody ? _self.settingDisableRenderRequestBody : settingDisableRenderRequestBody // ignore: cast_nullable_to_non_nullable
as bool?,settingEncodeUrl: freezed == settingEncodeUrl ? _self.settingEncodeUrl : settingEncodeUrl // ignore: cast_nullable_to_non_nullable
as bool?,settingRebuildPath: freezed == settingRebuildPath ? _self.settingRebuildPath : settingRebuildPath // ignore: cast_nullable_to_non_nullable
as bool?,settingFollowRedirects: freezed == settingFollowRedirects ? _self.settingFollowRedirects : settingFollowRedirects // ignore: cast_nullable_to_non_nullable
as String?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as dynamic,environmentPropertyOrder: freezed == environmentPropertyOrder ? _self.environmentPropertyOrder : environmentPropertyOrder // ignore: cast_nullable_to_non_nullable
as dynamic,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,dataPropertyOrder: freezed == dataPropertyOrder ? _self.dataPropertyOrder : dataPropertyOrder // ignore: cast_nullable_to_non_nullable
as dynamic,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as dynamic,cookies: freezed == cookies ? _self._cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<Cookie>?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contents: freezed == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,environmentType: freezed == environmentType ? _self.environmentType : environmentType // ignore: cast_nullable_to_non_nullable
as String?,kvPairData: freezed == kvPairData ? _self._kvPairData : kvPairData // ignore: cast_nullable_to_non_nullable
as List<KVPairDatum>?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Resource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $BodyCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}
}


/// @nodoc
mixin _$Body {

 String? get mimeType; String? get text; List<Formdatum>? get params;
/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyCopyWith<Body> get copyWith => _$BodyCopyWithImpl<Body>(this as Body, _$identity);

  /// Serializes this Body to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Body&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.params, params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,text,const DeepCollectionEquality().hash(params));

@override
String toString() {
  return 'Body(mimeType: $mimeType, text: $text, params: $params)';
}


}

/// @nodoc
abstract mixin class $BodyCopyWith<$Res>  {
  factory $BodyCopyWith(Body value, $Res Function(Body) _then) = _$BodyCopyWithImpl;
@useResult
$Res call({
 String? mimeType, String? text, List<Formdatum>? params
});




}
/// @nodoc
class _$BodyCopyWithImpl<$Res>
    implements $BodyCopyWith<$Res> {
  _$BodyCopyWithImpl(this._self, this._then);

  final Body _self;
  final $Res Function(Body) _then;

/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mimeType = freezed,Object? text = freezed,Object? params = freezed,}) {
  return _then(_self.copyWith(
mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as List<Formdatum>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Body].
extension BodyPatterns on Body {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Body value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Body() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Body value)  $default,){
final _that = this;
switch (_that) {
case _Body():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Body value)?  $default,){
final _that = this;
switch (_that) {
case _Body() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? mimeType,  String? text,  List<Formdatum>? params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Body() when $default != null:
return $default(_that.mimeType,_that.text,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? mimeType,  String? text,  List<Formdatum>? params)  $default,) {final _that = this;
switch (_that) {
case _Body():
return $default(_that.mimeType,_that.text,_that.params);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? mimeType,  String? text,  List<Formdatum>? params)?  $default,) {final _that = this;
switch (_that) {
case _Body() when $default != null:
return $default(_that.mimeType,_that.text,_that.params);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Body implements Body {
  const _Body({this.mimeType, this.text, final  List<Formdatum>? params}): _params = params;
  factory _Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

@override final  String? mimeType;
@override final  String? text;
 final  List<Formdatum>? _params;
@override List<Formdatum>? get params {
  final value = _params;
  if (value == null) return null;
  if (_params is EqualUnmodifiableListView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyCopyWith<_Body> get copyWith => __$BodyCopyWithImpl<_Body>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Body&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,text,const DeepCollectionEquality().hash(_params));

@override
String toString() {
  return 'Body(mimeType: $mimeType, text: $text, params: $params)';
}


}

/// @nodoc
abstract mixin class _$BodyCopyWith<$Res> implements $BodyCopyWith<$Res> {
  factory _$BodyCopyWith(_Body value, $Res Function(_Body) _then) = __$BodyCopyWithImpl;
@override @useResult
$Res call({
 String? mimeType, String? text, List<Formdatum>? params
});




}
/// @nodoc
class __$BodyCopyWithImpl<$Res>
    implements _$BodyCopyWith<$Res> {
  __$BodyCopyWithImpl(this._self, this._then);

  final _Body _self;
  final $Res Function(_Body) _then;

/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mimeType = freezed,Object? text = freezed,Object? params = freezed,}) {
  return _then(_Body(
mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,params: freezed == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as List<Formdatum>?,
  ));
}


}


/// @nodoc
mixin _$Formdatum {

 String? get name; String? get value; String? get type;@JsonKey(name: 'fileName') String? get src;
/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormdatumCopyWith<Formdatum> get copyWith => _$FormdatumCopyWithImpl<Formdatum>(this as Formdatum, _$identity);

  /// Serializes this Formdatum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Formdatum&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.src, src) || other.src == src));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,type,src);

@override
String toString() {
  return 'Formdatum(name: $name, value: $value, type: $type, src: $src)';
}


}

/// @nodoc
abstract mixin class $FormdatumCopyWith<$Res>  {
  factory $FormdatumCopyWith(Formdatum value, $Res Function(Formdatum) _then) = _$FormdatumCopyWithImpl;
@useResult
$Res call({
 String? name, String? value, String? type,@JsonKey(name: 'fileName') String? src
});




}
/// @nodoc
class _$FormdatumCopyWithImpl<$Res>
    implements $FormdatumCopyWith<$Res> {
  _$FormdatumCopyWithImpl(this._self, this._then);

  final Formdatum _self;
  final $Res Function(Formdatum) _then;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? value = freezed,Object? type = freezed,Object? src = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,src: freezed == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Formdatum].
extension FormdatumPatterns on Formdatum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Formdatum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Formdatum value)  $default,){
final _that = this;
switch (_that) {
case _Formdatum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Formdatum value)?  $default,){
final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? value,  String? type, @JsonKey(name: 'fileName')  String? src)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
return $default(_that.name,_that.value,_that.type,_that.src);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? value,  String? type, @JsonKey(name: 'fileName')  String? src)  $default,) {final _that = this;
switch (_that) {
case _Formdatum():
return $default(_that.name,_that.value,_that.type,_that.src);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? value,  String? type, @JsonKey(name: 'fileName')  String? src)?  $default,) {final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
return $default(_that.name,_that.value,_that.type,_that.src);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Formdatum implements Formdatum {
  const _Formdatum({this.name, this.value, this.type, @JsonKey(name: 'fileName') this.src});
  factory _Formdatum.fromJson(Map<String, dynamic> json) => _$FormdatumFromJson(json);

@override final  String? name;
@override final  String? value;
@override final  String? type;
@override@JsonKey(name: 'fileName') final  String? src;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormdatumCopyWith<_Formdatum> get copyWith => __$FormdatumCopyWithImpl<_Formdatum>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormdatumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Formdatum&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.src, src) || other.src == src));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,type,src);

@override
String toString() {
  return 'Formdatum(name: $name, value: $value, type: $type, src: $src)';
}


}

/// @nodoc
abstract mixin class _$FormdatumCopyWith<$Res> implements $FormdatumCopyWith<$Res> {
  factory _$FormdatumCopyWith(_Formdatum value, $Res Function(_Formdatum) _then) = __$FormdatumCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? value, String? type,@JsonKey(name: 'fileName') String? src
});




}
/// @nodoc
class __$FormdatumCopyWithImpl<$Res>
    implements _$FormdatumCopyWith<$Res> {
  __$FormdatumCopyWithImpl(this._self, this._then);

  final _Formdatum _self;
  final $Res Function(_Formdatum) _then;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? value = freezed,Object? type = freezed,Object? src = freezed,}) {
  return _then(_Formdatum(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,src: freezed == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Parameter {

 String? get id; String? get name; String? get value; String? get description; bool? get disabled;
/// Create a copy of Parameter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParameterCopyWith<Parameter> get copyWith => _$ParameterCopyWithImpl<Parameter>(this as Parameter, _$identity);

  /// Serializes this Parameter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Parameter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.description, description) || other.description == description)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value,description,disabled);

@override
String toString() {
  return 'Parameter(id: $id, name: $name, value: $value, description: $description, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $ParameterCopyWith<$Res>  {
  factory $ParameterCopyWith(Parameter value, $Res Function(Parameter) _then) = _$ParameterCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? value, String? description, bool? disabled
});




}
/// @nodoc
class _$ParameterCopyWithImpl<$Res>
    implements $ParameterCopyWith<$Res> {
  _$ParameterCopyWithImpl(this._self, this._then);

  final Parameter _self;
  final $Res Function(Parameter) _then;

/// Create a copy of Parameter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? value = freezed,Object? description = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Parameter].
extension ParameterPatterns on Parameter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Parameter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Parameter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Parameter value)  $default,){
final _that = this;
switch (_that) {
case _Parameter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Parameter value)?  $default,){
final _that = this;
switch (_that) {
case _Parameter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? value,  String? description,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Parameter() when $default != null:
return $default(_that.id,_that.name,_that.value,_that.description,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? value,  String? description,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Parameter():
return $default(_that.id,_that.name,_that.value,_that.description,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? value,  String? description,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Parameter() when $default != null:
return $default(_that.id,_that.name,_that.value,_that.description,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Parameter implements Parameter {
  const _Parameter({this.id, this.name, this.value, this.description, this.disabled});
  factory _Parameter.fromJson(Map<String, dynamic> json) => _$ParameterFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? value;
@override final  String? description;
@override final  bool? disabled;

/// Create a copy of Parameter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParameterCopyWith<_Parameter> get copyWith => __$ParameterCopyWithImpl<_Parameter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParameterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Parameter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.description, description) || other.description == description)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value,description,disabled);

@override
String toString() {
  return 'Parameter(id: $id, name: $name, value: $value, description: $description, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$ParameterCopyWith<$Res> implements $ParameterCopyWith<$Res> {
  factory _$ParameterCopyWith(_Parameter value, $Res Function(_Parameter) _then) = __$ParameterCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? value, String? description, bool? disabled
});




}
/// @nodoc
class __$ParameterCopyWithImpl<$Res>
    implements _$ParameterCopyWith<$Res> {
  __$ParameterCopyWithImpl(this._self, this._then);

  final _Parameter _self;
  final $Res Function(_Parameter) _then;

/// Create a copy of Parameter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? value = freezed,Object? description = freezed,Object? disabled = freezed,}) {
  return _then(_Parameter(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Header {

 String? get name; String? get value; bool? get disabled;
/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeaderCopyWith<Header> get copyWith => _$HeaderCopyWithImpl<Header>(this as Header, _$identity);

  /// Serializes this Header to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Header&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Header(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $HeaderCopyWith<$Res>  {
  factory $HeaderCopyWith(Header value, $Res Function(Header) _then) = _$HeaderCopyWithImpl;
@useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class _$HeaderCopyWithImpl<$Res>
    implements $HeaderCopyWith<$Res> {
  _$HeaderCopyWithImpl(this._self, this._then);

  final Header _self;
  final $Res Function(Header) _then;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Header].
extension HeaderPatterns on Header {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Header value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Header() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Header value)  $default,){
final _that = this;
switch (_that) {
case _Header():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Header value)?  $default,){
final _that = this;
switch (_that) {
case _Header() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Header():
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? value,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Header implements Header {
  const _Header({this.name, this.value, this.disabled});
  factory _Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

@override final  String? name;
@override final  String? value;
@override final  bool? disabled;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeaderCopyWith<_Header> get copyWith => __$HeaderCopyWithImpl<_Header>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeaderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Header&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Header(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$HeaderCopyWith<$Res> implements $HeaderCopyWith<$Res> {
  factory _$HeaderCopyWith(_Header value, $Res Function(_Header) _then) = __$HeaderCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class __$HeaderCopyWithImpl<$Res>
    implements _$HeaderCopyWith<$Res> {
  __$HeaderCopyWithImpl(this._self, this._then);

  final _Header _self;
  final $Res Function(_Header) _then;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_Header(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Cookie {

 String? get key; String? get value; String? get domain; String? get path; bool? get secure; bool? get httpOnly; bool? get hostOnly; DateTime? get creation; DateTime? get lastAccessed; String? get sameSite; String? get id;
/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookieCopyWith<Cookie> get copyWith => _$CookieCopyWithImpl<Cookie>(this as Cookie, _$identity);

  /// Serializes this Cookie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cookie&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.path, path) || other.path == path)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.httpOnly, httpOnly) || other.httpOnly == httpOnly)&&(identical(other.hostOnly, hostOnly) || other.hostOnly == hostOnly)&&(identical(other.creation, creation) || other.creation == creation)&&(identical(other.lastAccessed, lastAccessed) || other.lastAccessed == lastAccessed)&&(identical(other.sameSite, sameSite) || other.sameSite == sameSite)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,domain,path,secure,httpOnly,hostOnly,creation,lastAccessed,sameSite,id);

@override
String toString() {
  return 'Cookie(key: $key, value: $value, domain: $domain, path: $path, secure: $secure, httpOnly: $httpOnly, hostOnly: $hostOnly, creation: $creation, lastAccessed: $lastAccessed, sameSite: $sameSite, id: $id)';
}


}

/// @nodoc
abstract mixin class $CookieCopyWith<$Res>  {
  factory $CookieCopyWith(Cookie value, $Res Function(Cookie) _then) = _$CookieCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, String? domain, String? path, bool? secure, bool? httpOnly, bool? hostOnly, DateTime? creation, DateTime? lastAccessed, String? sameSite, String? id
});




}
/// @nodoc
class _$CookieCopyWithImpl<$Res>
    implements $CookieCopyWith<$Res> {
  _$CookieCopyWithImpl(this._self, this._then);

  final Cookie _self;
  final $Res Function(Cookie) _then;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? domain = freezed,Object? path = freezed,Object? secure = freezed,Object? httpOnly = freezed,Object? hostOnly = freezed,Object? creation = freezed,Object? lastAccessed = freezed,Object? sameSite = freezed,Object? id = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,secure: freezed == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool?,httpOnly: freezed == httpOnly ? _self.httpOnly : httpOnly // ignore: cast_nullable_to_non_nullable
as bool?,hostOnly: freezed == hostOnly ? _self.hostOnly : hostOnly // ignore: cast_nullable_to_non_nullable
as bool?,creation: freezed == creation ? _self.creation : creation // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessed: freezed == lastAccessed ? _self.lastAccessed : lastAccessed // ignore: cast_nullable_to_non_nullable
as DateTime?,sameSite: freezed == sameSite ? _self.sameSite : sameSite // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cookie].
extension CookiePatterns on Cookie {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cookie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cookie() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cookie value)  $default,){
final _that = this;
switch (_that) {
case _Cookie():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cookie value)?  $default,){
final _that = this;
switch (_that) {
case _Cookie() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  String? domain,  String? path,  bool? secure,  bool? httpOnly,  bool? hostOnly,  DateTime? creation,  DateTime? lastAccessed,  String? sameSite,  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that.key,_that.value,_that.domain,_that.path,_that.secure,_that.httpOnly,_that.hostOnly,_that.creation,_that.lastAccessed,_that.sameSite,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  String? domain,  String? path,  bool? secure,  bool? httpOnly,  bool? hostOnly,  DateTime? creation,  DateTime? lastAccessed,  String? sameSite,  String? id)  $default,) {final _that = this;
switch (_that) {
case _Cookie():
return $default(_that.key,_that.value,_that.domain,_that.path,_that.secure,_that.httpOnly,_that.hostOnly,_that.creation,_that.lastAccessed,_that.sameSite,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  String? domain,  String? path,  bool? secure,  bool? httpOnly,  bool? hostOnly,  DateTime? creation,  DateTime? lastAccessed,  String? sameSite,  String? id)?  $default,) {final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that.key,_that.value,_that.domain,_that.path,_that.secure,_that.httpOnly,_that.hostOnly,_that.creation,_that.lastAccessed,_that.sameSite,_that.id);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Cookie implements Cookie {
  const _Cookie({this.key, this.value, this.domain, this.path, this.secure, this.httpOnly, this.hostOnly, this.creation, this.lastAccessed, this.sameSite, this.id});
  factory _Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);

@override final  String? key;
@override final  String? value;
@override final  String? domain;
@override final  String? path;
@override final  bool? secure;
@override final  bool? httpOnly;
@override final  bool? hostOnly;
@override final  DateTime? creation;
@override final  DateTime? lastAccessed;
@override final  String? sameSite;
@override final  String? id;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookieCopyWith<_Cookie> get copyWith => __$CookieCopyWithImpl<_Cookie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CookieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cookie&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.path, path) || other.path == path)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.httpOnly, httpOnly) || other.httpOnly == httpOnly)&&(identical(other.hostOnly, hostOnly) || other.hostOnly == hostOnly)&&(identical(other.creation, creation) || other.creation == creation)&&(identical(other.lastAccessed, lastAccessed) || other.lastAccessed == lastAccessed)&&(identical(other.sameSite, sameSite) || other.sameSite == sameSite)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,domain,path,secure,httpOnly,hostOnly,creation,lastAccessed,sameSite,id);

@override
String toString() {
  return 'Cookie(key: $key, value: $value, domain: $domain, path: $path, secure: $secure, httpOnly: $httpOnly, hostOnly: $hostOnly, creation: $creation, lastAccessed: $lastAccessed, sameSite: $sameSite, id: $id)';
}


}

/// @nodoc
abstract mixin class _$CookieCopyWith<$Res> implements $CookieCopyWith<$Res> {
  factory _$CookieCopyWith(_Cookie value, $Res Function(_Cookie) _then) = __$CookieCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, String? domain, String? path, bool? secure, bool? httpOnly, bool? hostOnly, DateTime? creation, DateTime? lastAccessed, String? sameSite, String? id
});




}
/// @nodoc
class __$CookieCopyWithImpl<$Res>
    implements _$CookieCopyWith<$Res> {
  __$CookieCopyWithImpl(this._self, this._then);

  final _Cookie _self;
  final $Res Function(_Cookie) _then;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? domain = freezed,Object? path = freezed,Object? secure = freezed,Object? httpOnly = freezed,Object? hostOnly = freezed,Object? creation = freezed,Object? lastAccessed = freezed,Object? sameSite = freezed,Object? id = freezed,}) {
  return _then(_Cookie(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,domain: freezed == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,secure: freezed == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool?,httpOnly: freezed == httpOnly ? _self.httpOnly : httpOnly // ignore: cast_nullable_to_non_nullable
as bool?,hostOnly: freezed == hostOnly ? _self.hostOnly : hostOnly // ignore: cast_nullable_to_non_nullable
as bool?,creation: freezed == creation ? _self.creation : creation // ignore: cast_nullable_to_non_nullable
as DateTime?,lastAccessed: freezed == lastAccessed ? _self.lastAccessed : lastAccessed // ignore: cast_nullable_to_non_nullable
as DateTime?,sameSite: freezed == sameSite ? _self.sameSite : sameSite // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$KVPairDatum {

 String? get id; String? get name; String? get value; String? get type; bool? get enabled;
/// Create a copy of KVPairDatum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KVPairDatumCopyWith<KVPairDatum> get copyWith => _$KVPairDatumCopyWithImpl<KVPairDatum>(this as KVPairDatum, _$identity);

  /// Serializes this KVPairDatum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KVPairDatum&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value,type,enabled);

@override
String toString() {
  return 'KVPairDatum(id: $id, name: $name, value: $value, type: $type, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $KVPairDatumCopyWith<$Res>  {
  factory $KVPairDatumCopyWith(KVPairDatum value, $Res Function(KVPairDatum) _then) = _$KVPairDatumCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? value, String? type, bool? enabled
});




}
/// @nodoc
class _$KVPairDatumCopyWithImpl<$Res>
    implements $KVPairDatumCopyWith<$Res> {
  _$KVPairDatumCopyWithImpl(this._self, this._then);

  final KVPairDatum _self;
  final $Res Function(KVPairDatum) _then;

/// Create a copy of KVPairDatum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? value = freezed,Object? type = freezed,Object? enabled = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,enabled: freezed == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [KVPairDatum].
extension KVPairDatumPatterns on KVPairDatum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KVPairDatum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KVPairDatum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KVPairDatum value)  $default,){
final _that = this;
switch (_that) {
case _KVPairDatum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KVPairDatum value)?  $default,){
final _that = this;
switch (_that) {
case _KVPairDatum() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? value,  String? type,  bool? enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KVPairDatum() when $default != null:
return $default(_that.id,_that.name,_that.value,_that.type,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? value,  String? type,  bool? enabled)  $default,) {final _that = this;
switch (_that) {
case _KVPairDatum():
return $default(_that.id,_that.name,_that.value,_that.type,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? value,  String? type,  bool? enabled)?  $default,) {final _that = this;
switch (_that) {
case _KVPairDatum() when $default != null:
return $default(_that.id,_that.name,_that.value,_that.type,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _KVPairDatum implements KVPairDatum {
  const _KVPairDatum({this.id, this.name, this.value, this.type, this.enabled});
  factory _KVPairDatum.fromJson(Map<String, dynamic> json) => _$KVPairDatumFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? value;
@override final  String? type;
@override final  bool? enabled;

/// Create a copy of KVPairDatum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KVPairDatumCopyWith<_KVPairDatum> get copyWith => __$KVPairDatumCopyWithImpl<_KVPairDatum>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KVPairDatumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KVPairDatum&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,value,type,enabled);

@override
String toString() {
  return 'KVPairDatum(id: $id, name: $name, value: $value, type: $type, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$KVPairDatumCopyWith<$Res> implements $KVPairDatumCopyWith<$Res> {
  factory _$KVPairDatumCopyWith(_KVPairDatum value, $Res Function(_KVPairDatum) _then) = __$KVPairDatumCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? value, String? type, bool? enabled
});




}
/// @nodoc
class __$KVPairDatumCopyWithImpl<$Res>
    implements _$KVPairDatumCopyWith<$Res> {
  __$KVPairDatumCopyWithImpl(this._self, this._then);

  final _KVPairDatum _self;
  final $Res Function(_KVPairDatum) _then;

/// Create a copy of KVPairDatum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? value = freezed,Object? type = freezed,Object? enabled = freezed,}) {
  return _then(_KVPairDatum(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,enabled: freezed == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
