// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_oauth2_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthOAuth2Model _$AuthOAuth2ModelFromJson(Map<String, dynamic> json) {
  return _AuthOAuth2Model.fromJson(json);
}

/// @nodoc
mixin _$AuthOAuth2Model {
  OAuth2GrantType get grantType => throw _privateConstructorUsedError;
  String get authorizationUrl => throw _privateConstructorUsedError;
  String get accessTokenUrl => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get clientSecret => throw _privateConstructorUsedError;
  String? get credentialsFilePath => throw _privateConstructorUsedError;
  String? get redirectUrl => throw _privateConstructorUsedError;
  String? get scope => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String get codeChallengeMethod => throw _privateConstructorUsedError;
  String? get codeVerifier => throw _privateConstructorUsedError;
  String? get codeChallenge => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  String? get identityToken => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;

  /// Serializes this AuthOAuth2Model to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthOAuth2Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthOAuth2ModelCopyWith<AuthOAuth2Model> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthOAuth2ModelCopyWith<$Res> {
  factory $AuthOAuth2ModelCopyWith(
    AuthOAuth2Model value,
    $Res Function(AuthOAuth2Model) then,
  ) = _$AuthOAuth2ModelCopyWithImpl<$Res, AuthOAuth2Model>;
  @useResult
  $Res call({
    OAuth2GrantType grantType,
    String authorizationUrl,
    String accessTokenUrl,
    String clientId,
    String clientSecret,
    String? credentialsFilePath,
    String? redirectUrl,
    String? scope,
    String? state,
    String codeChallengeMethod,
    String? codeVerifier,
    String? codeChallenge,
    String? username,
    String? password,
    String? refreshToken,
    String? identityToken,
    String? accessToken,
  });
}

/// @nodoc
class _$AuthOAuth2ModelCopyWithImpl<$Res, $Val extends AuthOAuth2Model>
    implements $AuthOAuth2ModelCopyWith<$Res> {
  _$AuthOAuth2ModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthOAuth2Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantType = null,
    Object? authorizationUrl = null,
    Object? accessTokenUrl = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? credentialsFilePath = freezed,
    Object? redirectUrl = freezed,
    Object? scope = freezed,
    Object? state = freezed,
    Object? codeChallengeMethod = null,
    Object? codeVerifier = freezed,
    Object? codeChallenge = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? refreshToken = freezed,
    Object? identityToken = freezed,
    Object? accessToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            grantType: null == grantType
                ? _value.grantType
                : grantType // ignore: cast_nullable_to_non_nullable
                      as OAuth2GrantType,
            authorizationUrl: null == authorizationUrl
                ? _value.authorizationUrl
                : authorizationUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            accessTokenUrl: null == accessTokenUrl
                ? _value.accessTokenUrl
                : accessTokenUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientSecret: null == clientSecret
                ? _value.clientSecret
                : clientSecret // ignore: cast_nullable_to_non_nullable
                      as String,
            credentialsFilePath: freezed == credentialsFilePath
                ? _value.credentialsFilePath
                : credentialsFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            redirectUrl: freezed == redirectUrl
                ? _value.redirectUrl
                : redirectUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            scope: freezed == scope
                ? _value.scope
                : scope // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            codeChallengeMethod: null == codeChallengeMethod
                ? _value.codeChallengeMethod
                : codeChallengeMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            codeVerifier: freezed == codeVerifier
                ? _value.codeVerifier
                : codeVerifier // ignore: cast_nullable_to_non_nullable
                      as String?,
            codeChallenge: freezed == codeChallenge
                ? _value.codeChallenge
                : codeChallenge // ignore: cast_nullable_to_non_nullable
                      as String?,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            password: freezed == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            identityToken: freezed == identityToken
                ? _value.identityToken
                : identityToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            accessToken: freezed == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthOAuth2ModelImplCopyWith<$Res>
    implements $AuthOAuth2ModelCopyWith<$Res> {
  factory _$$AuthOAuth2ModelImplCopyWith(
    _$AuthOAuth2ModelImpl value,
    $Res Function(_$AuthOAuth2ModelImpl) then,
  ) = __$$AuthOAuth2ModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    OAuth2GrantType grantType,
    String authorizationUrl,
    String accessTokenUrl,
    String clientId,
    String clientSecret,
    String? credentialsFilePath,
    String? redirectUrl,
    String? scope,
    String? state,
    String codeChallengeMethod,
    String? codeVerifier,
    String? codeChallenge,
    String? username,
    String? password,
    String? refreshToken,
    String? identityToken,
    String? accessToken,
  });
}

/// @nodoc
class __$$AuthOAuth2ModelImplCopyWithImpl<$Res>
    extends _$AuthOAuth2ModelCopyWithImpl<$Res, _$AuthOAuth2ModelImpl>
    implements _$$AuthOAuth2ModelImplCopyWith<$Res> {
  __$$AuthOAuth2ModelImplCopyWithImpl(
    _$AuthOAuth2ModelImpl _value,
    $Res Function(_$AuthOAuth2ModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthOAuth2Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grantType = null,
    Object? authorizationUrl = null,
    Object? accessTokenUrl = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? credentialsFilePath = freezed,
    Object? redirectUrl = freezed,
    Object? scope = freezed,
    Object? state = freezed,
    Object? codeChallengeMethod = null,
    Object? codeVerifier = freezed,
    Object? codeChallenge = freezed,
    Object? username = freezed,
    Object? password = freezed,
    Object? refreshToken = freezed,
    Object? identityToken = freezed,
    Object? accessToken = freezed,
  }) {
    return _then(
      _$AuthOAuth2ModelImpl(
        grantType: null == grantType
            ? _value.grantType
            : grantType // ignore: cast_nullable_to_non_nullable
                  as OAuth2GrantType,
        authorizationUrl: null == authorizationUrl
            ? _value.authorizationUrl
            : authorizationUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        accessTokenUrl: null == accessTokenUrl
            ? _value.accessTokenUrl
            : accessTokenUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientSecret: null == clientSecret
            ? _value.clientSecret
            : clientSecret // ignore: cast_nullable_to_non_nullable
                  as String,
        credentialsFilePath: freezed == credentialsFilePath
            ? _value.credentialsFilePath
            : credentialsFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        redirectUrl: freezed == redirectUrl
            ? _value.redirectUrl
            : redirectUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        scope: freezed == scope
            ? _value.scope
            : scope // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        codeChallengeMethod: null == codeChallengeMethod
            ? _value.codeChallengeMethod
            : codeChallengeMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        codeVerifier: freezed == codeVerifier
            ? _value.codeVerifier
            : codeVerifier // ignore: cast_nullable_to_non_nullable
                  as String?,
        codeChallenge: freezed == codeChallenge
            ? _value.codeChallenge
            : codeChallenge // ignore: cast_nullable_to_non_nullable
                  as String?,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        password: freezed == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        identityToken: freezed == identityToken
            ? _value.identityToken
            : identityToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        accessToken: freezed == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthOAuth2ModelImpl implements _AuthOAuth2Model {
  const _$AuthOAuth2ModelImpl({
    this.grantType = OAuth2GrantType.authorizationCode,
    required this.authorizationUrl,
    required this.accessTokenUrl,
    required this.clientId,
    required this.clientSecret,
    this.credentialsFilePath,
    this.redirectUrl,
    this.scope,
    this.state,
    this.codeChallengeMethod = "sha-256",
    this.codeVerifier,
    this.codeChallenge,
    this.username,
    this.password,
    this.refreshToken,
    this.identityToken,
    this.accessToken,
  });

  factory _$AuthOAuth2ModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthOAuth2ModelImplFromJson(json);

  @override
  @JsonKey()
  final OAuth2GrantType grantType;
  @override
  final String authorizationUrl;
  @override
  final String accessTokenUrl;
  @override
  final String clientId;
  @override
  final String clientSecret;
  @override
  final String? credentialsFilePath;
  @override
  final String? redirectUrl;
  @override
  final String? scope;
  @override
  final String? state;
  @override
  @JsonKey()
  final String codeChallengeMethod;
  @override
  final String? codeVerifier;
  @override
  final String? codeChallenge;
  @override
  final String? username;
  @override
  final String? password;
  @override
  final String? refreshToken;
  @override
  final String? identityToken;
  @override
  final String? accessToken;

  @override
  String toString() {
    return 'AuthOAuth2Model(grantType: $grantType, authorizationUrl: $authorizationUrl, accessTokenUrl: $accessTokenUrl, clientId: $clientId, clientSecret: $clientSecret, credentialsFilePath: $credentialsFilePath, redirectUrl: $redirectUrl, scope: $scope, state: $state, codeChallengeMethod: $codeChallengeMethod, codeVerifier: $codeVerifier, codeChallenge: $codeChallenge, username: $username, password: $password, refreshToken: $refreshToken, identityToken: $identityToken, accessToken: $accessToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthOAuth2ModelImpl &&
            (identical(other.grantType, grantType) ||
                other.grantType == grantType) &&
            (identical(other.authorizationUrl, authorizationUrl) ||
                other.authorizationUrl == authorizationUrl) &&
            (identical(other.accessTokenUrl, accessTokenUrl) ||
                other.accessTokenUrl == accessTokenUrl) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.credentialsFilePath, credentialsFilePath) ||
                other.credentialsFilePath == credentialsFilePath) &&
            (identical(other.redirectUrl, redirectUrl) ||
                other.redirectUrl == redirectUrl) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.codeChallengeMethod, codeChallengeMethod) ||
                other.codeChallengeMethod == codeChallengeMethod) &&
            (identical(other.codeVerifier, codeVerifier) ||
                other.codeVerifier == codeVerifier) &&
            (identical(other.codeChallenge, codeChallenge) ||
                other.codeChallenge == codeChallenge) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    grantType,
    authorizationUrl,
    accessTokenUrl,
    clientId,
    clientSecret,
    credentialsFilePath,
    redirectUrl,
    scope,
    state,
    codeChallengeMethod,
    codeVerifier,
    codeChallenge,
    username,
    password,
    refreshToken,
    identityToken,
    accessToken,
  );

  /// Create a copy of AuthOAuth2Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthOAuth2ModelImplCopyWith<_$AuthOAuth2ModelImpl> get copyWith =>
      __$$AuthOAuth2ModelImplCopyWithImpl<_$AuthOAuth2ModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthOAuth2ModelImplToJson(this);
  }
}

abstract class _AuthOAuth2Model implements AuthOAuth2Model {
  const factory _AuthOAuth2Model({
    final OAuth2GrantType grantType,
    required final String authorizationUrl,
    required final String accessTokenUrl,
    required final String clientId,
    required final String clientSecret,
    final String? credentialsFilePath,
    final String? redirectUrl,
    final String? scope,
    final String? state,
    final String codeChallengeMethod,
    final String? codeVerifier,
    final String? codeChallenge,
    final String? username,
    final String? password,
    final String? refreshToken,
    final String? identityToken,
    final String? accessToken,
  }) = _$AuthOAuth2ModelImpl;

  factory _AuthOAuth2Model.fromJson(Map<String, dynamic> json) =
      _$AuthOAuth2ModelImpl.fromJson;

  @override
  OAuth2GrantType get grantType;
  @override
  String get authorizationUrl;
  @override
  String get accessTokenUrl;
  @override
  String get clientId;
  @override
  String get clientSecret;
  @override
  String? get credentialsFilePath;
  @override
  String? get redirectUrl;
  @override
  String? get scope;
  @override
  String? get state;
  @override
  String get codeChallengeMethod;
  @override
  String? get codeVerifier;
  @override
  String? get codeChallenge;
  @override
  String? get username;
  @override
  String? get password;
  @override
  String? get refreshToken;
  @override
  String? get identityToken;
  @override
  String? get accessToken;

  /// Create a copy of AuthOAuth2Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthOAuth2ModelImplCopyWith<_$AuthOAuth2ModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
