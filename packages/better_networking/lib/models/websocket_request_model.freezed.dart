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
  /// ws:// or wss:// URL
  String get url;

  /// Headers
  List<NameValueModel>? get headers;
  List<bool>? get isHeaderEnabledList;

  /// Query params
  List<NameValueModel>? get params;
  List<bool>? get isParamEnabledList;

  /// Auth (reuse HTTP auth model)
  AuthModel? get authModel;

  /// Optional initial payload (sent after connect)
  String? get initialMessage;

  /// Message content type (json / text)
  ContentType get messageContentType;

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
            const DeepCollectionEquality()
                .equals(other.isHeaderEnabledList, isHeaderEnabledList) &&
            const DeepCollectionEquality().equals(other.params, params) &&
            const DeepCollectionEquality()
                .equals(other.isParamEnabledList, isParamEnabledList) &&
            (identical(other.authModel, authModel) ||
                other.authModel == authModel) &&
            (identical(other.initialMessage, initialMessage) ||
                other.initialMessage == initialMessage) &&
            (identical(other.messageContentType, messageContentType) ||
                other.messageContentType == messageContentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      const DeepCollectionEquality().hash(headers),
      const DeepCollectionEquality().hash(isHeaderEnabledList),
      const DeepCollectionEquality().hash(params),
      const DeepCollectionEquality().hash(isParamEnabledList),
      authModel,
      initialMessage,
      messageContentType);

  @override
  String toString() {
    return 'WebSocketRequestModel(url: $url, headers: $headers, isHeaderEnabledList: $isHeaderEnabledList, params: $params, isParamEnabledList: $isParamEnabledList, authModel: $authModel, initialMessage: $initialMessage, messageContentType: $messageContentType)';
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
      List<NameValueModel>? headers,
      List<bool>? isHeaderEnabledList,
      List<NameValueModel>? params,
      List<bool>? isParamEnabledList,
      AuthModel? authModel,
      String? initialMessage,
      ContentType messageContentType});

  $AuthModelCopyWith<$Res>? get authModel;
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
    Object? headers = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? params = freezed,
    Object? isParamEnabledList = freezed,
    Object? authModel = freezed,
    Object? initialMessage = freezed,
    Object? messageContentType = null,
  }) {
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _self.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _self.isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      params: freezed == params
          ? _self.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _self.isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      authModel: freezed == authModel
          ? _self.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
      initialMessage: freezed == initialMessage
          ? _self.initialMessage
          : initialMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      messageContentType: null == messageContentType
          ? _self.messageContentType
          : messageContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
    ));
  }

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
      return null;
    }

    return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
      return _then(_self.copyWith(authModel: value));
    });
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
    TResult Function(
            String url,
            List<NameValueModel>? headers,
            List<bool>? isHeaderEnabledList,
            List<NameValueModel>? params,
            List<bool>? isParamEnabledList,
            AuthModel? authModel,
            String? initialMessage,
            ContentType messageContentType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
        return $default(
            _that.url,
            _that.headers,
            _that.isHeaderEnabledList,
            _that.params,
            _that.isParamEnabledList,
            _that.authModel,
            _that.initialMessage,
            _that.messageContentType);
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
            String url,
            List<NameValueModel>? headers,
            List<bool>? isHeaderEnabledList,
            List<NameValueModel>? params,
            List<bool>? isParamEnabledList,
            AuthModel? authModel,
            String? initialMessage,
            ContentType messageContentType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel():
        return $default(
            _that.url,
            _that.headers,
            _that.isHeaderEnabledList,
            _that.params,
            _that.isParamEnabledList,
            _that.authModel,
            _that.initialMessage,
            _that.messageContentType);
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
            String url,
            List<NameValueModel>? headers,
            List<bool>? isHeaderEnabledList,
            List<NameValueModel>? params,
            List<bool>? isParamEnabledList,
            AuthModel? authModel,
            String? initialMessage,
            ContentType messageContentType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WebSocketRequestModel() when $default != null:
        return $default(
            _that.url,
            _that.headers,
            _that.isHeaderEnabledList,
            _that.params,
            _that.isParamEnabledList,
            _that.authModel,
            _that.initialMessage,
            _that.messageContentType);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _WebSocketRequestModel extends WebSocketRequestModel {
  const _WebSocketRequestModel(
      {this.url = "",
      final List<NameValueModel>? headers,
      final List<bool>? isHeaderEnabledList,
      final List<NameValueModel>? params,
      final List<bool>? isParamEnabledList,
      this.authModel = const AuthModel(type: APIAuthType.none),
      this.initialMessage,
      this.messageContentType = ContentType.json})
      : _headers = headers,
        _isHeaderEnabledList = isHeaderEnabledList,
        _params = params,
        _isParamEnabledList = isParamEnabledList,
        super._();
  factory _WebSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestModelFromJson(json);

  /// ws:// or wss:// URL
  @override
  @JsonKey()
  final String url;

  /// Headers
  final List<NameValueModel>? _headers;

  /// Headers
  @override
  List<NameValueModel>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isHeaderEnabledList;
  @override
  List<bool>? get isHeaderEnabledList {
    final value = _isHeaderEnabledList;
    if (value == null) return null;
    if (_isHeaderEnabledList is EqualUnmodifiableListView)
      return _isHeaderEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Query params
  final List<NameValueModel>? _params;

  /// Query params
  @override
  List<NameValueModel>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableListView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<bool>? _isParamEnabledList;
  @override
  List<bool>? get isParamEnabledList {
    final value = _isParamEnabledList;
    if (value == null) return null;
    if (_isParamEnabledList is EqualUnmodifiableListView)
      return _isParamEnabledList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Auth (reuse HTTP auth model)
  @override
  @JsonKey()
  final AuthModel? authModel;

  /// Optional initial payload (sent after connect)
  @override
  final String? initialMessage;

  /// Message content type (json / text)
  @override
  @JsonKey()
  final ContentType messageContentType;

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
            const DeepCollectionEquality()
                .equals(other._isHeaderEnabledList, _isHeaderEnabledList) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality()
                .equals(other._isParamEnabledList, _isParamEnabledList) &&
            (identical(other.authModel, authModel) ||
                other.authModel == authModel) &&
            (identical(other.initialMessage, initialMessage) ||
                other.initialMessage == initialMessage) &&
            (identical(other.messageContentType, messageContentType) ||
                other.messageContentType == messageContentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      url,
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_isHeaderEnabledList),
      const DeepCollectionEquality().hash(_params),
      const DeepCollectionEquality().hash(_isParamEnabledList),
      authModel,
      initialMessage,
      messageContentType);

  @override
  String toString() {
    return 'WebSocketRequestModel(url: $url, headers: $headers, isHeaderEnabledList: $isHeaderEnabledList, params: $params, isParamEnabledList: $isParamEnabledList, authModel: $authModel, initialMessage: $initialMessage, messageContentType: $messageContentType)';
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
      List<NameValueModel>? headers,
      List<bool>? isHeaderEnabledList,
      List<NameValueModel>? params,
      List<bool>? isParamEnabledList,
      AuthModel? authModel,
      String? initialMessage,
      ContentType messageContentType});

  @override
  $AuthModelCopyWith<$Res>? get authModel;
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
    Object? headers = freezed,
    Object? isHeaderEnabledList = freezed,
    Object? params = freezed,
    Object? isParamEnabledList = freezed,
    Object? authModel = freezed,
    Object? initialMessage = freezed,
    Object? messageContentType = null,
  }) {
    return _then(_WebSocketRequestModel(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      headers: freezed == headers
          ? _self._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isHeaderEnabledList: freezed == isHeaderEnabledList
          ? _self._isHeaderEnabledList
          : isHeaderEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      params: freezed == params
          ? _self._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<NameValueModel>?,
      isParamEnabledList: freezed == isParamEnabledList
          ? _self._isParamEnabledList
          : isParamEnabledList // ignore: cast_nullable_to_non_nullable
              as List<bool>?,
      authModel: freezed == authModel
          ? _self.authModel
          : authModel // ignore: cast_nullable_to_non_nullable
              as AuthModel?,
      initialMessage: freezed == initialMessage
          ? _self.initialMessage
          : initialMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      messageContentType: null == messageContentType
          ? _self.messageContentType
          : messageContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
    ));
  }

  /// Create a copy of WebSocketRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthModelCopyWith<$Res>? get authModel {
    if (_self.authModel == null) {
      return null;
    }

    return $AuthModelCopyWith<$Res>(_self.authModel!, (value) {
      return _then(_self.copyWith(authModel: value));
    });
  }
}

// dart format on
