// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stress_test_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StressTestSummary _$StressTestSummaryFromJson(Map<String, dynamic> json) {
  return _StressTestSummary.fromJson(json);
}

/// @nodoc
mixin _$StressTestSummary {
  List<ApiRequestResult> get results => throw _privateConstructorUsedError;
  Duration get totalDuration => throw _privateConstructorUsedError;
  double get avgResponseTime => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  int get failureCount => throw _privateConstructorUsedError;

  /// Serializes this StressTestSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StressTestSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StressTestSummaryCopyWith<StressTestSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StressTestSummaryCopyWith<$Res> {
  factory $StressTestSummaryCopyWith(
          StressTestSummary value, $Res Function(StressTestSummary) then) =
      _$StressTestSummaryCopyWithImpl<$Res, StressTestSummary>;
  @useResult
  $Res call(
      {List<ApiRequestResult> results,
      Duration totalDuration,
      double avgResponseTime,
      int successCount,
      int failureCount});
}

/// @nodoc
class _$StressTestSummaryCopyWithImpl<$Res, $Val extends StressTestSummary>
    implements $StressTestSummaryCopyWith<$Res> {
  _$StressTestSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StressTestSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? totalDuration = null,
    Object? avgResponseTime = null,
    Object? successCount = null,
    Object? failureCount = null,
  }) {
    return _then(_value.copyWith(
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<ApiRequestResult>,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StressTestSummaryImplCopyWith<$Res>
    implements $StressTestSummaryCopyWith<$Res> {
  factory _$$StressTestSummaryImplCopyWith(_$StressTestSummaryImpl value,
          $Res Function(_$StressTestSummaryImpl) then) =
      __$$StressTestSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ApiRequestResult> results,
      Duration totalDuration,
      double avgResponseTime,
      int successCount,
      int failureCount});
}

/// @nodoc
class __$$StressTestSummaryImplCopyWithImpl<$Res>
    extends _$StressTestSummaryCopyWithImpl<$Res, _$StressTestSummaryImpl>
    implements _$$StressTestSummaryImplCopyWith<$Res> {
  __$$StressTestSummaryImplCopyWithImpl(_$StressTestSummaryImpl _value,
      $Res Function(_$StressTestSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of StressTestSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? results = null,
    Object? totalDuration = null,
    Object? avgResponseTime = null,
    Object? successCount = null,
    Object? failureCount = null,
  }) {
    return _then(_$StressTestSummaryImpl(
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<ApiRequestResult>,
      totalDuration: null == totalDuration
          ? _value.totalDuration
          : totalDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      avgResponseTime: null == avgResponseTime
          ? _value.avgResponseTime
          : avgResponseTime // ignore: cast_nullable_to_non_nullable
              as double,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StressTestSummaryImpl implements _StressTestSummary {
  const _$StressTestSummaryImpl(
      {required final List<ApiRequestResult> results,
      required this.totalDuration,
      required this.avgResponseTime,
      required this.successCount,
      required this.failureCount})
      : _results = results;

  factory _$StressTestSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StressTestSummaryImplFromJson(json);

  final List<ApiRequestResult> _results;
  @override
  List<ApiRequestResult> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  final Duration totalDuration;
  @override
  final double avgResponseTime;
  @override
  final int successCount;
  @override
  final int failureCount;

  @override
  String toString() {
    return 'StressTestSummary(results: $results, totalDuration: $totalDuration, avgResponseTime: $avgResponseTime, successCount: $successCount, failureCount: $failureCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StressTestSummaryImpl &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.avgResponseTime, avgResponseTime) ||
                other.avgResponseTime == avgResponseTime) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_results),
      totalDuration,
      avgResponseTime,
      successCount,
      failureCount);

  /// Create a copy of StressTestSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StressTestSummaryImplCopyWith<_$StressTestSummaryImpl> get copyWith =>
      __$$StressTestSummaryImplCopyWithImpl<_$StressTestSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StressTestSummaryImplToJson(
      this,
    );
  }
}

abstract class _StressTestSummary implements StressTestSummary {
  const factory _StressTestSummary(
      {required final List<ApiRequestResult> results,
      required final Duration totalDuration,
      required final double avgResponseTime,
      required final int successCount,
      required final int failureCount}) = _$StressTestSummaryImpl;

  factory _StressTestSummary.fromJson(Map<String, dynamic> json) =
      _$StressTestSummaryImpl.fromJson;

  @override
  List<ApiRequestResult> get results;
  @override
  Duration get totalDuration;
  @override
  double get avgResponseTime;
  @override
  int get successCount;
  @override
  int get failureCount;

  /// Create a copy of StressTestSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StressTestSummaryImplCopyWith<_$StressTestSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
