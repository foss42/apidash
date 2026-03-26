// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) {
  return _AuthModel.fromJson(json);
}

/// @nodoc
mixin _$AuthModel {
  APIAuthType get type => throw _privateConstructorUsedError;
  AuthApiKeyModel? get apikey => throw _privateConstructorUsedError;
  AuthBearerModel? get bearer => throw _privateConstructorUsedError;
  AuthBasicAuthModel? get basic => throw _privateConstructorUsedError;
  AuthJwtModel? get jwt => throw _privateConstructorUsedError;
  AuthDigestModel? get digest => throw _privateConstructorUsedError;
  AuthOAuth1Model? get oauth1 => throw _privateConstructorUsedError;
  AuthOAuth2Model? get oauth2 => throw _privateConstructorUsedError;

  /// Serializes this AuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthModelCopyWith<AuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthModelCopyWith<$Res> {
  factory $AuthModelCopyWith(AuthModel value, $Res Function(AuthModel) then) =
      _$AuthModelCopyWithImpl<$Res, AuthModel>;
  @useResult
  $Res call({
    APIAuthType type,
    AuthApiKeyModel? apikey,
    AuthBearerModel? bearer,
    AuthBasicAuthModel? basic,
    AuthJwtModel? jwt,
    AuthDigestModel? digest,
    AuthOAuth1Model? oauth1,
    AuthOAuth2Model? oauth2,
  });

  $AuthApiKeyModelCopyWith<$Res>? get apikey;
  $AuthBearerModelCopyWith<$Res>? get bearer;
  $AuthBasicAuthModelCopyWith<$Res>? get basic;
  $AuthJwtModelCopyWith<$Res>? get jwt;
  $AuthDigestModelCopyWith<$Res>? get digest;
  $AuthOAuth1ModelCopyWith<$Res>? get oauth1;
  $AuthOAuth2ModelCopyWith<$Res>? get oauth2;
}

/// @nodoc
class _$AuthModelCopyWithImpl<$Res, $Val extends AuthModel>
    implements $AuthModelCopyWith<$Res> {
  _$AuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apikey = freezed,
    Object? bearer = freezed,
    Object? basic = freezed,
    Object? jwt = freezed,
    Object? digest = freezed,
    Object? oauth1 = freezed,
    Object? oauth2 = freezed,
  }) {
    return _then(
      _value.copyWith(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                as APIAuthType,
        apikey: freezed == apikey
            ? _value.apikey
            : apikey // ignore: cast_nullable_to_non_nullable
                as AuthApiKeyModel?,
        bearer: freezed == bearer
            ? _value.bearer
            : bearer // ignore: cast_nullable_to_non_nullable
                as AuthBearerModel?,
        basic: freezed == basic
            ? _value.basic
            : basic // ignore: cast_nullable_to_non_nullable
                as AuthBasicAuthModel?,
        jwt: freezed == jwt
            ? _value.jwt
            : jwt // ignore: cast_nullable_to_non_nullable
                as AuthJwtModel?,
        digest: freezed == digest
            ? _value.digest
            : digest // ignore: cast_nullable_to_non_nullable
                as AuthDigestModel?,
        oauth1: freezed == oauth1
            ? _value.oauth1
            : oauth1 // ignore: cast_nullable_to_non_nullable
                as AuthOAuth1Model?,
        oauth2: freezed == oauth2
            ? _value.oauth2
            : oauth2 // ignore: cast_nullable_to_non_nullable
                as AuthOAuth2Model?,
      ) as $Val,
    );
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthApiKeyModelCopyWith<$Res>? get apikey {
    if (_value.apikey == null) {
      return null;
    }

    return $AuthApiKeyModelCopyWith<$Res>(_value.apikey!, (value) {
      return _then(_value.copyWith(apikey: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthBearerModelCopyWith<$Res>? get bearer {
    if (_value.bearer == null) {
      return null;
    }

    return $AuthBearerModelCopyWith<$Res>(_value.bearer!, (value) {
      return _then(_value.copyWith(bearer: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthBasicAuthModelCopyWith<$Res>? get basic {
    if (_value.basic == null) {
      return null;
    }

    return $AuthBasicAuthModelCopyWith<$Res>(_value.basic!, (value) {
      return _then(_value.copyWith(basic: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthJwtModelCopyWith<$Res>? get jwt {
    if (_value.jwt == null) {
      return null;
    }

    return $AuthJwtModelCopyWith<$Res>(_value.jwt!, (value) {
      return _then(_value.copyWith(jwt: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthDigestModelCopyWith<$Res>? get digest {
    if (_value.digest == null) {
      return null;
    }

    return $AuthDigestModelCopyWith<$Res>(_value.digest!, (value) {
      return _then(_value.copyWith(digest: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthOAuth1ModelCopyWith<$Res>? get oauth1 {
    if (_value.oauth1 == null) {
      return null;
    }

    return $AuthOAuth1ModelCopyWith<$Res>(_value.oauth1!, (value) {
      return _then(_value.copyWith(oauth1: value) as $Val);
    });
  }

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthOAuth2ModelCopyWith<$Res>? get oauth2 {
    if (_value.oauth2 == null) {
      return null;
    }

    return $AuthOAuth2ModelCopyWith<$Res>(_value.oauth2!, (value) {
      return _then(_value.copyWith(oauth2: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthModelImplCopyWith<$Res>
    implements $AuthModelCopyWith<$Res> {
  factory _$$AuthModelImplCopyWith(
    _$AuthModelImpl value,
    $Res Function(_$AuthModelImpl) then,
  ) = __$$AuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    APIAuthType type,
    AuthApiKeyModel? apikey,
    AuthBearerModel? bearer,
    AuthBasicAuthModel? basic,
    AuthJwtModel? jwt,
    AuthDigestModel? digest,
    AuthOAuth1Model? oauth1,
    AuthOAuth2Model? oauth2,
  });

  @override
  $AuthApiKeyModelCopyWith<$Res>? get apikey;
  @override
  $AuthBearerModelCopyWith<$Res>? get bearer;
  @override
  $AuthBasicAuthModelCopyWith<$Res>? get basic;
  @override
  $AuthJwtModelCopyWith<$Res>? get jwt;
  @override
  $AuthDigestModelCopyWith<$Res>? get digest;
  @override
  $AuthOAuth1ModelCopyWith<$Res>? get oauth1;
  @override
  $AuthOAuth2ModelCopyWith<$Res>? get oauth2;
}

/// @nodoc
class __$$AuthModelImplCopyWithImpl<$Res>
    extends _$AuthModelCopyWithImpl<$Res, _$AuthModelImpl>
    implements _$$AuthModelImplCopyWith<$Res> {
  __$$AuthModelImplCopyWithImpl(
    _$AuthModelImpl _value,
    $Res Function(_$AuthModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apikey = freezed,
    Object? bearer = freezed,
    Object? basic = freezed,
    Object? jwt = freezed,
    Object? digest = freezed,
    Object? oauth1 = freezed,
    Object? oauth2 = freezed,
  }) {
    return _then(
      _$AuthModelImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                as APIAuthType,
        apikey: freezed == apikey
            ? _value.apikey
            : apikey // ignore: cast_nullable_to_non_nullable
                as AuthApiKeyModel?,
        bearer: freezed == bearer
            ? _value.bearer
            : bearer // ignore: cast_nullable_to_non_nullable
                as AuthBearerModel?,
        basic: freezed == basic
            ? _value.basic
            : basic // ignore: cast_nullable_to_non_nullable
                as AuthBasicAuthModel?,
        jwt: freezed == jwt
            ? _value.jwt
            : jwt // ignore: cast_nullable_to_non_nullable
                as AuthJwtModel?,
        digest: freezed == digest
            ? _value.digest
            : digest // ignore: cast_nullable_to_non_nullable
                as AuthDigestModel?,
        oauth1: freezed == oauth1
            ? _value.oauth1
            : oauth1 // ignore: cast_nullable_to_non_nullable
                as AuthOAuth1Model?,
        oauth2: freezed == oauth2
            ? _value.oauth2
            : oauth2 // ignore: cast_nullable_to_non_nullable
                as AuthOAuth2Model?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$AuthModelImpl implements _AuthModel {
  const _$AuthModelImpl({
    required this.type,
    this.apikey,
    this.bearer,
    this.basic,
    this.jwt,
    this.digest,
    this.oauth1,
    this.oauth2,
  });

  factory _$AuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthModelImplFromJson(json);

  @override
  final APIAuthType type;
  @override
  final AuthApiKeyModel? apikey;
  @override
  final AuthBearerModel? bearer;
  @override
  final AuthBasicAuthModel? basic;
  @override
  final AuthJwtModel? jwt;
  @override
  final AuthDigestModel? digest;
  @override
  final AuthOAuth1Model? oauth1;
  @override
  final AuthOAuth2Model? oauth2;

  @override
  String toString() {
    return 'AuthModel(type: $type, apikey: $apikey, bearer: $bearer, basic: $basic, jwt: $jwt, digest: $digest, oauth1: $oauth1, oauth2: $oauth2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.apikey, apikey) || other.apikey == apikey) &&
            (identical(other.bearer, bearer) || other.bearer == bearer) &&
            (identical(other.basic, basic) || other.basic == basic) &&
            (identical(other.jwt, jwt) || other.jwt == jwt) &&
            (identical(other.digest, digest) || other.digest == digest) &&
            (identical(other.oauth1, oauth1) || other.oauth1 == oauth1) &&
            (identical(other.oauth2, oauth2) || other.oauth2 == oauth2));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        type,
        apikey,
        bearer,
        basic,
        jwt,
        digest,
        oauth1,
        oauth2,
      );

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthModelImplCopyWith<_$AuthModelImpl> get copyWith =>
      __$$AuthModelImplCopyWithImpl<_$AuthModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthModelImplToJson(this);
  }
}

abstract class _AuthModel implements AuthModel {
  const factory _AuthModel({
    required final APIAuthType type,
    final AuthApiKeyModel? apikey,
    final AuthBearerModel? bearer,
    final AuthBasicAuthModel? basic,
    final AuthJwtModel? jwt,
    final AuthDigestModel? digest,
    final AuthOAuth1Model? oauth1,
    final AuthOAuth2Model? oauth2,
  }) = _$AuthModelImpl;

  factory _AuthModel.fromJson(Map<String, dynamic> json) =
      _$AuthModelImpl.fromJson;

  @override
  APIAuthType get type;
  @override
  AuthApiKeyModel? get apikey;
  @override
  AuthBearerModel? get bearer;
  @override
  AuthBasicAuthModel? get basic;
  @override
  AuthJwtModel? get jwt;
  @override
  AuthDigestModel? get digest;
  @override
  AuthOAuth1Model? get oauth1;
  @override
  AuthOAuth2Model? get oauth2;

  /// Create a copy of AuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthModelImplCopyWith<_$AuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
