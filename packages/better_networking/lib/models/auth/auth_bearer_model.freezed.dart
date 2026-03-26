// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bearer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthBearerModel _$AuthBearerModelFromJson(Map<String, dynamic> json) {
  return _AuthBearerModel.fromJson(json);
}

/// @nodoc
mixin _$AuthBearerModel {
  String get token => throw _privateConstructorUsedError;

  /// Serializes this AuthBearerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthBearerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthBearerModelCopyWith<AuthBearerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthBearerModelCopyWith<$Res> {
  factory $AuthBearerModelCopyWith(
    AuthBearerModel value,
    $Res Function(AuthBearerModel) then,
  ) = _$AuthBearerModelCopyWithImpl<$Res, AuthBearerModel>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class _$AuthBearerModelCopyWithImpl<$Res, $Val extends AuthBearerModel>
    implements $AuthBearerModelCopyWith<$Res> {
  _$AuthBearerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthBearerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null}) {
    return _then(
      _value.copyWith(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                as String,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthBearerModelImplCopyWith<$Res>
    implements $AuthBearerModelCopyWith<$Res> {
  factory _$$AuthBearerModelImplCopyWith(
    _$AuthBearerModelImpl value,
    $Res Function(_$AuthBearerModelImpl) then,
  ) = __$$AuthBearerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$AuthBearerModelImplCopyWithImpl<$Res>
    extends _$AuthBearerModelCopyWithImpl<$Res, _$AuthBearerModelImpl>
    implements _$$AuthBearerModelImplCopyWith<$Res> {
  __$$AuthBearerModelImplCopyWithImpl(
    _$AuthBearerModelImpl _value,
    $Res Function(_$AuthBearerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthBearerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null}) {
    return _then(
      _$AuthBearerModelImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthBearerModelImpl implements _AuthBearerModel {
  const _$AuthBearerModelImpl({required this.token});

  factory _$AuthBearerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthBearerModelImplFromJson(json);

  @override
  final String token;

  @override
  String toString() {
    return 'AuthBearerModel(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthBearerModelImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of AuthBearerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthBearerModelImplCopyWith<_$AuthBearerModelImpl> get copyWith =>
      __$$AuthBearerModelImplCopyWithImpl<_$AuthBearerModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthBearerModelImplToJson(this);
  }
}

abstract class _AuthBearerModel implements AuthBearerModel {
  const factory _AuthBearerModel({required final String token}) =
      _$AuthBearerModelImpl;

  factory _AuthBearerModel.fromJson(Map<String, dynamic> json) =
      _$AuthBearerModelImpl.fromJson;

  @override
  String get token;

  /// Create a copy of AuthBearerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthBearerModelImplCopyWith<_$AuthBearerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
