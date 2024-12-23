// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'graphql_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GraphqlRequestModel _$GraphqlRequestModelFromJson(Map<String, dynamic> json) {
  return _GraphqlRequestModel.fromJson(json);
}

/// @nodoc
mixin _$GraphqlRequestModel {
  String get query => throw _privateConstructorUsedError;
  Map<String, dynamic>? get variables => throw _privateConstructorUsedError;

  /// Serializes this GraphqlRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GraphqlRequestModelCopyWith<GraphqlRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraphqlRequestModelCopyWith<$Res> {
  factory $GraphqlRequestModelCopyWith(
          GraphqlRequestModel value, $Res Function(GraphqlRequestModel) then) =
      _$GraphqlRequestModelCopyWithImpl<$Res, GraphqlRequestModel>;
  @useResult
  $Res call({String query, Map<String, dynamic>? variables});
}

/// @nodoc
class _$GraphqlRequestModelCopyWithImpl<$Res, $Val extends GraphqlRequestModel>
    implements $GraphqlRequestModelCopyWith<$Res> {
  _$GraphqlRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? variables = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      variables: freezed == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraphqlRequestModelImplCopyWith<$Res>
    implements $GraphqlRequestModelCopyWith<$Res> {
  factory _$$GraphqlRequestModelImplCopyWith(_$GraphqlRequestModelImpl value,
          $Res Function(_$GraphqlRequestModelImpl) then) =
      __$$GraphqlRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String query, Map<String, dynamic>? variables});
}

/// @nodoc
class __$$GraphqlRequestModelImplCopyWithImpl<$Res>
    extends _$GraphqlRequestModelCopyWithImpl<$Res, _$GraphqlRequestModelImpl>
    implements _$$GraphqlRequestModelImplCopyWith<$Res> {
  __$$GraphqlRequestModelImplCopyWithImpl(_$GraphqlRequestModelImpl _value,
      $Res Function(_$GraphqlRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? variables = freezed,
  }) {
    return _then(_$GraphqlRequestModelImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      variables: freezed == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraphqlRequestModelImpl implements _GraphqlRequestModel {
  _$GraphqlRequestModelImpl(
      {required this.query, final Map<String, dynamic>? variables})
      : _variables = variables;

  factory _$GraphqlRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraphqlRequestModelImplFromJson(json);

  @override
  final String query;
  final Map<String, dynamic>? _variables;
  @override
  Map<String, dynamic>? get variables {
    final value = _variables;
    if (value == null) return null;
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'GraphqlRequestModel(query: $query, variables: $variables)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraphqlRequestModelImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, query, const DeepCollectionEquality().hash(_variables));

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GraphqlRequestModelImplCopyWith<_$GraphqlRequestModelImpl> get copyWith =>
      __$$GraphqlRequestModelImplCopyWithImpl<_$GraphqlRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraphqlRequestModelImplToJson(
      this,
    );
  }
}

abstract class _GraphqlRequestModel implements GraphqlRequestModel {
  factory _GraphqlRequestModel(
      {required final String query,
      final Map<String, dynamic>? variables}) = _$GraphqlRequestModelImpl;

  factory _GraphqlRequestModel.fromJson(Map<String, dynamic> json) =
      _$GraphqlRequestModelImpl.fromJson;

  @override
  String get query;
  @override
  Map<String, dynamic>? get variables;

  /// Create a copy of GraphqlRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GraphqlRequestModelImplCopyWith<_$GraphqlRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
