// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestMetaModel {

 String get id; String get name; APIType get apiType;/// Abbreviation for the request.
 String get abbr; String get url;
/// Create a copy of RequestMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestMetaModelCopyWith<RequestMetaModel> get copyWith => _$RequestMetaModelCopyWithImpl<RequestMetaModel>(this as RequestMetaModel, _$identity);

  /// Serializes this RequestMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestMetaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.apiType, apiType) || other.apiType == apiType)&&(identical(other.abbr, abbr) || other.abbr == abbr)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,apiType,abbr,url);

@override
String toString() {
  return 'RequestMetaModel(id: $id, name: $name, apiType: $apiType, abbr: $abbr, url: $url)';
}


}

/// @nodoc
abstract mixin class $RequestMetaModelCopyWith<$Res>  {
  factory $RequestMetaModelCopyWith(RequestMetaModel value, $Res Function(RequestMetaModel) _then) = _$RequestMetaModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, APIType apiType, String abbr, String url
});




}
/// @nodoc
class _$RequestMetaModelCopyWithImpl<$Res>
    implements $RequestMetaModelCopyWith<$Res> {
  _$RequestMetaModelCopyWithImpl(this._self, this._then);

  final RequestMetaModel _self;
  final $Res Function(RequestMetaModel) _then;

/// Create a copy of RequestMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? apiType = null,Object? abbr = null,Object? url = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,apiType: null == apiType ? _self.apiType : apiType // ignore: cast_nullable_to_non_nullable
as APIType,abbr: null == abbr ? _self.abbr : abbr // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestMetaModel].
extension RequestMetaModelPatterns on RequestMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _RequestMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _RequestMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  APIType apiType,  String abbr,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestMetaModel() when $default != null:
return $default(_that.id,_that.name,_that.apiType,_that.abbr,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  APIType apiType,  String abbr,  String url)  $default,) {final _that = this;
switch (_that) {
case _RequestMetaModel():
return $default(_that.id,_that.name,_that.apiType,_that.abbr,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  APIType apiType,  String abbr,  String url)?  $default,) {final _that = this;
switch (_that) {
case _RequestMetaModel() when $default != null:
return $default(_that.id,_that.name,_that.apiType,_that.abbr,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestMetaModel extends RequestMetaModel {
  const _RequestMetaModel({required this.id, this.name = '', this.apiType = APIType.rest, this.abbr = '', this.url = ''}): super._();
  factory _RequestMetaModel.fromJson(Map<String, dynamic> json) => _$RequestMetaModelFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  APIType apiType;
/// Abbreviation for the request.
@override@JsonKey() final  String abbr;
@override@JsonKey() final  String url;

/// Create a copy of RequestMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestMetaModelCopyWith<_RequestMetaModel> get copyWith => __$RequestMetaModelCopyWithImpl<_RequestMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestMetaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.apiType, apiType) || other.apiType == apiType)&&(identical(other.abbr, abbr) || other.abbr == abbr)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,apiType,abbr,url);

@override
String toString() {
  return 'RequestMetaModel(id: $id, name: $name, apiType: $apiType, abbr: $abbr, url: $url)';
}


}

/// @nodoc
abstract mixin class _$RequestMetaModelCopyWith<$Res> implements $RequestMetaModelCopyWith<$Res> {
  factory _$RequestMetaModelCopyWith(_RequestMetaModel value, $Res Function(_RequestMetaModel) _then) = __$RequestMetaModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, APIType apiType, String abbr, String url
});




}
/// @nodoc
class __$RequestMetaModelCopyWithImpl<$Res>
    implements _$RequestMetaModelCopyWith<$Res> {
  __$RequestMetaModelCopyWithImpl(this._self, this._then);

  final _RequestMetaModel _self;
  final $Res Function(_RequestMetaModel) _then;

/// Create a copy of RequestMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? apiType = null,Object? abbr = null,Object? url = null,}) {
  return _then(_RequestMetaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,apiType: null == apiType ? _self.apiType : apiType // ignore: cast_nullable_to_non_nullable
as APIType,abbr: null == abbr ? _self.abbr : abbr // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
