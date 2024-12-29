// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hurl_assert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HurlAssert _$HurlAssertFromJson(Map<String, dynamic> json) {
  return _HurlAssert.fromJson(json);
}

/// @nodoc
mixin _$HurlAssert {
  Query get query => throw _privateConstructorUsedError;
  List<Filter>? get filters => throw _privateConstructorUsedError;
  Predicate get predicate => throw _privateConstructorUsedError;

  /// Serializes this HurlAssert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HurlAssertCopyWith<HurlAssert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HurlAssertCopyWith<$Res> {
  factory $HurlAssertCopyWith(
          HurlAssert value, $Res Function(HurlAssert) then) =
      _$HurlAssertCopyWithImpl<$Res, HurlAssert>;
  @useResult
  $Res call({Query query, List<Filter>? filters, Predicate predicate});

  $QueryCopyWith<$Res> get query;
  $PredicateCopyWith<$Res> get predicate;
}

/// @nodoc
class _$HurlAssertCopyWithImpl<$Res, $Val extends HurlAssert>
    implements $HurlAssertCopyWith<$Res> {
  _$HurlAssertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? filters = freezed,
    Object? predicate = null,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as Query,
      filters: freezed == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>?,
      predicate: null == predicate
          ? _value.predicate
          : predicate // ignore: cast_nullable_to_non_nullable
              as Predicate,
    ) as $Val);
  }

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryCopyWith<$Res> get query {
    return $QueryCopyWith<$Res>(_value.query, (value) {
      return _then(_value.copyWith(query: value) as $Val);
    });
  }

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PredicateCopyWith<$Res> get predicate {
    return $PredicateCopyWith<$Res>(_value.predicate, (value) {
      return _then(_value.copyWith(predicate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HurlAssertImplCopyWith<$Res>
    implements $HurlAssertCopyWith<$Res> {
  factory _$$HurlAssertImplCopyWith(
          _$HurlAssertImpl value, $Res Function(_$HurlAssertImpl) then) =
      __$$HurlAssertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Query query, List<Filter>? filters, Predicate predicate});

  @override
  $QueryCopyWith<$Res> get query;
  @override
  $PredicateCopyWith<$Res> get predicate;
}

/// @nodoc
class __$$HurlAssertImplCopyWithImpl<$Res>
    extends _$HurlAssertCopyWithImpl<$Res, _$HurlAssertImpl>
    implements _$$HurlAssertImplCopyWith<$Res> {
  __$$HurlAssertImplCopyWithImpl(
      _$HurlAssertImpl _value, $Res Function(_$HurlAssertImpl) _then)
      : super(_value, _then);

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? filters = freezed,
    Object? predicate = null,
  }) {
    return _then(_$HurlAssertImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as Query,
      filters: freezed == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>?,
      predicate: null == predicate
          ? _value.predicate
          : predicate // ignore: cast_nullable_to_non_nullable
              as Predicate,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$HurlAssertImpl implements _HurlAssert {
  const _$HurlAssertImpl(
      {required this.query,
      final List<Filter>? filters,
      required this.predicate})
      : _filters = filters;

  factory _$HurlAssertImpl.fromJson(Map<String, dynamic> json) =>
      _$$HurlAssertImplFromJson(json);

  @override
  final Query query;
  final List<Filter>? _filters;
  @override
  List<Filter>? get filters {
    final value = _filters;
    if (value == null) return null;
    if (_filters is EqualUnmodifiableListView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Predicate predicate;

  @override
  String toString() {
    return 'HurlAssert(query: $query, filters: $filters, predicate: $predicate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HurlAssertImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.predicate, predicate) ||
                other.predicate == predicate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, query,
      const DeepCollectionEquality().hash(_filters), predicate);

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HurlAssertImplCopyWith<_$HurlAssertImpl> get copyWith =>
      __$$HurlAssertImplCopyWithImpl<_$HurlAssertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HurlAssertImplToJson(
      this,
    );
  }
}

abstract class _HurlAssert implements HurlAssert {
  const factory _HurlAssert(
      {required final Query query,
      final List<Filter>? filters,
      required final Predicate predicate}) = _$HurlAssertImpl;

  factory _HurlAssert.fromJson(Map<String, dynamic> json) =
      _$HurlAssertImpl.fromJson;

  @override
  Query get query;
  @override
  List<Filter>? get filters;
  @override
  Predicate get predicate;

  /// Create a copy of HurlAssert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HurlAssertImplCopyWith<_$HurlAssertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
