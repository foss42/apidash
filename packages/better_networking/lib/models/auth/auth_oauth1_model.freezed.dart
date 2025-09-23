// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_oauth1_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthOAuth1Model _$AuthOAuth1ModelFromJson(Map<String, dynamic> json) {
  return _AuthOAuth1Model.fromJson(json);
}

/// @nodoc
mixin _$AuthOAuth1Model {
  String get consumerKey => throw _privateConstructorUsedError;
  String get consumerSecret => throw _privateConstructorUsedError;
  String? get credentialsFilePath => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get tokenSecret => throw _privateConstructorUsedError;
  OAuth1SignatureMethod get signatureMethod =>
      throw _privateConstructorUsedError;
  String get parameterLocation => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String? get realm => throw _privateConstructorUsedError;
  String? get callbackUrl => throw _privateConstructorUsedError;
  String? get verifier => throw _privateConstructorUsedError;
  String? get nonce => throw _privateConstructorUsedError;
  String? get timestamp => throw _privateConstructorUsedError;
  bool get includeBodyHash => throw _privateConstructorUsedError;

  /// Serializes this AuthOAuth1Model to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthOAuth1Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthOAuth1ModelCopyWith<AuthOAuth1Model> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthOAuth1ModelCopyWith<$Res> {
  factory $AuthOAuth1ModelCopyWith(
    AuthOAuth1Model value,
    $Res Function(AuthOAuth1Model) then,
  ) = _$AuthOAuth1ModelCopyWithImpl<$Res, AuthOAuth1Model>;
  @useResult
  $Res call({
    String consumerKey,
    String consumerSecret,
    String? credentialsFilePath,
    String? accessToken,
    String? tokenSecret,
    OAuth1SignatureMethod signatureMethod,
    String parameterLocation,
    String version,
    String? realm,
    String? callbackUrl,
    String? verifier,
    String? nonce,
    String? timestamp,
    bool includeBodyHash,
  });
}

/// @nodoc
class _$AuthOAuth1ModelCopyWithImpl<$Res, $Val extends AuthOAuth1Model>
    implements $AuthOAuth1ModelCopyWith<$Res> {
  _$AuthOAuth1ModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthOAuth1Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumerKey = null,
    Object? consumerSecret = null,
    Object? credentialsFilePath = freezed,
    Object? accessToken = freezed,
    Object? tokenSecret = freezed,
    Object? signatureMethod = null,
    Object? parameterLocation = null,
    Object? version = null,
    Object? realm = freezed,
    Object? callbackUrl = freezed,
    Object? verifier = freezed,
    Object? nonce = freezed,
    Object? timestamp = freezed,
    Object? includeBodyHash = null,
  }) {
    return _then(
      _value.copyWith(
            consumerKey: null == consumerKey
                ? _value.consumerKey
                : consumerKey // ignore: cast_nullable_to_non_nullable
                      as String,
            consumerSecret: null == consumerSecret
                ? _value.consumerSecret
                : consumerSecret // ignore: cast_nullable_to_non_nullable
                      as String,
            credentialsFilePath: freezed == credentialsFilePath
                ? _value.credentialsFilePath
                : credentialsFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            accessToken: freezed == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            tokenSecret: freezed == tokenSecret
                ? _value.tokenSecret
                : tokenSecret // ignore: cast_nullable_to_non_nullable
                      as String?,
            signatureMethod: null == signatureMethod
                ? _value.signatureMethod
                : signatureMethod // ignore: cast_nullable_to_non_nullable
                      as OAuth1SignatureMethod,
            parameterLocation: null == parameterLocation
                ? _value.parameterLocation
                : parameterLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            realm: freezed == realm
                ? _value.realm
                : realm // ignore: cast_nullable_to_non_nullable
                      as String?,
            callbackUrl: freezed == callbackUrl
                ? _value.callbackUrl
                : callbackUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            verifier: freezed == verifier
                ? _value.verifier
                : verifier // ignore: cast_nullable_to_non_nullable
                      as String?,
            nonce: freezed == nonce
                ? _value.nonce
                : nonce // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: freezed == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String?,
            includeBodyHash: null == includeBodyHash
                ? _value.includeBodyHash
                : includeBodyHash // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthOAuth1ModelImplCopyWith<$Res>
    implements $AuthOAuth1ModelCopyWith<$Res> {
  factory _$$AuthOAuth1ModelImplCopyWith(
    _$AuthOAuth1ModelImpl value,
    $Res Function(_$AuthOAuth1ModelImpl) then,
  ) = __$$AuthOAuth1ModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String consumerKey,
    String consumerSecret,
    String? credentialsFilePath,
    String? accessToken,
    String? tokenSecret,
    OAuth1SignatureMethod signatureMethod,
    String parameterLocation,
    String version,
    String? realm,
    String? callbackUrl,
    String? verifier,
    String? nonce,
    String? timestamp,
    bool includeBodyHash,
  });
}

/// @nodoc
class __$$AuthOAuth1ModelImplCopyWithImpl<$Res>
    extends _$AuthOAuth1ModelCopyWithImpl<$Res, _$AuthOAuth1ModelImpl>
    implements _$$AuthOAuth1ModelImplCopyWith<$Res> {
  __$$AuthOAuth1ModelImplCopyWithImpl(
    _$AuthOAuth1ModelImpl _value,
    $Res Function(_$AuthOAuth1ModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthOAuth1Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumerKey = null,
    Object? consumerSecret = null,
    Object? credentialsFilePath = freezed,
    Object? accessToken = freezed,
    Object? tokenSecret = freezed,
    Object? signatureMethod = null,
    Object? parameterLocation = null,
    Object? version = null,
    Object? realm = freezed,
    Object? callbackUrl = freezed,
    Object? verifier = freezed,
    Object? nonce = freezed,
    Object? timestamp = freezed,
    Object? includeBodyHash = null,
  }) {
    return _then(
      _$AuthOAuth1ModelImpl(
        consumerKey: null == consumerKey
            ? _value.consumerKey
            : consumerKey // ignore: cast_nullable_to_non_nullable
                  as String,
        consumerSecret: null == consumerSecret
            ? _value.consumerSecret
            : consumerSecret // ignore: cast_nullable_to_non_nullable
                  as String,
        credentialsFilePath: freezed == credentialsFilePath
            ? _value.credentialsFilePath
            : credentialsFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        accessToken: freezed == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        tokenSecret: freezed == tokenSecret
            ? _value.tokenSecret
            : tokenSecret // ignore: cast_nullable_to_non_nullable
                  as String?,
        signatureMethod: null == signatureMethod
            ? _value.signatureMethod
            : signatureMethod // ignore: cast_nullable_to_non_nullable
                  as OAuth1SignatureMethod,
        parameterLocation: null == parameterLocation
            ? _value.parameterLocation
            : parameterLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        realm: freezed == realm
            ? _value.realm
            : realm // ignore: cast_nullable_to_non_nullable
                  as String?,
        callbackUrl: freezed == callbackUrl
            ? _value.callbackUrl
            : callbackUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        verifier: freezed == verifier
            ? _value.verifier
            : verifier // ignore: cast_nullable_to_non_nullable
                  as String?,
        nonce: freezed == nonce
            ? _value.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String?,
        includeBodyHash: null == includeBodyHash
            ? _value.includeBodyHash
            : includeBodyHash // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthOAuth1ModelImpl implements _AuthOAuth1Model {
  const _$AuthOAuth1ModelImpl({
    required this.consumerKey,
    required this.consumerSecret,
    this.credentialsFilePath,
    this.accessToken,
    this.tokenSecret,
    this.signatureMethod = OAuth1SignatureMethod.hmacSha1,
    this.parameterLocation = "header",
    this.version = '1.0',
    this.realm,
    this.callbackUrl,
    this.verifier,
    this.nonce,
    this.timestamp,
    this.includeBodyHash = false,
  });

  factory _$AuthOAuth1ModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthOAuth1ModelImplFromJson(json);

  @override
  final String consumerKey;
  @override
  final String consumerSecret;
  @override
  final String? credentialsFilePath;
  @override
  final String? accessToken;
  @override
  final String? tokenSecret;
  @override
  @JsonKey()
  final OAuth1SignatureMethod signatureMethod;
  @override
  @JsonKey()
  final String parameterLocation;
  @override
  @JsonKey()
  final String version;
  @override
  final String? realm;
  @override
  final String? callbackUrl;
  @override
  final String? verifier;
  @override
  final String? nonce;
  @override
  final String? timestamp;
  @override
  @JsonKey()
  final bool includeBodyHash;

  @override
  String toString() {
    return 'AuthOAuth1Model(consumerKey: $consumerKey, consumerSecret: $consumerSecret, credentialsFilePath: $credentialsFilePath, accessToken: $accessToken, tokenSecret: $tokenSecret, signatureMethod: $signatureMethod, parameterLocation: $parameterLocation, version: $version, realm: $realm, callbackUrl: $callbackUrl, verifier: $verifier, nonce: $nonce, timestamp: $timestamp, includeBodyHash: $includeBodyHash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthOAuth1ModelImpl &&
            (identical(other.consumerKey, consumerKey) ||
                other.consumerKey == consumerKey) &&
            (identical(other.consumerSecret, consumerSecret) ||
                other.consumerSecret == consumerSecret) &&
            (identical(other.credentialsFilePath, credentialsFilePath) ||
                other.credentialsFilePath == credentialsFilePath) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.tokenSecret, tokenSecret) ||
                other.tokenSecret == tokenSecret) &&
            (identical(other.signatureMethod, signatureMethod) ||
                other.signatureMethod == signatureMethod) &&
            (identical(other.parameterLocation, parameterLocation) ||
                other.parameterLocation == parameterLocation) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.realm, realm) || other.realm == realm) &&
            (identical(other.callbackUrl, callbackUrl) ||
                other.callbackUrl == callbackUrl) &&
            (identical(other.verifier, verifier) ||
                other.verifier == verifier) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.includeBodyHash, includeBodyHash) ||
                other.includeBodyHash == includeBodyHash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    consumerKey,
    consumerSecret,
    credentialsFilePath,
    accessToken,
    tokenSecret,
    signatureMethod,
    parameterLocation,
    version,
    realm,
    callbackUrl,
    verifier,
    nonce,
    timestamp,
    includeBodyHash,
  );

  /// Create a copy of AuthOAuth1Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthOAuth1ModelImplCopyWith<_$AuthOAuth1ModelImpl> get copyWith =>
      __$$AuthOAuth1ModelImplCopyWithImpl<_$AuthOAuth1ModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthOAuth1ModelImplToJson(this);
  }
}

abstract class _AuthOAuth1Model implements AuthOAuth1Model {
  const factory _AuthOAuth1Model({
    required final String consumerKey,
    required final String consumerSecret,
    final String? credentialsFilePath,
    final String? accessToken,
    final String? tokenSecret,
    final OAuth1SignatureMethod signatureMethod,
    final String parameterLocation,
    final String version,
    final String? realm,
    final String? callbackUrl,
    final String? verifier,
    final String? nonce,
    final String? timestamp,
    final bool includeBodyHash,
  }) = _$AuthOAuth1ModelImpl;

  factory _AuthOAuth1Model.fromJson(Map<String, dynamic> json) =
      _$AuthOAuth1ModelImpl.fromJson;

  @override
  String get consumerKey;
  @override
  String get consumerSecret;
  @override
  String? get credentialsFilePath;
  @override
  String? get accessToken;
  @override
  String? get tokenSecret;
  @override
  OAuth1SignatureMethod get signatureMethod;
  @override
  String get parameterLocation;
  @override
  String get version;
  @override
  String? get realm;
  @override
  String? get callbackUrl;
  @override
  String? get verifier;
  @override
  String? get nonce;
  @override
  String? get timestamp;
  @override
  bool get includeBodyHash;

  /// Create a copy of AuthOAuth1Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthOAuth1ModelImplCopyWith<_$AuthOAuth1ModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
