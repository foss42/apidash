// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authorization_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthorizationModel _$AuthorizationModelFromJson(Map<String, dynamic> json) {
  return _AuthorizationModel.fromJson(json);
}

/// @nodoc
mixin _$AuthorizationModel {
  AuthType get authType => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  BasicAuthModel get basicAuthModel => throw _privateConstructorUsedError;
  BearerAuthModel get bearerAuthModel => throw _privateConstructorUsedError;
  ApiKeyAuthModel get apiKeyAuthModel => throw _privateConstructorUsedError;

  /// Serializes this AuthorizationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthorizationModelCopyWith<AuthorizationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorizationModelCopyWith<$Res> {
  factory $AuthorizationModelCopyWith(
          AuthorizationModel value, $Res Function(AuthorizationModel) then) =
      _$AuthorizationModelCopyWithImpl<$Res, AuthorizationModel>;
  @useResult
  $Res call(
      {AuthType authType,
      bool isEnabled,
      BasicAuthModel basicAuthModel,
      BearerAuthModel bearerAuthModel,
      ApiKeyAuthModel apiKeyAuthModel});

  $BasicAuthModelCopyWith<$Res> get basicAuthModel;
  $BearerAuthModelCopyWith<$Res> get bearerAuthModel;
  $ApiKeyAuthModelCopyWith<$Res> get apiKeyAuthModel;
}

/// @nodoc
class _$AuthorizationModelCopyWithImpl<$Res, $Val extends AuthorizationModel>
    implements $AuthorizationModelCopyWith<$Res> {
  _$AuthorizationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authType = null,
    Object? isEnabled = null,
    Object? basicAuthModel = null,
    Object? bearerAuthModel = null,
    Object? apiKeyAuthModel = null,
  }) {
    return _then(_value.copyWith(
      authType: null == authType
          ? _value.authType
          : authType // ignore: cast_nullable_to_non_nullable
              as AuthType,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      basicAuthModel: null == basicAuthModel
          ? _value.basicAuthModel
          : basicAuthModel // ignore: cast_nullable_to_non_nullable
              as BasicAuthModel,
      bearerAuthModel: null == bearerAuthModel
          ? _value.bearerAuthModel
          : bearerAuthModel // ignore: cast_nullable_to_non_nullable
              as BearerAuthModel,
      apiKeyAuthModel: null == apiKeyAuthModel
          ? _value.apiKeyAuthModel
          : apiKeyAuthModel // ignore: cast_nullable_to_non_nullable
              as ApiKeyAuthModel,
    ) as $Val);
  }

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BasicAuthModelCopyWith<$Res> get basicAuthModel {
    return $BasicAuthModelCopyWith<$Res>(_value.basicAuthModel, (value) {
      return _then(_value.copyWith(basicAuthModel: value) as $Val);
    });
  }

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BearerAuthModelCopyWith<$Res> get bearerAuthModel {
    return $BearerAuthModelCopyWith<$Res>(_value.bearerAuthModel, (value) {
      return _then(_value.copyWith(bearerAuthModel: value) as $Val);
    });
  }

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ApiKeyAuthModelCopyWith<$Res> get apiKeyAuthModel {
    return $ApiKeyAuthModelCopyWith<$Res>(_value.apiKeyAuthModel, (value) {
      return _then(_value.copyWith(apiKeyAuthModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthorizationModelImplCopyWith<$Res>
    implements $AuthorizationModelCopyWith<$Res> {
  factory _$$AuthorizationModelImplCopyWith(_$AuthorizationModelImpl value,
          $Res Function(_$AuthorizationModelImpl) then) =
      __$$AuthorizationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthType authType,
      bool isEnabled,
      BasicAuthModel basicAuthModel,
      BearerAuthModel bearerAuthModel,
      ApiKeyAuthModel apiKeyAuthModel});

  @override
  $BasicAuthModelCopyWith<$Res> get basicAuthModel;
  @override
  $BearerAuthModelCopyWith<$Res> get bearerAuthModel;
  @override
  $ApiKeyAuthModelCopyWith<$Res> get apiKeyAuthModel;
}

/// @nodoc
class __$$AuthorizationModelImplCopyWithImpl<$Res>
    extends _$AuthorizationModelCopyWithImpl<$Res, _$AuthorizationModelImpl>
    implements _$$AuthorizationModelImplCopyWith<$Res> {
  __$$AuthorizationModelImplCopyWithImpl(_$AuthorizationModelImpl _value,
      $Res Function(_$AuthorizationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authType = null,
    Object? isEnabled = null,
    Object? basicAuthModel = null,
    Object? bearerAuthModel = null,
    Object? apiKeyAuthModel = null,
  }) {
    return _then(_$AuthorizationModelImpl(
      authType: null == authType
          ? _value.authType
          : authType // ignore: cast_nullable_to_non_nullable
              as AuthType,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      basicAuthModel: null == basicAuthModel
          ? _value.basicAuthModel
          : basicAuthModel // ignore: cast_nullable_to_non_nullable
              as BasicAuthModel,
      bearerAuthModel: null == bearerAuthModel
          ? _value.bearerAuthModel
          : bearerAuthModel // ignore: cast_nullable_to_non_nullable
              as BearerAuthModel,
      apiKeyAuthModel: null == apiKeyAuthModel
          ? _value.apiKeyAuthModel
          : apiKeyAuthModel // ignore: cast_nullable_to_non_nullable
              as ApiKeyAuthModel,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$AuthorizationModelImpl implements _AuthorizationModel {
  const _$AuthorizationModelImpl(
      {this.authType = AuthType.noauth,
      this.isEnabled = false,
      this.basicAuthModel = const BasicAuthModel(username: '', password: ''),
      this.bearerAuthModel = const BearerAuthModel(token: ''),
      this.apiKeyAuthModel =
          const ApiKeyAuthModel(key: '', value: '', addTo: AddTo.header)});

  factory _$AuthorizationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthorizationModelImplFromJson(json);

  @override
  @JsonKey()
  final AuthType authType;
  @override
  @JsonKey()
  final bool isEnabled;
  @override
  @JsonKey()
  final BasicAuthModel basicAuthModel;
  @override
  @JsonKey()
  final BearerAuthModel bearerAuthModel;
  @override
  @JsonKey()
  final ApiKeyAuthModel apiKeyAuthModel;

  @override
  String toString() {
    return 'AuthorizationModel(authType: $authType, isEnabled: $isEnabled, basicAuthModel: $basicAuthModel, bearerAuthModel: $bearerAuthModel, apiKeyAuthModel: $apiKeyAuthModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthorizationModelImpl &&
            (identical(other.authType, authType) ||
                other.authType == authType) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.basicAuthModel, basicAuthModel) ||
                other.basicAuthModel == basicAuthModel) &&
            (identical(other.bearerAuthModel, bearerAuthModel) ||
                other.bearerAuthModel == bearerAuthModel) &&
            (identical(other.apiKeyAuthModel, apiKeyAuthModel) ||
                other.apiKeyAuthModel == apiKeyAuthModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, authType, isEnabled,
      basicAuthModel, bearerAuthModel, apiKeyAuthModel);

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthorizationModelImplCopyWith<_$AuthorizationModelImpl> get copyWith =>
      __$$AuthorizationModelImplCopyWithImpl<_$AuthorizationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthorizationModelImplToJson(
      this,
    );
  }
}

abstract class _AuthorizationModel implements AuthorizationModel {
  const factory _AuthorizationModel(
      {final AuthType authType,
      final bool isEnabled,
      final BasicAuthModel basicAuthModel,
      final BearerAuthModel bearerAuthModel,
      final ApiKeyAuthModel apiKeyAuthModel}) = _$AuthorizationModelImpl;

  factory _AuthorizationModel.fromJson(Map<String, dynamic> json) =
      _$AuthorizationModelImpl.fromJson;

  @override
  AuthType get authType;
  @override
  bool get isEnabled;
  @override
  BasicAuthModel get basicAuthModel;
  @override
  BearerAuthModel get bearerAuthModel;
  @override
  ApiKeyAuthModel get apiKeyAuthModel;

  /// Create a copy of AuthorizationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthorizationModelImplCopyWith<_$AuthorizationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BasicAuthModel _$BasicAuthModelFromJson(Map<String, dynamic> json) {
  return _BasicAuthModel.fromJson(json);
}

/// @nodoc
mixin _$BasicAuthModel {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this BasicAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicAuthModelCopyWith<BasicAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicAuthModelCopyWith<$Res> {
  factory $BasicAuthModelCopyWith(
          BasicAuthModel value, $Res Function(BasicAuthModel) then) =
      _$BasicAuthModelCopyWithImpl<$Res, BasicAuthModel>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$BasicAuthModelCopyWithImpl<$Res, $Val extends BasicAuthModel>
    implements $BasicAuthModelCopyWith<$Res> {
  _$BasicAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasicAuthModelImplCopyWith<$Res>
    implements $BasicAuthModelCopyWith<$Res> {
  factory _$$BasicAuthModelImplCopyWith(_$BasicAuthModelImpl value,
          $Res Function(_$BasicAuthModelImpl) then) =
      __$$BasicAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$BasicAuthModelImplCopyWithImpl<$Res>
    extends _$BasicAuthModelCopyWithImpl<$Res, _$BasicAuthModelImpl>
    implements _$$BasicAuthModelImplCopyWith<$Res> {
  __$$BasicAuthModelImplCopyWithImpl(
      _$BasicAuthModelImpl _value, $Res Function(_$BasicAuthModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
  }) {
    return _then(_$BasicAuthModelImpl(
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

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$BasicAuthModelImpl implements _BasicAuthModel {
  const _$BasicAuthModelImpl({this.username = "", this.password = ""});

  factory _$BasicAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicAuthModelImplFromJson(json);

  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String password;

  @override
  String toString() {
    return 'BasicAuthModel(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasicAuthModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of BasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicAuthModelImplCopyWith<_$BasicAuthModelImpl> get copyWith =>
      __$$BasicAuthModelImplCopyWithImpl<_$BasicAuthModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicAuthModelImplToJson(
      this,
    );
  }
}

abstract class _BasicAuthModel implements BasicAuthModel {
  const factory _BasicAuthModel(
      {final String username, final String password}) = _$BasicAuthModelImpl;

  factory _BasicAuthModel.fromJson(Map<String, dynamic> json) =
      _$BasicAuthModelImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of BasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicAuthModelImplCopyWith<_$BasicAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BearerAuthModel _$BearerAuthModelFromJson(Map<String, dynamic> json) {
  return _BearerAuthModel.fromJson(json);
}

/// @nodoc
mixin _$BearerAuthModel {
  String get token => throw _privateConstructorUsedError;

  /// Serializes this BearerAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BearerAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BearerAuthModelCopyWith<BearerAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BearerAuthModelCopyWith<$Res> {
  factory $BearerAuthModelCopyWith(
          BearerAuthModel value, $Res Function(BearerAuthModel) then) =
      _$BearerAuthModelCopyWithImpl<$Res, BearerAuthModel>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$BearerAuthModelCopyWithImpl<$Res, $Val extends BearerAuthModel>
    implements $BearerAuthModelCopyWith<$Res> {
  _$BearerAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BearerAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BearerAuthModelImplCopyWith<$Res>
    implements $BearerAuthModelCopyWith<$Res> {
  factory _$$BearerAuthModelImplCopyWith(_$BearerAuthModelImpl value,
          $Res Function(_$BearerAuthModelImpl) then) =
      __$$BearerAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$BearerAuthModelImplCopyWithImpl<$Res>
    extends _$BearerAuthModelCopyWithImpl<$Res, _$BearerAuthModelImpl>
    implements _$$BearerAuthModelImplCopyWith<$Res> {
  __$$BearerAuthModelImplCopyWithImpl(
      _$BearerAuthModelImpl _value, $Res Function(_$BearerAuthModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BearerAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$BearerAuthModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$BearerAuthModelImpl implements _BearerAuthModel {
  const _$BearerAuthModelImpl({this.token = ""});

  factory _$BearerAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BearerAuthModelImplFromJson(json);

  @override
  @JsonKey()
  final String token;

  @override
  String toString() {
    return 'BearerAuthModel(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BearerAuthModelImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of BearerAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BearerAuthModelImplCopyWith<_$BearerAuthModelImpl> get copyWith =>
      __$$BearerAuthModelImplCopyWithImpl<_$BearerAuthModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BearerAuthModelImplToJson(
      this,
    );
  }
}

abstract class _BearerAuthModel implements BearerAuthModel {
  const factory _BearerAuthModel({final String token}) = _$BearerAuthModelImpl;

  factory _BearerAuthModel.fromJson(Map<String, dynamic> json) =
      _$BearerAuthModelImpl.fromJson;

  @override
  String get token;

  /// Create a copy of BearerAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BearerAuthModelImplCopyWith<_$BearerAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiKeyAuthModel _$ApiKeyAuthModelFromJson(Map<String, dynamic> json) {
  return _ApiKeyAuthModel.fromJson(json);
}

/// @nodoc
mixin _$ApiKeyAuthModel {
  String get key => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  AddTo get addTo => throw _privateConstructorUsedError;

  /// Serializes this ApiKeyAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiKeyAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiKeyAuthModelCopyWith<ApiKeyAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiKeyAuthModelCopyWith<$Res> {
  factory $ApiKeyAuthModelCopyWith(
          ApiKeyAuthModel value, $Res Function(ApiKeyAuthModel) then) =
      _$ApiKeyAuthModelCopyWithImpl<$Res, ApiKeyAuthModel>;
  @useResult
  $Res call({String key, String value, AddTo addTo});
}

/// @nodoc
class _$ApiKeyAuthModelCopyWithImpl<$Res, $Val extends ApiKeyAuthModel>
    implements $ApiKeyAuthModelCopyWith<$Res> {
  _$ApiKeyAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiKeyAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? addTo = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      addTo: null == addTo
          ? _value.addTo
          : addTo // ignore: cast_nullable_to_non_nullable
              as AddTo,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiKeyAuthModelImplCopyWith<$Res>
    implements $ApiKeyAuthModelCopyWith<$Res> {
  factory _$$ApiKeyAuthModelImplCopyWith(_$ApiKeyAuthModelImpl value,
          $Res Function(_$ApiKeyAuthModelImpl) then) =
      __$$ApiKeyAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, String value, AddTo addTo});
}

/// @nodoc
class __$$ApiKeyAuthModelImplCopyWithImpl<$Res>
    extends _$ApiKeyAuthModelCopyWithImpl<$Res, _$ApiKeyAuthModelImpl>
    implements _$$ApiKeyAuthModelImplCopyWith<$Res> {
  __$$ApiKeyAuthModelImplCopyWithImpl(
      _$ApiKeyAuthModelImpl _value, $Res Function(_$ApiKeyAuthModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApiKeyAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? addTo = null,
  }) {
    return _then(_$ApiKeyAuthModelImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      addTo: null == addTo
          ? _value.addTo
          : addTo // ignore: cast_nullable_to_non_nullable
              as AddTo,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$ApiKeyAuthModelImpl implements _ApiKeyAuthModel {
  const _$ApiKeyAuthModelImpl(
      {this.key = "", this.value = "", this.addTo = AddTo.header});

  factory _$ApiKeyAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiKeyAuthModelImplFromJson(json);

  @override
  @JsonKey()
  final String key;
  @override
  @JsonKey()
  final String value;
  @override
  @JsonKey()
  final AddTo addTo;

  @override
  String toString() {
    return 'ApiKeyAuthModel(key: $key, value: $value, addTo: $addTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiKeyAuthModelImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.addTo, addTo) || other.addTo == addTo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, value, addTo);

  /// Create a copy of ApiKeyAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiKeyAuthModelImplCopyWith<_$ApiKeyAuthModelImpl> get copyWith =>
      __$$ApiKeyAuthModelImplCopyWithImpl<_$ApiKeyAuthModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiKeyAuthModelImplToJson(
      this,
    );
  }
}

abstract class _ApiKeyAuthModel implements ApiKeyAuthModel {
  const factory _ApiKeyAuthModel(
      {final String key,
      final String value,
      final AddTo addTo}) = _$ApiKeyAuthModelImpl;

  factory _ApiKeyAuthModel.fromJson(Map<String, dynamic> json) =
      _$ApiKeyAuthModelImpl.fromJson;

  @override
  String get key;
  @override
  String get value;
  @override
  AddTo get addTo;

  /// Create a copy of ApiKeyAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiKeyAuthModelImplCopyWith<_$ApiKeyAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
