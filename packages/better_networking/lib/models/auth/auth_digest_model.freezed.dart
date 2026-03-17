// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_digest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthDigestModel _$AuthDigestModelFromJson(Map<String, dynamic> json) {
  return _AuthDigestModel.fromJson(json);
}

/// @nodoc
mixin _$AuthDigestModel {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get realm => throw _privateConstructorUsedError;
  String get nonce => throw _privateConstructorUsedError;
  String get algorithm => throw _privateConstructorUsedError;
  String get qop => throw _privateConstructorUsedError;
  String get opaque => throw _privateConstructorUsedError;

  /// Serializes this AuthDigestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthDigestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthDigestModelCopyWith<AuthDigestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthDigestModelCopyWith<$Res> {
  factory $AuthDigestModelCopyWith(
    AuthDigestModel value,
    $Res Function(AuthDigestModel) then,
  ) = _$AuthDigestModelCopyWithImpl<$Res, AuthDigestModel>;
  @useResult
  $Res call({
    String username,
    String password,
    String realm,
    String nonce,
    String algorithm,
    String qop,
    String opaque,
  });
}

/// @nodoc
class _$AuthDigestModelCopyWithImpl<$Res, $Val extends AuthDigestModel>
    implements $AuthDigestModelCopyWith<$Res> {
  _$AuthDigestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthDigestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? realm = null,
    Object? nonce = null,
    Object? algorithm = null,
    Object? qop = null,
    Object? opaque = null,
  }) {
    return _then(
      _value.copyWith(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                as String,
        realm: null == realm
            ? _value.realm
            : realm // ignore: cast_nullable_to_non_nullable
                as String,
        nonce: null == nonce
            ? _value.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                as String,
        algorithm: null == algorithm
            ? _value.algorithm
            : algorithm // ignore: cast_nullable_to_non_nullable
                as String,
        qop: null == qop
            ? _value.qop
            : qop // ignore: cast_nullable_to_non_nullable
                as String,
        opaque: null == opaque
            ? _value.opaque
            : opaque // ignore: cast_nullable_to_non_nullable
                as String,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthDigestModelImplCopyWith<$Res>
    implements $AuthDigestModelCopyWith<$Res> {
  factory _$$AuthDigestModelImplCopyWith(
    _$AuthDigestModelImpl value,
    $Res Function(_$AuthDigestModelImpl) then,
  ) = __$$AuthDigestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String username,
    String password,
    String realm,
    String nonce,
    String algorithm,
    String qop,
    String opaque,
  });
}

/// @nodoc
class __$$AuthDigestModelImplCopyWithImpl<$Res>
    extends _$AuthDigestModelCopyWithImpl<$Res, _$AuthDigestModelImpl>
    implements _$$AuthDigestModelImplCopyWith<$Res> {
  __$$AuthDigestModelImplCopyWithImpl(
    _$AuthDigestModelImpl _value,
    $Res Function(_$AuthDigestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthDigestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? realm = null,
    Object? nonce = null,
    Object? algorithm = null,
    Object? qop = null,
    Object? opaque = null,
  }) {
    return _then(
      _$AuthDigestModelImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                as String,
        realm: null == realm
            ? _value.realm
            : realm // ignore: cast_nullable_to_non_nullable
                as String,
        nonce: null == nonce
            ? _value.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                as String,
        algorithm: null == algorithm
            ? _value.algorithm
            : algorithm // ignore: cast_nullable_to_non_nullable
                as String,
        qop: null == qop
            ? _value.qop
            : qop // ignore: cast_nullable_to_non_nullable
                as String,
        opaque: null == opaque
            ? _value.opaque
            : opaque // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthDigestModelImpl implements _AuthDigestModel {
  const _$AuthDigestModelImpl({
    required this.username,
    required this.password,
    required this.realm,
    required this.nonce,
    required this.algorithm,
    required this.qop,
    required this.opaque,
  });

  factory _$AuthDigestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthDigestModelImplFromJson(json);

  @override
  final String username;
  @override
  final String password;
  @override
  final String realm;
  @override
  final String nonce;
  @override
  final String algorithm;
  @override
  final String qop;
  @override
  final String opaque;

  @override
  String toString() {
    return 'AuthDigestModel(username: $username, password: $password, realm: $realm, nonce: $nonce, algorithm: $algorithm, qop: $qop, opaque: $opaque)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDigestModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.realm, realm) || other.realm == realm) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.algorithm, algorithm) ||
                other.algorithm == algorithm) &&
            (identical(other.qop, qop) || other.qop == qop) &&
            (identical(other.opaque, opaque) || other.opaque == opaque));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        username,
        password,
        realm,
        nonce,
        algorithm,
        qop,
        opaque,
      );

  /// Create a copy of AuthDigestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDigestModelImplCopyWith<_$AuthDigestModelImpl> get copyWith =>
      __$$AuthDigestModelImplCopyWithImpl<_$AuthDigestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthDigestModelImplToJson(this);
  }
}

abstract class _AuthDigestModel implements AuthDigestModel {
  const factory _AuthDigestModel({
    required final String username,
    required final String password,
    required final String realm,
    required final String nonce,
    required final String algorithm,
    required final String qop,
    required final String opaque,
  }) = _$AuthDigestModelImpl;

  factory _AuthDigestModel.fromJson(Map<String, dynamic> json) =
      _$AuthDigestModelImpl.fromJson;

  @override
  String get username;
  @override
  String get password;
  @override
  String get realm;
  @override
  String get nonce;
  @override
  String get algorithm;
  @override
  String get qop;
  @override
  String get opaque;

  /// Create a copy of AuthDigestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthDigestModelImplCopyWith<_$AuthDigestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
