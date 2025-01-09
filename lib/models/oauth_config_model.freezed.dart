// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oauth_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OAuthConfig _$OAuthConfigFromJson(Map<String, dynamic> json) {
  return _OAuthConfig.fromJson(json);
}

/// @nodoc
mixin _$OAuthConfig {
  /// Unique identifier for this OAuth configuration
  String get id => throw _privateConstructorUsedError;

  /// Name of the configuration
  String get name => throw _privateConstructorUsedError;

  /// OAuth Flow type
  OAuthFlow get flow => throw _privateConstructorUsedError;

  /// Client ID from OAuth provider
  String get clientId => throw _privateConstructorUsedError;

  /// Client Secret from OAuth provider
  String get clientSecret => throw _privateConstructorUsedError;

  /// Authorization endpoint URL
  String get authUrl => throw _privateConstructorUsedError;

  /// Token endpoint URL
  String get tokenEndpoint => throw _privateConstructorUsedError;

  /// Callback URL for OAuth
  String get callbackUrl => throw _privateConstructorUsedError;

  /// OAuth scope
  String get scope => throw _privateConstructorUsedError;

  /// State
  String get state => throw _privateConstructorUsedError;

  /// Auto refresh token option
  bool get autoRefresh => throw _privateConstructorUsedError;

  /// Share token option
  bool get shareToken => throw _privateConstructorUsedError;

  /// Serializes this OAuthConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OAuthConfigCopyWith<OAuthConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OAuthConfigCopyWith<$Res> {
  factory $OAuthConfigCopyWith(
          OAuthConfig value, $Res Function(OAuthConfig) then) =
      _$OAuthConfigCopyWithImpl<$Res, OAuthConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      OAuthFlow flow,
      String clientId,
      String clientSecret,
      String authUrl,
      String tokenEndpoint,
      String callbackUrl,
      String scope,
      String state,
      bool autoRefresh,
      bool shareToken});
}

/// @nodoc
class _$OAuthConfigCopyWithImpl<$Res, $Val extends OAuthConfig>
    implements $OAuthConfigCopyWith<$Res> {
  _$OAuthConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? flow = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? authUrl = null,
    Object? tokenEndpoint = null,
    Object? callbackUrl = null,
    Object? scope = null,
    Object? state = null,
    Object? autoRefresh = null,
    Object? shareToken = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as OAuthFlow,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      authUrl: null == authUrl
          ? _value.authUrl
          : authUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tokenEndpoint: null == tokenEndpoint
          ? _value.tokenEndpoint
          : tokenEndpoint // ignore: cast_nullable_to_non_nullable
              as String,
      callbackUrl: null == callbackUrl
          ? _value.callbackUrl
          : callbackUrl // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      autoRefresh: null == autoRefresh
          ? _value.autoRefresh
          : autoRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: null == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OAuthConfigImplCopyWith<$Res>
    implements $OAuthConfigCopyWith<$Res> {
  factory _$$OAuthConfigImplCopyWith(
          _$OAuthConfigImpl value, $Res Function(_$OAuthConfigImpl) then) =
      __$$OAuthConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      OAuthFlow flow,
      String clientId,
      String clientSecret,
      String authUrl,
      String tokenEndpoint,
      String callbackUrl,
      String scope,
      String state,
      bool autoRefresh,
      bool shareToken});
}

/// @nodoc
class __$$OAuthConfigImplCopyWithImpl<$Res>
    extends _$OAuthConfigCopyWithImpl<$Res, _$OAuthConfigImpl>
    implements _$$OAuthConfigImplCopyWith<$Res> {
  __$$OAuthConfigImplCopyWithImpl(
      _$OAuthConfigImpl _value, $Res Function(_$OAuthConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of OAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? flow = null,
    Object? clientId = null,
    Object? clientSecret = null,
    Object? authUrl = null,
    Object? tokenEndpoint = null,
    Object? callbackUrl = null,
    Object? scope = null,
    Object? state = null,
    Object? autoRefresh = null,
    Object? shareToken = null,
  }) {
    return _then(_$OAuthConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as OAuthFlow,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      authUrl: null == authUrl
          ? _value.authUrl
          : authUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tokenEndpoint: null == tokenEndpoint
          ? _value.tokenEndpoint
          : tokenEndpoint // ignore: cast_nullable_to_non_nullable
              as String,
      callbackUrl: null == callbackUrl
          ? _value.callbackUrl
          : callbackUrl // ignore: cast_nullable_to_non_nullable
              as String,
      scope: null == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      autoRefresh: null == autoRefresh
          ? _value.autoRefresh
          : autoRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      shareToken: null == shareToken
          ? _value.shareToken
          : shareToken // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OAuthConfigImpl extends _OAuthConfig {
  const _$OAuthConfigImpl(
      {required this.id,
      required this.name,
      required this.flow,
      required this.clientId,
      required this.clientSecret,
      required this.authUrl,
      required this.tokenEndpoint,
      required this.callbackUrl,
      required this.scope,
      required this.state,
      this.autoRefresh = false,
      this.shareToken = false})
      : super._();

  factory _$OAuthConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$OAuthConfigImplFromJson(json);

  /// Unique identifier for this OAuth configuration
  @override
  final String id;

  /// Name of the configuration
  @override
  final String name;

  /// OAuth Flow type
  @override
  final OAuthFlow flow;

  /// Client ID from OAuth provider
  @override
  final String clientId;

  /// Client Secret from OAuth provider
  @override
  final String clientSecret;

  /// Authorization endpoint URL
  @override
  final String authUrl;

  /// Token endpoint URL
  @override
  final String tokenEndpoint;

  /// Callback URL for OAuth
  @override
  final String callbackUrl;

  /// OAuth scope
  @override
  final String scope;

  /// State
  @override
  final String state;

  /// Auto refresh token option
  @override
  @JsonKey()
  final bool autoRefresh;

  /// Share token option
  @override
  @JsonKey()
  final bool shareToken;

  @override
  String toString() {
    return 'OAuthConfig(id: $id, name: $name, flow: $flow, clientId: $clientId, clientSecret: $clientSecret, authUrl: $authUrl, tokenEndpoint: $tokenEndpoint, callbackUrl: $callbackUrl, scope: $scope, state: $state, autoRefresh: $autoRefresh, shareToken: $shareToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OAuthConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.flow, flow) || other.flow == flow) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.authUrl, authUrl) || other.authUrl == authUrl) &&
            (identical(other.tokenEndpoint, tokenEndpoint) ||
                other.tokenEndpoint == tokenEndpoint) &&
            (identical(other.callbackUrl, callbackUrl) ||
                other.callbackUrl == callbackUrl) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.autoRefresh, autoRefresh) ||
                other.autoRefresh == autoRefresh) &&
            (identical(other.shareToken, shareToken) ||
                other.shareToken == shareToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      flow,
      clientId,
      clientSecret,
      authUrl,
      tokenEndpoint,
      callbackUrl,
      scope,
      state,
      autoRefresh,
      shareToken);

  /// Create a copy of OAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OAuthConfigImplCopyWith<_$OAuthConfigImpl> get copyWith =>
      __$$OAuthConfigImplCopyWithImpl<_$OAuthConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OAuthConfigImplToJson(
      this,
    );
  }
}

abstract class _OAuthConfig extends OAuthConfig {
  const factory _OAuthConfig(
      {required final String id,
      required final String name,
      required final OAuthFlow flow,
      required final String clientId,
      required final String clientSecret,
      required final String authUrl,
      required final String tokenEndpoint,
      required final String callbackUrl,
      required final String scope,
      required final String state,
      final bool autoRefresh,
      final bool shareToken}) = _$OAuthConfigImpl;
  const _OAuthConfig._() : super._();

  factory _OAuthConfig.fromJson(Map<String, dynamic> json) =
      _$OAuthConfigImpl.fromJson;

  /// Unique identifier for this OAuth configuration
  @override
  String get id;

  /// Name of the configuration
  @override
  String get name;

  /// OAuth Flow type
  @override
  OAuthFlow get flow;

  /// Client ID from OAuth provider
  @override
  String get clientId;

  /// Client Secret from OAuth provider
  @override
  String get clientSecret;

  /// Authorization endpoint URL
  @override
  String get authUrl;

  /// Token endpoint URL
  @override
  String get tokenEndpoint;

  /// Callback URL for OAuth
  @override
  String get callbackUrl;

  /// OAuth scope
  @override
  String get scope;

  /// State
  @override
  String get state;

  /// Auto refresh token option
  @override
  bool get autoRefresh;

  /// Share token option
  @override
  bool get shareToken;

  /// Create a copy of OAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OAuthConfigImplCopyWith<_$OAuthConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
