// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestOptions _$RequestOptionsFromJson(Map<String, dynamic> json) {
  return _RequestOptions.fromJson(json);
}

/// @nodoc
mixin _$RequestOptions {
  String? get awsSigv4 => throw _privateConstructorUsedError;
  String? get cacert => throw _privateConstructorUsedError;
  String? get cert => throw _privateConstructorUsedError;
  String? get key => throw _privateConstructorUsedError;
  bool? get compressed => throw _privateConstructorUsedError;
  String? get connectTimeout => throw _privateConstructorUsedError;
  String? get delay => throw _privateConstructorUsedError;
  bool? get http3 => throw _privateConstructorUsedError;
  bool? get insecure => throw _privateConstructorUsedError;
  bool? get ipv6 => throw _privateConstructorUsedError;
  int? get limitRate => throw _privateConstructorUsedError;
  bool? get location => throw _privateConstructorUsedError;
  int? get maxRedirs => throw _privateConstructorUsedError;
  String? get output => throw _privateConstructorUsedError;
  bool? get pathAsIs => throw _privateConstructorUsedError;
  int? get retry => throw _privateConstructorUsedError;
  String? get retryInterval => throw _privateConstructorUsedError;
  bool? get skip => throw _privateConstructorUsedError;
  String? get unixSocket => throw _privateConstructorUsedError;
  String? get user => throw _privateConstructorUsedError;
  String? get proxy => throw _privateConstructorUsedError;
  Map<String, String>? get variables => throw _privateConstructorUsedError;
  bool? get verbose => throw _privateConstructorUsedError;
  bool? get veryVerbose => throw _privateConstructorUsedError;

  /// Serializes this RequestOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestOptionsCopyWith<RequestOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestOptionsCopyWith<$Res> {
  factory $RequestOptionsCopyWith(
          RequestOptions value, $Res Function(RequestOptions) then) =
      _$RequestOptionsCopyWithImpl<$Res, RequestOptions>;
  @useResult
  $Res call(
      {String? awsSigv4,
      String? cacert,
      String? cert,
      String? key,
      bool? compressed,
      String? connectTimeout,
      String? delay,
      bool? http3,
      bool? insecure,
      bool? ipv6,
      int? limitRate,
      bool? location,
      int? maxRedirs,
      String? output,
      bool? pathAsIs,
      int? retry,
      String? retryInterval,
      bool? skip,
      String? unixSocket,
      String? user,
      String? proxy,
      Map<String, String>? variables,
      bool? verbose,
      bool? veryVerbose});
}

/// @nodoc
class _$RequestOptionsCopyWithImpl<$Res, $Val extends RequestOptions>
    implements $RequestOptionsCopyWith<$Res> {
  _$RequestOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awsSigv4 = freezed,
    Object? cacert = freezed,
    Object? cert = freezed,
    Object? key = freezed,
    Object? compressed = freezed,
    Object? connectTimeout = freezed,
    Object? delay = freezed,
    Object? http3 = freezed,
    Object? insecure = freezed,
    Object? ipv6 = freezed,
    Object? limitRate = freezed,
    Object? location = freezed,
    Object? maxRedirs = freezed,
    Object? output = freezed,
    Object? pathAsIs = freezed,
    Object? retry = freezed,
    Object? retryInterval = freezed,
    Object? skip = freezed,
    Object? unixSocket = freezed,
    Object? user = freezed,
    Object? proxy = freezed,
    Object? variables = freezed,
    Object? verbose = freezed,
    Object? veryVerbose = freezed,
  }) {
    return _then(_value.copyWith(
      awsSigv4: freezed == awsSigv4
          ? _value.awsSigv4
          : awsSigv4 // ignore: cast_nullable_to_non_nullable
              as String?,
      cacert: freezed == cacert
          ? _value.cacert
          : cacert // ignore: cast_nullable_to_non_nullable
              as String?,
      cert: freezed == cert
          ? _value.cert
          : cert // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      compressed: freezed == compressed
          ? _value.compressed
          : compressed // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectTimeout: freezed == connectTimeout
          ? _value.connectTimeout
          : connectTimeout // ignore: cast_nullable_to_non_nullable
              as String?,
      delay: freezed == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as String?,
      http3: freezed == http3
          ? _value.http3
          : http3 // ignore: cast_nullable_to_non_nullable
              as bool?,
      insecure: freezed == insecure
          ? _value.insecure
          : insecure // ignore: cast_nullable_to_non_nullable
              as bool?,
      ipv6: freezed == ipv6
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as bool?,
      limitRate: freezed == limitRate
          ? _value.limitRate
          : limitRate // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirs: freezed == maxRedirs
          ? _value.maxRedirs
          : maxRedirs // ignore: cast_nullable_to_non_nullable
              as int?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      pathAsIs: freezed == pathAsIs
          ? _value.pathAsIs
          : pathAsIs // ignore: cast_nullable_to_non_nullable
              as bool?,
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int?,
      retryInterval: freezed == retryInterval
          ? _value.retryInterval
          : retryInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      skip: freezed == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool?,
      unixSocket: freezed == unixSocket
          ? _value.unixSocket
          : unixSocket // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      proxy: freezed == proxy
          ? _value.proxy
          : proxy // ignore: cast_nullable_to_non_nullable
              as String?,
      variables: freezed == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      verbose: freezed == verbose
          ? _value.verbose
          : verbose // ignore: cast_nullable_to_non_nullable
              as bool?,
      veryVerbose: freezed == veryVerbose
          ? _value.veryVerbose
          : veryVerbose // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestOptionsImplCopyWith<$Res>
    implements $RequestOptionsCopyWith<$Res> {
  factory _$$RequestOptionsImplCopyWith(_$RequestOptionsImpl value,
          $Res Function(_$RequestOptionsImpl) then) =
      __$$RequestOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? awsSigv4,
      String? cacert,
      String? cert,
      String? key,
      bool? compressed,
      String? connectTimeout,
      String? delay,
      bool? http3,
      bool? insecure,
      bool? ipv6,
      int? limitRate,
      bool? location,
      int? maxRedirs,
      String? output,
      bool? pathAsIs,
      int? retry,
      String? retryInterval,
      bool? skip,
      String? unixSocket,
      String? user,
      String? proxy,
      Map<String, String>? variables,
      bool? verbose,
      bool? veryVerbose});
}

/// @nodoc
class __$$RequestOptionsImplCopyWithImpl<$Res>
    extends _$RequestOptionsCopyWithImpl<$Res, _$RequestOptionsImpl>
    implements _$$RequestOptionsImplCopyWith<$Res> {
  __$$RequestOptionsImplCopyWithImpl(
      _$RequestOptionsImpl _value, $Res Function(_$RequestOptionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awsSigv4 = freezed,
    Object? cacert = freezed,
    Object? cert = freezed,
    Object? key = freezed,
    Object? compressed = freezed,
    Object? connectTimeout = freezed,
    Object? delay = freezed,
    Object? http3 = freezed,
    Object? insecure = freezed,
    Object? ipv6 = freezed,
    Object? limitRate = freezed,
    Object? location = freezed,
    Object? maxRedirs = freezed,
    Object? output = freezed,
    Object? pathAsIs = freezed,
    Object? retry = freezed,
    Object? retryInterval = freezed,
    Object? skip = freezed,
    Object? unixSocket = freezed,
    Object? user = freezed,
    Object? proxy = freezed,
    Object? variables = freezed,
    Object? verbose = freezed,
    Object? veryVerbose = freezed,
  }) {
    return _then(_$RequestOptionsImpl(
      awsSigv4: freezed == awsSigv4
          ? _value.awsSigv4
          : awsSigv4 // ignore: cast_nullable_to_non_nullable
              as String?,
      cacert: freezed == cacert
          ? _value.cacert
          : cacert // ignore: cast_nullable_to_non_nullable
              as String?,
      cert: freezed == cert
          ? _value.cert
          : cert // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      compressed: freezed == compressed
          ? _value.compressed
          : compressed // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectTimeout: freezed == connectTimeout
          ? _value.connectTimeout
          : connectTimeout // ignore: cast_nullable_to_non_nullable
              as String?,
      delay: freezed == delay
          ? _value.delay
          : delay // ignore: cast_nullable_to_non_nullable
              as String?,
      http3: freezed == http3
          ? _value.http3
          : http3 // ignore: cast_nullable_to_non_nullable
              as bool?,
      insecure: freezed == insecure
          ? _value.insecure
          : insecure // ignore: cast_nullable_to_non_nullable
              as bool?,
      ipv6: freezed == ipv6
          ? _value.ipv6
          : ipv6 // ignore: cast_nullable_to_non_nullable
              as bool?,
      limitRate: freezed == limitRate
          ? _value.limitRate
          : limitRate // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxRedirs: freezed == maxRedirs
          ? _value.maxRedirs
          : maxRedirs // ignore: cast_nullable_to_non_nullable
              as int?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      pathAsIs: freezed == pathAsIs
          ? _value.pathAsIs
          : pathAsIs // ignore: cast_nullable_to_non_nullable
              as bool?,
      retry: freezed == retry
          ? _value.retry
          : retry // ignore: cast_nullable_to_non_nullable
              as int?,
      retryInterval: freezed == retryInterval
          ? _value.retryInterval
          : retryInterval // ignore: cast_nullable_to_non_nullable
              as String?,
      skip: freezed == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool?,
      unixSocket: freezed == unixSocket
          ? _value.unixSocket
          : unixSocket // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as String?,
      proxy: freezed == proxy
          ? _value.proxy
          : proxy // ignore: cast_nullable_to_non_nullable
              as String?,
      variables: freezed == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      verbose: freezed == verbose
          ? _value.verbose
          : verbose // ignore: cast_nullable_to_non_nullable
              as bool?,
      veryVerbose: freezed == veryVerbose
          ? _value.veryVerbose
          : veryVerbose // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestOptionsImpl implements _RequestOptions {
  const _$RequestOptionsImpl(
      {this.awsSigv4,
      this.cacert,
      this.cert,
      this.key,
      this.compressed,
      this.connectTimeout,
      this.delay,
      this.http3,
      this.insecure,
      this.ipv6,
      this.limitRate,
      this.location,
      this.maxRedirs,
      this.output,
      this.pathAsIs,
      this.retry,
      this.retryInterval,
      this.skip,
      this.unixSocket,
      this.user,
      this.proxy,
      final Map<String, String>? variables,
      this.verbose,
      this.veryVerbose})
      : _variables = variables;

  factory _$RequestOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestOptionsImplFromJson(json);

  @override
  final String? awsSigv4;
  @override
  final String? cacert;
  @override
  final String? cert;
  @override
  final String? key;
  @override
  final bool? compressed;
  @override
  final String? connectTimeout;
  @override
  final String? delay;
  @override
  final bool? http3;
  @override
  final bool? insecure;
  @override
  final bool? ipv6;
  @override
  final int? limitRate;
  @override
  final bool? location;
  @override
  final int? maxRedirs;
  @override
  final String? output;
  @override
  final bool? pathAsIs;
  @override
  final int? retry;
  @override
  final String? retryInterval;
  @override
  final bool? skip;
  @override
  final String? unixSocket;
  @override
  final String? user;
  @override
  final String? proxy;
  final Map<String, String>? _variables;
  @override
  Map<String, String>? get variables {
    final value = _variables;
    if (value == null) return null;
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? verbose;
  @override
  final bool? veryVerbose;

  @override
  String toString() {
    return 'RequestOptions(awsSigv4: $awsSigv4, cacert: $cacert, cert: $cert, key: $key, compressed: $compressed, connectTimeout: $connectTimeout, delay: $delay, http3: $http3, insecure: $insecure, ipv6: $ipv6, limitRate: $limitRate, location: $location, maxRedirs: $maxRedirs, output: $output, pathAsIs: $pathAsIs, retry: $retry, retryInterval: $retryInterval, skip: $skip, unixSocket: $unixSocket, user: $user, proxy: $proxy, variables: $variables, verbose: $verbose, veryVerbose: $veryVerbose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestOptionsImpl &&
            (identical(other.awsSigv4, awsSigv4) ||
                other.awsSigv4 == awsSigv4) &&
            (identical(other.cacert, cacert) || other.cacert == cacert) &&
            (identical(other.cert, cert) || other.cert == cert) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.compressed, compressed) ||
                other.compressed == compressed) &&
            (identical(other.connectTimeout, connectTimeout) ||
                other.connectTimeout == connectTimeout) &&
            (identical(other.delay, delay) || other.delay == delay) &&
            (identical(other.http3, http3) || other.http3 == http3) &&
            (identical(other.insecure, insecure) ||
                other.insecure == insecure) &&
            (identical(other.ipv6, ipv6) || other.ipv6 == ipv6) &&
            (identical(other.limitRate, limitRate) ||
                other.limitRate == limitRate) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.maxRedirs, maxRedirs) ||
                other.maxRedirs == maxRedirs) &&
            (identical(other.output, output) || other.output == output) &&
            (identical(other.pathAsIs, pathAsIs) ||
                other.pathAsIs == pathAsIs) &&
            (identical(other.retry, retry) || other.retry == retry) &&
            (identical(other.retryInterval, retryInterval) ||
                other.retryInterval == retryInterval) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.unixSocket, unixSocket) ||
                other.unixSocket == unixSocket) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.proxy, proxy) || other.proxy == proxy) &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables) &&
            (identical(other.verbose, verbose) || other.verbose == verbose) &&
            (identical(other.veryVerbose, veryVerbose) ||
                other.veryVerbose == veryVerbose));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        awsSigv4,
        cacert,
        cert,
        key,
        compressed,
        connectTimeout,
        delay,
        http3,
        insecure,
        ipv6,
        limitRate,
        location,
        maxRedirs,
        output,
        pathAsIs,
        retry,
        retryInterval,
        skip,
        unixSocket,
        user,
        proxy,
        const DeepCollectionEquality().hash(_variables),
        verbose,
        veryVerbose
      ]);

  /// Create a copy of RequestOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestOptionsImplCopyWith<_$RequestOptionsImpl> get copyWith =>
      __$$RequestOptionsImplCopyWithImpl<_$RequestOptionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestOptionsImplToJson(
      this,
    );
  }
}

abstract class _RequestOptions implements RequestOptions {
  const factory _RequestOptions(
      {final String? awsSigv4,
      final String? cacert,
      final String? cert,
      final String? key,
      final bool? compressed,
      final String? connectTimeout,
      final String? delay,
      final bool? http3,
      final bool? insecure,
      final bool? ipv6,
      final int? limitRate,
      final bool? location,
      final int? maxRedirs,
      final String? output,
      final bool? pathAsIs,
      final int? retry,
      final String? retryInterval,
      final bool? skip,
      final String? unixSocket,
      final String? user,
      final String? proxy,
      final Map<String, String>? variables,
      final bool? verbose,
      final bool? veryVerbose}) = _$RequestOptionsImpl;

  factory _RequestOptions.fromJson(Map<String, dynamic> json) =
      _$RequestOptionsImpl.fromJson;

  @override
  String? get awsSigv4;
  @override
  String? get cacert;
  @override
  String? get cert;
  @override
  String? get key;
  @override
  bool? get compressed;
  @override
  String? get connectTimeout;
  @override
  String? get delay;
  @override
  bool? get http3;
  @override
  bool? get insecure;
  @override
  bool? get ipv6;
  @override
  int? get limitRate;
  @override
  bool? get location;
  @override
  int? get maxRedirs;
  @override
  String? get output;
  @override
  bool? get pathAsIs;
  @override
  int? get retry;
  @override
  String? get retryInterval;
  @override
  bool? get skip;
  @override
  String? get unixSocket;
  @override
  String? get user;
  @override
  String? get proxy;
  @override
  Map<String, String>? get variables;
  @override
  bool? get verbose;
  @override
  bool? get veryVerbose;

  /// Create a copy of RequestOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestOptionsImplCopyWith<_$RequestOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
