// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'har_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HarLog {

 Log? get log;
/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarLogCopyWith<HarLog> get copyWith => _$HarLogCopyWithImpl<HarLog>(this as HarLog, _$identity);

  /// Serializes this HarLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarLog&&(identical(other.log, log) || other.log == log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,log);

@override
String toString() {
  return 'HarLog(log: $log)';
}


}

/// @nodoc
abstract mixin class $HarLogCopyWith<$Res>  {
  factory $HarLogCopyWith(HarLog value, $Res Function(HarLog) _then) = _$HarLogCopyWithImpl;
@useResult
$Res call({
 Log? log
});


$LogCopyWith<$Res>? get log;

}
/// @nodoc
class _$HarLogCopyWithImpl<$Res>
    implements $HarLogCopyWith<$Res> {
  _$HarLogCopyWithImpl(this._self, this._then);

  final HarLog _self;
  final $Res Function(HarLog) _then;

/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? log = freezed,}) {
  return _then(_self.copyWith(
log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as Log?,
  ));
}
/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogCopyWith<$Res>? get log {
    if (_self.log == null) {
    return null;
  }

  return $LogCopyWith<$Res>(_self.log!, (value) {
    return _then(_self.copyWith(log: value));
  });
}
}


/// Adds pattern-matching-related methods to [HarLog].
extension HarLogPatterns on HarLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarLog() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarLog value)  $default,){
final _that = this;
switch (_that) {
case _HarLog():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarLog value)?  $default,){
final _that = this;
switch (_that) {
case _HarLog() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Log? log)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarLog() when $default != null:
return $default(_that.log);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Log? log)  $default,) {final _that = this;
switch (_that) {
case _HarLog():
return $default(_that.log);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Log? log)?  $default,) {final _that = this;
switch (_that) {
case _HarLog() when $default != null:
return $default(_that.log);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _HarLog implements HarLog {
  const _HarLog({this.log});
  factory _HarLog.fromJson(Map<String, dynamic> json) => _$HarLogFromJson(json);

@override final  Log? log;

/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarLogCopyWith<_HarLog> get copyWith => __$HarLogCopyWithImpl<_HarLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarLog&&(identical(other.log, log) || other.log == log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,log);

@override
String toString() {
  return 'HarLog(log: $log)';
}


}

/// @nodoc
abstract mixin class _$HarLogCopyWith<$Res> implements $HarLogCopyWith<$Res> {
  factory _$HarLogCopyWith(_HarLog value, $Res Function(_HarLog) _then) = __$HarLogCopyWithImpl;
@override @useResult
$Res call({
 Log? log
});


@override $LogCopyWith<$Res>? get log;

}
/// @nodoc
class __$HarLogCopyWithImpl<$Res>
    implements _$HarLogCopyWith<$Res> {
  __$HarLogCopyWithImpl(this._self, this._then);

  final _HarLog _self;
  final $Res Function(_HarLog) _then;

/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? log = freezed,}) {
  return _then(_HarLog(
log: freezed == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as Log?,
  ));
}

/// Create a copy of HarLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LogCopyWith<$Res>? get log {
    if (_self.log == null) {
    return null;
  }

  return $LogCopyWith<$Res>(_self.log!, (value) {
    return _then(_self.copyWith(log: value));
  });
}
}


/// @nodoc
mixin _$Log {

 String? get version; Creator? get creator; List<Entry>? get entries;
/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogCopyWith<Log> get copyWith => _$LogCopyWithImpl<Log>(this as Log, _$identity);

  /// Serializes this Log to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Log&&(identical(other.version, version) || other.version == version)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,creator,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'Log(version: $version, creator: $creator, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $LogCopyWith<$Res>  {
  factory $LogCopyWith(Log value, $Res Function(Log) _then) = _$LogCopyWithImpl;
@useResult
$Res call({
 String? version, Creator? creator, List<Entry>? entries
});


$CreatorCopyWith<$Res>? get creator;

}
/// @nodoc
class _$LogCopyWithImpl<$Res>
    implements $LogCopyWith<$Res> {
  _$LogCopyWithImpl(this._self, this._then);

  final Log _self;
  final $Res Function(Log) _then;

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? creator = freezed,Object? entries = freezed,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as Creator?,entries: freezed == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<Entry>?,
  ));
}
/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatorCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $CreatorCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [Log].
extension LogPatterns on Log {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Log value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Log value)  $default,){
final _that = this;
switch (_that) {
case _Log():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Log value)?  $default,){
final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? version,  Creator? creator,  List<Entry>? entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that.version,_that.creator,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? version,  Creator? creator,  List<Entry>? entries)  $default,) {final _that = this;
switch (_that) {
case _Log():
return $default(_that.version,_that.creator,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? version,  Creator? creator,  List<Entry>? entries)?  $default,) {final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that.version,_that.creator,_that.entries);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Log implements Log {
  const _Log({this.version, this.creator, final  List<Entry>? entries}): _entries = entries;
  factory _Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

@override final  String? version;
@override final  Creator? creator;
 final  List<Entry>? _entries;
@override List<Entry>? get entries {
  final value = _entries;
  if (value == null) return null;
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogCopyWith<_Log> get copyWith => __$LogCopyWithImpl<_Log>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Log&&(identical(other.version, version) || other.version == version)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other._entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,creator,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'Log(version: $version, creator: $creator, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$LogCopyWith<$Res> implements $LogCopyWith<$Res> {
  factory _$LogCopyWith(_Log value, $Res Function(_Log) _then) = __$LogCopyWithImpl;
@override @useResult
$Res call({
 String? version, Creator? creator, List<Entry>? entries
});


@override $CreatorCopyWith<$Res>? get creator;

}
/// @nodoc
class __$LogCopyWithImpl<$Res>
    implements _$LogCopyWith<$Res> {
  __$LogCopyWithImpl(this._self, this._then);

  final _Log _self;
  final $Res Function(_Log) _then;

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? creator = freezed,Object? entries = freezed,}) {
  return _then(_Log(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,creator: freezed == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as Creator?,entries: freezed == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<Entry>?,
  ));
}

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatorCopyWith<$Res>? get creator {
    if (_self.creator == null) {
    return null;
  }

  return $CreatorCopyWith<$Res>(_self.creator!, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// @nodoc
mixin _$Creator {

 String? get name; String? get version;
/// Create a copy of Creator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatorCopyWith<Creator> get copyWith => _$CreatorCopyWithImpl<Creator>(this as Creator, _$identity);

  /// Serializes this Creator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Creator&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version);

@override
String toString() {
  return 'Creator(name: $name, version: $version)';
}


}

/// @nodoc
abstract mixin class $CreatorCopyWith<$Res>  {
  factory $CreatorCopyWith(Creator value, $Res Function(Creator) _then) = _$CreatorCopyWithImpl;
@useResult
$Res call({
 String? name, String? version
});




}
/// @nodoc
class _$CreatorCopyWithImpl<$Res>
    implements $CreatorCopyWith<$Res> {
  _$CreatorCopyWithImpl(this._self, this._then);

  final Creator _self;
  final $Res Function(Creator) _then;

/// Create a copy of Creator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? version = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Creator].
extension CreatorPatterns on Creator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Creator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Creator() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Creator value)  $default,){
final _that = this;
switch (_that) {
case _Creator():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Creator value)?  $default,){
final _that = this;
switch (_that) {
case _Creator() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Creator() when $default != null:
return $default(_that.name,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? version)  $default,) {final _that = this;
switch (_that) {
case _Creator():
return $default(_that.name,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _Creator() when $default != null:
return $default(_that.name,_that.version);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Creator implements Creator {
  const _Creator({this.name, this.version});
  factory _Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);

@override final  String? name;
@override final  String? version;

/// Create a copy of Creator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatorCopyWith<_Creator> get copyWith => __$CreatorCopyWithImpl<_Creator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Creator&&(identical(other.name, name) || other.name == name)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,version);

@override
String toString() {
  return 'Creator(name: $name, version: $version)';
}


}

/// @nodoc
abstract mixin class _$CreatorCopyWith<$Res> implements $CreatorCopyWith<$Res> {
  factory _$CreatorCopyWith(_Creator value, $Res Function(_Creator) _then) = __$CreatorCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? version
});




}
/// @nodoc
class __$CreatorCopyWithImpl<$Res>
    implements _$CreatorCopyWith<$Res> {
  __$CreatorCopyWithImpl(this._self, this._then);

  final _Creator _self;
  final $Res Function(_Creator) _then;

/// Create a copy of Creator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? version = freezed,}) {
  return _then(_Creator(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Entry {

 String? get startedDateTime; int? get time; Request? get request; Response? get response;
/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryCopyWith<Entry> get copyWith => _$EntryCopyWithImpl<Entry>(this as Entry, _$identity);

  /// Serializes this Entry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entry&&(identical(other.startedDateTime, startedDateTime) || other.startedDateTime == startedDateTime)&&(identical(other.time, time) || other.time == time)&&(identical(other.request, request) || other.request == request)&&(identical(other.response, response) || other.response == response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedDateTime,time,request,response);

@override
String toString() {
  return 'Entry(startedDateTime: $startedDateTime, time: $time, request: $request, response: $response)';
}


}

/// @nodoc
abstract mixin class $EntryCopyWith<$Res>  {
  factory $EntryCopyWith(Entry value, $Res Function(Entry) _then) = _$EntryCopyWithImpl;
@useResult
$Res call({
 String? startedDateTime, int? time, Request? request, Response? response
});


$RequestCopyWith<$Res>? get request;$ResponseCopyWith<$Res>? get response;

}
/// @nodoc
class _$EntryCopyWithImpl<$Res>
    implements $EntryCopyWith<$Res> {
  _$EntryCopyWithImpl(this._self, this._then);

  final Entry _self;
  final $Res Function(Entry) _then;

/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startedDateTime = freezed,Object? time = freezed,Object? request = freezed,Object? response = freezed,}) {
  return _then(_self.copyWith(
startedDateTime: freezed == startedDateTime ? _self.startedDateTime : startedDateTime // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as Request?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response?,
  ));
}
/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResponseCopyWith<$Res>? get response {
    if (_self.response == null) {
    return null;
  }

  return $ResponseCopyWith<$Res>(_self.response!, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}


/// Adds pattern-matching-related methods to [Entry].
extension EntryPatterns on Entry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entry() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entry value)  $default,){
final _that = this;
switch (_that) {
case _Entry():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entry value)?  $default,){
final _that = this;
switch (_that) {
case _Entry() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? startedDateTime,  int? time,  Request? request,  Response? response)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entry() when $default != null:
return $default(_that.startedDateTime,_that.time,_that.request,_that.response);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? startedDateTime,  int? time,  Request? request,  Response? response)  $default,) {final _that = this;
switch (_that) {
case _Entry():
return $default(_that.startedDateTime,_that.time,_that.request,_that.response);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? startedDateTime,  int? time,  Request? request,  Response? response)?  $default,) {final _that = this;
switch (_that) {
case _Entry() when $default != null:
return $default(_that.startedDateTime,_that.time,_that.request,_that.response);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Entry implements Entry {
  const _Entry({this.startedDateTime, this.time, this.request, this.response});
  factory _Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

@override final  String? startedDateTime;
@override final  int? time;
@override final  Request? request;
@override final  Response? response;

/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryCopyWith<_Entry> get copyWith => __$EntryCopyWithImpl<_Entry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entry&&(identical(other.startedDateTime, startedDateTime) || other.startedDateTime == startedDateTime)&&(identical(other.time, time) || other.time == time)&&(identical(other.request, request) || other.request == request)&&(identical(other.response, response) || other.response == response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedDateTime,time,request,response);

@override
String toString() {
  return 'Entry(startedDateTime: $startedDateTime, time: $time, request: $request, response: $response)';
}


}

/// @nodoc
abstract mixin class _$EntryCopyWith<$Res> implements $EntryCopyWith<$Res> {
  factory _$EntryCopyWith(_Entry value, $Res Function(_Entry) _then) = __$EntryCopyWithImpl;
@override @useResult
$Res call({
 String? startedDateTime, int? time, Request? request, Response? response
});


@override $RequestCopyWith<$Res>? get request;@override $ResponseCopyWith<$Res>? get response;

}
/// @nodoc
class __$EntryCopyWithImpl<$Res>
    implements _$EntryCopyWith<$Res> {
  __$EntryCopyWithImpl(this._self, this._then);

  final _Entry _self;
  final $Res Function(_Entry) _then;

/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedDateTime = freezed,Object? time = freezed,Object? request = freezed,Object? response = freezed,}) {
  return _then(_Entry(
startedDateTime: freezed == startedDateTime ? _self.startedDateTime : startedDateTime // ignore: cast_nullable_to_non_nullable
as String?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as Request?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as Response?,
  ));
}

/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestCopyWith<$Res>? get request {
    if (_self.request == null) {
    return null;
  }

  return $RequestCopyWith<$Res>(_self.request!, (value) {
    return _then(_self.copyWith(request: value));
  });
}/// Create a copy of Entry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResponseCopyWith<$Res>? get response {
    if (_self.response == null) {
    return null;
  }

  return $ResponseCopyWith<$Res>(_self.response!, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}


/// @nodoc
mixin _$Request {

 String? get method; String? get url; String? get httpVersion; List<dynamic>? get cookies; List<Header>? get headers; List<Query>? get queryString; PostData? get postData; int? get headersSize; int? get bodySize;
/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestCopyWith<Request> get copyWith => _$RequestCopyWithImpl<Request>(this as Request, _$identity);

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Request&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&(identical(other.httpVersion, httpVersion) || other.httpVersion == httpVersion)&&const DeepCollectionEquality().equals(other.cookies, cookies)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.queryString, queryString)&&(identical(other.postData, postData) || other.postData == postData)&&(identical(other.headersSize, headersSize) || other.headersSize == headersSize)&&(identical(other.bodySize, bodySize) || other.bodySize == bodySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,httpVersion,const DeepCollectionEquality().hash(cookies),const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(queryString),postData,headersSize,bodySize);

@override
String toString() {
  return 'Request(method: $method, url: $url, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, queryString: $queryString, postData: $postData, headersSize: $headersSize, bodySize: $bodySize)';
}


}

/// @nodoc
abstract mixin class $RequestCopyWith<$Res>  {
  factory $RequestCopyWith(Request value, $Res Function(Request) _then) = _$RequestCopyWithImpl;
@useResult
$Res call({
 String? method, String? url, String? httpVersion, List<dynamic>? cookies, List<Header>? headers, List<Query>? queryString, PostData? postData, int? headersSize, int? bodySize
});


$PostDataCopyWith<$Res>? get postData;

}
/// @nodoc
class _$RequestCopyWithImpl<$Res>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._self, this._then);

  final Request _self;
  final $Res Function(Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = freezed,Object? url = freezed,Object? httpVersion = freezed,Object? cookies = freezed,Object? headers = freezed,Object? queryString = freezed,Object? postData = freezed,Object? headersSize = freezed,Object? bodySize = freezed,}) {
  return _then(_self.copyWith(
method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,httpVersion: freezed == httpVersion ? _self.httpVersion : httpVersion // ignore: cast_nullable_to_non_nullable
as String?,cookies: freezed == cookies ? _self.cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<Header>?,queryString: freezed == queryString ? _self.queryString : queryString // ignore: cast_nullable_to_non_nullable
as List<Query>?,postData: freezed == postData ? _self.postData : postData // ignore: cast_nullable_to_non_nullable
as PostData?,headersSize: freezed == headersSize ? _self.headersSize : headersSize // ignore: cast_nullable_to_non_nullable
as int?,bodySize: freezed == bodySize ? _self.bodySize : bodySize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostDataCopyWith<$Res>? get postData {
    if (_self.postData == null) {
    return null;
  }

  return $PostDataCopyWith<$Res>(_self.postData!, (value) {
    return _then(_self.copyWith(postData: value));
  });
}
}


/// Adds pattern-matching-related methods to [Request].
extension RequestPatterns on Request {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Request value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Request value)  $default,){
final _that = this;
switch (_that) {
case _Request():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Request value)?  $default,){
final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? method,  String? url,  String? httpVersion,  List<dynamic>? cookies,  List<Header>? headers,  List<Query>? queryString,  PostData? postData,  int? headersSize,  int? bodySize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that.method,_that.url,_that.httpVersion,_that.cookies,_that.headers,_that.queryString,_that.postData,_that.headersSize,_that.bodySize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? method,  String? url,  String? httpVersion,  List<dynamic>? cookies,  List<Header>? headers,  List<Query>? queryString,  PostData? postData,  int? headersSize,  int? bodySize)  $default,) {final _that = this;
switch (_that) {
case _Request():
return $default(_that.method,_that.url,_that.httpVersion,_that.cookies,_that.headers,_that.queryString,_that.postData,_that.headersSize,_that.bodySize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? method,  String? url,  String? httpVersion,  List<dynamic>? cookies,  List<Header>? headers,  List<Query>? queryString,  PostData? postData,  int? headersSize,  int? bodySize)?  $default,) {final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that.method,_that.url,_that.httpVersion,_that.cookies,_that.headers,_that.queryString,_that.postData,_that.headersSize,_that.bodySize);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Request implements Request {
  const _Request({this.method, this.url, this.httpVersion, final  List<dynamic>? cookies, final  List<Header>? headers, final  List<Query>? queryString, this.postData, this.headersSize, this.bodySize}): _cookies = cookies,_headers = headers,_queryString = queryString;
  factory _Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

@override final  String? method;
@override final  String? url;
@override final  String? httpVersion;
 final  List<dynamic>? _cookies;
@override List<dynamic>? get cookies {
  final value = _cookies;
  if (value == null) return null;
  if (_cookies is EqualUnmodifiableListView) return _cookies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Header>? _headers;
@override List<Header>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Query>? _queryString;
@override List<Query>? get queryString {
  final value = _queryString;
  if (value == null) return null;
  if (_queryString is EqualUnmodifiableListView) return _queryString;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  PostData? postData;
@override final  int? headersSize;
@override final  int? bodySize;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestCopyWith<_Request> get copyWith => __$RequestCopyWithImpl<_Request>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Request&&(identical(other.method, method) || other.method == method)&&(identical(other.url, url) || other.url == url)&&(identical(other.httpVersion, httpVersion) || other.httpVersion == httpVersion)&&const DeepCollectionEquality().equals(other._cookies, _cookies)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other._queryString, _queryString)&&(identical(other.postData, postData) || other.postData == postData)&&(identical(other.headersSize, headersSize) || other.headersSize == headersSize)&&(identical(other.bodySize, bodySize) || other.bodySize == bodySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,url,httpVersion,const DeepCollectionEquality().hash(_cookies),const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(_queryString),postData,headersSize,bodySize);

@override
String toString() {
  return 'Request(method: $method, url: $url, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, queryString: $queryString, postData: $postData, headersSize: $headersSize, bodySize: $bodySize)';
}


}

/// @nodoc
abstract mixin class _$RequestCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$RequestCopyWith(_Request value, $Res Function(_Request) _then) = __$RequestCopyWithImpl;
@override @useResult
$Res call({
 String? method, String? url, String? httpVersion, List<dynamic>? cookies, List<Header>? headers, List<Query>? queryString, PostData? postData, int? headersSize, int? bodySize
});


@override $PostDataCopyWith<$Res>? get postData;

}
/// @nodoc
class __$RequestCopyWithImpl<$Res>
    implements _$RequestCopyWith<$Res> {
  __$RequestCopyWithImpl(this._self, this._then);

  final _Request _self;
  final $Res Function(_Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = freezed,Object? url = freezed,Object? httpVersion = freezed,Object? cookies = freezed,Object? headers = freezed,Object? queryString = freezed,Object? postData = freezed,Object? headersSize = freezed,Object? bodySize = freezed,}) {
  return _then(_Request(
method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,httpVersion: freezed == httpVersion ? _self.httpVersion : httpVersion // ignore: cast_nullable_to_non_nullable
as String?,cookies: freezed == cookies ? _self._cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<Header>?,queryString: freezed == queryString ? _self._queryString : queryString // ignore: cast_nullable_to_non_nullable
as List<Query>?,postData: freezed == postData ? _self.postData : postData // ignore: cast_nullable_to_non_nullable
as PostData?,headersSize: freezed == headersSize ? _self.headersSize : headersSize // ignore: cast_nullable_to_non_nullable
as int?,bodySize: freezed == bodySize ? _self.bodySize : bodySize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostDataCopyWith<$Res>? get postData {
    if (_self.postData == null) {
    return null;
  }

  return $PostDataCopyWith<$Res>(_self.postData!, (value) {
    return _then(_self.copyWith(postData: value));
  });
}
}


/// @nodoc
mixin _$PostData {

 String? get mimeType; String? get text; List<Param>? get params;
/// Create a copy of PostData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostDataCopyWith<PostData> get copyWith => _$PostDataCopyWithImpl<PostData>(this as PostData, _$identity);

  /// Serializes this PostData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostData&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.params, params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,text,const DeepCollectionEquality().hash(params));

@override
String toString() {
  return 'PostData(mimeType: $mimeType, text: $text, params: $params)';
}


}

/// @nodoc
abstract mixin class $PostDataCopyWith<$Res>  {
  factory $PostDataCopyWith(PostData value, $Res Function(PostData) _then) = _$PostDataCopyWithImpl;
@useResult
$Res call({
 String? mimeType, String? text, List<Param>? params
});




}
/// @nodoc
class _$PostDataCopyWithImpl<$Res>
    implements $PostDataCopyWith<$Res> {
  _$PostDataCopyWithImpl(this._self, this._then);

  final PostData _self;
  final $Res Function(PostData) _then;

/// Create a copy of PostData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mimeType = freezed,Object? text = freezed,Object? params = freezed,}) {
  return _then(_self.copyWith(
mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as List<Param>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostData].
extension PostDataPatterns on PostData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostData value)  $default,){
final _that = this;
switch (_that) {
case _PostData():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostData value)?  $default,){
final _that = this;
switch (_that) {
case _PostData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? mimeType,  String? text,  List<Param>? params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostData() when $default != null:
return $default(_that.mimeType,_that.text,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? mimeType,  String? text,  List<Param>? params)  $default,) {final _that = this;
switch (_that) {
case _PostData():
return $default(_that.mimeType,_that.text,_that.params);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? mimeType,  String? text,  List<Param>? params)?  $default,) {final _that = this;
switch (_that) {
case _PostData() when $default != null:
return $default(_that.mimeType,_that.text,_that.params);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _PostData implements PostData {
  const _PostData({this.mimeType, this.text, final  List<Param>? params}): _params = params;
  factory _PostData.fromJson(Map<String, dynamic> json) => _$PostDataFromJson(json);

@override final  String? mimeType;
@override final  String? text;
 final  List<Param>? _params;
@override List<Param>? get params {
  final value = _params;
  if (value == null) return null;
  if (_params is EqualUnmodifiableListView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PostData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostDataCopyWith<_PostData> get copyWith => __$PostDataCopyWithImpl<_PostData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostData&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,text,const DeepCollectionEquality().hash(_params));

@override
String toString() {
  return 'PostData(mimeType: $mimeType, text: $text, params: $params)';
}


}

/// @nodoc
abstract mixin class _$PostDataCopyWith<$Res> implements $PostDataCopyWith<$Res> {
  factory _$PostDataCopyWith(_PostData value, $Res Function(_PostData) _then) = __$PostDataCopyWithImpl;
@override @useResult
$Res call({
 String? mimeType, String? text, List<Param>? params
});




}
/// @nodoc
class __$PostDataCopyWithImpl<$Res>
    implements _$PostDataCopyWith<$Res> {
  __$PostDataCopyWithImpl(this._self, this._then);

  final _PostData _self;
  final $Res Function(_PostData) _then;

/// Create a copy of PostData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mimeType = freezed,Object? text = freezed,Object? params = freezed,}) {
  return _then(_PostData(
mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,params: freezed == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as List<Param>?,
  ));
}


}


/// @nodoc
mixin _$Param {

 String? get name; String? get value; String? get fileName; String? get contentType; bool? get disabled;
/// Create a copy of Param
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParamCopyWith<Param> get copyWith => _$ParamCopyWithImpl<Param>(this as Param, _$identity);

  /// Serializes this Param to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Param&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,fileName,contentType,disabled);

@override
String toString() {
  return 'Param(name: $name, value: $value, fileName: $fileName, contentType: $contentType, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $ParamCopyWith<$Res>  {
  factory $ParamCopyWith(Param value, $Res Function(Param) _then) = _$ParamCopyWithImpl;
@useResult
$Res call({
 String? name, String? value, String? fileName, String? contentType, bool? disabled
});




}
/// @nodoc
class _$ParamCopyWithImpl<$Res>
    implements $ParamCopyWith<$Res> {
  _$ParamCopyWithImpl(this._self, this._then);

  final Param _self;
  final $Res Function(Param) _then;

/// Create a copy of Param
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? value = freezed,Object? fileName = freezed,Object? contentType = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Param].
extension ParamPatterns on Param {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Param value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Param() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Param value)  $default,){
final _that = this;
switch (_that) {
case _Param():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Param value)?  $default,){
final _that = this;
switch (_that) {
case _Param() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? value,  String? fileName,  String? contentType,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Param() when $default != null:
return $default(_that.name,_that.value,_that.fileName,_that.contentType,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? value,  String? fileName,  String? contentType,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Param():
return $default(_that.name,_that.value,_that.fileName,_that.contentType,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? value,  String? fileName,  String? contentType,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Param() when $default != null:
return $default(_that.name,_that.value,_that.fileName,_that.contentType,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Param implements Param {
  const _Param({this.name, this.value, this.fileName, this.contentType, this.disabled});
  factory _Param.fromJson(Map<String, dynamic> json) => _$ParamFromJson(json);

@override final  String? name;
@override final  String? value;
@override final  String? fileName;
@override final  String? contentType;
@override final  bool? disabled;

/// Create a copy of Param
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParamCopyWith<_Param> get copyWith => __$ParamCopyWithImpl<_Param>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Param&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,fileName,contentType,disabled);

@override
String toString() {
  return 'Param(name: $name, value: $value, fileName: $fileName, contentType: $contentType, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$ParamCopyWith<$Res> implements $ParamCopyWith<$Res> {
  factory _$ParamCopyWith(_Param value, $Res Function(_Param) _then) = __$ParamCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? value, String? fileName, String? contentType, bool? disabled
});




}
/// @nodoc
class __$ParamCopyWithImpl<$Res>
    implements _$ParamCopyWith<$Res> {
  __$ParamCopyWithImpl(this._self, this._then);

  final _Param _self;
  final $Res Function(_Param) _then;

/// Create a copy of Param
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? value = freezed,Object? fileName = freezed,Object? contentType = freezed,Object? disabled = freezed,}) {
  return _then(_Param(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Query {

 String? get name; String? get value; bool? get disabled;
/// Create a copy of Query
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCopyWith<Query> get copyWith => _$QueryCopyWithImpl<Query>(this as Query, _$identity);

  /// Serializes this Query to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Query&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Query(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $QueryCopyWith<$Res>  {
  factory $QueryCopyWith(Query value, $Res Function(Query) _then) = _$QueryCopyWithImpl;
@useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class _$QueryCopyWithImpl<$Res>
    implements $QueryCopyWith<$Res> {
  _$QueryCopyWithImpl(this._self, this._then);

  final Query _self;
  final $Res Function(Query) _then;

/// Create a copy of Query
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Query].
extension QueryPatterns on Query {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Query value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Query value)  $default,){
final _that = this;
switch (_that) {
case _Query():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Query value)?  $default,){
final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Query():
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? value,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Query implements Query {
  const _Query({this.name, this.value, this.disabled});
  factory _Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

@override final  String? name;
@override final  String? value;
@override final  bool? disabled;

/// Create a copy of Query
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueryCopyWith<_Query> get copyWith => __$QueryCopyWithImpl<_Query>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Query&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Query(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$QueryCopyWith<$Res> implements $QueryCopyWith<$Res> {
  factory _$QueryCopyWith(_Query value, $Res Function(_Query) _then) = __$QueryCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class __$QueryCopyWithImpl<$Res>
    implements _$QueryCopyWith<$Res> {
  __$QueryCopyWithImpl(this._self, this._then);

  final _Query _self;
  final $Res Function(_Query) _then;

/// Create a copy of Query
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_Query(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Header {

 String? get name; String? get value; bool? get disabled;
/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeaderCopyWith<Header> get copyWith => _$HeaderCopyWithImpl<Header>(this as Header, _$identity);

  /// Serializes this Header to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Header&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Header(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $HeaderCopyWith<$Res>  {
  factory $HeaderCopyWith(Header value, $Res Function(Header) _then) = _$HeaderCopyWithImpl;
@useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class _$HeaderCopyWithImpl<$Res>
    implements $HeaderCopyWith<$Res> {
  _$HeaderCopyWithImpl(this._self, this._then);

  final Header _self;
  final $Res Function(Header) _then;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Header].
extension HeaderPatterns on Header {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Header value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Header value)  $default,){
final _that = this;
switch (_that) {
case _Header():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Header value)?  $default,){
final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? value,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Header():
return $default(_that.name,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? value,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.name,_that.value,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Header implements Header {
  const _Header({this.name, this.value, this.disabled});
  factory _Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

@override final  String? name;
@override final  String? value;
@override final  bool? disabled;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeaderCopyWith<_Header> get copyWith => __$HeaderCopyWithImpl<_Header>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeaderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Header&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,disabled);

@override
String toString() {
  return 'Header(name: $name, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$HeaderCopyWith<$Res> implements $HeaderCopyWith<$Res> {
  factory _$HeaderCopyWith(_Header value, $Res Function(_Header) _then) = __$HeaderCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? value, bool? disabled
});




}
/// @nodoc
class __$HeaderCopyWithImpl<$Res>
    implements _$HeaderCopyWith<$Res> {
  __$HeaderCopyWithImpl(this._self, this._then);

  final _Header _self;
  final $Res Function(_Header) _then;

/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_Header(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Response {

 int? get status; String? get statusText; String? get httpVersion; List<dynamic>? get cookies; List<dynamic>? get headers; Content? get content; String? get redirectURL; int? get headersSize; int? get bodySize;
/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResponseCopyWith<Response> get copyWith => _$ResponseCopyWithImpl<Response>(this as Response, _$identity);

  /// Serializes this Response to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Response&&(identical(other.status, status) || other.status == status)&&(identical(other.statusText, statusText) || other.statusText == statusText)&&(identical(other.httpVersion, httpVersion) || other.httpVersion == httpVersion)&&const DeepCollectionEquality().equals(other.cookies, cookies)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.content, content) || other.content == content)&&(identical(other.redirectURL, redirectURL) || other.redirectURL == redirectURL)&&(identical(other.headersSize, headersSize) || other.headersSize == headersSize)&&(identical(other.bodySize, bodySize) || other.bodySize == bodySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,statusText,httpVersion,const DeepCollectionEquality().hash(cookies),const DeepCollectionEquality().hash(headers),content,redirectURL,headersSize,bodySize);

@override
String toString() {
  return 'Response(status: $status, statusText: $statusText, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, content: $content, redirectURL: $redirectURL, headersSize: $headersSize, bodySize: $bodySize)';
}


}

/// @nodoc
abstract mixin class $ResponseCopyWith<$Res>  {
  factory $ResponseCopyWith(Response value, $Res Function(Response) _then) = _$ResponseCopyWithImpl;
@useResult
$Res call({
 int? status, String? statusText, String? httpVersion, List<dynamic>? cookies, List<dynamic>? headers, Content? content, String? redirectURL, int? headersSize, int? bodySize
});


$ContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$ResponseCopyWithImpl<$Res>
    implements $ResponseCopyWith<$Res> {
  _$ResponseCopyWithImpl(this._self, this._then);

  final Response _self;
  final $Res Function(Response) _then;

/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? statusText = freezed,Object? httpVersion = freezed,Object? cookies = freezed,Object? headers = freezed,Object? content = freezed,Object? redirectURL = freezed,Object? headersSize = freezed,Object? bodySize = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,statusText: freezed == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String?,httpVersion: freezed == httpVersion ? _self.httpVersion : httpVersion // ignore: cast_nullable_to_non_nullable
as String?,cookies: freezed == cookies ? _self.cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as Content?,redirectURL: freezed == redirectURL ? _self.redirectURL : redirectURL // ignore: cast_nullable_to_non_nullable
as String?,headersSize: freezed == headersSize ? _self.headersSize : headersSize // ignore: cast_nullable_to_non_nullable
as int?,bodySize: freezed == bodySize ? _self.bodySize : bodySize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $ContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [Response].
extension ResponsePatterns on Response {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Response value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Response() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Response value)  $default,){
final _that = this;
switch (_that) {
case _Response():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Response value)?  $default,){
final _that = this;
switch (_that) {
case _Response() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? status,  String? statusText,  String? httpVersion,  List<dynamic>? cookies,  List<dynamic>? headers,  Content? content,  String? redirectURL,  int? headersSize,  int? bodySize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Response() when $default != null:
return $default(_that.status,_that.statusText,_that.httpVersion,_that.cookies,_that.headers,_that.content,_that.redirectURL,_that.headersSize,_that.bodySize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? status,  String? statusText,  String? httpVersion,  List<dynamic>? cookies,  List<dynamic>? headers,  Content? content,  String? redirectURL,  int? headersSize,  int? bodySize)  $default,) {final _that = this;
switch (_that) {
case _Response():
return $default(_that.status,_that.statusText,_that.httpVersion,_that.cookies,_that.headers,_that.content,_that.redirectURL,_that.headersSize,_that.bodySize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? status,  String? statusText,  String? httpVersion,  List<dynamic>? cookies,  List<dynamic>? headers,  Content? content,  String? redirectURL,  int? headersSize,  int? bodySize)?  $default,) {final _that = this;
switch (_that) {
case _Response() when $default != null:
return $default(_that.status,_that.statusText,_that.httpVersion,_that.cookies,_that.headers,_that.content,_that.redirectURL,_that.headersSize,_that.bodySize);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Response implements Response {
  const _Response({this.status, this.statusText, this.httpVersion, final  List<dynamic>? cookies, final  List<dynamic>? headers, this.content, this.redirectURL, this.headersSize, this.bodySize}): _cookies = cookies,_headers = headers;
  factory _Response.fromJson(Map<String, dynamic> json) => _$ResponseFromJson(json);

@override final  int? status;
@override final  String? statusText;
@override final  String? httpVersion;
 final  List<dynamic>? _cookies;
@override List<dynamic>? get cookies {
  final value = _cookies;
  if (value == null) return null;
  if (_cookies is EqualUnmodifiableListView) return _cookies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<dynamic>? _headers;
@override List<dynamic>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableListView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Content? content;
@override final  String? redirectURL;
@override final  int? headersSize;
@override final  int? bodySize;

/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResponseCopyWith<_Response> get copyWith => __$ResponseCopyWithImpl<_Response>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Response&&(identical(other.status, status) || other.status == status)&&(identical(other.statusText, statusText) || other.statusText == statusText)&&(identical(other.httpVersion, httpVersion) || other.httpVersion == httpVersion)&&const DeepCollectionEquality().equals(other._cookies, _cookies)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.content, content) || other.content == content)&&(identical(other.redirectURL, redirectURL) || other.redirectURL == redirectURL)&&(identical(other.headersSize, headersSize) || other.headersSize == headersSize)&&(identical(other.bodySize, bodySize) || other.bodySize == bodySize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,statusText,httpVersion,const DeepCollectionEquality().hash(_cookies),const DeepCollectionEquality().hash(_headers),content,redirectURL,headersSize,bodySize);

@override
String toString() {
  return 'Response(status: $status, statusText: $statusText, httpVersion: $httpVersion, cookies: $cookies, headers: $headers, content: $content, redirectURL: $redirectURL, headersSize: $headersSize, bodySize: $bodySize)';
}


}

/// @nodoc
abstract mixin class _$ResponseCopyWith<$Res> implements $ResponseCopyWith<$Res> {
  factory _$ResponseCopyWith(_Response value, $Res Function(_Response) _then) = __$ResponseCopyWithImpl;
@override @useResult
$Res call({
 int? status, String? statusText, String? httpVersion, List<dynamic>? cookies, List<dynamic>? headers, Content? content, String? redirectURL, int? headersSize, int? bodySize
});


@override $ContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$ResponseCopyWithImpl<$Res>
    implements _$ResponseCopyWith<$Res> {
  __$ResponseCopyWithImpl(this._self, this._then);

  final _Response _self;
  final $Res Function(_Response) _then;

/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? statusText = freezed,Object? httpVersion = freezed,Object? cookies = freezed,Object? headers = freezed,Object? content = freezed,Object? redirectURL = freezed,Object? headersSize = freezed,Object? bodySize = freezed,}) {
  return _then(_Response(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,statusText: freezed == statusText ? _self.statusText : statusText // ignore: cast_nullable_to_non_nullable
as String?,httpVersion: freezed == httpVersion ? _self.httpVersion : httpVersion // ignore: cast_nullable_to_non_nullable
as String?,cookies: freezed == cookies ? _self._cookies : cookies // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as Content?,redirectURL: freezed == redirectURL ? _self.redirectURL : redirectURL // ignore: cast_nullable_to_non_nullable
as String?,headersSize: freezed == headersSize ? _self.headersSize : headersSize // ignore: cast_nullable_to_non_nullable
as int?,bodySize: freezed == bodySize ? _self.bodySize : bodySize // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Response
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $ContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$Content {

 int? get size; String? get mimeType;
/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentCopyWith<Content> get copyWith => _$ContentCopyWithImpl<Content>(this as Content, _$identity);

  /// Serializes this Content to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Content&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,mimeType);

@override
String toString() {
  return 'Content(size: $size, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $ContentCopyWith<$Res>  {
  factory $ContentCopyWith(Content value, $Res Function(Content) _then) = _$ContentCopyWithImpl;
@useResult
$Res call({
 int? size, String? mimeType
});




}
/// @nodoc
class _$ContentCopyWithImpl<$Res>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._self, this._then);

  final Content _self;
  final $Res Function(Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Content].
extension ContentPatterns on Content {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Content value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Content value)  $default,){
final _that = this;
switch (_that) {
case _Content():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Content value)?  $default,){
final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? size,  String? mimeType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.size,_that.mimeType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? size,  String? mimeType)  $default,) {final _that = this;
switch (_that) {
case _Content():
return $default(_that.size,_that.mimeType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? size,  String? mimeType)?  $default,) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.size,_that.mimeType);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Content implements Content {
  const _Content({this.size, this.mimeType});
  factory _Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);

@override final  int? size;
@override final  String? mimeType;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentCopyWith<_Content> get copyWith => __$ContentCopyWithImpl<_Content>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Content&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,mimeType);

@override
String toString() {
  return 'Content(size: $size, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$ContentCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$ContentCopyWith(_Content value, $Res Function(_Content) _then) = __$ContentCopyWithImpl;
@override @useResult
$Res call({
 int? size, String? mimeType
});




}
/// @nodoc
class __$ContentCopyWithImpl<$Res>
    implements _$ContentCopyWith<$Res> {
  __$ContentCopyWithImpl(this._self, this._then);

  final _Content _self;
  final $Res Function(_Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = freezed,Object? mimeType = freezed,}) {
  return _then(_Content(
size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
