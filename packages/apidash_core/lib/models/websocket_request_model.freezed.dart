// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebSocketRequestModel {
  String get url;
  List<NameValueModel> get headers;
  List<NameValueModel> get params;
  List<WebSocketMessageModel> get messages;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WebSocketRequestModelCopyWith<WebSocketRequestModel> get copyWith =>
      _$WebSocketRequestModelCopyWithImpl<WebSocketRequestModel>(
          this as WebSocketRequestModel, _$identity);

  /// Serializes this WebSocketRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WebSocketRequestModel &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other.headers, headers) &&
            const DeepCollectionEquality().equals(other.params, params) &&
            const DeepCollectionEquality().equals(other.messages, messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      const DeepCollectionEquality().hash(headers),
      const DeepCollectionEquality().hash(params),
      const DeepCollectionEquality().hash(messages));

  @override
  String toString() {
    return 'WebSocketRequestModel(url: $url, headers: $headers, params: $params, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class $WebSocketRequestModelCopyWith<$Res> {
  factory $WebSocketRequestModelCopyWith(WebSocketRequestModel value,
          $Res Function(WebSocketRequestModel) _then) =
      _$WebSocketRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String url,
      List<NameValueModel> headers,
      List<NameValueModel> params,
      List<WebSocketMessageModel> messages});
}

/// @nodoc
class _$WebSocketRequestModelCopyWithImpl<$Res>
    implements $WebSocketRequestModelCopyWith<$Res> {
  _$WebSocketRequestModelCopyWithImpl(this._self, this._then);

  final WebSocketRequestModel _self;
  final $Res Function(WebSocketRequestModel) _then;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? headers = null,
    Object? params = null,
    Object? messages = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      params: null == params
          ? _self.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      messages: null == messages
          ? _self.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<WebSocketMessageModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WebSocketRequestModel].
extension WebSocketRequestModelPatterns on WebSocketRequestModel {
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
    TResult Function(_WebSocketRequestModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
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
    TResult Function(_WebSocketRequestModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel():
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
    TResult? Function(_WebSocketRequestModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
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
    TResult Function(String url, List<NameValueModel> headers,
            List<NameValueModel> params, List<WebSocketMessageModel> messages)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
        return $default(_that.url, _that.headers, _that.params, _that.messages);
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
    TResult Function(String url, List<NameValueModel> headers,
            List<NameValueModel> params, List<WebSocketMessageModel> messages)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel():
        return $default(_that.url, _that.headers, _that.params, _that.messages);
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
    TResult? Function(String url, List<NameValueModel> headers,
            List<NameValueModel> params, List<WebSocketMessageModel> messages)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
        return $default(_that.url, _that.headers, _that.params, _that.messages);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _WebSocketRequestModel implements WebSocketRequestModel {
  const _WebSocketRequestModel(
      {this.url = "",
      final List<NameValueModel> headers = const [],
      final List<NameValueModel> params = const [],
      final List<WebSocketMessageModel> messages = const []})
      : _headers = headers,
        _params = params,
        _messages = messages;
  factory _WebSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestModelFromJson(json);

  @override
  @JsonKey()
  final String url;
  final List<NameValueModel> _headers;
  @override
  @JsonKey()
  List<NameValueModel> get headers {
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_headers);
  }

  final List<NameValueModel> _params;
  @override
  @JsonKey()
  List<NameValueModel> get params {
    if (_params is EqualUnmodifiableListView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_params);
  }

  final List<WebSocketMessageModel> _messages;
  @override
  @JsonKey()
  List<WebSocketMessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WebSocketRequestModelCopyWith<_WebSocketRequestModel> get copyWith =>
      __$WebSocketRequestModelCopyWithImpl<_WebSocketRequestModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WebSocketRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WebSocketRequestModel &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_params),
      const DeepCollectionEquality().hash(_messages));

  @override
  String toString() {
    return 'WebSocketRequestModel(url: $url, headers: $headers, params: $params, messages: $messages)';
  }
}

/// @nodoc
abstract mixin class _$WebSocketRequestModelCopyWith<$Res>
    implements $WebSocketRequestModelCopyWith<$Res> {
  factory _$WebSocketRequestModelCopyWith(_WebSocketRequestModel value,
          $Res Function(_WebSocketRequestModel) _then) =
      __$WebSocketRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String url,
      List<NameValueModel> headers,
      List<NameValueModel> params,
      List<WebSocketMessageModel> messages});
}

/// @nodoc
class __$WebSocketRequestModelCopyWithImpl<$Res>
    implements _$WebSocketRequestModelCopyWith<$Res> {
  __$WebSocketRequestModelCopyWithImpl(this._self, this._then);

  final _WebSocketRequestModel _self;
  final $Res Function(_WebSocketRequestModel) _then;

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? headers = null,
    Object? params = null,
    Object? messages = null,
  }) {
    return _then(_WebSocketRequestModel(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      params: null == params
          ? _self._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>,
      messages: null == messages
          ? _self._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<WebSocketMessageModel>,
    ));
  }
}

/// @nodoc
mixin _$WebSocketMessageModel {
  String get message;
  DateTime get time;
  bool get isSent;

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
            (identical(other.message, message) || other.message == message) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isSent, isSent) || other.isSent == isSent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, time, isSent);

  @override
  String toString() {
    return 'WebSocketMessageModel(message: $message, time: $time, isSent: $isSent)';
  }
}

/// @nodoc
abstract mixin class $WebSocketMessageModelCopyWith<$Res> {
  factory $WebSocketMessageModelCopyWith(WebSocketMessageModel value,
          $Res Function(WebSocketMessageModel) _then) =
      _$WebSocketMessageModelCopyWithImpl;
  @useResult
  $Res call({String message, DateTime time, bool isSent});
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
    Object? message = null,
    Object? time = null,
    Object? isSent = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSent: null == isSent
          ? _self.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
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
    TResult Function(String message, DateTime time, bool isSent)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
        return $default(_that.message, _that.time, _that.isSent);
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
    TResult Function(String message, DateTime time, bool isSent) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel():
        return $default(_that.message, _that.time, _that.isSent);
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
    TResult? Function(String message, DateTime time, bool isSent)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketMessageModel() when $default != null:
        return $default(_that.message, _that.time, _that.isSent);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WebSocketMessageModel implements WebSocketMessageModel {
  const _WebSocketMessageModel(
      {required this.message, required this.time, required this.isSent});
  factory _WebSocketMessageModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageModelFromJson(json);

  @override
  final String message;
  @override
  final DateTime time;
  @override
  final bool isSent;

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
            (identical(other.message, message) || other.message == message) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.isSent, isSent) || other.isSent == isSent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, time, isSent);

  @override
  String toString() {
    return 'WebSocketMessageModel(message: $message, time: $time, isSent: $isSent)';
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
  $Res call({String message, DateTime time, bool isSent});
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
    Object? message = null,
    Object? time = null,
    Object? isSent = null,
  }) {
    return _then(_WebSocketMessageModel(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSent: null == isSent
          ? _self.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
