// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_oauth2_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthOAuth2Model {

 OAuth2GrantType get grantType; String get authorizationUrl; String get accessTokenUrl; String get clientId; String get clientSecret; String? get credentialsFilePath; String? get redirectUrl; String? get scope; String? get state; String get codeChallengeMethod; String? get codeVerifier; String? get codeChallenge; String? get username; String? get password; String? get refreshToken; String? get identityToken; String? get accessToken;
/// Create a copy of AuthOAuth2Model
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOAuth2ModelCopyWith<AuthOAuth2Model> get copyWith => _$AuthOAuth2ModelCopyWithImpl<AuthOAuth2Model>(this as AuthOAuth2Model, _$identity);

  /// Serializes this AuthOAuth2Model to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOAuth2Model&&(identical(other.grantType, grantType) || other.grantType == grantType)&&(identical(other.authorizationUrl, authorizationUrl) || other.authorizationUrl == authorizationUrl)&&(identical(other.accessTokenUrl, accessTokenUrl) || other.accessTokenUrl == accessTokenUrl)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.credentialsFilePath, credentialsFilePath) || other.credentialsFilePath == credentialsFilePath)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.state, state) || other.state == state)&&(identical(other.codeChallengeMethod, codeChallengeMethod) || other.codeChallengeMethod == codeChallengeMethod)&&(identical(other.codeVerifier, codeVerifier) || other.codeVerifier == codeVerifier)&&(identical(other.codeChallenge, codeChallenge) || other.codeChallenge == codeChallenge)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.identityToken, identityToken) || other.identityToken == identityToken)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grantType,authorizationUrl,accessTokenUrl,clientId,clientSecret,credentialsFilePath,redirectUrl,scope,state,codeChallengeMethod,codeVerifier,codeChallenge,username,password,refreshToken,identityToken,accessToken);

@override
String toString() {
  return 'AuthOAuth2Model(grantType: $grantType, authorizationUrl: $authorizationUrl, accessTokenUrl: $accessTokenUrl, clientId: $clientId, clientSecret: $clientSecret, credentialsFilePath: $credentialsFilePath, redirectUrl: $redirectUrl, scope: $scope, state: $state, codeChallengeMethod: $codeChallengeMethod, codeVerifier: $codeVerifier, codeChallenge: $codeChallenge, username: $username, password: $password, refreshToken: $refreshToken, identityToken: $identityToken, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class $AuthOAuth2ModelCopyWith<$Res>  {
  factory $AuthOAuth2ModelCopyWith(AuthOAuth2Model value, $Res Function(AuthOAuth2Model) _then) = _$AuthOAuth2ModelCopyWithImpl;
@useResult
$Res call({
 OAuth2GrantType grantType, String authorizationUrl, String accessTokenUrl, String clientId, String clientSecret, String? credentialsFilePath, String? redirectUrl, String? scope, String? state, String codeChallengeMethod, String? codeVerifier, String? codeChallenge, String? username, String? password, String? refreshToken, String? identityToken, String? accessToken
});




}
/// @nodoc
class _$AuthOAuth2ModelCopyWithImpl<$Res>
    implements $AuthOAuth2ModelCopyWith<$Res> {
  _$AuthOAuth2ModelCopyWithImpl(this._self, this._then);

  final AuthOAuth2Model _self;
  final $Res Function(AuthOAuth2Model) _then;

/// Create a copy of AuthOAuth2Model
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grantType = null,Object? authorizationUrl = null,Object? accessTokenUrl = null,Object? clientId = null,Object? clientSecret = null,Object? credentialsFilePath = freezed,Object? redirectUrl = freezed,Object? scope = freezed,Object? state = freezed,Object? codeChallengeMethod = null,Object? codeVerifier = freezed,Object? codeChallenge = freezed,Object? username = freezed,Object? password = freezed,Object? refreshToken = freezed,Object? identityToken = freezed,Object? accessToken = freezed,}) {
  return _then(_self.copyWith(
grantType: null == grantType ? _self.grantType : grantType // ignore: cast_nullable_to_non_nullable
as OAuth2GrantType,authorizationUrl: null == authorizationUrl ? _self.authorizationUrl : authorizationUrl // ignore: cast_nullable_to_non_nullable
as String,accessTokenUrl: null == accessTokenUrl ? _self.accessTokenUrl : accessTokenUrl // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,credentialsFilePath: freezed == credentialsFilePath ? _self.credentialsFilePath : credentialsFilePath // ignore: cast_nullable_to_non_nullable
as String?,redirectUrl: freezed == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,codeChallengeMethod: null == codeChallengeMethod ? _self.codeChallengeMethod : codeChallengeMethod // ignore: cast_nullable_to_non_nullable
as String,codeVerifier: freezed == codeVerifier ? _self.codeVerifier : codeVerifier // ignore: cast_nullable_to_non_nullable
as String?,codeChallenge: freezed == codeChallenge ? _self.codeChallenge : codeChallenge // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,identityToken: freezed == identityToken ? _self.identityToken : identityToken // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthOAuth2Model].
extension AuthOAuth2ModelPatterns on AuthOAuth2Model {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthOAuth2Model value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthOAuth2Model() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthOAuth2Model value)  $default,){
final _that = this;
switch (_that) {
case _AuthOAuth2Model():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthOAuth2Model value)?  $default,){
final _that = this;
switch (_that) {
case _AuthOAuth2Model() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OAuth2GrantType grantType,  String authorizationUrl,  String accessTokenUrl,  String clientId,  String clientSecret,  String? credentialsFilePath,  String? redirectUrl,  String? scope,  String? state,  String codeChallengeMethod,  String? codeVerifier,  String? codeChallenge,  String? username,  String? password,  String? refreshToken,  String? identityToken,  String? accessToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthOAuth2Model() when $default != null:
return $default(_that.grantType,_that.authorizationUrl,_that.accessTokenUrl,_that.clientId,_that.clientSecret,_that.credentialsFilePath,_that.redirectUrl,_that.scope,_that.state,_that.codeChallengeMethod,_that.codeVerifier,_that.codeChallenge,_that.username,_that.password,_that.refreshToken,_that.identityToken,_that.accessToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OAuth2GrantType grantType,  String authorizationUrl,  String accessTokenUrl,  String clientId,  String clientSecret,  String? credentialsFilePath,  String? redirectUrl,  String? scope,  String? state,  String codeChallengeMethod,  String? codeVerifier,  String? codeChallenge,  String? username,  String? password,  String? refreshToken,  String? identityToken,  String? accessToken)  $default,) {final _that = this;
switch (_that) {
case _AuthOAuth2Model():
return $default(_that.grantType,_that.authorizationUrl,_that.accessTokenUrl,_that.clientId,_that.clientSecret,_that.credentialsFilePath,_that.redirectUrl,_that.scope,_that.state,_that.codeChallengeMethod,_that.codeVerifier,_that.codeChallenge,_that.username,_that.password,_that.refreshToken,_that.identityToken,_that.accessToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OAuth2GrantType grantType,  String authorizationUrl,  String accessTokenUrl,  String clientId,  String clientSecret,  String? credentialsFilePath,  String? redirectUrl,  String? scope,  String? state,  String codeChallengeMethod,  String? codeVerifier,  String? codeChallenge,  String? username,  String? password,  String? refreshToken,  String? identityToken,  String? accessToken)?  $default,) {final _that = this;
switch (_that) {
case _AuthOAuth2Model() when $default != null:
return $default(_that.grantType,_that.authorizationUrl,_that.accessTokenUrl,_that.clientId,_that.clientSecret,_that.credentialsFilePath,_that.redirectUrl,_that.scope,_that.state,_that.codeChallengeMethod,_that.codeVerifier,_that.codeChallenge,_that.username,_that.password,_that.refreshToken,_that.identityToken,_that.accessToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthOAuth2Model implements AuthOAuth2Model {
  const _AuthOAuth2Model({this.grantType = OAuth2GrantType.authorizationCode, required this.authorizationUrl, required this.accessTokenUrl, required this.clientId, required this.clientSecret, this.credentialsFilePath, this.redirectUrl, this.scope, this.state, this.codeChallengeMethod = "sha-256", this.codeVerifier, this.codeChallenge, this.username, this.password, this.refreshToken, this.identityToken, this.accessToken});
  factory _AuthOAuth2Model.fromJson(Map<String, dynamic> json) => _$AuthOAuth2ModelFromJson(json);

@override@JsonKey() final  OAuth2GrantType grantType;
@override final  String authorizationUrl;
@override final  String accessTokenUrl;
@override final  String clientId;
@override final  String clientSecret;
@override final  String? credentialsFilePath;
@override final  String? redirectUrl;
@override final  String? scope;
@override final  String? state;
@override@JsonKey() final  String codeChallengeMethod;
@override final  String? codeVerifier;
@override final  String? codeChallenge;
@override final  String? username;
@override final  String? password;
@override final  String? refreshToken;
@override final  String? identityToken;
@override final  String? accessToken;

/// Create a copy of AuthOAuth2Model
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthOAuth2ModelCopyWith<_AuthOAuth2Model> get copyWith => __$AuthOAuth2ModelCopyWithImpl<_AuthOAuth2Model>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthOAuth2ModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthOAuth2Model&&(identical(other.grantType, grantType) || other.grantType == grantType)&&(identical(other.authorizationUrl, authorizationUrl) || other.authorizationUrl == authorizationUrl)&&(identical(other.accessTokenUrl, accessTokenUrl) || other.accessTokenUrl == accessTokenUrl)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.credentialsFilePath, credentialsFilePath) || other.credentialsFilePath == credentialsFilePath)&&(identical(other.redirectUrl, redirectUrl) || other.redirectUrl == redirectUrl)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.state, state) || other.state == state)&&(identical(other.codeChallengeMethod, codeChallengeMethod) || other.codeChallengeMethod == codeChallengeMethod)&&(identical(other.codeVerifier, codeVerifier) || other.codeVerifier == codeVerifier)&&(identical(other.codeChallenge, codeChallenge) || other.codeChallenge == codeChallenge)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.identityToken, identityToken) || other.identityToken == identityToken)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grantType,authorizationUrl,accessTokenUrl,clientId,clientSecret,credentialsFilePath,redirectUrl,scope,state,codeChallengeMethod,codeVerifier,codeChallenge,username,password,refreshToken,identityToken,accessToken);

@override
String toString() {
  return 'AuthOAuth2Model(grantType: $grantType, authorizationUrl: $authorizationUrl, accessTokenUrl: $accessTokenUrl, clientId: $clientId, clientSecret: $clientSecret, credentialsFilePath: $credentialsFilePath, redirectUrl: $redirectUrl, scope: $scope, state: $state, codeChallengeMethod: $codeChallengeMethod, codeVerifier: $codeVerifier, codeChallenge: $codeChallenge, username: $username, password: $password, refreshToken: $refreshToken, identityToken: $identityToken, accessToken: $accessToken)';
}


}

/// @nodoc
abstract mixin class _$AuthOAuth2ModelCopyWith<$Res> implements $AuthOAuth2ModelCopyWith<$Res> {
  factory _$AuthOAuth2ModelCopyWith(_AuthOAuth2Model value, $Res Function(_AuthOAuth2Model) _then) = __$AuthOAuth2ModelCopyWithImpl;
@override @useResult
$Res call({
 OAuth2GrantType grantType, String authorizationUrl, String accessTokenUrl, String clientId, String clientSecret, String? credentialsFilePath, String? redirectUrl, String? scope, String? state, String codeChallengeMethod, String? codeVerifier, String? codeChallenge, String? username, String? password, String? refreshToken, String? identityToken, String? accessToken
});




}
/// @nodoc
class __$AuthOAuth2ModelCopyWithImpl<$Res>
    implements _$AuthOAuth2ModelCopyWith<$Res> {
  __$AuthOAuth2ModelCopyWithImpl(this._self, this._then);

  final _AuthOAuth2Model _self;
  final $Res Function(_AuthOAuth2Model) _then;

/// Create a copy of AuthOAuth2Model
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grantType = null,Object? authorizationUrl = null,Object? accessTokenUrl = null,Object? clientId = null,Object? clientSecret = null,Object? credentialsFilePath = freezed,Object? redirectUrl = freezed,Object? scope = freezed,Object? state = freezed,Object? codeChallengeMethod = null,Object? codeVerifier = freezed,Object? codeChallenge = freezed,Object? username = freezed,Object? password = freezed,Object? refreshToken = freezed,Object? identityToken = freezed,Object? accessToken = freezed,}) {
  return _then(_AuthOAuth2Model(
grantType: null == grantType ? _self.grantType : grantType // ignore: cast_nullable_to_non_nullable
as OAuth2GrantType,authorizationUrl: null == authorizationUrl ? _self.authorizationUrl : authorizationUrl // ignore: cast_nullable_to_non_nullable
as String,accessTokenUrl: null == accessTokenUrl ? _self.accessTokenUrl : accessTokenUrl // ignore: cast_nullable_to_non_nullable
as String,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,credentialsFilePath: freezed == credentialsFilePath ? _self.credentialsFilePath : credentialsFilePath // ignore: cast_nullable_to_non_nullable
as String?,redirectUrl: freezed == redirectUrl ? _self.redirectUrl : redirectUrl // ignore: cast_nullable_to_non_nullable
as String?,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,codeChallengeMethod: null == codeChallengeMethod ? _self.codeChallengeMethod : codeChallengeMethod // ignore: cast_nullable_to_non_nullable
as String,codeVerifier: freezed == codeVerifier ? _self.codeVerifier : codeVerifier // ignore: cast_nullable_to_non_nullable
as String?,codeChallenge: freezed == codeChallenge ? _self.codeChallenge : codeChallenge // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,identityToken: freezed == identityToken ? _self.identityToken : identityToken // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
