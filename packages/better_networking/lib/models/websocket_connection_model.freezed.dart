// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_connection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebSocketConnectionModel {
  bool get isConnecting;
  bool get isConnected;
  bool get isClosed;
  DateTime? get connectedAt;
  DateTime? get disconnectedAt;
  List<WebSocketMessageModel> get messages;

  /// Create a copy of WebSocketConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WebSocketConnectionModelCopyWith<WebSocketConnectionModel> get copyWith =>
      _$WebSocketConnectionModelCopyWithImpl<WebSocketConnectionModel>(
          this as WebSocketConnectionModel, _$identity);

  /// Serializes this WebSocketConnectionModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WebSocketConnectionModel &&
            (identical(other.isConnecting, isConnecting) ||
                other.isConnecting == isConnecting) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.disconnectedAt, disconnectedAt) ||
                other.disconnectedAt == disconnectedAt) &&
            const DeepCollectionEquality().equals(other.messages, messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isConnecting,
      isConnected,
      isClosed,
      connectedAt,
      disconnectedAt,
      const DeepCollectionEquality().hash(messages));

  @override
  String toString() {
    return 'WebSocketConnectionModel(isConnecting: $isConnecting, isConnected: $isConnected, isClosed: $isClosed, connectedAt: $connectedAt, disconnectedAt: $disconnectedAt, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $WebSocketConnectionModelCopyWith<$Res> {
  factory $WebSocketConnectionModelCopyWith(WebSocketConnectionModel value,
          $Res Function(WebSocketConnectionModel) _then) =
      _$WebSocketConnectionModelCopyWithImpl;
  @useResult
  $Res call(
      {bool isConnecting,
      bool isConnected,
      bool isClosed,
      DateTime? connectedAt,
      DateTime? disconnectedAt,
      List<WebSocketMessageModel> messages});
}

/// @nodoc
class _$WebSocketConnectionModelCopyWithImpl<$Res>
    implements $WebSocketConnectionModelCopyWith<$Res> {
  _$WebSocketConnectionModelCopyWithImpl(this._self, this._then);

  final WebSocketConnectionModel _self;
  final $Res Function(WebSocketConnectionModel) _then;

  /// Create a copy of WebSocketConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isConnecting = null,
    Object? isConnected = null,
    Object? isClosed = null,
    Object? connectedAt = freezed,
    Object? disconnectedAt = freezed,
    Object? messages = null,
  }) {
    return _then(_self.copyWith(
      isConnecting: null == isConnecting
          ? _self.isConnecting
          : isConnecting // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _self.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosed: null == isClosed
          ? _self.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      connectedAt: freezed == connectedAt
          ? _self.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disconnectedAt: freezed == disconnectedAt
          ? _self.disconnectedAt
          : disconnectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<WebSocketMessageModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WebSocketConnectionModel].
extension WebSocketConnectionModelPatterns on WebSocketConnectionModel {
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
    TResult Function(_WebSocketConnectionModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel() when $default != null:
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
    TResult Function(_WebSocketConnectionModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel():
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
    TResult? Function(_WebSocketConnectionModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel() when $default != null:
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
            bool isConnecting,
            bool isConnected,
            bool isClosed,
            DateTime? connectedAt,
            DateTime? disconnectedAt,
            List<WebSocketMessageModel> messages)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel() when $default != null:
        return $default(_that.isConnecting, _that.isConnected, _that.isClosed,
            _that.connectedAt, _that.disconnectedAt, _that.messages);
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
            bool isConnecting,
            bool isConnected,
            bool isClosed,
            DateTime? connectedAt,
            DateTime? disconnectedAt,
            List<WebSocketMessageModel> messages)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel():
        return $default(_that.isConnecting, _that.isConnected, _that.isClosed,
            _that.connectedAt, _that.disconnectedAt, _that.messages);
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
            bool isConnecting,
            bool isConnected,
            bool isClosed,
            DateTime? connectedAt,
            DateTime? disconnectedAt,
            List<WebSocketMessageModel> messages)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketConnectionModel() when $default != null:
        return $default(_that.isConnecting, _that.isConnected, _that.isClosed,
            _that.connectedAt, _that.disconnectedAt, _that.messages);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _WebSocketConnectionModel implements WebSocketConnectionModel {
  const _WebSocketConnectionModel(
      {this.isConnecting = false,
      this.isConnected = false,
      this.isClosed = false,
      this.connectedAt,
      this.disconnectedAt,
      final List<WebSocketMessageModel> messages =
          const <WebSocketMessageModel>[]})
      : _messages = messages;
  factory _WebSocketConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketConnectionModelFromJson(json);

  @override
  @JsonKey()
  final bool isConnecting;
  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final bool isClosed;
  @override
  final DateTime? connectedAt;
  @override
  final DateTime? disconnectedAt;
  final List<WebSocketMessageModel> _messages;
  @override
  @JsonKey()
  List<WebSocketMessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Create a copy of WebSocketConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WebSocketConnectionModelCopyWith<_WebSocketConnectionModel> get copyWith =>
      __$WebSocketConnectionModelCopyWithImpl<_WebSocketConnectionModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WebSocketConnectionModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WebSocketConnectionModel &&
            (identical(other.isConnecting, isConnecting) ||
                other.isConnecting == isConnecting) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.disconnectedAt, disconnectedAt) ||
                other.disconnectedAt == disconnectedAt) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isConnecting,
      isConnected,
      isClosed,
      connectedAt,
      disconnectedAt,
      const DeepCollectionEquality().hash(_messages));

  @override
  String toString() {
    return 'WebSocketConnectionModel(isConnecting: $isConnecting, isConnected: $isConnected, isClosed: $isClosed, connectedAt: $connectedAt, disconnectedAt: $disconnectedAt, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class _$WebSocketConnectionModelCopyWith<$Res>
    implements $WebSocketConnectionModelCopyWith<$Res> {
  factory _$WebSocketConnectionModelCopyWith(_WebSocketConnectionModel value,
          $Res Function(_WebSocketConnectionModel) _then) =
      __$WebSocketConnectionModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isConnecting,
      bool isConnected,
      bool isClosed,
      DateTime? connectedAt,
      DateTime? disconnectedAt,
      List<WebSocketMessageModel> messages});
}

/// @nodoc
class __$WebSocketConnectionModelCopyWithImpl<$Res>
    implements _$WebSocketConnectionModelCopyWith<$Res> {
  __$WebSocketConnectionModelCopyWithImpl(this._self, this._then);

  final _WebSocketConnectionModel _self;
  final $Res Function(_WebSocketConnectionModel) _then;

  /// Create a copy of WebSocketConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isConnecting = null,
    Object? isConnected = null,
    Object? isClosed = null,
    Object? connectedAt = freezed,
    Object? disconnectedAt = freezed,
    Object? messages = null,
  }) {
    return _then(_WebSocketConnectionModel(
      isConnecting: null == isConnecting
          ? _self.isConnecting
          : isConnecting // ignore: cast_nullable_to_non_nullable
              as bool,
      isConnected: null == isConnected
          ? _self.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isClosed: null == isClosed
          ? _self.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      connectedAt: freezed == connectedAt
          ? _self.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      disconnectedAt: freezed == disconnectedAt
          ? _self.disconnectedAt
          : disconnectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<WebSocketMessageModel>,
    ));
  }
}

// dart format on
