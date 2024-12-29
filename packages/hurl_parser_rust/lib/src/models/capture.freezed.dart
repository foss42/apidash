// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Capture _$CaptureFromJson(Map<String, dynamic> json) {
  return _Capture.fromJson(json);
}

/// @nodoc
mixin _$Capture {
  String get name => throw _privateConstructorUsedError;
  Query get query => throw _privateConstructorUsedError;
  List<Filter>? get filters => throw _privateConstructorUsedError;

  /// Serializes this Capture to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaptureCopyWith<Capture> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaptureCopyWith<$Res> {
  factory $CaptureCopyWith(Capture value, $Res Function(Capture) then) =
      _$CaptureCopyWithImpl<$Res, Capture>;
  @useResult
  $Res call({String name, Query query, List<Filter>? filters});

  $QueryCopyWith<$Res> get query;
}

/// @nodoc
class _$CaptureCopyWithImpl<$Res, $Val extends Capture>
    implements $CaptureCopyWith<$Res> {
  _$CaptureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? query = null,
    Object? filters = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as Query,
      filters: freezed == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>?,
    ) as $Val);
  }

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueryCopyWith<$Res> get query {
    return $QueryCopyWith<$Res>(_value.query, (value) {
      return _then(_value.copyWith(query: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CaptureImplCopyWith<$Res> implements $CaptureCopyWith<$Res> {
  factory _$$CaptureImplCopyWith(
          _$CaptureImpl value, $Res Function(_$CaptureImpl) then) =
      __$$CaptureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, Query query, List<Filter>? filters});

  @override
  $QueryCopyWith<$Res> get query;
}

/// @nodoc
class __$$CaptureImplCopyWithImpl<$Res>
    extends _$CaptureCopyWithImpl<$Res, _$CaptureImpl>
    implements _$$CaptureImplCopyWith<$Res> {
  __$$CaptureImplCopyWithImpl(
      _$CaptureImpl _value, $Res Function(_$CaptureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? query = null,
    Object? filters = freezed,
  }) {
    return _then(_$CaptureImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as Query,
      filters: freezed == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as List<Filter>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _$CaptureImpl implements _Capture {
  const _$CaptureImpl(
      {required this.name, required this.query, final List<Filter>? filters})
      : _filters = filters;

  factory _$CaptureImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaptureImplFromJson(json);

  @override
  final String name;
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
  String toString() {
    return 'Capture(name: $name, query: $query, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaptureImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._filters, _filters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, query, const DeepCollectionEquality().hash(_filters));

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaptureImplCopyWith<_$CaptureImpl> get copyWith =>
      __$$CaptureImplCopyWithImpl<_$CaptureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaptureImplToJson(
      this,
    );
  }
}

abstract class _Capture implements Capture {
  const factory _Capture(
      {required final String name,
      required final Query query,
      final List<Filter>? filters}) = _$CaptureImpl;

  factory _Capture.fromJson(Map<String, dynamic> json) = _$CaptureImpl.fromJson;

  @override
  String get name;
  @override
  Query get query;
  @override
  List<Filter>? get filters;

  /// Create a copy of Capture
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaptureImplCopyWith<_$CaptureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
