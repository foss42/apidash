// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_jwt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthJwtModel _$AuthJwtModelFromJson(Map<String, dynamic> json) {
  return _AuthJwtModel.fromJson(json);
}

/// @nodoc
mixin _$AuthJwtModel {
  String get secret => throw _privateConstructorUsedError;
  String? get privateKey => throw _privateConstructorUsedError;
  String get payload => throw _privateConstructorUsedError;
  String get addTokenTo => throw _privateConstructorUsedError;
  String get algorithm => throw _privateConstructorUsedError;
  bool get isSecretBase64Encoded => throw _privateConstructorUsedError;
  String get headerPrefix => throw _privateConstructorUsedError;
  String get queryParamKey => throw _privateConstructorUsedError;
  String get header => throw _privateConstructorUsedError;

  /// Serializes this AuthJwtModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthJwtModelCopyWith<AuthJwtModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthJwtModelCopyWith<$Res> {
  factory $AuthJwtModelCopyWith(
    AuthJwtModel value,
    $Res Function(AuthJwtModel) then,
  ) = _$AuthJwtModelCopyWithImpl<$Res, AuthJwtModel>;
  @useResult
  $Res call({
    String secret,
    String? privateKey,
    String payload,
    String addTokenTo,
    String algorithm,
    bool isSecretBase64Encoded,
    String headerPrefix,
    String queryParamKey,
    String header,
  });
}

/// @nodoc
class _$AuthJwtModelCopyWithImpl<$Res, $Val extends AuthJwtModel>
    implements $AuthJwtModelCopyWith<$Res> {
  _$AuthJwtModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? secret = null,
    Object? privateKey = freezed,
    Object? payload = null,
    Object? addTokenTo = null,
    Object? algorithm = null,
    Object? isSecretBase64Encoded = null,
    Object? headerPrefix = null,
    Object? queryParamKey = null,
    Object? header = null,
  }) {
    return _then(
      _value.copyWith(
            secret: null == secret
                ? _value.secret
                : secret // ignore: cast_nullable_to_non_nullable
                      as String,
            privateKey: freezed == privateKey
                ? _value.privateKey
                : privateKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as String,
            addTokenTo: null == addTokenTo
                ? _value.addTokenTo
                : addTokenTo // ignore: cast_nullable_to_non_nullable
                      as String,
            algorithm: null == algorithm
                ? _value.algorithm
                : algorithm // ignore: cast_nullable_to_non_nullable
                      as String,
            isSecretBase64Encoded: null == isSecretBase64Encoded
                ? _value.isSecretBase64Encoded
                : isSecretBase64Encoded // ignore: cast_nullable_to_non_nullable
                      as bool,
            headerPrefix: null == headerPrefix
                ? _value.headerPrefix
                : headerPrefix // ignore: cast_nullable_to_non_nullable
                      as String,
            queryParamKey: null == queryParamKey
                ? _value.queryParamKey
                : queryParamKey // ignore: cast_nullable_to_non_nullable
                      as String,
            header: null == header
                ? _value.header
                : header // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthJwtModelImplCopyWith<$Res>
    implements $AuthJwtModelCopyWith<$Res> {
  factory _$$AuthJwtModelImplCopyWith(
    _$AuthJwtModelImpl value,
    $Res Function(_$AuthJwtModelImpl) then,
  ) = __$$AuthJwtModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String secret,
    String? privateKey,
    String payload,
    String addTokenTo,
    String algorithm,
    bool isSecretBase64Encoded,
    String headerPrefix,
    String queryParamKey,
    String header,
  });
}

/// @nodoc
class __$$AuthJwtModelImplCopyWithImpl<$Res>
    extends _$AuthJwtModelCopyWithImpl<$Res, _$AuthJwtModelImpl>
    implements _$$AuthJwtModelImplCopyWith<$Res> {
  __$$AuthJwtModelImplCopyWithImpl(
    _$AuthJwtModelImpl _value,
    $Res Function(_$AuthJwtModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? secret = null,
    Object? privateKey = freezed,
    Object? payload = null,
    Object? addTokenTo = null,
    Object? algorithm = null,
    Object? isSecretBase64Encoded = null,
    Object? headerPrefix = null,
    Object? queryParamKey = null,
    Object? header = null,
  }) {
    return _then(
      _$AuthJwtModelImpl(
        secret: null == secret
            ? _value.secret
            : secret // ignore: cast_nullable_to_non_nullable
                  as String,
        privateKey: freezed == privateKey
            ? _value.privateKey
            : privateKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        payload: null == payload
            ? _value.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as String,
        addTokenTo: null == addTokenTo
            ? _value.addTokenTo
            : addTokenTo // ignore: cast_nullable_to_non_nullable
                  as String,
        algorithm: null == algorithm
            ? _value.algorithm
            : algorithm // ignore: cast_nullable_to_non_nullable
                  as String,
        isSecretBase64Encoded: null == isSecretBase64Encoded
            ? _value.isSecretBase64Encoded
            : isSecretBase64Encoded // ignore: cast_nullable_to_non_nullable
                  as bool,
        headerPrefix: null == headerPrefix
            ? _value.headerPrefix
            : headerPrefix // ignore: cast_nullable_to_non_nullable
                  as String,
        queryParamKey: null == queryParamKey
            ? _value.queryParamKey
            : queryParamKey // ignore: cast_nullable_to_non_nullable
                  as String,
        header: null == header
            ? _value.header
            : header // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthJwtModelImpl implements _AuthJwtModel {
  const _$AuthJwtModelImpl({
    required this.secret,
    this.privateKey,
    required this.payload,
    required this.addTokenTo,
    required this.algorithm,
    required this.isSecretBase64Encoded,
    required this.headerPrefix,
    required this.queryParamKey,
    required this.header,
  });

  factory _$AuthJwtModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthJwtModelImplFromJson(json);

  @override
  final String secret;
  @override
  final String? privateKey;
  @override
  final String payload;
  @override
  final String addTokenTo;
  @override
  final String algorithm;
  @override
  final bool isSecretBase64Encoded;
  @override
  final String headerPrefix;
  @override
  final String queryParamKey;
  @override
  final String header;

  @override
  String toString() {
    return 'AuthJwtModel(secret: $secret, privateKey: $privateKey, payload: $payload, addTokenTo: $addTokenTo, algorithm: $algorithm, isSecretBase64Encoded: $isSecretBase64Encoded, headerPrefix: $headerPrefix, queryParamKey: $queryParamKey, header: $header)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthJwtModelImpl &&
            (identical(other.secret, secret) || other.secret == secret) &&
            (identical(other.privateKey, privateKey) ||
                other.privateKey == privateKey) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.addTokenTo, addTokenTo) ||
                other.addTokenTo == addTokenTo) &&
            (identical(other.algorithm, algorithm) ||
                other.algorithm == algorithm) &&
            (identical(other.isSecretBase64Encoded, isSecretBase64Encoded) ||
                other.isSecretBase64Encoded == isSecretBase64Encoded) &&
            (identical(other.headerPrefix, headerPrefix) ||
                other.headerPrefix == headerPrefix) &&
            (identical(other.queryParamKey, queryParamKey) ||
                other.queryParamKey == queryParamKey) &&
            (identical(other.header, header) || other.header == header));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    secret,
    privateKey,
    payload,
    addTokenTo,
    algorithm,
    isSecretBase64Encoded,
    headerPrefix,
    queryParamKey,
    header,
  );

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthJwtModelImplCopyWith<_$AuthJwtModelImpl> get copyWith =>
      __$$AuthJwtModelImplCopyWithImpl<_$AuthJwtModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthJwtModelImplToJson(this);
  }
}

abstract class _AuthJwtModel implements AuthJwtModel {
  const factory _AuthJwtModel({
    required final String secret,
    final String? privateKey,
    required final String payload,
    required final String addTokenTo,
    required final String algorithm,
    required final bool isSecretBase64Encoded,
    required final String headerPrefix,
    required final String queryParamKey,
    required final String header,
  }) = _$AuthJwtModelImpl;

  factory _AuthJwtModel.fromJson(Map<String, dynamic> json) =
      _$AuthJwtModelImpl.fromJson;

  @override
  String get secret;
  @override
  String? get privateKey;
  @override
  String get payload;
  @override
  String get addTokenTo;
  @override
  String get algorithm;
  @override
  bool get isSecretBase64Encoded;
  @override
  String get headerPrefix;
  @override
  String get queryParamKey;
  @override
  String get header;

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthJwtModelImplCopyWith<_$AuthJwtModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
