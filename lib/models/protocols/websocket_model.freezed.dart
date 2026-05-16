// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WebSocketRequestModel {

 String get url; List<WebSocketMessage> get messageHistory; Map<String, String> get customHeaders; bool get autoReconnect;
/// Create a copy of WebSocketRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebSocketRequestModelCopyWith<WebSocketRequestModel> get copyWith => _$WebSocketRequestModelCopyWithImpl<WebSocketRequestModel>(this as WebSocketRequestModel, _$identity);

  /// Serializes this WebSocketRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebSocketRequestModel&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.messageHistory, messageHistory)&&const DeepCollectionEquality().equals(other.customHeaders, customHeaders)&&(identical(other.autoReconnect, autoReconnect) || other.autoReconnect == autoReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,const DeepCollectionEquality().hash(messageHistory),const DeepCollectionEquality().hash(customHeaders),autoReconnect);

@override
String toString() {
  return 'WebSocketRequestModel(url: $url, messageHistory: $messageHistory, customHeaders: $customHeaders, autoReconnect: $autoReconnect)';
}


}

/// @nodoc
abstract mixin class $WebSocketRequestModelCopyWith<$Res>  {
  factory $WebSocketRequestModelCopyWith(WebSocketRequestModel value, $Res Function(WebSocketRequestModel) _then) = _$WebSocketRequestModelCopyWithImpl;
@useResult
$Res call({
 String url, List<WebSocketMessage> messageHistory, Map<String, String> customHeaders, bool autoReconnect
});




}
/// @nodoc
class _$WebSocketRequestModelCopyWithImpl<$Res>
    implements $WebSocketRequestModelCopyWith<$Res> {
  _$WebSocketRequestModelCopyWithImpl(this._self, this._then);

  final WebSocketRequestModel _self;
  final $Res Function(WebSocketRequestModel) _then;

/// Create a copy of WebSocketRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? messageHistory = null,Object? customHeaders = null,Object? autoReconnect = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,messageHistory: null == messageHistory ? _self.messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoReconnect: null == autoReconnect ? _self.autoReconnect : autoReconnect // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebSocketRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebSocketRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebSocketRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _WebSocketRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebSocketRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _WebSocketRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  List<WebSocketMessage> messageHistory,  Map<String, String> customHeaders,  bool autoReconnect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebSocketRequestModel() when $default != null:
return $default(_that.url,_that.messageHistory,_that.customHeaders,_that.autoReconnect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  List<WebSocketMessage> messageHistory,  Map<String, String> customHeaders,  bool autoReconnect)  $default,) {final _that = this;
switch (_that) {
case _WebSocketRequestModel():
return $default(_that.url,_that.messageHistory,_that.customHeaders,_that.autoReconnect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  List<WebSocketMessage> messageHistory,  Map<String, String> customHeaders,  bool autoReconnect)?  $default,) {final _that = this;
switch (_that) {
case _WebSocketRequestModel() when $default != null:
return $default(_that.url,_that.messageHistory,_that.customHeaders,_that.autoReconnect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebSocketRequestModel implements WebSocketRequestModel {
  const _WebSocketRequestModel({required this.url, final  List<WebSocketMessage> messageHistory = const [], final  Map<String, String> customHeaders = const {}, this.autoReconnect = false}): _messageHistory = messageHistory,_customHeaders = customHeaders;
  factory _WebSocketRequestModel.fromJson(Map<String, dynamic> json) => _$WebSocketRequestModelFromJson(json);

@override final  String url;
 final  List<WebSocketMessage> _messageHistory;
@override@JsonKey() List<WebSocketMessage> get messageHistory {
  if (_messageHistory is EqualUnmodifiableListView) return _messageHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageHistory);
}

 final  Map<String, String> _customHeaders;
@override@JsonKey() Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}

@override@JsonKey() final  bool autoReconnect;

/// Create a copy of WebSocketRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebSocketRequestModelCopyWith<_WebSocketRequestModel> get copyWith => __$WebSocketRequestModelCopyWithImpl<_WebSocketRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebSocketRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebSocketRequestModel&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._messageHistory, _messageHistory)&&const DeepCollectionEquality().equals(other._customHeaders, _customHeaders)&&(identical(other.autoReconnect, autoReconnect) || other.autoReconnect == autoReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,const DeepCollectionEquality().hash(_messageHistory),const DeepCollectionEquality().hash(_customHeaders),autoReconnect);

@override
String toString() {
  return 'WebSocketRequestModel(url: $url, messageHistory: $messageHistory, customHeaders: $customHeaders, autoReconnect: $autoReconnect)';
}


}

/// @nodoc
abstract mixin class _$WebSocketRequestModelCopyWith<$Res> implements $WebSocketRequestModelCopyWith<$Res> {
  factory _$WebSocketRequestModelCopyWith(_WebSocketRequestModel value, $Res Function(_WebSocketRequestModel) _then) = __$WebSocketRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String url, List<WebSocketMessage> messageHistory, Map<String, String> customHeaders, bool autoReconnect
});




}
/// @nodoc
class __$WebSocketRequestModelCopyWithImpl<$Res>
    implements _$WebSocketRequestModelCopyWith<$Res> {
  __$WebSocketRequestModelCopyWithImpl(this._self, this._then);

  final _WebSocketRequestModel _self;
  final $Res Function(_WebSocketRequestModel) _then;

/// Create a copy of WebSocketRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? messageHistory = null,Object? customHeaders = null,Object? autoReconnect = null,}) {
  return _then(_WebSocketRequestModel(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,messageHistory: null == messageHistory ? _self._messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,autoReconnect: null == autoReconnect ? _self.autoReconnect : autoReconnect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$WebSocketMessage {

 String get payload; DateTime? get timestamp; bool get outgoing; WebSocketMessageType get messageType; int? get qos;
/// Create a copy of WebSocketMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebSocketMessageCopyWith<WebSocketMessage> get copyWith => _$WebSocketMessageCopyWithImpl<WebSocketMessage>(this as WebSocketMessage, _$identity);

  /// Serializes this WebSocketMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebSocketMessage&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.outgoing, outgoing) || other.outgoing == outgoing)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.qos, qos) || other.qos == qos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,payload,timestamp,outgoing,messageType,qos);

@override
String toString() {
  return 'WebSocketMessage(payload: $payload, timestamp: $timestamp, outgoing: $outgoing, messageType: $messageType, qos: $qos)';
}


}

/// @nodoc
abstract mixin class $WebSocketMessageCopyWith<$Res>  {
  factory $WebSocketMessageCopyWith(WebSocketMessage value, $Res Function(WebSocketMessage) _then) = _$WebSocketMessageCopyWithImpl;
@useResult
$Res call({
 String payload, DateTime? timestamp, bool outgoing, WebSocketMessageType messageType, int? qos
});




}
/// @nodoc
class _$WebSocketMessageCopyWithImpl<$Res>
    implements $WebSocketMessageCopyWith<$Res> {
  _$WebSocketMessageCopyWithImpl(this._self, this._then);

  final WebSocketMessage _self;
  final $Res Function(WebSocketMessage) _then;

/// Create a copy of WebSocketMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payload = null,Object? timestamp = freezed,Object? outgoing = null,Object? messageType = null,Object? qos = freezed,}) {
  return _then(_self.copyWith(
payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,outgoing: null == outgoing ? _self.outgoing : outgoing // ignore: cast_nullable_to_non_nullable
as bool,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as WebSocketMessageType,qos: freezed == qos ? _self.qos : qos // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebSocketMessage].
extension WebSocketMessagePatterns on WebSocketMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebSocketMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebSocketMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebSocketMessage value)  $default,){
final _that = this;
switch (_that) {
case _WebSocketMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebSocketMessage value)?  $default,){
final _that = this;
switch (_that) {
case _WebSocketMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String payload,  DateTime? timestamp,  bool outgoing,  WebSocketMessageType messageType,  int? qos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebSocketMessage() when $default != null:
return $default(_that.payload,_that.timestamp,_that.outgoing,_that.messageType,_that.qos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String payload,  DateTime? timestamp,  bool outgoing,  WebSocketMessageType messageType,  int? qos)  $default,) {final _that = this;
switch (_that) {
case _WebSocketMessage():
return $default(_that.payload,_that.timestamp,_that.outgoing,_that.messageType,_that.qos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String payload,  DateTime? timestamp,  bool outgoing,  WebSocketMessageType messageType,  int? qos)?  $default,) {final _that = this;
switch (_that) {
case _WebSocketMessage() when $default != null:
return $default(_that.payload,_that.timestamp,_that.outgoing,_that.messageType,_that.qos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WebSocketMessage implements WebSocketMessage {
  const _WebSocketMessage({required this.payload, this.timestamp, this.outgoing = true, this.messageType = WebSocketMessageType.received, this.qos});
  factory _WebSocketMessage.fromJson(Map<String, dynamic> json) => _$WebSocketMessageFromJson(json);

@override final  String payload;
@override final  DateTime? timestamp;
@override@JsonKey() final  bool outgoing;
@override@JsonKey() final  WebSocketMessageType messageType;
@override final  int? qos;

/// Create a copy of WebSocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebSocketMessageCopyWith<_WebSocketMessage> get copyWith => __$WebSocketMessageCopyWithImpl<_WebSocketMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WebSocketMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebSocketMessage&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.outgoing, outgoing) || other.outgoing == outgoing)&&(identical(other.messageType, messageType) || other.messageType == messageType)&&(identical(other.qos, qos) || other.qos == qos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,payload,timestamp,outgoing,messageType,qos);

@override
String toString() {
  return 'WebSocketMessage(payload: $payload, timestamp: $timestamp, outgoing: $outgoing, messageType: $messageType, qos: $qos)';
}


}

/// @nodoc
abstract mixin class _$WebSocketMessageCopyWith<$Res> implements $WebSocketMessageCopyWith<$Res> {
  factory _$WebSocketMessageCopyWith(_WebSocketMessage value, $Res Function(_WebSocketMessage) _then) = __$WebSocketMessageCopyWithImpl;
@override @useResult
$Res call({
 String payload, DateTime? timestamp, bool outgoing, WebSocketMessageType messageType, int? qos
});




}
/// @nodoc
class __$WebSocketMessageCopyWithImpl<$Res>
    implements _$WebSocketMessageCopyWith<$Res> {
  __$WebSocketMessageCopyWithImpl(this._self, this._then);

  final _WebSocketMessage _self;
  final $Res Function(_WebSocketMessage) _then;

/// Create a copy of WebSocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payload = null,Object? timestamp = freezed,Object? outgoing = null,Object? messageType = null,Object? qos = freezed,}) {
  return _then(_WebSocketMessage(
payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,outgoing: null == outgoing ? _self.outgoing : outgoing // ignore: cast_nullable_to_non_nullable
as bool,messageType: null == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as WebSocketMessageType,qos: freezed == qos ? _self.qos : qos // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
