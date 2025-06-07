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

APIAuthModel _$APIAuthModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'none':
      return None.fromJson(json);
    case 'basic':
      return BasicAuth.fromJson(json);
    case 'bearerToken':
      return BearerTokenAuth.fromJson(json);
    case 'apiKey':
      return APIKeyAuth.fromJson(json);
    case 'jwtBearer':
      return JWTBearerAuth.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'APIAuthModel',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$APIAuthModel {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this APIAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $APIAuthModelCopyWith<$Res> {
  factory $APIAuthModelCopyWith(
          APIAuthModel value, $Res Function(APIAuthModel) then) =
      _$APIAuthModelCopyWithImpl<$Res, APIAuthModel>;
}

/// @nodoc
class _$APIAuthModelCopyWithImpl<$Res, $Val extends APIAuthModel>
    implements $APIAuthModelCopyWith<$Res> {
  _$APIAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NoneImplCopyWith<$Res> {
  factory _$$NoneImplCopyWith(
          _$NoneImpl value, $Res Function(_$NoneImpl) then) =
      __$$NoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoneImplCopyWithImpl<$Res>
    extends _$APIAuthModelCopyWithImpl<$Res, _$NoneImpl>
    implements _$$NoneImplCopyWith<$Res> {
  __$$NoneImplCopyWithImpl(_$NoneImpl _value, $Res Function(_$NoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$NoneImpl implements None {
  const _$NoneImpl({final String? $type}) : $type = $type ?? 'none';

  factory _$NoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoneImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'APIAuthModel.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoneImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NoneImplToJson(
      this,
    );
  }
}

abstract class None implements APIAuthModel {
  const factory None() = _$NoneImpl;

  factory None.fromJson(Map<String, dynamic> json) = _$NoneImpl.fromJson;
}

/// @nodoc
abstract class _$$BasicAuthImplCopyWith<$Res> {
  factory _$$BasicAuthImplCopyWith(
          _$BasicAuthImpl value, $Res Function(_$BasicAuthImpl) then) =
      __$$BasicAuthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$BasicAuthImplCopyWithImpl<$Res>
    extends _$APIAuthModelCopyWithImpl<$Res, _$BasicAuthImpl>
    implements _$$BasicAuthImplCopyWith<$Res> {
  __$$BasicAuthImplCopyWithImpl(
      _$BasicAuthImpl _value, $Res Function(_$BasicAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_$BasicAuthImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasicAuthImpl implements BasicAuth {
  const _$BasicAuthImpl(
      {required this.username, required this.password, final String? $type})
      : $type = $type ?? 'basic';

  factory _$BasicAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicAuthImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'APIAuthModel.basic(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicAuthImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicAuthImplCopyWith<_$BasicAuthImpl> get copyWith =>
      __$$BasicAuthImplCopyWithImpl<_$BasicAuthImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) {
    return basic(username, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) {
    return basic?.call(username, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) {
    if (basic != null) {
      return basic(username, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) {
    return basic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) {
    return basic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) {
    if (basic != null) {
      return basic(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicAuthImplToJson(
      this,
    );
  }
}

abstract class BasicAuth implements APIAuthModel {
  const factory BasicAuth(
      {required final String username,
      required final String password}) = _$BasicAuthImpl;

  factory BasicAuth.fromJson(Map<String, dynamic> json) =
      _$BasicAuthImpl.fromJson;

  String get username;
  String get password;

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicAuthImplCopyWith<_$BasicAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BearerTokenAuthImplCopyWith<$Res> {
  factory _$$BearerTokenAuthImplCopyWith(_$BearerTokenAuthImpl value,
          $Res Function(_$BearerTokenAuthImpl) then) =
      __$$BearerTokenAuthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$BearerTokenAuthImplCopyWithImpl<$Res>
    extends _$APIAuthModelCopyWithImpl<$Res, _$BearerTokenAuthImpl>
    implements _$$BearerTokenAuthImplCopyWith<$Res> {
  __$$BearerTokenAuthImplCopyWithImpl(
      _$BearerTokenAuthImpl _value, $Res Function(_$BearerTokenAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$BearerTokenAuthImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BearerTokenAuthImpl implements BearerTokenAuth {
  const _$BearerTokenAuthImpl({required this.token, final String? $type})
      : $type = $type ?? 'bearerToken';

  factory _$BearerTokenAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$BearerTokenAuthImplFromJson(json);

  @override
  final String token;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'APIAuthModel.bearerToken(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BearerTokenAuthImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BearerTokenAuthImplCopyWith<_$BearerTokenAuthImpl> get copyWith =>
      __$$BearerTokenAuthImplCopyWithImpl<_$BearerTokenAuthImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) {
    return bearerToken(token);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) {
    return bearerToken?.call(token);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) {
    if (bearerToken != null) {
      return bearerToken(token);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) {
    return bearerToken(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) {
    return bearerToken?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) {
    if (bearerToken != null) {
      return bearerToken(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BearerTokenAuthImplToJson(
      this,
    );
  }
}

abstract class BearerTokenAuth implements APIAuthModel {
  const factory BearerTokenAuth({required final String token}) =
      _$BearerTokenAuthImpl;

  factory BearerTokenAuth.fromJson(Map<String, dynamic> json) =
      _$BearerTokenAuthImpl.fromJson;

  String get token;

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BearerTokenAuthImplCopyWith<_$BearerTokenAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$APIKeyAuthImplCopyWith<$Res> {
  factory _$$APIKeyAuthImplCopyWith(
          _$APIKeyAuthImpl value, $Res Function(_$APIKeyAuthImpl) then) =
      __$$APIKeyAuthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String key, String location, String name});
}

/// @nodoc
class __$$APIKeyAuthImplCopyWithImpl<$Res>
    extends _$APIAuthModelCopyWithImpl<$Res, _$APIKeyAuthImpl>
    implements _$$APIKeyAuthImplCopyWith<$Res> {
  __$$APIKeyAuthImplCopyWithImpl(
      _$APIKeyAuthImpl _value, $Res Function(_$APIKeyAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? location = null,
    Object? name = null,
  }) {
    return _then(_$APIKeyAuthImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$APIKeyAuthImpl implements APIKeyAuth {
  const _$APIKeyAuthImpl(
      {required this.key,
      this.location = 'header',
      this.name = 'x-api-key',
      final String? $type})
      : $type = $type ?? 'apiKey';

  factory _$APIKeyAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$APIKeyAuthImplFromJson(json);

  @override
  final String key;
  @override
  @JsonKey()
  final String location;
// or 'query'
  @override
  @JsonKey()
  final String name;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'APIAuthModel.apiKey(key: $key, location: $location, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$APIKeyAuthImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, location, name);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$APIKeyAuthImplCopyWith<_$APIKeyAuthImpl> get copyWith =>
      __$$APIKeyAuthImplCopyWithImpl<_$APIKeyAuthImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) {
    return apiKey(key, location, name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) {
    return apiKey?.call(key, location, name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) {
    if (apiKey != null) {
      return apiKey(key, location, name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) {
    return apiKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) {
    return apiKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) {
    if (apiKey != null) {
      return apiKey(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$APIKeyAuthImplToJson(
      this,
    );
  }
}

abstract class APIKeyAuth implements APIAuthModel {
  const factory APIKeyAuth(
      {required final String key,
      final String location,
      final String name}) = _$APIKeyAuthImpl;

  factory APIKeyAuth.fromJson(Map<String, dynamic> json) =
      _$APIKeyAuthImpl.fromJson;

  String get key;
  String get location; // or 'query'
  String get name;

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$APIKeyAuthImplCopyWith<_$APIKeyAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JWTBearerAuthImplCopyWith<$Res> {
  factory _$$JWTBearerAuthImplCopyWith(
          _$JWTBearerAuthImpl value, $Res Function(_$JWTBearerAuthImpl) then) =
      __$$JWTBearerAuthImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String jwt});
}

/// @nodoc
class __$$JWTBearerAuthImplCopyWithImpl<$Res>
    extends _$APIAuthModelCopyWithImpl<$Res, _$JWTBearerAuthImpl>
    implements _$$JWTBearerAuthImplCopyWith<$Res> {
  __$$JWTBearerAuthImplCopyWithImpl(
      _$JWTBearerAuthImpl _value, $Res Function(_$JWTBearerAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jwt = null,
  }) {
    return _then(_$JWTBearerAuthImpl(
      jwt: null == jwt
          ? _value.jwt
          : jwt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JWTBearerAuthImpl implements JWTBearerAuth {
  const _$JWTBearerAuthImpl({required this.jwt, final String? $type})
      : $type = $type ?? 'jwtBearer';

  factory _$JWTBearerAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$JWTBearerAuthImplFromJson(json);

  @override
  final String jwt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'APIAuthModel.jwtBearer(jwt: $jwt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JWTBearerAuthImpl &&
            (identical(other.jwt, jwt) || other.jwt == jwt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jwt);

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JWTBearerAuthImplCopyWith<_$JWTBearerAuthImpl> get copyWith =>
      __$$JWTBearerAuthImplCopyWithImpl<_$JWTBearerAuthImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(String username, String password) basic,
    required TResult Function(String token) bearerToken,
    required TResult Function(String key, String location, String name) apiKey,
    required TResult Function(String jwt) jwtBearer,
  }) {
    return jwtBearer(jwt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function(String username, String password)? basic,
    TResult? Function(String token)? bearerToken,
    TResult? Function(String key, String location, String name)? apiKey,
    TResult? Function(String jwt)? jwtBearer,
  }) {
    return jwtBearer?.call(jwt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(String username, String password)? basic,
    TResult Function(String token)? bearerToken,
    TResult Function(String key, String location, String name)? apiKey,
    TResult Function(String jwt)? jwtBearer,
    required TResult orElse(),
  }) {
    if (jwtBearer != null) {
      return jwtBearer(jwt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(None value) none,
    required TResult Function(BasicAuth value) basic,
    required TResult Function(BearerTokenAuth value) bearerToken,
    required TResult Function(APIKeyAuth value) apiKey,
    required TResult Function(JWTBearerAuth value) jwtBearer,
  }) {
    return jwtBearer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(None value)? none,
    TResult? Function(BasicAuth value)? basic,
    TResult? Function(BearerTokenAuth value)? bearerToken,
    TResult? Function(APIKeyAuth value)? apiKey,
    TResult? Function(JWTBearerAuth value)? jwtBearer,
  }) {
    return jwtBearer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(None value)? none,
    TResult Function(BasicAuth value)? basic,
    TResult Function(BearerTokenAuth value)? bearerToken,
    TResult Function(APIKeyAuth value)? apiKey,
    TResult Function(JWTBearerAuth value)? jwtBearer,
    required TResult orElse(),
  }) {
    if (jwtBearer != null) {
      return jwtBearer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$JWTBearerAuthImplToJson(
      this,
    );
  }
}

abstract class JWTBearerAuth implements APIAuthModel {
  const factory JWTBearerAuth({required final String jwt}) =
      _$JWTBearerAuthImpl;

  factory JWTBearerAuth.fromJson(Map<String, dynamic> json) =
      _$JWTBearerAuthImpl.fromJson;

  String get jwt;

  /// Create a copy of APIAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JWTBearerAuthImplCopyWith<_$JWTBearerAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
