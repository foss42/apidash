// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_basic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthBasicAuthModel _$AuthBasicAuthModelFromJson(Map<String, dynamic> json) {
  return _AuthBasicAuthModel.fromJson(json);
}

/// @nodoc
mixin _$AuthBasicAuthModel {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this AuthBasicAuthModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthBasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthBasicAuthModelCopyWith<AuthBasicAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthBasicAuthModelCopyWith<$Res> {
  factory $AuthBasicAuthModelCopyWith(
    AuthBasicAuthModel value,
    $Res Function(AuthBasicAuthModel) then,
  ) = _$AuthBasicAuthModelCopyWithImpl<$Res, AuthBasicAuthModel>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$AuthBasicAuthModelCopyWithImpl<$Res, $Val extends AuthBasicAuthModel>
    implements $AuthBasicAuthModelCopyWith<$Res> {
  _$AuthBasicAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthBasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthBasicAuthModelImplCopyWith<$Res>
    implements $AuthBasicAuthModelCopyWith<$Res> {
  factory _$$AuthBasicAuthModelImplCopyWith(
    _$AuthBasicAuthModelImpl value,
    $Res Function(_$AuthBasicAuthModelImpl) then,
  ) = __$$AuthBasicAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$AuthBasicAuthModelImplCopyWithImpl<$Res>
    extends _$AuthBasicAuthModelCopyWithImpl<$Res, _$AuthBasicAuthModelImpl>
    implements _$$AuthBasicAuthModelImplCopyWith<$Res> {
  __$$AuthBasicAuthModelImplCopyWithImpl(
    _$AuthBasicAuthModelImpl _value,
    $Res Function(_$AuthBasicAuthModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthBasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? username = null, Object? password = null}) {
    return _then(
      _$AuthBasicAuthModelImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthBasicAuthModelImpl implements _AuthBasicAuthModel {
  const _$AuthBasicAuthModelImpl({
    required this.username,
    required this.password,
  });

  factory _$AuthBasicAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthBasicAuthModelImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthBasicAuthModel(username: $username, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthBasicAuthModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password);

  /// Create a copy of AuthBasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthBasicAuthModelImplCopyWith<_$AuthBasicAuthModelImpl> get copyWith =>
      __$$AuthBasicAuthModelImplCopyWithImpl<_$AuthBasicAuthModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthBasicAuthModelImplToJson(this);
  }
}

abstract class _AuthBasicAuthModel implements AuthBasicAuthModel {
  const factory _AuthBasicAuthModel({
    required final String username,
    required final String password,
  }) = _$AuthBasicAuthModelImpl;

  factory _AuthBasicAuthModel.fromJson(Map<String, dynamic> json) =
      _$AuthBasicAuthModelImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of AuthBasicAuthModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthBasicAuthModelImplCopyWith<_$AuthBasicAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
