// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'har_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HarLog _$HarLogFromJson(Map<String, dynamic> json) {
  return _HarLog.fromJson(json);
}

/// @nodoc
mixin _$HarLog {
  Log? get log => throw _privateConstructorUsedError;

  /// Serializes this HarLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HarLogCopyWith<HarLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HarLogCopyWith<$Res> {
  factory $HarLogCopyWith(HarLog value, $Res Function(HarLog) then) =
      _$HarLogCopyWithImpl<$Res, HarLog>;
  @useResult
  $Res call({Log? log});

  $LogCopyWith<$Res>? get log;
}

/// @nodoc
class _$HarLogCopyWithImpl<$Res, $Val extends HarLog>
    implements $HarLogCopyWith<$Res> {
  _$HarLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(_value.copyWith(
      log: freezed == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as Log?,
    ) as $Val);
  }

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogCopyWith<$Res>? get log {
    if (_value.log == null) {
      return null;
    }

    return $LogCopyWith<$Res>(_value.log!, (value) {
      return _then(_value.copyWith(log: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HarLogImplCopyWith<$Res> implements $HarLogCopyWith<$Res> {
  factory _$$HarLogImplCopyWith(
          _$HarLogImpl value, $Res Function(_$HarLogImpl) then) =
      __$$HarLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Log? log});

  @override
  $LogCopyWith<$Res>? get log;
}

/// @nodoc
class __$$HarLogImplCopyWithImpl<$Res>
    extends _$HarLogCopyWithImpl<$Res, _$HarLogImpl>
    implements _$$HarLogImplCopyWith<$Res> {
  __$$HarLogImplCopyWithImpl(
      _$HarLogImpl _value, $Res Function(_$HarLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(_$HarLogImpl(
      log: freezed == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as Log?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$HarLogImpl implements _HarLog {
  const _$HarLogImpl({this.log});

  factory _$HarLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$HarLogImplFromJson(json);

  @override
  final Log? log;

  @override
  String toString() {
    return 'HarLog(log: $log)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HarLogImpl &&
            (identical(other.log, log) || other.log == log));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, log);

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HarLogImplCopyWith<_$HarLogImpl> get copyWith =>
      __$$HarLogImplCopyWithImpl<_$HarLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HarLogImplToJson(
      this,
    );
  }
}

abstract class _HarLog implements HarLog {
  const factory _HarLog({final Log? log}) = _$HarLogImpl;

  factory _HarLog.fromJson(Map<String, dynamic> json) = _$HarLogImpl.fromJson;

  @override
  Log? get log;

  /// Create a copy of HarLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HarLogImplCopyWith<_$HarLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Log _$LogFromJson(Map<String, dynamic> json) {
  return _Log.fromJson(json);
}

/// @nodoc
mixin _$Log {
  String? get version => throw _privateConstructorUsedError;
  Creator? get creator => throw _privateConstructorUsedError;
  List<Entry>? get entries => throw _privateConstructorUsedError;

  /// Serializes this Log to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogCopyWith<Log> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogCopyWith<$Res> {
  factory $LogCopyWith(Log value, $Res Function(Log) then) =
      _$LogCopyWithImpl<$Res, Log>;
  @useResult
  $Res call({String? version, Creator? creator, List<Entry>? entries});

  $CreatorCopyWith<$Res>? get creator;
}

/// @nodoc
class _$LogCopyWithImpl<$Res, $Val extends Log> implements $LogCopyWith<$Res> {
  _$LogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? creator = freezed,
    Object? entries = freezed,
  }) {
    return _then(_value.copyWith(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as Creator?,
      entries: freezed == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<Entry>?,
    ) as $Val);
  }

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreatorCopyWith<$Res>? get creator {
    if (_value.creator == null) {
      return null;
    }

    return $CreatorCopyWith<$Res>(_value.creator!, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LogImplCopyWith<$Res> implements $LogCopyWith<$Res> {
  factory _$$LogImplCopyWith(_$LogImpl value, $Res Function(_$LogImpl) then) =
      __$$LogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? version, Creator? creator, List<Entry>? entries});

  @override
  $CreatorCopyWith<$Res>? get creator;
}

/// @nodoc
class __$$LogImplCopyWithImpl<$Res> extends _$LogCopyWithImpl<$Res, _$LogImpl>
    implements _$$LogImplCopyWith<$Res> {
  __$$LogImplCopyWithImpl(_$LogImpl _value, $Res Function(_$LogImpl) _then)
      : super(_value, _then);

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? creator = freezed,
    Object? entries = freezed,
  }) {
    return _then(_$LogImpl(
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as Creator?,
      entries: freezed == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<Entry>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$LogImpl implements _Log {
  const _$LogImpl({this.version, this.creator, final List<Entry>? entries})
      : _entries = entries;

  factory _$LogImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogImplFromJson(json);

  @override
  final String? version;
  @override
  final Creator? creator;
  final List<Entry>? _entries;
  @override
  List<Entry>? get entries {
    final value = _entries;
    if (value == null) return null;
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Log(version: $version, creator: $creator, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            const DeepCollectionEquality().equals(other._entries, _entries));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, creator,
      const DeepCollectionEquality().hash(_entries));

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogImplCopyWith<_$LogImpl> get copyWith =>
      __$$LogImplCopyWithImpl<_$LogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogImplToJson(
      this,
    );
  }
}

abstract class _Log implements Log {
  const factory _Log(
      {final String? version,
      final Creator? creator,
      final List<Entry>? entries}) = _$LogImpl;

  factory _Log.fromJson(Map<String, dynamic> json) = _$LogImpl.fromJson;

  @override
  String? get version;
  @override
  Creator? get creator;
  @override
  List<Entry>? get entries;

  /// Create a copy of Log
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogImplCopyWith<_$LogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Creator _$CreatorFromJson(Map<String, dynamic> json) {
  return _Creator.fromJson(json);
}

/// @nodoc
mixin _$Creator {
  String? get name => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;

  /// Serializes this Creator to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Creator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatorCopyWith<Creator> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatorCopyWith<$Res> {
  factory $CreatorCopyWith(Creator value, $Res Function(Creator) then) =
      _$CreatorCopyWithImpl<$Res, Creator>;
  @useResult
  $Res call({String? name, String? version});
}

/// @nodoc
class _$CreatorCopyWithImpl<$Res, $Val extends Creator>
    implements $CreatorCopyWith<$Res> {
  _$CreatorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Creator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? version = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatorImplCopyWith<$Res> implements $CreatorCopyWith<$Res> {
  factory _$$CreatorImplCopyWith(
          _$CreatorImpl value, $Res Function(_$CreatorImpl) then) =
      __$$CreatorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? version});
}

/// @nodoc
class __$$CreatorImplCopyWithImpl<$Res>
    extends _$CreatorCopyWithImpl<$Res, _$CreatorImpl>
    implements _$$CreatorImplCopyWith<$Res> {
  __$$CreatorImplCopyWithImpl(
      _$CreatorImpl _value, $Res Function(_$CreatorImpl) _then)
      : super(_value, _then);

  /// Create a copy of Creator
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? version = freezed,
  }) {
    return _then(_$CreatorImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$CreatorImpl implements _Creator {
  const _$CreatorImpl({this.name, this.version});

  factory _$CreatorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatorImplFromJson(json);

  @override
  final String? name;
  @override
  final String? version;

  @override
  String toString() {
    return 'Creator(name: $name, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatorImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, version);

  /// Create a copy of Creator
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatorImplCopyWith<_$CreatorImpl> get copyWith =>
      __$$CreatorImplCopyWithImpl<_$CreatorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatorImplToJson(
      this,
    );
  }
}

abstract class _Creator implements Creator {
  const factory _Creator({final String? name, final String? version}) =
      _$CreatorImpl;

  factory _Creator.fromJson(Map<String, dynamic> json) = _$CreatorImpl.fromJson;

  @override
  String? get name;
  @override
  String? get version;

  /// Create a copy of Creator
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatorImplCopyWith<_$CreatorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return _Entry.fromJson(json);
}

/// @nodoc
mixin _$Entry {
  String? get startedDateTime => throw _privateConstructorUsedError;
  int? get time => throw _privateConstructorUsedError;
  Request? get request => throw _privateConstructorUsedError;
  Response? get response => throw _privateConstructorUsedError;

  /// Serializes this Entry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EntryCopyWith<Entry> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntryCopyWith<$Res> {
  factory $EntryCopyWith(Entry value, $Res Function(Entry) then) =
      _$EntryCopyWithImpl<$Res, Entry>;
  @useResult
  $Res call(
      {String? startedDateTime,
      int? time,
      Request? request,
      Response? response});

  $RequestCopyWith<$Res>? get request;
  $ResponseCopyWith<$Res>? get response;
}

/// @nodoc
class _$EntryCopyWithImpl<$Res, $Val extends Entry>
    implements $EntryCopyWith<$Res> {
  _$EntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startedDateTime = freezed,
    Object? time = freezed,
    Object? request = freezed,
    Object? response = freezed,
  }) {
    return _then(_value.copyWith(
      startedDateTime: freezed == startedDateTime
          ? _value.startedDateTime
          : startedDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as Request?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Response?,
    ) as $Val);
  }

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RequestCopyWith<$Res>? get request {
    if (_value.request == null) {
      return null;
    }

    return $RequestCopyWith<$Res>(_value.request!, (value) {
      return _then(_value.copyWith(request: value) as $Val);
    });
  }

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResponseCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $ResponseCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EntryImplCopyWith<$Res> implements $EntryCopyWith<$Res> {
  factory _$$EntryImplCopyWith(
          _$EntryImpl value, $Res Function(_$EntryImpl) then) =
      __$$EntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? startedDateTime,
      int? time,
      Request? request,
      Response? response});

  @override
  $RequestCopyWith<$Res>? get request;
  @override
  $ResponseCopyWith<$Res>? get response;
}

/// @nodoc
class __$$EntryImplCopyWithImpl<$Res>
    extends _$EntryCopyWithImpl<$Res, _$EntryImpl>
    implements _$$EntryImplCopyWith<$Res> {
  __$$EntryImplCopyWithImpl(
      _$EntryImpl _value, $Res Function(_$EntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startedDateTime = freezed,
    Object? time = freezed,
    Object? request = freezed,
    Object? response = freezed,
  }) {
    return _then(_$EntryImpl(
      startedDateTime: freezed == startedDateTime
          ? _value.startedDateTime
          : startedDateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
      request: freezed == request
          ? _value.request
          : request // ignore: cast_nullable_to_non_nullable
              as Request?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as Response?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$EntryImpl implements _Entry {
  const _$EntryImpl(
      {this.startedDateTime, this.time, this.request, this.response});

  factory _$EntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntryImplFromJson(json);

  @override
  final String? startedDateTime;
  @override
  final int? time;
  @override
  final Request? request;
  @override
  final Response? response;

  @override
  String toString() {
    return 'Entry(startedDateTime: $startedDateTime, time: $time, request: $request, response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntryImpl &&
            (identical(other.startedDateTime, startedDateTime) ||
                other.startedDateTime == startedDateTime) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.request, request) || other.request == request) &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startedDateTime, time, request, response);

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      __$$EntryImplCopyWithImpl<_$EntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntryImplToJson(
      this,
    );
  }
}

abstract class _Entry implements Entry {
  const factory _Entry(
      {final String? startedDateTime,
      final int? time,
      final Request? request,
      final Response? response}) = _$EntryImpl;

  factory _Entry.fromJson(Map<String, dynamic> json) = _$EntryImpl.fromJson;

  @override
  String? get startedDateTime;
  @override
  int? get time;
  @override
  Request? get request;
  @override
  Response? get response;

  /// Create a copy of Entry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EntryImplCopyWith<_$EntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Request _$RequestFromJson(Map<String, dynamic> json) {
  return _Request.fromJson(json);
}

/// @nodoc
mixin _$Request {
  String? get method => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get httpVersion => throw _privateConstructorUsedError;
  List<dynamic>? get cookies => throw _privateConstructorUsedError;
  List<Header>? get headers => throw _privateConstructorUsedError;
  List<Query>? get queryString => throw _privateConstructorUsedError;
  PostData? get postData => throw _privateConstructorUsedError;
  int? get headersSize => throw _privateConstructorUsedError;
  int? get bodySize => throw _privateConstructorUsedError;

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestCopyWith<Request> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestCopyWith<$Res> {
  factory $RequestCopyWith(Request value, $Res Function(Request) then) =
      _$RequestCopyWithImpl<$Res, Request>;
  @useResult
  $Res call(
      {String? method,
      String? url,
      String? httpVersion,
      List<dynamic>? cookies,
      List<Header>? headers,
      List<Query>? queryString,
      PostData? postData,
      int? headersSize,
      int? bodySize});

  $PostDataCopyWith<$Res>? get postData;
}

/// @nodoc
class _$RequestCopyWithImpl<$Res, $Val extends Request>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? url = freezed,
    Object? httpVersion = freezed,
    Object? cookies = freezed,
    Object? headers = freezed,
    Object? queryString = freezed,
    Object? postData = freezed,
    Object? headersSize = freezed,
    Object? bodySize = freezed,
  }) {
    return _then(_value.copyWith(
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      httpVersion: freezed == httpVersion
          ? _value.httpVersion
          : httpVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      cookies: freezed == cookies
          ? _value.cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      queryString: freezed == queryString
          ? _value.queryString
          : queryString // ignore: cast_nullable_to_non_nullable
              as List<Query>?,
      postData: freezed == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as PostData?,
      headersSize: freezed == headersSize
          ? _value.headersSize
          : headersSize // ignore: cast_nullable_to_non_nullable
              as int?,
      bodySize: freezed == bodySize
          ? _value.bodySize
          : bodySize // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostDataCopyWith<$Res>? get postData {
    if (_value.postData == null) {
      return null;
    }

    return $PostDataCopyWith<$Res>(_value.postData!, (value) {
      return _then(_value.copyWith(postData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestImplCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$$RequestImplCopyWith(
          _$RequestImpl value, $Res Function(_$RequestImpl) then) =
      __$$RequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? method,
      String? url,
      String? httpVersion,
      List<dynamic>? cookies,
      List<Header>? headers,
      List<Query>? queryString,
      PostData? postData,
      int? headersSize,
      int? bodySize});

  @override
  $PostDataCopyWith<$Res>? get postData;
}

/// @nodoc
class __$$RequestImplCopyWithImpl<$Res>
    extends _$RequestCopyWithImpl<$Res, _$RequestImpl>
    implements _$$RequestImplCopyWith<$Res> {
  __$$RequestImplCopyWithImpl(
      _$RequestImpl _value, $Res Function(_$RequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = freezed,
    Object? url = freezed,
    Object? httpVersion = freezed,
    Object? cookies = freezed,
    Object? headers = freezed,
    Object? queryString = freezed,
    Object? postData = freezed,
    Object? headersSize = freezed,
    Object? bodySize = freezed,
  }) {
    return _then(_$RequestImpl(
      method: freezed == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      httpVersion: freezed == httpVersion
          ? _value.httpVersion
          : httpVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      cookies: freezed == cookies
          ? _value._cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<Header>?,
      queryString: freezed == queryString
          ? _value._queryString
          : queryString // ignore: cast_nullable_to_non_nullable
              as List<Query>?,
      postData: freezed == postData
          ? _value.postData
          : postData // ignore: cast_nullable_to_non_nullable
              as PostData?,
      headersSize: freezed == headersSize
          ? _value.headersSize
          : headersSize // ignore: cast_nullable_to_non_nullable
              as int?,
      bodySize: freezed == bodySize
          ? _value.bodySize
          : bodySize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$RequestImpl implements _Request {
  const _$RequestImpl(
      {this.method,
      this.url,
      this.httpVersion,
      final List<dynamic>? cookies,
      final List<Header>? headers,
      final List<Query>? queryString,
      this.postData,
      this.headersSize,
      this.bodySize})
      : _cookies = cookies,
        _headers = headers,
        _queryString = queryString;

  factory _$RequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestImplFromJson(json);

  @override
  final String? method;
  @override
  final String? url;
  @override
  final String? httpVersion;
  final List<dynamic>? _cookies;
  @override
  List<dynamic>? get cookies {
    final value = _cookies;
    if (value == null) return null;
    if (_cookies is EqualUnmodifiableListView) return _cookies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Header>? _headers;
  @override
  List<Header>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Query>? _queryString;
  @override
  List<Query>? get queryString {
    final value = _queryString;
    if (value == null) return null;
    if (_queryString is EqualUnmodifiableListView) return _queryString;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final PostData? postData;
  @override
  final int? headersSize;
  @override
  final int? bodySize;

  @override
  String toString() {
    return 'Request(method: $method, url: $url, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, queryString: $queryString, postData: $postData, headersSize: $headersSize, bodySize: $bodySize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.httpVersion, httpVersion) ||
                other.httpVersion == httpVersion) &&
            const DeepCollectionEquality().equals(other._cookies, _cookies) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            const DeepCollectionEquality()
                .equals(other._queryString, _queryString) &&
            (identical(other.postData, postData) ||
                other.postData == postData) &&
            (identical(other.headersSize, headersSize) ||
                other.headersSize == headersSize) &&
            (identical(other.bodySize, bodySize) ||
                other.bodySize == bodySize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      method,
      url,
      httpVersion,
      const DeepCollectionEquality().hash(_cookies),
      const DeepCollectionEquality().hash(_headers),
      const DeepCollectionEquality().hash(_queryString),
      postData,
      headersSize,
      bodySize);

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      __$$RequestImplCopyWithImpl<_$RequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestImplToJson(
      this,
    );
  }
}

abstract class _Request implements Request {
  const factory _Request(
      {final String? method,
      final String? url,
      final String? httpVersion,
      final List<dynamic>? cookies,
      final List<Header>? headers,
      final List<Query>? queryString,
      final PostData? postData,
      final int? headersSize,
      final int? bodySize}) = _$RequestImpl;

  factory _Request.fromJson(Map<String, dynamic> json) = _$RequestImpl.fromJson;

  @override
  String? get method;
  @override
  String? get url;
  @override
  String? get httpVersion;
  @override
  List<dynamic>? get cookies;
  @override
  List<Header>? get headers;
  @override
  List<Query>? get queryString;
  @override
  PostData? get postData;
  @override
  int? get headersSize;
  @override
  int? get bodySize;

  /// Create a copy of Request
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestImplCopyWith<_$RequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostData _$PostDataFromJson(Map<String, dynamic> json) {
  return _PostData.fromJson(json);
}

/// @nodoc
mixin _$PostData {
  String? get mimeType => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<Param>? get params => throw _privateConstructorUsedError;

  /// Serializes this PostData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostDataCopyWith<PostData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostDataCopyWith<$Res> {
  factory $PostDataCopyWith(PostData value, $Res Function(PostData) then) =
      _$PostDataCopyWithImpl<$Res, PostData>;
  @useResult
  $Res call({String? mimeType, String? text, List<Param>? params});
}

/// @nodoc
class _$PostDataCopyWithImpl<$Res, $Val extends PostData>
    implements $PostDataCopyWith<$Res> {
  _$PostDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = freezed,
    Object? text = freezed,
    Object? params = freezed,
  }) {
    return _then(_value.copyWith(
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as List<Param>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostDataImplCopyWith<$Res>
    implements $PostDataCopyWith<$Res> {
  factory _$$PostDataImplCopyWith(
          _$PostDataImpl value, $Res Function(_$PostDataImpl) then) =
      __$$PostDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? mimeType, String? text, List<Param>? params});
}

/// @nodoc
class __$$PostDataImplCopyWithImpl<$Res>
    extends _$PostDataCopyWithImpl<$Res, _$PostDataImpl>
    implements _$$PostDataImplCopyWith<$Res> {
  __$$PostDataImplCopyWithImpl(
      _$PostDataImpl _value, $Res Function(_$PostDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mimeType = freezed,
    Object? text = freezed,
    Object? params = freezed,
  }) {
    return _then(_$PostDataImpl(
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as List<Param>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$PostDataImpl implements _PostData {
  const _$PostDataImpl({this.mimeType, this.text, final List<Param>? params})
      : _params = params;

  factory _$PostDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostDataImplFromJson(json);

  @override
  final String? mimeType;
  @override
  final String? text;
  final List<Param>? _params;
  @override
  List<Param>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableListView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostData(mimeType: $mimeType, text: $text, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostDataImpl &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._params, _params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mimeType, text,
      const DeepCollectionEquality().hash(_params));

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostDataImplCopyWith<_$PostDataImpl> get copyWith =>
      __$$PostDataImplCopyWithImpl<_$PostDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostDataImplToJson(
      this,
    );
  }
}

abstract class _PostData implements PostData {
  const factory _PostData(
      {final String? mimeType,
      final String? text,
      final List<Param>? params}) = _$PostDataImpl;

  factory _PostData.fromJson(Map<String, dynamic> json) =
      _$PostDataImpl.fromJson;

  @override
  String? get mimeType;
  @override
  String? get text;
  @override
  List<Param>? get params;

  /// Create a copy of PostData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostDataImplCopyWith<_$PostDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Param _$ParamFromJson(Map<String, dynamic> json) {
  return _Param.fromJson(json);
}

/// @nodoc
mixin _$Param {
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  String? get fileName => throw _privateConstructorUsedError;
  String? get contentType => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Param to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Param
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParamCopyWith<Param> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParamCopyWith<$Res> {
  factory $ParamCopyWith(Param value, $Res Function(Param) then) =
      _$ParamCopyWithImpl<$Res, Param>;
  @useResult
  $Res call(
      {String? name,
      String? value,
      String? fileName,
      String? contentType,
      bool? disabled});
}

/// @nodoc
class _$ParamCopyWithImpl<$Res, $Val extends Param>
    implements $ParamCopyWith<$Res> {
  _$ParamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Param
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? fileName = freezed,
    Object? contentType = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParamImplCopyWith<$Res> implements $ParamCopyWith<$Res> {
  factory _$$ParamImplCopyWith(
          _$ParamImpl value, $Res Function(_$ParamImpl) then) =
      __$$ParamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? value,
      String? fileName,
      String? contentType,
      bool? disabled});
}

/// @nodoc
class __$$ParamImplCopyWithImpl<$Res>
    extends _$ParamCopyWithImpl<$Res, _$ParamImpl>
    implements _$$ParamImplCopyWith<$Res> {
  __$$ParamImplCopyWithImpl(
      _$ParamImpl _value, $Res Function(_$ParamImpl) _then)
      : super(_value, _then);

  /// Create a copy of Param
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? fileName = freezed,
    Object? contentType = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$ParamImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: freezed == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      contentType: freezed == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ParamImpl implements _Param {
  const _$ParamImpl(
      {this.name, this.value, this.fileName, this.contentType, this.disabled});

  factory _$ParamImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParamImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;
  @override
  final String? fileName;
  @override
  final String? contentType;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Param(name: $name, value: $value, fileName: $fileName, contentType: $contentType, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParamImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, value, fileName, contentType, disabled);

  /// Create a copy of Param
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParamImplCopyWith<_$ParamImpl> get copyWith =>
      __$$ParamImplCopyWithImpl<_$ParamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParamImplToJson(
      this,
    );
  }
}

abstract class _Param implements Param {
  const factory _Param(
      {final String? name,
      final String? value,
      final String? fileName,
      final String? contentType,
      final bool? disabled}) = _$ParamImpl;

  factory _Param.fromJson(Map<String, dynamic> json) = _$ParamImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;
  @override
  String? get fileName;
  @override
  String? get contentType;
  @override
  bool? get disabled;

  /// Create a copy of Param
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParamImplCopyWith<_$ParamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Query _$QueryFromJson(Map<String, dynamic> json) {
  return _Query.fromJson(json);
}

/// @nodoc
mixin _$Query {
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Query to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueryCopyWith<Query> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryCopyWith<$Res> {
  factory $QueryCopyWith(Query value, $Res Function(Query) then) =
      _$QueryCopyWithImpl<$Res, Query>;
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class _$QueryCopyWithImpl<$Res, $Val extends Query>
    implements $QueryCopyWith<$Res> {
  _$QueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryImplCopyWith<$Res> implements $QueryCopyWith<$Res> {
  factory _$$QueryImplCopyWith(
          _$QueryImpl value, $Res Function(_$QueryImpl) then) =
      __$$QueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class __$$QueryImplCopyWithImpl<$Res>
    extends _$QueryCopyWithImpl<$Res, _$QueryImpl>
    implements _$$QueryImplCopyWith<$Res> {
  __$$QueryImplCopyWithImpl(
      _$QueryImpl _value, $Res Function(_$QueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$QueryImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$QueryImpl implements _Query {
  const _$QueryImpl({this.name, this.value, this.disabled});

  factory _$QueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueryImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Query(name: $name, value: $value, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, disabled);

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      __$$QueryImplCopyWithImpl<_$QueryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueryImplToJson(
      this,
    );
  }
}

abstract class _Query implements Query {
  const factory _Query(
      {final String? name,
      final String? value,
      final bool? disabled}) = _$QueryImpl;

  factory _Query.fromJson(Map<String, dynamic> json) = _$QueryImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;
  @override
  bool? get disabled;

  /// Create a copy of Query
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueryImplCopyWith<_$QueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Header _$HeaderFromJson(Map<String, dynamic> json) {
  return _Header.fromJson(json);
}

/// @nodoc
mixin _$Header {
  String? get name => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;

  /// Serializes this Header to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HeaderCopyWith<Header> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeaderCopyWith<$Res> {
  factory $HeaderCopyWith(Header value, $Res Function(Header) then) =
      _$HeaderCopyWithImpl<$Res, Header>;
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class _$HeaderCopyWithImpl<$Res, $Val extends Header>
    implements $HeaderCopyWith<$Res> {
  _$HeaderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeaderImplCopyWith<$Res> implements $HeaderCopyWith<$Res> {
  factory _$$HeaderImplCopyWith(
          _$HeaderImpl value, $Res Function(_$HeaderImpl) then) =
      __$$HeaderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? value, bool? disabled});
}

/// @nodoc
class __$$HeaderImplCopyWithImpl<$Res>
    extends _$HeaderCopyWithImpl<$Res, _$HeaderImpl>
    implements _$$HeaderImplCopyWith<$Res> {
  __$$HeaderImplCopyWithImpl(
      _$HeaderImpl _value, $Res Function(_$HeaderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? value = freezed,
    Object? disabled = freezed,
  }) {
    return _then(_$HeaderImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$HeaderImpl implements _Header {
  const _$HeaderImpl({this.name, this.value, this.disabled});

  factory _$HeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderImplFromJson(json);

  @override
  final String? name;
  @override
  final String? value;
  @override
  final bool? disabled;

  @override
  String toString() {
    return 'Header(name: $name, value: $value, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, disabled);

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      __$$HeaderImplCopyWithImpl<_$HeaderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeaderImplToJson(
      this,
    );
  }
}

abstract class _Header implements Header {
  const factory _Header(
      {final String? name,
      final String? value,
      final bool? disabled}) = _$HeaderImpl;

  factory _Header.fromJson(Map<String, dynamic> json) = _$HeaderImpl.fromJson;

  @override
  String? get name;
  @override
  String? get value;
  @override
  bool? get disabled;

  /// Create a copy of Header
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeaderImplCopyWith<_$HeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return _Response.fromJson(json);
}

/// @nodoc
mixin _$Response {
  int? get status => throw _privateConstructorUsedError;
  String? get statusText => throw _privateConstructorUsedError;
  String? get httpVersion => throw _privateConstructorUsedError;
  List<dynamic>? get cookies => throw _privateConstructorUsedError;
  List<dynamic>? get headers => throw _privateConstructorUsedError;
  Content? get content => throw _privateConstructorUsedError;
  String? get redirectURL => throw _privateConstructorUsedError;
  int? get headersSize => throw _privateConstructorUsedError;
  int? get bodySize => throw _privateConstructorUsedError;

  /// Serializes this Response to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseCopyWith<Response> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseCopyWith<$Res> {
  factory $ResponseCopyWith(Response value, $Res Function(Response) then) =
      _$ResponseCopyWithImpl<$Res, Response>;
  @useResult
  $Res call(
      {int? status,
      String? statusText,
      String? httpVersion,
      List<dynamic>? cookies,
      List<dynamic>? headers,
      Content? content,
      String? redirectURL,
      int? headersSize,
      int? bodySize});

  $ContentCopyWith<$Res>? get content;
}

/// @nodoc
class _$ResponseCopyWithImpl<$Res, $Val extends Response>
    implements $ResponseCopyWith<$Res> {
  _$ResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? statusText = freezed,
    Object? httpVersion = freezed,
    Object? cookies = freezed,
    Object? headers = freezed,
    Object? content = freezed,
    Object? redirectURL = freezed,
    Object? headersSize = freezed,
    Object? bodySize = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      httpVersion: freezed == httpVersion
          ? _value.httpVersion
          : httpVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      cookies: freezed == cookies
          ? _value.cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      headers: freezed == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content?,
      redirectURL: freezed == redirectURL
          ? _value.redirectURL
          : redirectURL // ignore: cast_nullable_to_non_nullable
              as String?,
      headersSize: freezed == headersSize
          ? _value.headersSize
          : headersSize // ignore: cast_nullable_to_non_nullable
              as int?,
      bodySize: freezed == bodySize
          ? _value.bodySize
          : bodySize // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentCopyWith<$Res>? get content {
    if (_value.content == null) {
      return null;
    }

    return $ContentCopyWith<$Res>(_value.content!, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResponseImplCopyWith<$Res>
    implements $ResponseCopyWith<$Res> {
  factory _$$ResponseImplCopyWith(
          _$ResponseImpl value, $Res Function(_$ResponseImpl) then) =
      __$$ResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? status,
      String? statusText,
      String? httpVersion,
      List<dynamic>? cookies,
      List<dynamic>? headers,
      Content? content,
      String? redirectURL,
      int? headersSize,
      int? bodySize});

  @override
  $ContentCopyWith<$Res>? get content;
}

/// @nodoc
class __$$ResponseImplCopyWithImpl<$Res>
    extends _$ResponseCopyWithImpl<$Res, _$ResponseImpl>
    implements _$$ResponseImplCopyWith<$Res> {
  __$$ResponseImplCopyWithImpl(
      _$ResponseImpl _value, $Res Function(_$ResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? statusText = freezed,
    Object? httpVersion = freezed,
    Object? cookies = freezed,
    Object? headers = freezed,
    Object? content = freezed,
    Object? redirectURL = freezed,
    Object? headersSize = freezed,
    Object? bodySize = freezed,
  }) {
    return _then(_$ResponseImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      httpVersion: freezed == httpVersion
          ? _value.httpVersion
          : httpVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      cookies: freezed == cookies
          ? _value._cookies
          : cookies // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      headers: freezed == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Content?,
      redirectURL: freezed == redirectURL
          ? _value.redirectURL
          : redirectURL // ignore: cast_nullable_to_non_nullable
              as String?,
      headersSize: freezed == headersSize
          ? _value.headersSize
          : headersSize // ignore: cast_nullable_to_non_nullable
              as int?,
      bodySize: freezed == bodySize
          ? _value.bodySize
          : bodySize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ResponseImpl implements _Response {
  const _$ResponseImpl(
      {this.status,
      this.statusText,
      this.httpVersion,
      final List<dynamic>? cookies,
      final List<dynamic>? headers,
      this.content,
      this.redirectURL,
      this.headersSize,
      this.bodySize})
      : _cookies = cookies,
        _headers = headers;

  factory _$ResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResponseImplFromJson(json);

  @override
  final int? status;
  @override
  final String? statusText;
  @override
  final String? httpVersion;
  final List<dynamic>? _cookies;
  @override
  List<dynamic>? get cookies {
    final value = _cookies;
    if (value == null) return null;
    if (_cookies is EqualUnmodifiableListView) return _cookies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _headers;
  @override
  List<dynamic>? get headers {
    final value = _headers;
    if (value == null) return null;
    if (_headers is EqualUnmodifiableListView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Content? content;
  @override
  final String? redirectURL;
  @override
  final int? headersSize;
  @override
  final int? bodySize;

  @override
  String toString() {
    return 'Response(status: $status, statusText: $statusText, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, content: $content, redirectURL: $redirectURL, headersSize: $headersSize, bodySize: $bodySize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.httpVersion, httpVersion) ||
                other.httpVersion == httpVersion) &&
            const DeepCollectionEquality().equals(other._cookies, _cookies) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.redirectURL, redirectURL) ||
                other.redirectURL == redirectURL) &&
            (identical(other.headersSize, headersSize) ||
                other.headersSize == headersSize) &&
            (identical(other.bodySize, bodySize) ||
                other.bodySize == bodySize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      statusText,
      httpVersion,
      const DeepCollectionEquality().hash(_cookies),
      const DeepCollectionEquality().hash(_headers),
      content,
      redirectURL,
      headersSize,
      bodySize);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseImplCopyWith<_$ResponseImpl> get copyWith =>
      __$$ResponseImplCopyWithImpl<_$ResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResponseImplToJson(
      this,
    );
  }
}

abstract class _Response implements Response {
  const factory _Response(
      {final int? status,
      final String? statusText,
      final String? httpVersion,
      final List<dynamic>? cookies,
      final List<dynamic>? headers,
      final Content? content,
      final String? redirectURL,
      final int? headersSize,
      final int? bodySize}) = _$ResponseImpl;

  factory _Response.fromJson(Map<String, dynamic> json) =
      _$ResponseImpl.fromJson;

  @override
  int? get status;
  @override
  String? get statusText;
  @override
  String? get httpVersion;
  @override
  List<dynamic>? get cookies;
  @override
  List<dynamic>? get headers;
  @override
  Content? get content;
  @override
  String? get redirectURL;
  @override
  int? get headersSize;
  @override
  int? get bodySize;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseImplCopyWith<_$ResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Content _$ContentFromJson(Map<String, dynamic> json) {
  return _Content.fromJson(json);
}

/// @nodoc
mixin _$Content {
  int? get size => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;

  /// Serializes this Content to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentCopyWith<Content> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res, Content>;
  @useResult
  $Res call({int? size, String? mimeType});
}

/// @nodoc
class _$ContentCopyWithImpl<$Res, $Val extends Content>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = freezed,
    Object? mimeType = freezed,
  }) {
    return _then(_value.copyWith(
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentImplCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$$ContentImplCopyWith(
          _$ContentImpl value, $Res Function(_$ContentImpl) then) =
      __$$ContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? size, String? mimeType});
}

/// @nodoc
class __$$ContentImplCopyWithImpl<$Res>
    extends _$ContentCopyWithImpl<$Res, _$ContentImpl>
    implements _$$ContentImplCopyWith<$Res> {
  __$$ContentImplCopyWithImpl(
      _$ContentImpl _value, $Res Function(_$ContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = freezed,
    Object? mimeType = freezed,
  }) {
    return _then(_$ContentImpl(
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _$ContentImpl implements _Content {
  const _$ContentImpl({this.size, this.mimeType});

  factory _$ContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentImplFromJson(json);

  @override
  final int? size;
  @override
  final String? mimeType;

  @override
  String toString() {
    return 'Content(size: $size, mimeType: $mimeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentImpl &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, size, mimeType);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      __$$ContentImplCopyWithImpl<_$ContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentImplToJson(
      this,
    );
  }
}

abstract class _Content implements Content {
  const factory _Content({final int? size, final String? mimeType}) =
      _$ContentImpl;

  factory _Content.fromJson(Map<String, dynamic> json) = _$ContentImpl.fromJson;

  @override
  int? get size;
  @override
  String? get mimeType;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
