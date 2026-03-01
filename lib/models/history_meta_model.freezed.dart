// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_meta_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryMetaModel {
  String get historyId;
  String get requestId;
  APIType get apiType;
  String get name;
  String get url;
  HTTPVerb get method;
  int get responseStatus;
  DateTime get timeStamp;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HistoryMetaModelCopyWith<HistoryMetaModel> get copyWith =>
      _$HistoryMetaModelCopyWithImpl<HistoryMetaModel>(
          this as HistoryMetaModel, _$identity);

  /// Serializes this HistoryMetaModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HistoryMetaModel &&
            (identical(other.historyId, historyId) ||
                other.historyId == historyId) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, historyId, requestId, apiType,
      name, url, method, responseStatus, timeStamp);

  @override
  String toString() {
    return 'HistoryMetaModel(historyId: $historyId, requestId: $requestId, apiType: $apiType, name: $name, url: $url, method: $method, responseStatus: $responseStatus, timeStamp: $timeStamp)';
  }
}

/// @nodoc
abstract mixin class $HistoryMetaModelCopyWith<$Res> {
  factory $HistoryMetaModelCopyWith(
          HistoryMetaModel value, $Res Function(HistoryMetaModel) _then) =
      _$HistoryMetaModelCopyWithImpl;
  @useResult
  $Res call(
      {String historyId,
      String requestId,
      APIType apiType,
      String name,
      String url,
      HTTPVerb method,
      int responseStatus,
      DateTime timeStamp});
}

/// @nodoc
class _$HistoryMetaModelCopyWithImpl<$Res>
    implements $HistoryMetaModelCopyWith<$Res> {
  _$HistoryMetaModelCopyWithImpl(this._self, this._then);

  final HistoryMetaModel _self;
  final $Res Function(HistoryMetaModel) _then;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? historyId = null,
    Object? requestId = null,
    Object? apiType = null,
    Object? name = null,
    Object? url = null,
    Object? method = null,
    Object? responseStatus = null,
    Object? timeStamp = null,
  }) {
    return _then(_self.copyWith(
      historyId: null == historyId
          ? _self.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _self.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      responseStatus: null == responseStatus
          ? _self.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int,
      timeStamp: null == timeStamp
          ? _self.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [HistoryMetaModel].
extension HistoryMetaModelPatterns on HistoryMetaModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryMetaModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryMetaModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryMetaModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String historyId,
            String requestId,
            APIType apiType,
            String name,
            String url,
            HTTPVerb method,
            int responseStatus,
            DateTime timeStamp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel() when $default != null:
        return $default(
            _that.historyId,
            _that.requestId,
            _that.apiType,
            _that.name,
            _that.url,
            _that.method,
            _that.responseStatus,
            _that.timeStamp);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String historyId,
            String requestId,
            APIType apiType,
            String name,
            String url,
            HTTPVerb method,
            int responseStatus,
            DateTime timeStamp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel():
        return $default(
            _that.historyId,
            _that.requestId,
            _that.apiType,
            _that.name,
            _that.url,
            _that.method,
            _that.responseStatus,
            _that.timeStamp);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String historyId,
            String requestId,
            APIType apiType,
            String name,
            String url,
            HTTPVerb method,
            int responseStatus,
            DateTime timeStamp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HistoryMetaModel() when $default != null:
        return $default(
            _that.historyId,
            _that.requestId,
            _that.apiType,
            _that.name,
            _that.url,
            _that.method,
            _that.responseStatus,
            _that.timeStamp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HistoryMetaModel implements HistoryMetaModel {
  const _HistoryMetaModel(
      {required this.historyId,
      required this.requestId,
      required this.apiType,
      this.name = "",
      required this.url,
      required this.method,
      required this.responseStatus,
      required this.timeStamp});
  factory _HistoryMetaModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryMetaModelFromJson(json);

  @override
  final String historyId;
  @override
  final String requestId;
  @override
  final APIType apiType;
  @override
  @JsonKey()
  final String name;
  @override
  final String url;
  @override
  final HTTPVerb method;
  @override
  final int responseStatus;
  @override
  final DateTime timeStamp;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HistoryMetaModelCopyWith<_HistoryMetaModel> get copyWith =>
      __$HistoryMetaModelCopyWithImpl<_HistoryMetaModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HistoryMetaModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HistoryMetaModel &&
            (identical(other.historyId, historyId) ||
                other.historyId == historyId) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.apiType, apiType) || other.apiType == apiType) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.responseStatus, responseStatus) ||
                other.responseStatus == responseStatus) &&
            (identical(other.timeStamp, timeStamp) ||
                other.timeStamp == timeStamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, historyId, requestId, apiType,
      name, url, method, responseStatus, timeStamp);

  @override
  String toString() {
    return 'HistoryMetaModel(historyId: $historyId, requestId: $requestId, apiType: $apiType, name: $name, url: $url, method: $method, responseStatus: $responseStatus, timeStamp: $timeStamp)';
  }
}

/// @nodoc
abstract mixin class _$HistoryMetaModelCopyWith<$Res>
    implements $HistoryMetaModelCopyWith<$Res> {
  factory _$HistoryMetaModelCopyWith(
          _HistoryMetaModel value, $Res Function(_HistoryMetaModel) _then) =
      __$HistoryMetaModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String historyId,
      String requestId,
      APIType apiType,
      String name,
      String url,
      HTTPVerb method,
      int responseStatus,
      DateTime timeStamp});
}

/// @nodoc
class __$HistoryMetaModelCopyWithImpl<$Res>
    implements _$HistoryMetaModelCopyWith<$Res> {
  __$HistoryMetaModelCopyWithImpl(this._self, this._then);

  final _HistoryMetaModel _self;
  final $Res Function(_HistoryMetaModel) _then;

  /// Create a copy of HistoryMetaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? historyId = null,
    Object? requestId = null,
    Object? apiType = null,
    Object? name = null,
    Object? url = null,
    Object? method = null,
    Object? responseStatus = null,
    Object? timeStamp = null,
  }) {
    return _then(_HistoryMetaModel(
      historyId: null == historyId
          ? _self.historyId
          : historyId // ignore: cast_nullable_to_non_nullable
              as String,
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      apiType: null == apiType
          ? _self.apiType
          : apiType // ignore: cast_nullable_to_non_nullable
              as APIType,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as HTTPVerb,
      responseStatus: null == responseStatus
          ? _self.responseStatus
          : responseStatus // ignore: cast_nullable_to_non_nullable
              as int,
      timeStamp: null == timeStamp
          ? _self.timeStamp
          : timeStamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
