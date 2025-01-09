// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oauth_credentials_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OAuthCredentials _$OAuthCredentialsFromJson(Map<String, dynamic> json) {
  return _OAuthCredentials.fromJson(json);
}

/// @nodoc
mixin _$OAuthCredentials {
  /// Access token
  String? get accessToken => throw _privateConstructorUsedError;

  /// Refresh token (optional)
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Token type (e.g., 'Bearer')
  String get tokenType => throw _privateConstructorUsedError;

  /// ID of the associated OAuth configuration
  String? get configId => throw _privateConstructorUsedError;

  /// Serializes this OAuthCredentials to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OAuthCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OAuthCredentialsCopyWith<OAuthCredentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OAuthCredentialsCopyWith<$Res> {
  factory $OAuthCredentialsCopyWith(
          OAuthCredentials value, $Res Function(OAuthCredentials) then) =
      _$OAuthCredentialsCopyWithImpl<$Res, OAuthCredentials>;
  @useResult
  $Res call(
      {String? accessToken,
      String? refreshToken,
      String tokenType,
      String? configId});
}

/// @nodoc
class _$OAuthCredentialsCopyWithImpl<$Res, $Val extends OAuthCredentials>
    implements $OAuthCredentialsCopyWith<$Res> {
  _$OAuthCredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OAuthCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? tokenType = null,
    Object? configId = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      configId: freezed == configId
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OAuthCredentialsImplCopyWith<$Res>
    implements $OAuthCredentialsCopyWith<$Res> {
  factory _$$OAuthCredentialsImplCopyWith(_$OAuthCredentialsImpl value,
          $Res Function(_$OAuthCredentialsImpl) then) =
      __$$OAuthCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? accessToken,
      String? refreshToken,
      String tokenType,
      String? configId});
}

/// @nodoc
class __$$OAuthCredentialsImplCopyWithImpl<$Res>
    extends _$OAuthCredentialsCopyWithImpl<$Res, _$OAuthCredentialsImpl>
    implements _$$OAuthCredentialsImplCopyWith<$Res> {
  __$$OAuthCredentialsImplCopyWithImpl(_$OAuthCredentialsImpl _value,
      $Res Function(_$OAuthCredentialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of OAuthCredentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? tokenType = null,
    Object? configId = freezed,
  }) {
    return _then(_$OAuthCredentialsImpl(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      configId: freezed == configId
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$OAuthCredentialsImpl extends _OAuthCredentials {
  const _$OAuthCredentialsImpl(
      {this.accessToken,
      this.refreshToken,
      this.tokenType = 'Bearer',
      this.configId})
      : super._();

  factory _$OAuthCredentialsImpl.fromJson(Map<String, dynamic> json) =>
      _$$OAuthCredentialsImplFromJson(json);

  /// Access token
  @override
  final String? accessToken;

  /// Refresh token (optional)
  @override
  final String? refreshToken;

  /// Token type (e.g., 'Bearer')
  @override
  @JsonKey()
  final String tokenType;

  /// ID of the associated OAuth configuration
  @override
  final String? configId;

  @override
  String toString() {
    return 'OAuthCredentials(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, configId: $configId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OAuthCredentialsImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.configId, configId) ||
                other.configId == configId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, tokenType, configId);

  /// Create a copy of OAuthCredentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OAuthCredentialsImplCopyWith<_$OAuthCredentialsImpl> get copyWith =>
      __$$OAuthCredentialsImplCopyWithImpl<_$OAuthCredentialsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OAuthCredentialsImplToJson(
      this,
    );
  }
}

abstract class _OAuthCredentials extends OAuthCredentials {
  const factory _OAuthCredentials(
      {final String? accessToken,
      final String? refreshToken,
      final String tokenType,
      final String? configId}) = _$OAuthCredentialsImpl;
  const _OAuthCredentials._() : super._();

  factory _OAuthCredentials.fromJson(Map<String, dynamic> json) =
      _$OAuthCredentialsImpl.fromJson;

  /// Access token
  @override
  String? get accessToken;

  /// Refresh token (optional)
  @override
  String? get refreshToken;

  /// Token type (e.g., 'Bearer')
  @override
  String get tokenType;

  /// ID of the associated OAuth configuration
  @override
  String? get configId;

  /// Create a copy of OAuthCredentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OAuthCredentialsImplCopyWith<_$OAuthCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
