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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthJwtModel _$AuthJwtModelFromJson(Map<String, dynamic> json) {
  return _AuthJwtModel.fromJson(json);
}

/// @nodoc
mixin _$AuthJwtModel {
  String get jwt => throw _privateConstructorUsedError;

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
          AuthJwtModel value, $Res Function(AuthJwtModel) then) =
      _$AuthJwtModelCopyWithImpl<$Res, AuthJwtModel>;
  @useResult
  $Res call({String jwt});
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
    Object? jwt = null,
  }) {
    return _then(_value.copyWith(
      jwt: null == jwt
          ? _value.jwt
          : jwt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthJwtModelImplCopyWith<$Res>
    implements $AuthJwtModelCopyWith<$Res> {
  factory _$$AuthJwtModelImplCopyWith(
          _$AuthJwtModelImpl value, $Res Function(_$AuthJwtModelImpl) then) =
      __$$AuthJwtModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String jwt});
}

/// @nodoc
class __$$AuthJwtModelImplCopyWithImpl<$Res>
    extends _$AuthJwtModelCopyWithImpl<$Res, _$AuthJwtModelImpl>
    implements _$$AuthJwtModelImplCopyWith<$Res> {
  __$$AuthJwtModelImplCopyWithImpl(
      _$AuthJwtModelImpl _value, $Res Function(_$AuthJwtModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jwt = null,
  }) {
    return _then(_$AuthJwtModelImpl(
      jwt: null == jwt
          ? _value.jwt
          : jwt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthJwtModelImpl implements _AuthJwtModel {
  const _$AuthJwtModelImpl({required this.jwt});

  factory _$AuthJwtModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthJwtModelImplFromJson(json);

  @override
  final String jwt;

  @override
  String toString() {
    return 'AuthJwtModel(jwt: $jwt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthJwtModelImpl &&
            (identical(other.jwt, jwt) || other.jwt == jwt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jwt);

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthJwtModelImplCopyWith<_$AuthJwtModelImpl> get copyWith =>
      __$$AuthJwtModelImplCopyWithImpl<_$AuthJwtModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthJwtModelImplToJson(
      this,
    );
  }
}

abstract class _AuthJwtModel implements AuthJwtModel {
  const factory _AuthJwtModel({required final String jwt}) = _$AuthJwtModelImpl;

  factory _AuthJwtModel.fromJson(Map<String, dynamic> json) =
      _$AuthJwtModelImpl.fromJson;

  @override
  String get jwt;

  /// Create a copy of AuthJwtModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthJwtModelImplCopyWith<_$AuthJwtModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
