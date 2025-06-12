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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return _Auth.fromJson(json);
}

/// @nodoc
mixin _$Auth {
  APIAuthType get type => throw _privateConstructorUsedError;
  AuthApiKeyModel? get apikey => throw _privateConstructorUsedError;
  AuthBearerModel? get bearer => throw _privateConstructorUsedError;
  AuthBasicAuthModel? get basic => throw _privateConstructorUsedError;
  AuthJwtModel? get jwt => throw _privateConstructorUsedError;

  /// Serializes this Auth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthCopyWith<Auth> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthCopyWith<$Res> {
  factory $AuthCopyWith(Auth value, $Res Function(Auth) then) =
      _$AuthCopyWithImpl<$Res, Auth>;
  @useResult
  $Res call(
      {APIAuthType type,
      AuthApiKeyModel? apikey,
      AuthBearerModel? bearer,
      AuthBasicAuthModel? basic,
      AuthJwtModel? jwt});

  $AuthApiKeyModelCopyWith<$Res>? get apikey;
  $AuthBearerModelCopyWith<$Res>? get bearer;
  $AuthBasicAuthModelCopyWith<$Res>? get basic;
  $AuthJwtModelCopyWith<$Res>? get jwt;
}

/// @nodoc
class _$AuthCopyWithImpl<$Res, $Val extends Auth>
    implements $AuthCopyWith<$Res> {
  _$AuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apikey = freezed,
    Object? bearer = freezed,
    Object? basic = freezed,
    Object? jwt = freezed,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }

  /// Create a copy of Auth
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

  /// Create a copy of Auth
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

  /// Create a copy of Auth
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

  /// Create a copy of Auth
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
}

/// @nodoc
abstract class _$$AuthImplCopyWith<$Res> implements $AuthCopyWith<$Res> {
  factory _$$AuthImplCopyWith(
          _$AuthImpl value, $Res Function(_$AuthImpl) then) =
      __$$AuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {APIAuthType type,
      AuthApiKeyModel? apikey,
      AuthBearerModel? bearer,
      AuthBasicAuthModel? basic,
      AuthJwtModel? jwt});

  @override
  $AuthApiKeyModelCopyWith<$Res>? get apikey;
  @override
  $AuthBearerModelCopyWith<$Res>? get bearer;
  @override
  $AuthBasicAuthModelCopyWith<$Res>? get basic;
  @override
  $AuthJwtModelCopyWith<$Res>? get jwt;
}

/// @nodoc
class __$$AuthImplCopyWithImpl<$Res>
    extends _$AuthCopyWithImpl<$Res, _$AuthImpl>
    implements _$$AuthImplCopyWith<$Res> {
  __$$AuthImplCopyWithImpl(_$AuthImpl _value, $Res Function(_$AuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? apikey = freezed,
    Object? bearer = freezed,
    Object? basic = freezed,
    Object? jwt = freezed,
  }) {
    return _then(_$AuthImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthImpl implements _Auth {
  const _$AuthImpl(
      {required this.type, this.apikey, this.bearer, this.basic, this.jwt});

  factory _$AuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthImplFromJson(json);

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
  String toString() {
    return 'Auth(type: $type, apikey: $apikey, bearer: $bearer, basic: $basic, jwt: $jwt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.apikey, apikey) || other.apikey == apikey) &&
            (identical(other.bearer, bearer) || other.bearer == bearer) &&
            (identical(other.basic, basic) || other.basic == basic) &&
            (identical(other.jwt, jwt) || other.jwt == jwt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, apikey, bearer, basic, jwt);

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      __$$AuthImplCopyWithImpl<_$AuthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthImplToJson(
      this,
    );
  }
}

abstract class _Auth implements Auth {
  const factory _Auth(
      {required final APIAuthType type,
      final AuthApiKeyModel? apikey,
      final AuthBearerModel? bearer,
      final AuthBasicAuthModel? basic,
      final AuthJwtModel? jwt}) = _$AuthImpl;

  factory _Auth.fromJson(Map<String, dynamic> json) = _$AuthImpl.fromJson;

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

  /// Create a copy of Auth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthImplCopyWith<_$AuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
