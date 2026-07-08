// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_oauth1_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthOAuth1Model {

 String get consumerKey; String get consumerSecret; String? get credentialsFilePath; String? get accessToken; String? get tokenSecret; OAuth1SignatureMethod get signatureMethod; String get parameterLocation; String get version; String? get realm; String? get callbackUrl; String? get verifier; String? get nonce; String? get timestamp; bool get includeBodyHash;
/// Create a copy of AuthOAuth1Model
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOAuth1ModelCopyWith<AuthOAuth1Model> get copyWith => _$AuthOAuth1ModelCopyWithImpl<AuthOAuth1Model>(this as AuthOAuth1Model, _$identity);

  /// Serializes this AuthOAuth1Model to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOAuth1Model&&(identical(other.consumerKey, consumerKey) || other.consumerKey == consumerKey)&&(identical(other.consumerSecret, consumerSecret) || other.consumerSecret == consumerSecret)&&(identical(other.credentialsFilePath, credentialsFilePath) || other.credentialsFilePath == credentialsFilePath)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenSecret, tokenSecret) || other.tokenSecret == tokenSecret)&&(identical(other.signatureMethod, signatureMethod) || other.signatureMethod == signatureMethod)&&(identical(other.parameterLocation, parameterLocation) || other.parameterLocation == parameterLocation)&&(identical(other.version, version) || other.version == version)&&(identical(other.realm, realm) || other.realm == realm)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.verifier, verifier) || other.verifier == verifier)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.includeBodyHash, includeBodyHash) || other.includeBodyHash == includeBodyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumerKey,consumerSecret,credentialsFilePath,accessToken,tokenSecret,signatureMethod,parameterLocation,version,realm,callbackUrl,verifier,nonce,timestamp,includeBodyHash);

@override
String toString() {
  return 'AuthOAuth1Model(consumerKey: $consumerKey, consumerSecret: $consumerSecret, credentialsFilePath: $credentialsFilePath, accessToken: $accessToken, tokenSecret: $tokenSecret, signatureMethod: $signatureMethod, parameterLocation: $parameterLocation, version: $version, realm: $realm, callbackUrl: $callbackUrl, verifier: $verifier, nonce: $nonce, timestamp: $timestamp, includeBodyHash: $includeBodyHash)';
}


}

/// @nodoc
abstract mixin class $AuthOAuth1ModelCopyWith<$Res>  {
  factory $AuthOAuth1ModelCopyWith(AuthOAuth1Model value, $Res Function(AuthOAuth1Model) _then) = _$AuthOAuth1ModelCopyWithImpl;
@useResult
$Res call({
 String consumerKey, String consumerSecret, String? credentialsFilePath, String? accessToken, String? tokenSecret, OAuth1SignatureMethod signatureMethod, String parameterLocation, String version, String? realm, String? callbackUrl, String? verifier, String? nonce, String? timestamp, bool includeBodyHash
});




}
/// @nodoc
class _$AuthOAuth1ModelCopyWithImpl<$Res>
    implements $AuthOAuth1ModelCopyWith<$Res> {
  _$AuthOAuth1ModelCopyWithImpl(this._self, this._then);

  final AuthOAuth1Model _self;
  final $Res Function(AuthOAuth1Model) _then;

/// Create a copy of AuthOAuth1Model
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consumerKey = null,Object? consumerSecret = null,Object? credentialsFilePath = freezed,Object? accessToken = freezed,Object? tokenSecret = freezed,Object? signatureMethod = null,Object? parameterLocation = null,Object? version = null,Object? realm = freezed,Object? callbackUrl = freezed,Object? verifier = freezed,Object? nonce = freezed,Object? timestamp = freezed,Object? includeBodyHash = null,}) {
  return _then(_self.copyWith(
consumerKey: null == consumerKey ? _self.consumerKey : consumerKey // ignore: cast_nullable_to_non_nullable
as String,consumerSecret: null == consumerSecret ? _self.consumerSecret : consumerSecret // ignore: cast_nullable_to_non_nullable
as String,credentialsFilePath: freezed == credentialsFilePath ? _self.credentialsFilePath : credentialsFilePath // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,tokenSecret: freezed == tokenSecret ? _self.tokenSecret : tokenSecret // ignore: cast_nullable_to_non_nullable
as String?,signatureMethod: null == signatureMethod ? _self.signatureMethod : signatureMethod // ignore: cast_nullable_to_non_nullable
as OAuth1SignatureMethod,parameterLocation: null == parameterLocation ? _self.parameterLocation : parameterLocation // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,realm: freezed == realm ? _self.realm : realm // ignore: cast_nullable_to_non_nullable
as String?,callbackUrl: freezed == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String?,verifier: freezed == verifier ? _self.verifier : verifier // ignore: cast_nullable_to_non_nullable
as String?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,includeBodyHash: null == includeBodyHash ? _self.includeBodyHash : includeBodyHash // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthOAuth1Model].
extension AuthOAuth1ModelPatterns on AuthOAuth1Model {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthOAuth1Model value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthOAuth1Model() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthOAuth1Model value)  $default,){
final _that = this;
switch (_that) {
case _AuthOAuth1Model():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthOAuth1Model value)?  $default,){
final _that = this;
switch (_that) {
case _AuthOAuth1Model() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String consumerKey,  String consumerSecret,  String? credentialsFilePath,  String? accessToken,  String? tokenSecret,  OAuth1SignatureMethod signatureMethod,  String parameterLocation,  String version,  String? realm,  String? callbackUrl,  String? verifier,  String? nonce,  String? timestamp,  bool includeBodyHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthOAuth1Model() when $default != null:
return $default(_that.consumerKey,_that.consumerSecret,_that.credentialsFilePath,_that.accessToken,_that.tokenSecret,_that.signatureMethod,_that.parameterLocation,_that.version,_that.realm,_that.callbackUrl,_that.verifier,_that.nonce,_that.timestamp,_that.includeBodyHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String consumerKey,  String consumerSecret,  String? credentialsFilePath,  String? accessToken,  String? tokenSecret,  OAuth1SignatureMethod signatureMethod,  String parameterLocation,  String version,  String? realm,  String? callbackUrl,  String? verifier,  String? nonce,  String? timestamp,  bool includeBodyHash)  $default,) {final _that = this;
switch (_that) {
case _AuthOAuth1Model():
return $default(_that.consumerKey,_that.consumerSecret,_that.credentialsFilePath,_that.accessToken,_that.tokenSecret,_that.signatureMethod,_that.parameterLocation,_that.version,_that.realm,_that.callbackUrl,_that.verifier,_that.nonce,_that.timestamp,_that.includeBodyHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String consumerKey,  String consumerSecret,  String? credentialsFilePath,  String? accessToken,  String? tokenSecret,  OAuth1SignatureMethod signatureMethod,  String parameterLocation,  String version,  String? realm,  String? callbackUrl,  String? verifier,  String? nonce,  String? timestamp,  bool includeBodyHash)?  $default,) {final _that = this;
switch (_that) {
case _AuthOAuth1Model() when $default != null:
return $default(_that.consumerKey,_that.consumerSecret,_that.credentialsFilePath,_that.accessToken,_that.tokenSecret,_that.signatureMethod,_that.parameterLocation,_that.version,_that.realm,_that.callbackUrl,_that.verifier,_that.nonce,_that.timestamp,_that.includeBodyHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthOAuth1Model implements AuthOAuth1Model {
  const _AuthOAuth1Model({required this.consumerKey, required this.consumerSecret, this.credentialsFilePath, this.accessToken, this.tokenSecret, this.signatureMethod = OAuth1SignatureMethod.hmacSha1, this.parameterLocation = "header", this.version = '1.0', this.realm, this.callbackUrl, this.verifier, this.nonce, this.timestamp, this.includeBodyHash = false});
  factory _AuthOAuth1Model.fromJson(Map<String, dynamic> json) => _$AuthOAuth1ModelFromJson(json);

@override final  String consumerKey;
@override final  String consumerSecret;
@override final  String? credentialsFilePath;
@override final  String? accessToken;
@override final  String? tokenSecret;
@override@JsonKey() final  OAuth1SignatureMethod signatureMethod;
@override@JsonKey() final  String parameterLocation;
@override@JsonKey() final  String version;
@override final  String? realm;
@override final  String? callbackUrl;
@override final  String? verifier;
@override final  String? nonce;
@override final  String? timestamp;
@override@JsonKey() final  bool includeBodyHash;

/// Create a copy of AuthOAuth1Model
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthOAuth1ModelCopyWith<_AuthOAuth1Model> get copyWith => __$AuthOAuth1ModelCopyWithImpl<_AuthOAuth1Model>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthOAuth1ModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthOAuth1Model&&(identical(other.consumerKey, consumerKey) || other.consumerKey == consumerKey)&&(identical(other.consumerSecret, consumerSecret) || other.consumerSecret == consumerSecret)&&(identical(other.credentialsFilePath, credentialsFilePath) || other.credentialsFilePath == credentialsFilePath)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.tokenSecret, tokenSecret) || other.tokenSecret == tokenSecret)&&(identical(other.signatureMethod, signatureMethod) || other.signatureMethod == signatureMethod)&&(identical(other.parameterLocation, parameterLocation) || other.parameterLocation == parameterLocation)&&(identical(other.version, version) || other.version == version)&&(identical(other.realm, realm) || other.realm == realm)&&(identical(other.callbackUrl, callbackUrl) || other.callbackUrl == callbackUrl)&&(identical(other.verifier, verifier) || other.verifier == verifier)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.includeBodyHash, includeBodyHash) || other.includeBodyHash == includeBodyHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumerKey,consumerSecret,credentialsFilePath,accessToken,tokenSecret,signatureMethod,parameterLocation,version,realm,callbackUrl,verifier,nonce,timestamp,includeBodyHash);

@override
String toString() {
  return 'AuthOAuth1Model(consumerKey: $consumerKey, consumerSecret: $consumerSecret, credentialsFilePath: $credentialsFilePath, accessToken: $accessToken, tokenSecret: $tokenSecret, signatureMethod: $signatureMethod, parameterLocation: $parameterLocation, version: $version, realm: $realm, callbackUrl: $callbackUrl, verifier: $verifier, nonce: $nonce, timestamp: $timestamp, includeBodyHash: $includeBodyHash)';
}


}

/// @nodoc
abstract mixin class _$AuthOAuth1ModelCopyWith<$Res> implements $AuthOAuth1ModelCopyWith<$Res> {
  factory _$AuthOAuth1ModelCopyWith(_AuthOAuth1Model value, $Res Function(_AuthOAuth1Model) _then) = __$AuthOAuth1ModelCopyWithImpl;
@override @useResult
$Res call({
 String consumerKey, String consumerSecret, String? credentialsFilePath, String? accessToken, String? tokenSecret, OAuth1SignatureMethod signatureMethod, String parameterLocation, String version, String? realm, String? callbackUrl, String? verifier, String? nonce, String? timestamp, bool includeBodyHash
});




}
/// @nodoc
class __$AuthOAuth1ModelCopyWithImpl<$Res>
    implements _$AuthOAuth1ModelCopyWith<$Res> {
  __$AuthOAuth1ModelCopyWithImpl(this._self, this._then);

  final _AuthOAuth1Model _self;
  final $Res Function(_AuthOAuth1Model) _then;

/// Create a copy of AuthOAuth1Model
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consumerKey = null,Object? consumerSecret = null,Object? credentialsFilePath = freezed,Object? accessToken = freezed,Object? tokenSecret = freezed,Object? signatureMethod = null,Object? parameterLocation = null,Object? version = null,Object? realm = freezed,Object? callbackUrl = freezed,Object? verifier = freezed,Object? nonce = freezed,Object? timestamp = freezed,Object? includeBodyHash = null,}) {
  return _then(_AuthOAuth1Model(
consumerKey: null == consumerKey ? _self.consumerKey : consumerKey // ignore: cast_nullable_to_non_nullable
as String,consumerSecret: null == consumerSecret ? _self.consumerSecret : consumerSecret // ignore: cast_nullable_to_non_nullable
as String,credentialsFilePath: freezed == credentialsFilePath ? _self.credentialsFilePath : credentialsFilePath // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,tokenSecret: freezed == tokenSecret ? _self.tokenSecret : tokenSecret // ignore: cast_nullable_to_non_nullable
as String?,signatureMethod: null == signatureMethod ? _self.signatureMethod : signatureMethod // ignore: cast_nullable_to_non_nullable
as OAuth1SignatureMethod,parameterLocation: null == parameterLocation ? _self.parameterLocation : parameterLocation // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,realm: freezed == realm ? _self.realm : realm // ignore: cast_nullable_to_non_nullable
as String?,callbackUrl: freezed == callbackUrl ? _self.callbackUrl : callbackUrl // ignore: cast_nullable_to_non_nullable
as String?,verifier: freezed == verifier ? _self.verifier : verifier // ignore: cast_nullable_to_non_nullable
as String?,nonce: freezed == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,includeBodyHash: null == includeBodyHash ? _self.includeBodyHash : includeBodyHash // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
