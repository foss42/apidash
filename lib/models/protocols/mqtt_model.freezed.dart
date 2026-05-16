// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mqtt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MQTTRequestModel {

 String get brokerUrl; int get port; String? get clientId; String? get username; String? get password; MQTTVersion get version; List<NameValueModel> get subscribedTopics; List<bool> get isTopicEnabledList; bool get useTLS; bool get useWebSocket; int get qos; List<WebSocketMessage> get messageHistory; String get message; String get publishTopic;
/// Create a copy of MQTTRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MQTTRequestModelCopyWith<MQTTRequestModel> get copyWith => _$MQTTRequestModelCopyWithImpl<MQTTRequestModel>(this as MQTTRequestModel, _$identity);

  /// Serializes this MQTTRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MQTTRequestModel&&(identical(other.brokerUrl, brokerUrl) || other.brokerUrl == brokerUrl)&&(identical(other.port, port) || other.port == port)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.subscribedTopics, subscribedTopics)&&const DeepCollectionEquality().equals(other.isTopicEnabledList, isTopicEnabledList)&&(identical(other.useTLS, useTLS) || other.useTLS == useTLS)&&(identical(other.useWebSocket, useWebSocket) || other.useWebSocket == useWebSocket)&&(identical(other.qos, qos) || other.qos == qos)&&const DeepCollectionEquality().equals(other.messageHistory, messageHistory)&&(identical(other.message, message) || other.message == message)&&(identical(other.publishTopic, publishTopic) || other.publishTopic == publishTopic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brokerUrl,port,clientId,username,password,version,const DeepCollectionEquality().hash(subscribedTopics),const DeepCollectionEquality().hash(isTopicEnabledList),useTLS,useWebSocket,qos,const DeepCollectionEquality().hash(messageHistory),message,publishTopic);

@override
String toString() {
  return 'MQTTRequestModel(brokerUrl: $brokerUrl, port: $port, clientId: $clientId, username: $username, password: $password, version: $version, subscribedTopics: $subscribedTopics, isTopicEnabledList: $isTopicEnabledList, useTLS: $useTLS, useWebSocket: $useWebSocket, qos: $qos, messageHistory: $messageHistory, message: $message, publishTopic: $publishTopic)';
}


}

/// @nodoc
abstract mixin class $MQTTRequestModelCopyWith<$Res>  {
  factory $MQTTRequestModelCopyWith(MQTTRequestModel value, $Res Function(MQTTRequestModel) _then) = _$MQTTRequestModelCopyWithImpl;
@useResult
$Res call({
 String brokerUrl, int port, String? clientId, String? username, String? password, MQTTVersion version, List<NameValueModel> subscribedTopics, List<bool> isTopicEnabledList, bool useTLS, bool useWebSocket, int qos, List<WebSocketMessage> messageHistory, String message, String publishTopic
});




}
/// @nodoc
class _$MQTTRequestModelCopyWithImpl<$Res>
    implements $MQTTRequestModelCopyWith<$Res> {
  _$MQTTRequestModelCopyWithImpl(this._self, this._then);

  final MQTTRequestModel _self;
  final $Res Function(MQTTRequestModel) _then;

/// Create a copy of MQTTRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brokerUrl = null,Object? port = null,Object? clientId = freezed,Object? username = freezed,Object? password = freezed,Object? version = null,Object? subscribedTopics = null,Object? isTopicEnabledList = null,Object? useTLS = null,Object? useWebSocket = null,Object? qos = null,Object? messageHistory = null,Object? message = null,Object? publishTopic = null,}) {
  return _then(_self.copyWith(
brokerUrl: null == brokerUrl ? _self.brokerUrl : brokerUrl // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as MQTTVersion,subscribedTopics: null == subscribedTopics ? _self.subscribedTopics : subscribedTopics // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>,isTopicEnabledList: null == isTopicEnabledList ? _self.isTopicEnabledList : isTopicEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>,useTLS: null == useTLS ? _self.useTLS : useTLS // ignore: cast_nullable_to_non_nullable
as bool,useWebSocket: null == useWebSocket ? _self.useWebSocket : useWebSocket // ignore: cast_nullable_to_non_nullable
as bool,qos: null == qos ? _self.qos : qos // ignore: cast_nullable_to_non_nullable
as int,messageHistory: null == messageHistory ? _self.messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,publishTopic: null == publishTopic ? _self.publishTopic : publishTopic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MQTTRequestModel].
extension MQTTRequestModelPatterns on MQTTRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MQTTRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MQTTRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MQTTRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _MQTTRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MQTTRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _MQTTRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brokerUrl,  int port,  String? clientId,  String? username,  String? password,  MQTTVersion version,  List<NameValueModel> subscribedTopics,  List<bool> isTopicEnabledList,  bool useTLS,  bool useWebSocket,  int qos,  List<WebSocketMessage> messageHistory,  String message,  String publishTopic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MQTTRequestModel() when $default != null:
return $default(_that.brokerUrl,_that.port,_that.clientId,_that.username,_that.password,_that.version,_that.subscribedTopics,_that.isTopicEnabledList,_that.useTLS,_that.useWebSocket,_that.qos,_that.messageHistory,_that.message,_that.publishTopic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brokerUrl,  int port,  String? clientId,  String? username,  String? password,  MQTTVersion version,  List<NameValueModel> subscribedTopics,  List<bool> isTopicEnabledList,  bool useTLS,  bool useWebSocket,  int qos,  List<WebSocketMessage> messageHistory,  String message,  String publishTopic)  $default,) {final _that = this;
switch (_that) {
case _MQTTRequestModel():
return $default(_that.brokerUrl,_that.port,_that.clientId,_that.username,_that.password,_that.version,_that.subscribedTopics,_that.isTopicEnabledList,_that.useTLS,_that.useWebSocket,_that.qos,_that.messageHistory,_that.message,_that.publishTopic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brokerUrl,  int port,  String? clientId,  String? username,  String? password,  MQTTVersion version,  List<NameValueModel> subscribedTopics,  List<bool> isTopicEnabledList,  bool useTLS,  bool useWebSocket,  int qos,  List<WebSocketMessage> messageHistory,  String message,  String publishTopic)?  $default,) {final _that = this;
switch (_that) {
case _MQTTRequestModel() when $default != null:
return $default(_that.brokerUrl,_that.port,_that.clientId,_that.username,_that.password,_that.version,_that.subscribedTopics,_that.isTopicEnabledList,_that.useTLS,_that.useWebSocket,_that.qos,_that.messageHistory,_that.message,_that.publishTopic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MQTTRequestModel implements MQTTRequestModel {
  const _MQTTRequestModel({required this.brokerUrl, this.port = 1883, this.clientId, this.username, this.password, this.version = MQTTVersion.v5, final  List<NameValueModel> subscribedTopics = const [], final  List<bool> isTopicEnabledList = const [], this.useTLS = false, this.useWebSocket = false, this.qos = 0, final  List<WebSocketMessage> messageHistory = const [], this.message = "", this.publishTopic = ""}): _subscribedTopics = subscribedTopics,_isTopicEnabledList = isTopicEnabledList,_messageHistory = messageHistory;
  factory _MQTTRequestModel.fromJson(Map<String, dynamic> json) => _$MQTTRequestModelFromJson(json);

@override final  String brokerUrl;
@override@JsonKey() final  int port;
@override final  String? clientId;
@override final  String? username;
@override final  String? password;
@override@JsonKey() final  MQTTVersion version;
 final  List<NameValueModel> _subscribedTopics;
@override@JsonKey() List<NameValueModel> get subscribedTopics {
  if (_subscribedTopics is EqualUnmodifiableListView) return _subscribedTopics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscribedTopics);
}

 final  List<bool> _isTopicEnabledList;
@override@JsonKey() List<bool> get isTopicEnabledList {
  if (_isTopicEnabledList is EqualUnmodifiableListView) return _isTopicEnabledList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_isTopicEnabledList);
}

@override@JsonKey() final  bool useTLS;
@override@JsonKey() final  bool useWebSocket;
@override@JsonKey() final  int qos;
 final  List<WebSocketMessage> _messageHistory;
@override@JsonKey() List<WebSocketMessage> get messageHistory {
  if (_messageHistory is EqualUnmodifiableListView) return _messageHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageHistory);
}

@override@JsonKey() final  String message;
@override@JsonKey() final  String publishTopic;

/// Create a copy of MQTTRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MQTTRequestModelCopyWith<_MQTTRequestModel> get copyWith => __$MQTTRequestModelCopyWithImpl<_MQTTRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MQTTRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MQTTRequestModel&&(identical(other.brokerUrl, brokerUrl) || other.brokerUrl == brokerUrl)&&(identical(other.port, port) || other.port == port)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._subscribedTopics, _subscribedTopics)&&const DeepCollectionEquality().equals(other._isTopicEnabledList, _isTopicEnabledList)&&(identical(other.useTLS, useTLS) || other.useTLS == useTLS)&&(identical(other.useWebSocket, useWebSocket) || other.useWebSocket == useWebSocket)&&(identical(other.qos, qos) || other.qos == qos)&&const DeepCollectionEquality().equals(other._messageHistory, _messageHistory)&&(identical(other.message, message) || other.message == message)&&(identical(other.publishTopic, publishTopic) || other.publishTopic == publishTopic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brokerUrl,port,clientId,username,password,version,const DeepCollectionEquality().hash(_subscribedTopics),const DeepCollectionEquality().hash(_isTopicEnabledList),useTLS,useWebSocket,qos,const DeepCollectionEquality().hash(_messageHistory),message,publishTopic);

@override
String toString() {
  return 'MQTTRequestModel(brokerUrl: $brokerUrl, port: $port, clientId: $clientId, username: $username, password: $password, version: $version, subscribedTopics: $subscribedTopics, isTopicEnabledList: $isTopicEnabledList, useTLS: $useTLS, useWebSocket: $useWebSocket, qos: $qos, messageHistory: $messageHistory, message: $message, publishTopic: $publishTopic)';
}


}

/// @nodoc
abstract mixin class _$MQTTRequestModelCopyWith<$Res> implements $MQTTRequestModelCopyWith<$Res> {
  factory _$MQTTRequestModelCopyWith(_MQTTRequestModel value, $Res Function(_MQTTRequestModel) _then) = __$MQTTRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String brokerUrl, int port, String? clientId, String? username, String? password, MQTTVersion version, List<NameValueModel> subscribedTopics, List<bool> isTopicEnabledList, bool useTLS, bool useWebSocket, int qos, List<WebSocketMessage> messageHistory, String message, String publishTopic
});




}
/// @nodoc
class __$MQTTRequestModelCopyWithImpl<$Res>
    implements _$MQTTRequestModelCopyWith<$Res> {
  __$MQTTRequestModelCopyWithImpl(this._self, this._then);

  final _MQTTRequestModel _self;
  final $Res Function(_MQTTRequestModel) _then;

/// Create a copy of MQTTRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brokerUrl = null,Object? port = null,Object? clientId = freezed,Object? username = freezed,Object? password = freezed,Object? version = null,Object? subscribedTopics = null,Object? isTopicEnabledList = null,Object? useTLS = null,Object? useWebSocket = null,Object? qos = null,Object? messageHistory = null,Object? message = null,Object? publishTopic = null,}) {
  return _then(_MQTTRequestModel(
brokerUrl: null == brokerUrl ? _self.brokerUrl : brokerUrl // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as MQTTVersion,subscribedTopics: null == subscribedTopics ? _self._subscribedTopics : subscribedTopics // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>,isTopicEnabledList: null == isTopicEnabledList ? _self._isTopicEnabledList : isTopicEnabledList // ignore: cast_nullable_to_non_nullable
as List<bool>,useTLS: null == useTLS ? _self.useTLS : useTLS // ignore: cast_nullable_to_non_nullable
as bool,useWebSocket: null == useWebSocket ? _self.useWebSocket : useWebSocket // ignore: cast_nullable_to_non_nullable
as bool,qos: null == qos ? _self.qos : qos // ignore: cast_nullable_to_non_nullable
as int,messageHistory: null == messageHistory ? _self._messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,publishTopic: null == publishTopic ? _self.publishTopic : publishTopic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
