// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebSocketMessageModel {
  String get id;

  /// sent | received | connect | disconnect | error
  WebSocketMessageType get type;

  /// Raw message payload
  String? get payload;

  /// Timestamp
  DateTime? get timestamp;

  /// Optional metadata (status, reason, etc.)
  String? get message;

  /// Size in bytes (optional)
  int? get sizeBytes;

  /// Create a copy of WebSocketMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WebSocketMessageModelCopyWith<WebSocketMessageModel> get copyWith =>
      _$WebSocketMessageModelCopyWithImpl<WebSocketMessageModel>(
          this as WebSocketMessageModel, _$identity);

  /// Serializes this WebSocketMessageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WebSocketMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, payload, timestamp, message, sizeBytes);

  @override
  String toString() {
    return 'WebSocketMessageModel(id: $id, type: $type, payload: $payload, timestamp: $timestamp, message: $message, sizeBytes: $sizeBytes)';
  }
}

/// @nodoc
abstract mixin class $WebSocketMessageModelCopyWith<$Res> {
  factory $WebSocketMessageModelCopyWith(WebSocketMessageModel value,
          $Res Function(WebSocketMessageModel) _then) =
      _$WebSocketMessageModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      WebSocketMessageType type,
      String? payload,
      DateTime? timestamp,
      String? message,
      int? sizeBytes});
}

/// @nodoc
class _$WebSocketMessageModelCopyWithImpl<$Res>
    implements $WebSocketMessageModelCopyWith<$Res> {
  _$WebSocketMessageModelCopyWithImpl(this._self, this._then);

  final WebSocketMessageModel _self;
  final $Res Function(WebSocketMessageModel) _then;

  /// Create a copy of WebSocketMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? payload = freezed,
    Object? timestamp = freezed,
    Object? message = freezed,
    Object? sizeBytes = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as WebSocketMessageType,
      payload: freezed == payload
          ? _self.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeBytes: freezed == sizeBytes
          ? _self.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WebSocketMessageModel].
extension WebSocketMessageModelPatterns on WebSocketMessageModel {
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
    TResult Function(_WebSocketMessageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
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
    TResult Function(_WebSocketMessageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel():
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
    TResult? Function(_WebSocketMessageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
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
    TResult Function(String id, WebSocketMessageType type, String? payload,
            DateTime? timestamp, String? message, int? sizeBytes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
        return $default(_that.id, _that.type, _that.payload, _that.timestamp,
            _that.message, _that.sizeBytes);
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
    TResult Function(String id, WebSocketMessageType type, String? payload,
            DateTime? timestamp, String? message, int? sizeBytes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel():
        return $default(_that.id, _that.type, _that.payload, _that.timestamp,
            _that.message, _that.sizeBytes);
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
    TResult? Function(String id, WebSocketMessageType type, String? payload,
            DateTime? timestamp, String? message, int? sizeBytes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
        return $default(_that.id, _that.type, _that.payload, _that.timestamp,
            _that.message, _that.sizeBytes);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _WebSocketMessageModel implements WebSocketMessageModel {
  const _WebSocketMessageModel(
      {required this.id,
      this.type = WebSocketMessageType.info,
      this.payload,
      this.timestamp,
      this.message,
      this.sizeBytes});
  factory _WebSocketMessageModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageModelFromJson(json);

  @override
  final String id;

  /// sent | received | connect | disconnect | error
  @override
  @JsonKey()
  final WebSocketMessageType type;

  /// Raw message payload
  @override
  final String? payload;

  /// Timestamp
  @override
  final DateTime? timestamp;

  /// Optional metadata (status, reason, etc.)
  @override
  final String? message;

  /// Size in bytes (optional)
  @override
  final int? sizeBytes;

  /// Create a copy of WebSocketMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WebSocketMessageModelCopyWith<_WebSocketMessageModel> get copyWith =>
      __$WebSocketMessageModelCopyWithImpl<_WebSocketMessageModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WebSocketMessageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WebSocketMessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, type, payload, timestamp, message, sizeBytes);

  @override
  String toString() {
    return 'WebSocketMessageModel(id: $id, type: $type, payload: $payload, timestamp: $timestamp, message: $message, sizeBytes: $sizeBytes)';
  }
}

/// @nodoc
abstract mixin class _$WebSocketMessageModelCopyWith<$Res>
    implements $WebSocketMessageModelCopyWith<$Res> {
  factory _$WebSocketMessageModelCopyWith(_WebSocketMessageModel value,
          $Res Function(_WebSocketMessageModel) _then) =
      __$WebSocketMessageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      WebSocketMessageType type,
      String? payload,
      DateTime? timestamp,
      String? message,
      int? sizeBytes});
}

/// @nodoc
class __$WebSocketMessageModelCopyWithImpl<$Res>
    implements _$WebSocketMessageModelCopyWith<$Res> {
  __$WebSocketMessageModelCopyWithImpl(this._self, this._then);

  final _WebSocketMessageModel _self;
  final $Res Function(_WebSocketMessageModel) _then;

  /// Create a copy of WebSocketMessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? payload = freezed,
    Object? timestamp = freezed,
    Object? message = freezed,
    Object? sizeBytes = freezed,
  }) {
    return _then(_WebSocketMessageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as WebSocketMessageType,
      payload: freezed == payload
          ? _self.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sizeBytes: freezed == sizeBytes
          ? _self.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
