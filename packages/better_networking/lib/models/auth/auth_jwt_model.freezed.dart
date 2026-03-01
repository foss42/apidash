// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_jwt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthJwtModel {

 String get secret; String? get privateKey; String get payload; String get addTokenTo; String get algorithm; bool get isSecretBase64Encoded; String get headerPrefix; String get queryParamKey; String get header;
/// Create a copy of AuthJwtModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthJwtModelCopyWith<AuthJwtModel> get copyWith => _$AuthJwtModelCopyWithImpl<AuthJwtModel>(this as AuthJwtModel, _$identity);

  /// Serializes this AuthJwtModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthJwtModel&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.addTokenTo, addTokenTo) || other.addTokenTo == addTokenTo)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.isSecretBase64Encoded, isSecretBase64Encoded) || other.isSecretBase64Encoded == isSecretBase64Encoded)&&(identical(other.headerPrefix, headerPrefix) || other.headerPrefix == headerPrefix)&&(identical(other.queryParamKey, queryParamKey) || other.queryParamKey == queryParamKey)&&(identical(other.header, header) || other.header == header));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,secret,privateKey,payload,addTokenTo,algorithm,isSecretBase64Encoded,headerPrefix,queryParamKey,header);

@override
String toString() {
  return 'AuthJwtModel(secret: $secret, privateKey: $privateKey, payload: $payload, addTokenTo: $addTokenTo, algorithm: $algorithm, isSecretBase64Encoded: $isSecretBase64Encoded, headerPrefix: $headerPrefix, queryParamKey: $queryParamKey, header: $header)';
}


}

/// @nodoc
abstract mixin class $AuthJwtModelCopyWith<$Res>  {
  factory $AuthJwtModelCopyWith(AuthJwtModel value, $Res Function(AuthJwtModel) _then) = _$AuthJwtModelCopyWithImpl;
@useResult
$Res call({
 String secret, String? privateKey, String payload, String addTokenTo, String algorithm, bool isSecretBase64Encoded, String headerPrefix, String queryParamKey, String header
});




}
/// @nodoc
class _$AuthJwtModelCopyWithImpl<$Res>
    implements $AuthJwtModelCopyWith<$Res> {
  _$AuthJwtModelCopyWithImpl(this._self, this._then);

  final AuthJwtModel _self;
  final $Res Function(AuthJwtModel) _then;

/// Create a copy of AuthJwtModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? secret = null,Object? privateKey = freezed,Object? payload = null,Object? addTokenTo = null,Object? algorithm = null,Object? isSecretBase64Encoded = null,Object? headerPrefix = null,Object? queryParamKey = null,Object? header = null,}) {
  return _then(_self.copyWith(
secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,privateKey: freezed == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,addTokenTo: null == addTokenTo ? _self.addTokenTo : addTokenTo // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,isSecretBase64Encoded: null == isSecretBase64Encoded ? _self.isSecretBase64Encoded : isSecretBase64Encoded // ignore: cast_nullable_to_non_nullable
as bool,headerPrefix: null == headerPrefix ? _self.headerPrefix : headerPrefix // ignore: cast_nullable_to_non_nullable
as String,queryParamKey: null == queryParamKey ? _self.queryParamKey : queryParamKey // ignore: cast_nullable_to_non_nullable
as String,header: null == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthJwtModel].
extension AuthJwtModelPatterns on AuthJwtModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthJwtModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthJwtModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthJwtModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthJwtModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthJwtModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthJwtModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String secret,  String? privateKey,  String payload,  String addTokenTo,  String algorithm,  bool isSecretBase64Encoded,  String headerPrefix,  String queryParamKey,  String header)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthJwtModel() when $default != null:
return $default(_that.secret,_that.privateKey,_that.payload,_that.addTokenTo,_that.algorithm,_that.isSecretBase64Encoded,_that.headerPrefix,_that.queryParamKey,_that.header);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String secret,  String? privateKey,  String payload,  String addTokenTo,  String algorithm,  bool isSecretBase64Encoded,  String headerPrefix,  String queryParamKey,  String header)  $default,) {final _that = this;
switch (_that) {
case _AuthJwtModel():
return $default(_that.secret,_that.privateKey,_that.payload,_that.addTokenTo,_that.algorithm,_that.isSecretBase64Encoded,_that.headerPrefix,_that.queryParamKey,_that.header);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String secret,  String? privateKey,  String payload,  String addTokenTo,  String algorithm,  bool isSecretBase64Encoded,  String headerPrefix,  String queryParamKey,  String header)?  $default,) {final _that = this;
switch (_that) {
case _AuthJwtModel() when $default != null:
return $default(_that.secret,_that.privateKey,_that.payload,_that.addTokenTo,_that.algorithm,_that.isSecretBase64Encoded,_that.headerPrefix,_that.queryParamKey,_that.header);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthJwtModel implements AuthJwtModel {
  const _AuthJwtModel({required this.secret, this.privateKey, required this.payload, required this.addTokenTo, required this.algorithm, required this.isSecretBase64Encoded, required this.headerPrefix, required this.queryParamKey, required this.header});
  factory _AuthJwtModel.fromJson(Map<String, dynamic> json) => _$AuthJwtModelFromJson(json);

@override final  String secret;
@override final  String? privateKey;
@override final  String payload;
@override final  String addTokenTo;
@override final  String algorithm;
@override final  bool isSecretBase64Encoded;
@override final  String headerPrefix;
@override final  String queryParamKey;
@override final  String header;

/// Create a copy of AuthJwtModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthJwtModelCopyWith<_AuthJwtModel> get copyWith => __$AuthJwtModelCopyWithImpl<_AuthJwtModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthJwtModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthJwtModel&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.privateKey, privateKey) || other.privateKey == privateKey)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.addTokenTo, addTokenTo) || other.addTokenTo == addTokenTo)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.isSecretBase64Encoded, isSecretBase64Encoded) || other.isSecretBase64Encoded == isSecretBase64Encoded)&&(identical(other.headerPrefix, headerPrefix) || other.headerPrefix == headerPrefix)&&(identical(other.queryParamKey, queryParamKey) || other.queryParamKey == queryParamKey)&&(identical(other.header, header) || other.header == header));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,secret,privateKey,payload,addTokenTo,algorithm,isSecretBase64Encoded,headerPrefix,queryParamKey,header);

@override
String toString() {
  return 'AuthJwtModel(secret: $secret, privateKey: $privateKey, payload: $payload, addTokenTo: $addTokenTo, algorithm: $algorithm, isSecretBase64Encoded: $isSecretBase64Encoded, headerPrefix: $headerPrefix, queryParamKey: $queryParamKey, header: $header)';
}


}

/// @nodoc
abstract mixin class _$AuthJwtModelCopyWith<$Res> implements $AuthJwtModelCopyWith<$Res> {
  factory _$AuthJwtModelCopyWith(_AuthJwtModel value, $Res Function(_AuthJwtModel) _then) = __$AuthJwtModelCopyWithImpl;
@override @useResult
$Res call({
 String secret, String? privateKey, String payload, String addTokenTo, String algorithm, bool isSecretBase64Encoded, String headerPrefix, String queryParamKey, String header
});




}
/// @nodoc
class __$AuthJwtModelCopyWithImpl<$Res>
    implements _$AuthJwtModelCopyWith<$Res> {
  __$AuthJwtModelCopyWithImpl(this._self, this._then);

  final _AuthJwtModel _self;
  final $Res Function(_AuthJwtModel) _then;

/// Create a copy of AuthJwtModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? secret = null,Object? privateKey = freezed,Object? payload = null,Object? addTokenTo = null,Object? algorithm = null,Object? isSecretBase64Encoded = null,Object? headerPrefix = null,Object? queryParamKey = null,Object? header = null,}) {
  return _then(_AuthJwtModel(
secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,privateKey: freezed == privateKey ? _self.privateKey : privateKey // ignore: cast_nullable_to_non_nullable
as String?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,addTokenTo: null == addTokenTo ? _self.addTokenTo : addTokenTo // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,isSecretBase64Encoded: null == isSecretBase64Encoded ? _self.isSecretBase64Encoded : isSecretBase64Encoded // ignore: cast_nullable_to_non_nullable
as bool,headerPrefix: null == headerPrefix ? _self.headerPrefix : headerPrefix // ignore: cast_nullable_to_non_nullable
as String,queryParamKey: null == queryParamKey ? _self.queryParamKey : queryParamKey // ignore: cast_nullable_to_non_nullable
as String,header: null == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
