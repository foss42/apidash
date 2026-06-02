// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthModel {

 APIAuthType get type; AuthApiKeyModel? get apikey; AuthBearerModel? get bearer; AuthBasicAuthModel? get basic; AuthJwtModel? get jwt; AuthDigestModel? get digest; AuthOAuth1Model? get oauth1; AuthOAuth2Model? get oauth2;
/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthModelCopyWith<AuthModel> get copyWith => _$AuthModelCopyWithImpl<AuthModel>(this as AuthModel, _$identity);

  /// Serializes this AuthModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthModel&&(identical(other.type, type) || other.type == type)&&(identical(other.apikey, apikey) || other.apikey == apikey)&&(identical(other.bearer, bearer) || other.bearer == bearer)&&(identical(other.basic, basic) || other.basic == basic)&&(identical(other.jwt, jwt) || other.jwt == jwt)&&(identical(other.digest, digest) || other.digest == digest)&&(identical(other.oauth1, oauth1) || other.oauth1 == oauth1)&&(identical(other.oauth2, oauth2) || other.oauth2 == oauth2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,apikey,bearer,basic,jwt,digest,oauth1,oauth2);

@override
String toString() {
  return 'AuthModel(type: $type, apikey: $apikey, bearer: $bearer, basic: $basic, jwt: $jwt, digest: $digest, oauth1: $oauth1, oauth2: $oauth2)';
}


}

/// @nodoc
abstract mixin class $AuthModelCopyWith<$Res>  {
  factory $AuthModelCopyWith(AuthModel value, $Res Function(AuthModel) _then) = _$AuthModelCopyWithImpl;
@useResult
$Res call({
 APIAuthType type, AuthApiKeyModel? apikey, AuthBearerModel? bearer, AuthBasicAuthModel? basic, AuthJwtModel? jwt, AuthDigestModel? digest, AuthOAuth1Model? oauth1, AuthOAuth2Model? oauth2
});


$AuthApiKeyModelCopyWith<$Res>? get apikey;$AuthBearerModelCopyWith<$Res>? get bearer;$AuthBasicAuthModelCopyWith<$Res>? get basic;$AuthJwtModelCopyWith<$Res>? get jwt;$AuthDigestModelCopyWith<$Res>? get digest;$AuthOAuth1ModelCopyWith<$Res>? get oauth1;$AuthOAuth2ModelCopyWith<$Res>? get oauth2;

}
/// @nodoc
class _$AuthModelCopyWithImpl<$Res>
    implements $AuthModelCopyWith<$Res> {
  _$AuthModelCopyWithImpl(this._self, this._then);

  final AuthModel _self;
  final $Res Function(AuthModel) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? apikey = freezed,Object? bearer = freezed,Object? basic = freezed,Object? jwt = freezed,Object? digest = freezed,Object? oauth1 = freezed,Object? oauth2 = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as APIAuthType,apikey: freezed == apikey ? _self.apikey : apikey // ignore: cast_nullable_to_non_nullable
as AuthApiKeyModel?,bearer: freezed == bearer ? _self.bearer : bearer // ignore: cast_nullable_to_non_nullable
as AuthBearerModel?,basic: freezed == basic ? _self.basic : basic // ignore: cast_nullable_to_non_nullable
as AuthBasicAuthModel?,jwt: freezed == jwt ? _self.jwt : jwt // ignore: cast_nullable_to_non_nullable
as AuthJwtModel?,digest: freezed == digest ? _self.digest : digest // ignore: cast_nullable_to_non_nullable
as AuthDigestModel?,oauth1: freezed == oauth1 ? _self.oauth1 : oauth1 // ignore: cast_nullable_to_non_nullable
as AuthOAuth1Model?,oauth2: freezed == oauth2 ? _self.oauth2 : oauth2 // ignore: cast_nullable_to_non_nullable
as AuthOAuth2Model?,
  ));
}
/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiKeyModelCopyWith<$Res>? get apikey {
    if (_self.apikey == null) {
    return null;
  }

  return $AuthApiKeyModelCopyWith<$Res>(_self.apikey!, (value) {
    return _then(_self.copyWith(apikey: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthBearerModelCopyWith<$Res>? get bearer {
    if (_self.bearer == null) {
    return null;
  }

  return $AuthBearerModelCopyWith<$Res>(_self.bearer!, (value) {
    return _then(_self.copyWith(bearer: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthBasicAuthModelCopyWith<$Res>? get basic {
    if (_self.basic == null) {
    return null;
  }

  return $AuthBasicAuthModelCopyWith<$Res>(_self.basic!, (value) {
    return _then(_self.copyWith(basic: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthJwtModelCopyWith<$Res>? get jwt {
    if (_self.jwt == null) {
    return null;
  }

  return $AuthJwtModelCopyWith<$Res>(_self.jwt!, (value) {
    return _then(_self.copyWith(jwt: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthDigestModelCopyWith<$Res>? get digest {
    if (_self.digest == null) {
    return null;
  }

  return $AuthDigestModelCopyWith<$Res>(_self.digest!, (value) {
    return _then(_self.copyWith(digest: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthOAuth1ModelCopyWith<$Res>? get oauth1 {
    if (_self.oauth1 == null) {
    return null;
  }

  return $AuthOAuth1ModelCopyWith<$Res>(_self.oauth1!, (value) {
    return _then(_self.copyWith(oauth1: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthOAuth2ModelCopyWith<$Res>? get oauth2 {
    if (_self.oauth2 == null) {
    return null;
  }

  return $AuthOAuth2ModelCopyWith<$Res>(_self.oauth2!, (value) {
    return _then(_self.copyWith(oauth2: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthModel].
extension AuthModelPatterns on AuthModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthModel value)  $default,){
final _that = this;
switch (_that) {
case _AuthModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthModel value)?  $default,){
final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( APIAuthType type,  AuthApiKeyModel? apikey,  AuthBearerModel? bearer,  AuthBasicAuthModel? basic,  AuthJwtModel? jwt,  AuthDigestModel? digest,  AuthOAuth1Model? oauth1,  AuthOAuth2Model? oauth2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
return $default(_that.type,_that.apikey,_that.bearer,_that.basic,_that.jwt,_that.digest,_that.oauth1,_that.oauth2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( APIAuthType type,  AuthApiKeyModel? apikey,  AuthBearerModel? bearer,  AuthBasicAuthModel? basic,  AuthJwtModel? jwt,  AuthDigestModel? digest,  AuthOAuth1Model? oauth1,  AuthOAuth2Model? oauth2)  $default,) {final _that = this;
switch (_that) {
case _AuthModel():
return $default(_that.type,_that.apikey,_that.bearer,_that.basic,_that.jwt,_that.digest,_that.oauth1,_that.oauth2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( APIAuthType type,  AuthApiKeyModel? apikey,  AuthBearerModel? bearer,  AuthBasicAuthModel? basic,  AuthJwtModel? jwt,  AuthDigestModel? digest,  AuthOAuth1Model? oauth1,  AuthOAuth2Model? oauth2)?  $default,) {final _that = this;
switch (_that) {
case _AuthModel() when $default != null:
return $default(_that.type,_that.apikey,_that.bearer,_that.basic,_that.jwt,_that.digest,_that.oauth1,_that.oauth2);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _AuthModel implements AuthModel {
  const _AuthModel({required this.type, this.apikey, this.bearer, this.basic, this.jwt, this.digest, this.oauth1, this.oauth2});
  factory _AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

@override final  APIAuthType type;
@override final  AuthApiKeyModel? apikey;
@override final  AuthBearerModel? bearer;
@override final  AuthBasicAuthModel? basic;
@override final  AuthJwtModel? jwt;
@override final  AuthDigestModel? digest;
@override final  AuthOAuth1Model? oauth1;
@override final  AuthOAuth2Model? oauth2;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthModelCopyWith<_AuthModel> get copyWith => __$AuthModelCopyWithImpl<_AuthModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthModel&&(identical(other.type, type) || other.type == type)&&(identical(other.apikey, apikey) || other.apikey == apikey)&&(identical(other.bearer, bearer) || other.bearer == bearer)&&(identical(other.basic, basic) || other.basic == basic)&&(identical(other.jwt, jwt) || other.jwt == jwt)&&(identical(other.digest, digest) || other.digest == digest)&&(identical(other.oauth1, oauth1) || other.oauth1 == oauth1)&&(identical(other.oauth2, oauth2) || other.oauth2 == oauth2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,apikey,bearer,basic,jwt,digest,oauth1,oauth2);

@override
String toString() {
  return 'AuthModel(type: $type, apikey: $apikey, bearer: $bearer, basic: $basic, jwt: $jwt, digest: $digest, oauth1: $oauth1, oauth2: $oauth2)';
}


}

/// @nodoc
abstract mixin class _$AuthModelCopyWith<$Res> implements $AuthModelCopyWith<$Res> {
  factory _$AuthModelCopyWith(_AuthModel value, $Res Function(_AuthModel) _then) = __$AuthModelCopyWithImpl;
@override @useResult
$Res call({
 APIAuthType type, AuthApiKeyModel? apikey, AuthBearerModel? bearer, AuthBasicAuthModel? basic, AuthJwtModel? jwt, AuthDigestModel? digest, AuthOAuth1Model? oauth1, AuthOAuth2Model? oauth2
});


@override $AuthApiKeyModelCopyWith<$Res>? get apikey;@override $AuthBearerModelCopyWith<$Res>? get bearer;@override $AuthBasicAuthModelCopyWith<$Res>? get basic;@override $AuthJwtModelCopyWith<$Res>? get jwt;@override $AuthDigestModelCopyWith<$Res>? get digest;@override $AuthOAuth1ModelCopyWith<$Res>? get oauth1;@override $AuthOAuth2ModelCopyWith<$Res>? get oauth2;

}
/// @nodoc
class __$AuthModelCopyWithImpl<$Res>
    implements _$AuthModelCopyWith<$Res> {
  __$AuthModelCopyWithImpl(this._self, this._then);

  final _AuthModel _self;
  final $Res Function(_AuthModel) _then;

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? apikey = freezed,Object? bearer = freezed,Object? basic = freezed,Object? jwt = freezed,Object? digest = freezed,Object? oauth1 = freezed,Object? oauth2 = freezed,}) {
  return _then(_AuthModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as APIAuthType,apikey: freezed == apikey ? _self.apikey : apikey // ignore: cast_nullable_to_non_nullable
as AuthApiKeyModel?,bearer: freezed == bearer ? _self.bearer : bearer // ignore: cast_nullable_to_non_nullable
as AuthBearerModel?,basic: freezed == basic ? _self.basic : basic // ignore: cast_nullable_to_non_nullable
as AuthBasicAuthModel?,jwt: freezed == jwt ? _self.jwt : jwt // ignore: cast_nullable_to_non_nullable
as AuthJwtModel?,digest: freezed == digest ? _self.digest : digest // ignore: cast_nullable_to_non_nullable
as AuthDigestModel?,oauth1: freezed == oauth1 ? _self.oauth1 : oauth1 // ignore: cast_nullable_to_non_nullable
as AuthOAuth1Model?,oauth2: freezed == oauth2 ? _self.oauth2 : oauth2 // ignore: cast_nullable_to_non_nullable
as AuthOAuth2Model?,
  ));
}

/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiKeyModelCopyWith<$Res>? get apikey {
    if (_self.apikey == null) {
    return null;
  }

  return $AuthApiKeyModelCopyWith<$Res>(_self.apikey!, (value) {
    return _then(_self.copyWith(apikey: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthBearerModelCopyWith<$Res>? get bearer {
    if (_self.bearer == null) {
    return null;
  }

  return $AuthBearerModelCopyWith<$Res>(_self.bearer!, (value) {
    return _then(_self.copyWith(bearer: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthBasicAuthModelCopyWith<$Res>? get basic {
    if (_self.basic == null) {
    return null;
  }

  return $AuthBasicAuthModelCopyWith<$Res>(_self.basic!, (value) {
    return _then(_self.copyWith(basic: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthJwtModelCopyWith<$Res>? get jwt {
    if (_self.jwt == null) {
    return null;
  }

  return $AuthJwtModelCopyWith<$Res>(_self.jwt!, (value) {
    return _then(_self.copyWith(jwt: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthDigestModelCopyWith<$Res>? get digest {
    if (_self.digest == null) {
    return null;
  }

  return $AuthDigestModelCopyWith<$Res>(_self.digest!, (value) {
    return _then(_self.copyWith(digest: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthOAuth1ModelCopyWith<$Res>? get oauth1 {
    if (_self.oauth1 == null) {
    return null;
  }

  return $AuthOAuth1ModelCopyWith<$Res>(_self.oauth1!, (value) {
    return _then(_self.copyWith(oauth1: value));
  });
}/// Create a copy of AuthModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthOAuth2ModelCopyWith<$Res>? get oauth2 {
    if (_self.oauth2 == null) {
    return null;
  }

  return $AuthOAuth2ModelCopyWith<$Res>(_self.oauth2!, (value) {
    return _then(_self.copyWith(oauth2: value));
  });
}
}

// dart format on
