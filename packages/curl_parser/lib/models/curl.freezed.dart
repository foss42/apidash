// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curl.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Curl {
  /// Specifies the HTTP request method (e.g., GET, POST, PUT, DELETE).
  String get method;

  /// Specifies the HTTP request URL.
  @UriJsonConverter()
  Uri get uri;

  /// Adds custom HTTP headers to the request.
  Map<String, String>? get headers;

  /// Sends data as the request body (typically used with POST requests).
  String? get data;

  /// Sends cookies with the request.
  String? get cookie;

  /// Specifies the username and password for HTTP basic authentication.
  String? get user;

  /// Sets the Referer header for the request.
  String? get referer;

  /// Sets the User-Agent header for the request.
  String? get userAgent;

  /// Sends data as a multipart/form-data request.
  bool get form;

  /// Form data list.
  List<FormDataModel>? get formData;

  /// Allows insecure SSL connections.
  bool get insecure;

  /// Follows HTTP redirects.
  bool get location;

  /// Create a copy of Curl
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CurlCopyWith<Curl> get copyWith =>
      _$CurlCopyWithImpl<Curl>(this as Curl, _$identity);

  /// Serializes this Curl to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Curl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            const DeepCollectionEquality().equals(other.headers, headers) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.cookie, cookie) || other.cookie == cookie) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.referer, referer) || other.referer == referer) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.form, form) || other.form == form) &&
            const DeepCollectionEquality().equals(other.formData, formData) &&
            (identical(other.insecure, insecure) ||
                other.insecure == insecure) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      uri,
      const DeepCollectionEquality().hash(headers),
      data,
      cookie,
      user,
      referer,
      userAgent,
      form,
      const DeepCollectionEquality().hash(formData),
      insecure,
      location);

  @override
  String toString() {
    return 'Curl(method: $method, uri: $uri, headers: $headers, data: $data, cookie: $cookie, user: $user, referer: $referer, userAgent: $userAgent, form: $form, formData: $formData, insecure: $insecure, location: $location)';
  }
}

/// @nodoc
abstract mixin class $CurlCopyWith<$Res> {
  factory $CurlCopyWith(Curl value, $Res Function(Curl) _then) =
      _$CurlCopyWithImpl;
  @useResult
  $Res call(
      {String method,
      @UriJsonConverter() Uri uri,
      Map<String, String>? headers,
      String? data,
      String? cookie,
      String? user,
      String? referer,
      String? userAgent,
      bool form,
      List<FormDataModel>? formData,
      bool insecure,
      bool location});
}

/// @nodoc
class _$CurlCopyWithImpl<$Res> implements $CurlCopyWith<$Res> {
  _$CurlCopyWithImpl(this._self, this._then);

  final Curl _self;
  final $Res Function(Curl) _then;

  /// Create a copy of Curl
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? uri = null,
    Object? headers = freezed,
    Object? data = freezed,
    Object? cookie = freezed,
    Object? user = freezed,
    Object? referer = freezed,
    Object? userAgent = freezed,
    Object? form = null,
    Object? formData = freezed,
    Object? insecure = null,
    Object? location = null,
  }) {
    return _then(_self.copyWith(
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      headers: freezed == headers
          ? _self.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      cookie: freezed == cookie
          ? _self.cookie
          : cookie // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      referer: freezed == referer
          ? _self.referer
          : referer // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _self.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      form: null == form
          ? _self.form
          : form // ignore: cast_nullable_to_non_nullable
              as bool,
      formData: freezed == formData
          ? _self.formData
          : formData // ignore: cast_nullable_to_non_nullable
              as List<FormDataModel>?,
      insecure: null == insecure
          ? _self.insecure
          : insecure // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Curl].
extension CurlPatterns on Curl {
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
    TResult Function(_Curl value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Curl() when $default != null:
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
    TResult Function(_Curl value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Curl():
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
    TResult? Function(_Curl value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Curl() when $default != null:
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
            String method,
            @UriJsonConverter() Uri uri,
            Map<String, String>? headers,
            String? data,
            String? cookie,
            String? user,
            String? referer,
            String? userAgent,
            bool form,
            List<FormDataModel>? formData,
            bool insecure,
            bool location)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Curl() when $default != null:
        return $default(
            _that.method,
            _that.uri,
            _that.headers,
            _that.data,
            _that.cookie,
            _that.user,
            _that.referer,
            _that.userAgent,
            _that.form,
            _that.formData,
            _that.insecure,
            _that.location);
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
            String method,
            @UriJsonConverter() Uri uri,
            Map<String, String>? headers,
            String? data,
            String? cookie,
            String? user,
            String? referer,
            String? userAgent,
            bool form,
            List<FormDataModel>? formData,
            bool insecure,
            bool location)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Curl():
        return $default(
            _that.method,
            _that.uri,
            _that.headers,
            _that.data,
            _that.cookie,
            _that.user,
            _that.referer,
            _that.userAgent,
            _that.form,
            _that.formData,
            _that.insecure,
            _that.location);
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
            String method,
            @UriJsonConverter() Uri uri,
            Map<String, String>? headers,
            String? data,
            String? cookie,
            String? user,
            String? referer,
            String? userAgent,
            bool form,
            List<FormDataModel>? formData,
            bool insecure,
            bool location)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Curl() when $default != null:
        return $default(
            _that.method,
            _that.uri,
            _that.headers,
            _that.data,
            _that.cookie,
            _that.user,
            _that.referer,
            _that.userAgent,
            _that.form,
            _that.formData,
            _that.insecure,
            _that.location);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Curl extends Curl {
  const _Curl(
      {required this.method,
      @UriJsonConverter() required this.uri,
      final Map<String, String>? headers,
      this.data,
      this.cookie,
      this.user,
      this.referer,
      this.userAgent,
      this.form = false,
      final List<FormDataModel>? formData,
      this.insecure = false,
      this.location = false})
      : _headers = headers,
        _formData = formData,
        super._();
  factory _Curl.fromJson(Map<String, dynamic> json) => _$CurlFromJson(json);

  /// Specifies the HTTP request method (e.g., GET, POST, PUT, DELETE).
  @override
  final String method;

  /// Specifies the HTTP request URL.
  @override
  @UriJsonConverter()
  final Uri uri;

  /// Adds custom HTTP headers to the request.
  final Map<String, String>? _headers;

  /// Adds custom HTTP headers to the request.
  @override
  Map<String, String>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Sends data as the request body (typically used with POST requests).
  @override
  final String? data;

  /// Sends cookies with the request.
  @override
  final String? cookie;

  /// Specifies the username and password for HTTP basic authentication.
  @override
  final String? user;

  /// Sets the Referer header for the request.
  @override
  final String? referer;

  /// Sets the User-Agent header for the request.
  @override
  final String? userAgent;

  /// Sends data as a multipart/form-data request.
  @override
  @JsonKey()
  final bool form;

  /// Form data list.
  final List<FormDataModel>? _formData;

  /// Form data list.
  @override
  List<FormDataModel>? get formData {
    final value = _formData;
    if (value == null) return null;
    if (_formData is EqualUnmodifiableListView) return _formData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Allows insecure SSL connections.
  @override
  @JsonKey()
  final bool insecure;

  /// Follows HTTP redirects.
  @override
  @JsonKey()
  final bool location;

  /// Create a copy of Curl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CurlCopyWith<_Curl> get copyWith =>
      __$CurlCopyWithImpl<_Curl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CurlToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Curl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.cookie, cookie) || other.cookie == cookie) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.referer, referer) || other.referer == referer) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.form, form) || other.form == form) &&
            const DeepCollectionEquality().equals(other._formData, _formData) &&
            (identical(other.insecure, insecure) ||
                other.insecure == insecure) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      uri,
      const DeepCollectionEquality().hash(_headers),
      data,
      cookie,
      user,
      referer,
      userAgent,
      form,
      const DeepCollectionEquality().hash(_formData),
      insecure,
      location);

  @override
  String toString() {
    return 'Curl(method: $method, uri: $uri, headers: $headers, data: $data, cookie: $cookie, user: $user, referer: $referer, userAgent: $userAgent, form: $form, formData: $formData, insecure: $insecure, location: $location)';
  }
}

/// @nodoc
abstract mixin class _$CurlCopyWith<$Res> implements $CurlCopyWith<$Res> {
  factory _$CurlCopyWith(_Curl value, $Res Function(_Curl) _then) =
      __$CurlCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String method,
      @UriJsonConverter() Uri uri,
      Map<String, String>? headers,
      String? data,
      String? cookie,
      String? user,
      String? referer,
      String? userAgent,
      bool form,
      List<FormDataModel>? formData,
      bool insecure,
      bool location});
}

/// @nodoc
class __$CurlCopyWithImpl<$Res> implements _$CurlCopyWith<$Res> {
  __$CurlCopyWithImpl(this._self, this._then);

  final _Curl _self;
  final $Res Function(_Curl) _then;

  /// Create a copy of Curl
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? method = null,
    Object? uri = null,
    Object? headers = freezed,
    Object? data = freezed,
    Object? cookie = freezed,
    Object? user = freezed,
    Object? referer = freezed,
    Object? userAgent = freezed,
    Object? form = null,
    Object? formData = freezed,
    Object? insecure = null,
    Object? location = null,
  }) {
    return _then(_Curl(
      method: null == method
          ? _self.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      headers: freezed == headers
          ? _self._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      cookie: freezed == cookie
          ? _self.cookie
          : cookie // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      referer: freezed == referer
          ? _self.referer
          : referer // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _self.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      form: null == form
          ? _self.form
          : form // ignore: cast_nullable_to_non_nullable
              as bool,
      formData: freezed == formData
          ? _self._formData
          : formData // ignore: cast_nullable_to_non_nullable
              as List<FormDataModel>?,
      insecure: null == insecure
          ? _self.insecure
          : insecure // ignore: cast_nullable_to_non_nullable
              as bool,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
