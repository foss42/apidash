// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graphql_variable_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphqlVariableModel _$GraphqlVariableModelFromJson(Map<String, dynamic> json) {
  return _GraphqlVariableModel.fromJson(json);
}

/// @nodoc
mixin _$GraphqlVariableModel {
  String get name => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  /// Serializes this GraphqlVariableModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphqlVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphqlVariableModelCopyWith<GraphqlVariableModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphqlVariableModelCopyWith<$Res> {
  factory $GraphqlVariableModelCopyWith(GraphqlVariableModel value,
          $Res Function(GraphqlVariableModel) then) =
      _$GraphqlVariableModelCopyWithImpl<$Res, GraphqlVariableModel>;
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class _$GraphqlVariableModelCopyWithImpl<$Res,
        $Val extends GraphqlVariableModel>
    implements $GraphqlVariableModelCopyWith<$Res> {
  _$GraphqlVariableModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphqlVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphqlVariableModelImplCopyWith<$Res>
    implements $GraphqlVariableModelCopyWith<$Res> {
  factory _$$GraphqlVariableModelImplCopyWith(_$GraphqlVariableModelImpl value,
          $Res Function(_$GraphqlVariableModelImpl) then) =
      __$$GraphqlVariableModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class __$$GraphqlVariableModelImplCopyWithImpl<$Res>
    extends _$GraphqlVariableModelCopyWithImpl<$Res, _$GraphqlVariableModelImpl>
    implements _$$GraphqlVariableModelImplCopyWith<$Res> {
  __$$GraphqlVariableModelImplCopyWithImpl(_$GraphqlVariableModelImpl _value,
      $Res Function(_$GraphqlVariableModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphqlVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_$GraphqlVariableModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphqlVariableModelImpl implements _GraphqlVariableModel {
  const _$GraphqlVariableModelImpl({required this.name, required this.value});

  factory _$GraphqlVariableModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphqlVariableModelImplFromJson(json);

  @override
  final String name;
  @override
  final String value;

  @override
  String toString() {
    return 'GraphqlVariableModel(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphqlVariableModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  /// Create a copy of GraphqlVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphqlVariableModelImplCopyWith<_$GraphqlVariableModelImpl>
      get copyWith =>
          __$$GraphqlVariableModelImplCopyWithImpl<_$GraphqlVariableModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphqlVariableModelImplToJson(
      this,
    );
  }
}

abstract class _GraphqlVariableModel implements GraphqlVariableModel {
  const factory _GraphqlVariableModel(
      {required final String name,
      required final String value}) = _$GraphqlVariableModelImpl;

  factory _GraphqlVariableModel.fromJson(Map<String, dynamic> json) =
      _$GraphqlVariableModelImpl.fromJson;

  @override
  String get name;
  @override
  String get value;

  /// Create a copy of GraphqlVariableModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphqlVariableModelImplCopyWith<_$GraphqlVariableModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}