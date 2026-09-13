// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_digest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthDigestModel {

 String get username; String get password; String get realm; String get nonce; String get algorithm; String get qop; String get opaque;
/// Create a copy of AuthDigestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthDigestModelCopyWith<AuthDigestModel> get copyWith => _$AuthDigestModelCopyWithImpl<AuthDigestModel>(this as AuthDigestModel, _$identity);

  /// Serializes this AuthDigestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthDigestModel&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.realm, realm) || other.realm == realm)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.qop, qop) || other.qop == qop)&&(identical(other.opaque, opaque) || other.opaque == opaque));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,realm,nonce,algorithm,qop,opaque);

@override
String toString() {
  return 'AuthDigestModel(username: $username, password: $password, realm: $realm, nonce: $nonce, algorithm: $algorithm, qop: $qop, opaque: $opaque)';
}


}

/// @nodoc
abstract mixin class $AuthDigestModelCopyWith<$Res>  {
  factory $AuthDigestModelCopyWith(AuthDigestModel value, $Res Function(AuthDigestModel) _then) = _$AuthDigestModelCopyWithImpl;
@useResult
$Res call({
 String username, String password, String realm, String nonce, String algorithm, String qop, String opaque
});




}
/// @nodoc
class _$AuthDigestModelCopyWithImpl<$Res>
    implements $AuthDigestModelCopyWith<$Res> {
  _$AuthDigestModelCopyWithImpl(this._self, this._then);

  final AuthDigestModel _self;
  final $Res Function(AuthDigestModel) _then;

/// Create a copy of AuthDigestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? realm = null,Object? nonce = null,Object? algorithm = null,Object? qop = null,Object? opaque = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,realm: null == realm ? _self.realm : realm // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,qop: null == qop ? _self.qop : qop // ignore: cast_nullable_to_non_nullable
as String,opaque: null == opaque ? _self.opaque : opaque // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthDigestModel].
extension AuthDigestModelPatterns on AuthDigestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthDigestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthDigestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthDigestModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthDigestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthDigestModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthDigestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password,  String realm,  String nonce,  String algorithm,  String qop,  String opaque)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthDigestModel() when $default != null:
return $default(_that.username,_that.password,_that.realm,_that.nonce,_that.algorithm,_that.qop,_that.opaque);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password,  String realm,  String nonce,  String algorithm,  String qop,  String opaque)  $default,) {final _that = this;
switch (_that) {
case _AuthDigestModel():
return $default(_that.username,_that.password,_that.realm,_that.nonce,_that.algorithm,_that.qop,_that.opaque);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password,  String realm,  String nonce,  String algorithm,  String qop,  String opaque)?  $default,) {final _that = this;
switch (_that) {
case _AuthDigestModel() when $default != null:
return $default(_that.username,_that.password,_that.realm,_that.nonce,_that.algorithm,_that.qop,_that.opaque);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthDigestModel implements AuthDigestModel {
  const _AuthDigestModel({required this.username, required this.password, required this.realm, required this.nonce, required this.algorithm, required this.qop, required this.opaque});
  factory _AuthDigestModel.fromJson(Map<String, dynamic> json) => _$AuthDigestModelFromJson(json);

@override final  String username;
@override final  String password;
@override final  String realm;
@override final  String nonce;
@override final  String algorithm;
@override final  String qop;
@override final  String opaque;

/// Create a copy of AuthDigestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthDigestModelCopyWith<_AuthDigestModel> get copyWith => __$AuthDigestModelCopyWithImpl<_AuthDigestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthDigestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthDigestModel&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.realm, realm) || other.realm == realm)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.qop, qop) || other.qop == qop)&&(identical(other.opaque, opaque) || other.opaque == opaque));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,realm,nonce,algorithm,qop,opaque);

@override
String toString() {
  return 'AuthDigestModel(username: $username, password: $password, realm: $realm, nonce: $nonce, algorithm: $algorithm, qop: $qop, opaque: $opaque)';
}


}

/// @nodoc
abstract mixin class _$AuthDigestModelCopyWith<$Res> implements $AuthDigestModelCopyWith<$Res> {
  factory _$AuthDigestModelCopyWith(_AuthDigestModel value, $Res Function(_AuthDigestModel) _then) = __$AuthDigestModelCopyWithImpl;
@override @useResult
$Res call({
 String username, String password, String realm, String nonce, String algorithm, String qop, String opaque
});




}
/// @nodoc
class __$AuthDigestModelCopyWithImpl<$Res>
    implements _$AuthDigestModelCopyWith<$Res> {
  __$AuthDigestModelCopyWithImpl(this._self, this._then);

  final _AuthDigestModel _self;
  final $Res Function(_AuthDigestModel) _then;

/// Create a copy of AuthDigestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? realm = null,Object? nonce = null,Object? algorithm = null,Object? qop = null,Object? opaque = null,}) {
  return _then(_AuthDigestModel(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,realm: null == realm ? _self.realm : realm // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,qop: null == qop ? _self.qop : qop // ignore: cast_nullable_to_non_nullable
as String,opaque: null == opaque ? _self.opaque : opaque // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
