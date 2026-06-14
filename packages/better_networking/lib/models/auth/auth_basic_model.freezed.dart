// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_basic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthBasicAuthModel {

 String get username; String get password;
/// Create a copy of AuthBasicAuthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthBasicAuthModelCopyWith<AuthBasicAuthModel> get copyWith => _$AuthBasicAuthModelCopyWithImpl<AuthBasicAuthModel>(this as AuthBasicAuthModel, _$identity);

  /// Serializes this AuthBasicAuthModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthBasicAuthModel&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'AuthBasicAuthModel(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthBasicAuthModelCopyWith<$Res>  {
  factory $AuthBasicAuthModelCopyWith(AuthBasicAuthModel value, $Res Function(AuthBasicAuthModel) _then) = _$AuthBasicAuthModelCopyWithImpl;
@useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class _$AuthBasicAuthModelCopyWithImpl<$Res>
    implements $AuthBasicAuthModelCopyWith<$Res> {
  _$AuthBasicAuthModelCopyWithImpl(this._self, this._then);

  final AuthBasicAuthModel _self;
  final $Res Function(AuthBasicAuthModel) _then;

/// Create a copy of AuthBasicAuthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthBasicAuthModel].
extension AuthBasicAuthModelPatterns on AuthBasicAuthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthBasicAuthModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthBasicAuthModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthBasicAuthModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthBasicAuthModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthBasicAuthModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthBasicAuthModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthBasicAuthModel() when $default != null:
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password)  $default,) {final _that = this;
switch (_that) {
case _AuthBasicAuthModel():
return $default(_that.username,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password)?  $default,) {final _that = this;
switch (_that) {
case _AuthBasicAuthModel() when $default != null:
return $default(_that.username,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthBasicAuthModel implements AuthBasicAuthModel {
  const _AuthBasicAuthModel({required this.username, required this.password});
  factory _AuthBasicAuthModel.fromJson(Map<String, dynamic> json) => _$AuthBasicAuthModelFromJson(json);

@override final  String username;
@override final  String password;

/// Create a copy of AuthBasicAuthModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthBasicAuthModelCopyWith<_AuthBasicAuthModel> get copyWith => __$AuthBasicAuthModelCopyWithImpl<_AuthBasicAuthModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthBasicAuthModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthBasicAuthModel&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'AuthBasicAuthModel(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class _$AuthBasicAuthModelCopyWith<$Res> implements $AuthBasicAuthModelCopyWith<$Res> {
  factory _$AuthBasicAuthModelCopyWith(_AuthBasicAuthModel value, $Res Function(_AuthBasicAuthModel) _then) = __$AuthBasicAuthModelCopyWithImpl;
@override @useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class __$AuthBasicAuthModelCopyWithImpl<$Res>
    implements _$AuthBasicAuthModelCopyWith<$Res> {
  __$AuthBasicAuthModelCopyWithImpl(this._self, this._then);

  final _AuthBasicAuthModel _self;
  final $Res Function(_AuthBasicAuthModel) _then;

/// Create a copy of AuthBasicAuthModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,}) {
  return _then(_AuthBasicAuthModel(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
