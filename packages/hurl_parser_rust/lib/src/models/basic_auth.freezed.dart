// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basic_auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BasicAuth _$BasicAuthFromJson(Map<String, dynamic> json) {
  return _BasicAuth.fromJson(json);
}

/// @nodoc
mixin _$BasicAuth {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this BasicAuth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BasicAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BasicAuthCopyWith<BasicAuth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasicAuthCopyWith<$Res> {
  factory $BasicAuthCopyWith(BasicAuth value, $Res Function(BasicAuth) then) =
      _$BasicAuthCopyWithImpl<$Res, BasicAuth>;
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class _$BasicAuthCopyWithImpl<$Res, $Val extends BasicAuth>
    implements $BasicAuthCopyWith<$Res> {
  _$BasicAuthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BasicAuth
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
abstract class _$$BasicAuthImplCopyWith<$Res>
    implements $BasicAuthCopyWith<$Res> {
  factory _$$BasicAuthImplCopyWith(
          _$BasicAuthImpl value, $Res Function(_$BasicAuthImpl) then) =
      __$$BasicAuthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password});
}

/// @nodoc
class __$$BasicAuthImplCopyWithImpl<$Res>
    extends _$BasicAuthCopyWithImpl<$Res, _$BasicAuthImpl>
    implements _$$BasicAuthImplCopyWith<$Res> {
  __$$BasicAuthImplCopyWithImpl(
      _$BasicAuthImpl _value, $Res Function(_$BasicAuthImpl) _then)
      : super(_value, _then);

  /// Create a copy of BasicAuth
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
class _$BasicAuthImpl implements _BasicAuth {
  const _$BasicAuthImpl({required this.username, required this.password});

  factory _$BasicAuthImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasicAuthImplFromJson(json);

  @override
  final String username;
  @override
  final String password;

  @override
  String toString() {
    return 'BasicAuth(username: $username, password: $password)';
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

  /// Create a copy of BasicAuth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BasicAuthImplCopyWith<_$BasicAuthImpl> get copyWith =>
      __$$BasicAuthImplCopyWithImpl<_$BasicAuthImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasicAuthImplToJson(
      this,
    );
  }
}

abstract class _BasicAuth implements BasicAuth {
  const factory _BasicAuth(
      {required final String username,
      required final String password}) = _$BasicAuthImpl;

  factory _BasicAuth.fromJson(Map<String, dynamic> json) =
      _$BasicAuthImpl.fromJson;

  @override
  String get username;
  @override
  String get password;

  /// Create a copy of BasicAuth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BasicAuthImplCopyWith<_$BasicAuthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
