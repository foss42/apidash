// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Query _$QueryFromJson(Map<String, dynamic> json) {
  return _Query.fromJson(json);
}

/// @nodoc
mixin _$Query {
  String get type => throw _privateConstructorUsedError;
  String? get expr =>
      throw _privateConstructorUsedError; // For jsonpath, xpath, regex queries
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this Query to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueryCopyWith<Query> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryCopyWith<$Res> {
  factory $QueryCopyWith(Query value, $Res Function(Query) then) =
      _$QueryCopyWithImpl<$Res, Query>;
  @useResult
  $Res call({String type, String? expr, String? name});
}

/// @nodoc
class _$QueryCopyWithImpl<$Res, $Val extends Query>
    implements $QueryCopyWith<$Res> {
  _$QueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expr = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expr: freezed == expr
          ? _value.expr
          : expr // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryImplCopyWith<$Res> implements $QueryCopyWith<$Res> {
  factory _$$QueryImplCopyWith(
          _$QueryImpl value, $Res Function(_$QueryImpl) then) =
      __$$QueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String? expr, String? name});
}

/// @nodoc
class __$$QueryImplCopyWithImpl<$Res>
    extends _$QueryCopyWithImpl<$Res, _$QueryImpl>
    implements _$$QueryImplCopyWith<$Res> {
  __$$QueryImplCopyWithImpl(
      _$QueryImpl _value, $Res Function(_$QueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? expr = freezed,
    Object? name = freezed,
  }) {
    return _then(_$QueryImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      expr: freezed == expr
          ? _value.expr
          : expr // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QueryImpl implements _Query {
  const _$QueryImpl({required this.type, this.expr, this.name});

  factory _$QueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueryImplFromJson(json);

  @override
  final String type;
  @override
  final String? expr;
// For jsonpath, xpath, regex queries
  @override
  final String? name;

  @override
  String toString() {
    return 'Query(type: $type, expr: $expr, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.expr, expr) || other.expr == expr) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, expr, name);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      __$$QueryImplCopyWithImpl<_$QueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueryImplToJson(
      this,
    );
  }
}

abstract class _Query implements Query {
  const factory _Query(
      {required final String type,
      final String? expr,
      final String? name}) = _$QueryImpl;

  factory _Query.fromJson(Map<String, dynamic> json) = _$QueryImpl.fromJson;

  @override
  String get type;
  @override
  String? get expr; // For jsonpath, xpath, regex queries
  @override
  String? get name;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
