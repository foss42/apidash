// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bearer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthBearerModel {

 String get token;
/// Create a copy of AuthBearerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthBearerModelCopyWith<AuthBearerModel> get copyWith => _$AuthBearerModelCopyWithImpl<AuthBearerModel>(this as AuthBearerModel, _$identity);

  /// Serializes this AuthBearerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthBearerModel&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AuthBearerModel(token: $token)';
}


}

/// @nodoc
abstract mixin class $AuthBearerModelCopyWith<$Res>  {
  factory $AuthBearerModelCopyWith(AuthBearerModel value, $Res Function(AuthBearerModel) _then) = _$AuthBearerModelCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$AuthBearerModelCopyWithImpl<$Res>
    implements $AuthBearerModelCopyWith<$Res> {
  _$AuthBearerModelCopyWithImpl(this._self, this._then);

  final AuthBearerModel _self;
  final $Res Function(AuthBearerModel) _then;

/// Create a copy of AuthBearerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthBearerModel].
extension AuthBearerModelPatterns on AuthBearerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthBearerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthBearerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthBearerModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthBearerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthBearerModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthBearerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthBearerModel() when $default != null:
return $default(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token)  $default,) {final _that = this;
switch (_that) {
case _AuthBearerModel():
return $default(_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token)?  $default,) {final _that = this;
switch (_that) {
case _AuthBearerModel() when $default != null:
return $default(_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthBearerModel implements AuthBearerModel {
  const _AuthBearerModel({required this.token});
  factory _AuthBearerModel.fromJson(Map<String, dynamic> json) => _$AuthBearerModelFromJson(json);

@override final  String token;

/// Create a copy of AuthBearerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthBearerModelCopyWith<_AuthBearerModel> get copyWith => __$AuthBearerModelCopyWithImpl<_AuthBearerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthBearerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthBearerModel&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'AuthBearerModel(token: $token)';
}


}

/// @nodoc
abstract mixin class _$AuthBearerModelCopyWith<$Res> implements $AuthBearerModelCopyWith<$Res> {
  factory _$AuthBearerModelCopyWith(_AuthBearerModel value, $Res Function(_AuthBearerModel) _then) = __$AuthBearerModelCopyWithImpl;
@override @useResult
$Res call({
 String token
});




}
/// @nodoc
class __$AuthBearerModelCopyWithImpl<$Res>
    implements _$AuthBearerModelCopyWith<$Res> {
  __$AuthBearerModelCopyWithImpl(this._self, this._then);

  final _AuthBearerModel _self;
  final $Res Function(_AuthBearerModel) _then;

/// Create a copy of AuthBearerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(_AuthBearerModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
