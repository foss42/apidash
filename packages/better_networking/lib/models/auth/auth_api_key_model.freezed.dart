// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_api_key_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthApiKeyModel {

 String get key; String get location;// 'header' or 'query'
 String get name;
/// Create a copy of AuthApiKeyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthApiKeyModelCopyWith<AuthApiKeyModel> get copyWith => _$AuthApiKeyModelCopyWithImpl<AuthApiKeyModel>(this as AuthApiKeyModel, _$identity);

  /// Serializes this AuthApiKeyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthApiKeyModel&&(identical(other.key, key) || other.key == key)&&(identical(other.location, location) || other.location == location)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,location,name);

@override
String toString() {
  return 'AuthApiKeyModel(key: $key, location: $location, name: $name)';
}


}

/// @nodoc
abstract mixin class $AuthApiKeyModelCopyWith<$Res>  {
  factory $AuthApiKeyModelCopyWith(AuthApiKeyModel value, $Res Function(AuthApiKeyModel) _then) = _$AuthApiKeyModelCopyWithImpl;
@useResult
$Res call({
 String key, String location, String name
});




}
/// @nodoc
class _$AuthApiKeyModelCopyWithImpl<$Res>
    implements $AuthApiKeyModelCopyWith<$Res> {
  _$AuthApiKeyModelCopyWithImpl(this._self, this._then);

  final AuthApiKeyModel _self;
  final $Res Function(AuthApiKeyModel) _then;

/// Create a copy of AuthApiKeyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? location = null,Object? name = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthApiKeyModel].
extension AuthApiKeyModelPatterns on AuthApiKeyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthApiKeyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthApiKeyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthApiKeyModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthApiKeyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthApiKeyModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthApiKeyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String location,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthApiKeyModel() when $default != null:
return $default(_that.key,_that.location,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String location,  String name)  $default,) {final _that = this;
switch (_that) {
case _AuthApiKeyModel():
return $default(_that.key,_that.location,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String location,  String name)?  $default,) {final _that = this;
switch (_that) {
case _AuthApiKeyModel() when $default != null:
return $default(_that.key,_that.location,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthApiKeyModel implements AuthApiKeyModel {
  const _AuthApiKeyModel({required this.key, this.location = 'header', this.name = 'x-api-key'});
  factory _AuthApiKeyModel.fromJson(Map<String, dynamic> json) => _$AuthApiKeyModelFromJson(json);

@override final  String key;
@override@JsonKey() final  String location;
// 'header' or 'query'
@override@JsonKey() final  String name;

/// Create a copy of AuthApiKeyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthApiKeyModelCopyWith<_AuthApiKeyModel> get copyWith => __$AuthApiKeyModelCopyWithImpl<_AuthApiKeyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthApiKeyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthApiKeyModel&&(identical(other.key, key) || other.key == key)&&(identical(other.location, location) || other.location == location)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,location,name);

@override
String toString() {
  return 'AuthApiKeyModel(key: $key, location: $location, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AuthApiKeyModelCopyWith<$Res> implements $AuthApiKeyModelCopyWith<$Res> {
  factory _$AuthApiKeyModelCopyWith(_AuthApiKeyModel value, $Res Function(_AuthApiKeyModel) _then) = __$AuthApiKeyModelCopyWithImpl;
@override @useResult
$Res call({
 String key, String location, String name
});




}
/// @nodoc
class __$AuthApiKeyModelCopyWithImpl<$Res>
    implements _$AuthApiKeyModelCopyWith<$Res> {
  __$AuthApiKeyModelCopyWithImpl(this._self, this._then);

  final _AuthApiKeyModel _self;
  final $Res Function(_AuthApiKeyModel) _then;

/// Create a copy of AuthApiKeyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? location = null,Object? name = null,}) {
  return _then(_AuthApiKeyModel(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
