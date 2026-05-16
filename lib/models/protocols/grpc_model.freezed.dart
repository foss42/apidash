// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grpc_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrpcParameterModel {

 String get name; int? get tag; String get type; String get value; bool get enabled; List<String>? get enumValues;
/// Create a copy of GrpcParameterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrpcParameterModelCopyWith<GrpcParameterModel> get copyWith => _$GrpcParameterModelCopyWithImpl<GrpcParameterModel>(this as GrpcParameterModel, _$identity);

  /// Serializes this GrpcParameterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrpcParameterModel&&(identical(other.name, name) || other.name == name)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.enumValues, enumValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,tag,type,value,enabled,const DeepCollectionEquality().hash(enumValues));

@override
String toString() {
  return 'GrpcParameterModel(name: $name, tag: $tag, type: $type, value: $value, enabled: $enabled, enumValues: $enumValues)';
}


}

/// @nodoc
abstract mixin class $GrpcParameterModelCopyWith<$Res>  {
  factory $GrpcParameterModelCopyWith(GrpcParameterModel value, $Res Function(GrpcParameterModel) _then) = _$GrpcParameterModelCopyWithImpl;
@useResult
$Res call({
 String name, int? tag, String type, String value, bool enabled, List<String>? enumValues
});




}
/// @nodoc
class _$GrpcParameterModelCopyWithImpl<$Res>
    implements $GrpcParameterModelCopyWith<$Res> {
  _$GrpcParameterModelCopyWithImpl(this._self, this._then);

  final GrpcParameterModel _self;
  final $Res Function(GrpcParameterModel) _then;

/// Create a copy of GrpcParameterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? tag = freezed,Object? type = null,Object? value = null,Object? enabled = null,Object? enumValues = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,enumValues: freezed == enumValues ? _self.enumValues : enumValues // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GrpcParameterModel].
extension GrpcParameterModelPatterns on GrpcParameterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrpcParameterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrpcParameterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrpcParameterModel value)  $default,){
final _that = this;
switch (_that) {
case _GrpcParameterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrpcParameterModel value)?  $default,){
final _that = this;
switch (_that) {
case _GrpcParameterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int? tag,  String type,  String value,  bool enabled,  List<String>? enumValues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrpcParameterModel() when $default != null:
return $default(_that.name,_that.tag,_that.type,_that.value,_that.enabled,_that.enumValues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int? tag,  String type,  String value,  bool enabled,  List<String>? enumValues)  $default,) {final _that = this;
switch (_that) {
case _GrpcParameterModel():
return $default(_that.name,_that.tag,_that.type,_that.value,_that.enabled,_that.enumValues);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int? tag,  String type,  String value,  bool enabled,  List<String>? enumValues)?  $default,) {final _that = this;
switch (_that) {
case _GrpcParameterModel() when $default != null:
return $default(_that.name,_that.tag,_that.type,_that.value,_that.enabled,_that.enumValues);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrpcParameterModel implements GrpcParameterModel {
  const _GrpcParameterModel({required this.name, this.tag, this.type = "string", this.value = "", this.enabled = true, final  List<String>? enumValues}): _enumValues = enumValues;
  factory _GrpcParameterModel.fromJson(Map<String, dynamic> json) => _$GrpcParameterModelFromJson(json);

@override final  String name;
@override final  int? tag;
@override@JsonKey() final  String type;
@override@JsonKey() final  String value;
@override@JsonKey() final  bool enabled;
 final  List<String>? _enumValues;
@override List<String>? get enumValues {
  final value = _enumValues;
  if (value == null) return null;
  if (_enumValues is EqualUnmodifiableListView) return _enumValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GrpcParameterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrpcParameterModelCopyWith<_GrpcParameterModel> get copyWith => __$GrpcParameterModelCopyWithImpl<_GrpcParameterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrpcParameterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrpcParameterModel&&(identical(other.name, name) || other.name == name)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.type, type) || other.type == type)&&(identical(other.value, value) || other.value == value)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._enumValues, _enumValues));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,tag,type,value,enabled,const DeepCollectionEquality().hash(_enumValues));

@override
String toString() {
  return 'GrpcParameterModel(name: $name, tag: $tag, type: $type, value: $value, enabled: $enabled, enumValues: $enumValues)';
}


}

/// @nodoc
abstract mixin class _$GrpcParameterModelCopyWith<$Res> implements $GrpcParameterModelCopyWith<$Res> {
  factory _$GrpcParameterModelCopyWith(_GrpcParameterModel value, $Res Function(_GrpcParameterModel) _then) = __$GrpcParameterModelCopyWithImpl;
@override @useResult
$Res call({
 String name, int? tag, String type, String value, bool enabled, List<String>? enumValues
});




}
/// @nodoc
class __$GrpcParameterModelCopyWithImpl<$Res>
    implements _$GrpcParameterModelCopyWith<$Res> {
  __$GrpcParameterModelCopyWithImpl(this._self, this._then);

  final _GrpcParameterModel _self;
  final $Res Function(_GrpcParameterModel) _then;

/// Create a copy of GrpcParameterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? tag = freezed,Object? type = null,Object? value = null,Object? enabled = null,Object? enumValues = freezed,}) {
  return _then(_GrpcParameterModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,enumValues: freezed == enumValues ? _self._enumValues : enumValues // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$GrpcRequestModel {

 String get host; int get port; String? get service; String? get method; String? get protoFile; bool get useTLS; GrpcStreamingType get streamingType; List<WebSocketMessage> get messageHistory; String get requestBody; bool get useReflection; List<NameValueModel>? get metadata; List<bool>? get isMetadataEnabled; List<String> get availableServices; List<String> get availableMethods; List<GrpcParameterModel> get parameters;
/// Create a copy of GrpcRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrpcRequestModelCopyWith<GrpcRequestModel> get copyWith => _$GrpcRequestModelCopyWithImpl<GrpcRequestModel>(this as GrpcRequestModel, _$identity);

  /// Serializes this GrpcRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrpcRequestModel&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.service, service) || other.service == service)&&(identical(other.method, method) || other.method == method)&&(identical(other.protoFile, protoFile) || other.protoFile == protoFile)&&(identical(other.useTLS, useTLS) || other.useTLS == useTLS)&&(identical(other.streamingType, streamingType) || other.streamingType == streamingType)&&const DeepCollectionEquality().equals(other.messageHistory, messageHistory)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.useReflection, useReflection) || other.useReflection == useReflection)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&const DeepCollectionEquality().equals(other.isMetadataEnabled, isMetadataEnabled)&&const DeepCollectionEquality().equals(other.availableServices, availableServices)&&const DeepCollectionEquality().equals(other.availableMethods, availableMethods)&&const DeepCollectionEquality().equals(other.parameters, parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,port,service,method,protoFile,useTLS,streamingType,const DeepCollectionEquality().hash(messageHistory),requestBody,useReflection,const DeepCollectionEquality().hash(metadata),const DeepCollectionEquality().hash(isMetadataEnabled),const DeepCollectionEquality().hash(availableServices),const DeepCollectionEquality().hash(availableMethods),const DeepCollectionEquality().hash(parameters));

@override
String toString() {
  return 'GrpcRequestModel(host: $host, port: $port, service: $service, method: $method, protoFile: $protoFile, useTLS: $useTLS, streamingType: $streamingType, messageHistory: $messageHistory, requestBody: $requestBody, useReflection: $useReflection, metadata: $metadata, isMetadataEnabled: $isMetadataEnabled, availableServices: $availableServices, availableMethods: $availableMethods, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class $GrpcRequestModelCopyWith<$Res>  {
  factory $GrpcRequestModelCopyWith(GrpcRequestModel value, $Res Function(GrpcRequestModel) _then) = _$GrpcRequestModelCopyWithImpl;
@useResult
$Res call({
 String host, int port, String? service, String? method, String? protoFile, bool useTLS, GrpcStreamingType streamingType, List<WebSocketMessage> messageHistory, String requestBody, bool useReflection, List<NameValueModel>? metadata, List<bool>? isMetadataEnabled, List<String> availableServices, List<String> availableMethods, List<GrpcParameterModel> parameters
});




}
/// @nodoc
class _$GrpcRequestModelCopyWithImpl<$Res>
    implements $GrpcRequestModelCopyWith<$Res> {
  _$GrpcRequestModelCopyWithImpl(this._self, this._then);

  final GrpcRequestModel _self;
  final $Res Function(GrpcRequestModel) _then;

/// Create a copy of GrpcRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? port = null,Object? service = freezed,Object? method = freezed,Object? protoFile = freezed,Object? useTLS = null,Object? streamingType = null,Object? messageHistory = null,Object? requestBody = null,Object? useReflection = null,Object? metadata = freezed,Object? isMetadataEnabled = freezed,Object? availableServices = null,Object? availableMethods = null,Object? parameters = null,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,protoFile: freezed == protoFile ? _self.protoFile : protoFile // ignore: cast_nullable_to_non_nullable
as String?,useTLS: null == useTLS ? _self.useTLS : useTLS // ignore: cast_nullable_to_non_nullable
as bool,streamingType: null == streamingType ? _self.streamingType : streamingType // ignore: cast_nullable_to_non_nullable
as GrpcStreamingType,messageHistory: null == messageHistory ? _self.messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as String,useReflection: null == useReflection ? _self.useReflection : useReflection // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,isMetadataEnabled: freezed == isMetadataEnabled ? _self.isMetadataEnabled : isMetadataEnabled // ignore: cast_nullable_to_non_nullable
as List<bool>?,availableServices: null == availableServices ? _self.availableServices : availableServices // ignore: cast_nullable_to_non_nullable
as List<String>,availableMethods: null == availableMethods ? _self.availableMethods : availableMethods // ignore: cast_nullable_to_non_nullable
as List<String>,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<GrpcParameterModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [GrpcRequestModel].
extension GrpcRequestModelPatterns on GrpcRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrpcRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrpcRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrpcRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _GrpcRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrpcRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _GrpcRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  int port,  String? service,  String? method,  String? protoFile,  bool useTLS,  GrpcStreamingType streamingType,  List<WebSocketMessage> messageHistory,  String requestBody,  bool useReflection,  List<NameValueModel>? metadata,  List<bool>? isMetadataEnabled,  List<String> availableServices,  List<String> availableMethods,  List<GrpcParameterModel> parameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrpcRequestModel() when $default != null:
return $default(_that.host,_that.port,_that.service,_that.method,_that.protoFile,_that.useTLS,_that.streamingType,_that.messageHistory,_that.requestBody,_that.useReflection,_that.metadata,_that.isMetadataEnabled,_that.availableServices,_that.availableMethods,_that.parameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  int port,  String? service,  String? method,  String? protoFile,  bool useTLS,  GrpcStreamingType streamingType,  List<WebSocketMessage> messageHistory,  String requestBody,  bool useReflection,  List<NameValueModel>? metadata,  List<bool>? isMetadataEnabled,  List<String> availableServices,  List<String> availableMethods,  List<GrpcParameterModel> parameters)  $default,) {final _that = this;
switch (_that) {
case _GrpcRequestModel():
return $default(_that.host,_that.port,_that.service,_that.method,_that.protoFile,_that.useTLS,_that.streamingType,_that.messageHistory,_that.requestBody,_that.useReflection,_that.metadata,_that.isMetadataEnabled,_that.availableServices,_that.availableMethods,_that.parameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  int port,  String? service,  String? method,  String? protoFile,  bool useTLS,  GrpcStreamingType streamingType,  List<WebSocketMessage> messageHistory,  String requestBody,  bool useReflection,  List<NameValueModel>? metadata,  List<bool>? isMetadataEnabled,  List<String> availableServices,  List<String> availableMethods,  List<GrpcParameterModel> parameters)?  $default,) {final _that = this;
switch (_that) {
case _GrpcRequestModel() when $default != null:
return $default(_that.host,_that.port,_that.service,_that.method,_that.protoFile,_that.useTLS,_that.streamingType,_that.messageHistory,_that.requestBody,_that.useReflection,_that.metadata,_that.isMetadataEnabled,_that.availableServices,_that.availableMethods,_that.parameters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrpcRequestModel extends GrpcRequestModel {
  const _GrpcRequestModel({required this.host, this.port = 50051, this.service, this.method, this.protoFile, this.useTLS = false, this.streamingType = GrpcStreamingType.unary, final  List<WebSocketMessage> messageHistory = const [], this.requestBody = "", this.useReflection = false, final  List<NameValueModel>? metadata = const [], final  List<bool>? isMetadataEnabled = const [], final  List<String> availableServices = const [], final  List<String> availableMethods = const [], final  List<GrpcParameterModel> parameters = const []}): _messageHistory = messageHistory,_metadata = metadata,_isMetadataEnabled = isMetadataEnabled,_availableServices = availableServices,_availableMethods = availableMethods,_parameters = parameters,super._();
  factory _GrpcRequestModel.fromJson(Map<String, dynamic> json) => _$GrpcRequestModelFromJson(json);

@override final  String host;
@override@JsonKey() final  int port;
@override final  String? service;
@override final  String? method;
@override final  String? protoFile;
@override@JsonKey() final  bool useTLS;
@override@JsonKey() final  GrpcStreamingType streamingType;
 final  List<WebSocketMessage> _messageHistory;
@override@JsonKey() List<WebSocketMessage> get messageHistory {
  if (_messageHistory is EqualUnmodifiableListView) return _messageHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageHistory);
}

@override@JsonKey() final  String requestBody;
@override@JsonKey() final  bool useReflection;
 final  List<NameValueModel>? _metadata;
@override@JsonKey() List<NameValueModel>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableListView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<bool>? _isMetadataEnabled;
@override@JsonKey() List<bool>? get isMetadataEnabled {
  final value = _isMetadataEnabled;
  if (value == null) return null;
  if (_isMetadataEnabled is EqualUnmodifiableListView) return _isMetadataEnabled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _availableServices;
@override@JsonKey() List<String> get availableServices {
  if (_availableServices is EqualUnmodifiableListView) return _availableServices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableServices);
}

 final  List<String> _availableMethods;
@override@JsonKey() List<String> get availableMethods {
  if (_availableMethods is EqualUnmodifiableListView) return _availableMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableMethods);
}

 final  List<GrpcParameterModel> _parameters;
@override@JsonKey() List<GrpcParameterModel> get parameters {
  if (_parameters is EqualUnmodifiableListView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parameters);
}


/// Create a copy of GrpcRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrpcRequestModelCopyWith<_GrpcRequestModel> get copyWith => __$GrpcRequestModelCopyWithImpl<_GrpcRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrpcRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrpcRequestModel&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.service, service) || other.service == service)&&(identical(other.method, method) || other.method == method)&&(identical(other.protoFile, protoFile) || other.protoFile == protoFile)&&(identical(other.useTLS, useTLS) || other.useTLS == useTLS)&&(identical(other.streamingType, streamingType) || other.streamingType == streamingType)&&const DeepCollectionEquality().equals(other._messageHistory, _messageHistory)&&(identical(other.requestBody, requestBody) || other.requestBody == requestBody)&&(identical(other.useReflection, useReflection) || other.useReflection == useReflection)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&const DeepCollectionEquality().equals(other._isMetadataEnabled, _isMetadataEnabled)&&const DeepCollectionEquality().equals(other._availableServices, _availableServices)&&const DeepCollectionEquality().equals(other._availableMethods, _availableMethods)&&const DeepCollectionEquality().equals(other._parameters, _parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,port,service,method,protoFile,useTLS,streamingType,const DeepCollectionEquality().hash(_messageHistory),requestBody,useReflection,const DeepCollectionEquality().hash(_metadata),const DeepCollectionEquality().hash(_isMetadataEnabled),const DeepCollectionEquality().hash(_availableServices),const DeepCollectionEquality().hash(_availableMethods),const DeepCollectionEquality().hash(_parameters));

@override
String toString() {
  return 'GrpcRequestModel(host: $host, port: $port, service: $service, method: $method, protoFile: $protoFile, useTLS: $useTLS, streamingType: $streamingType, messageHistory: $messageHistory, requestBody: $requestBody, useReflection: $useReflection, metadata: $metadata, isMetadataEnabled: $isMetadataEnabled, availableServices: $availableServices, availableMethods: $availableMethods, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class _$GrpcRequestModelCopyWith<$Res> implements $GrpcRequestModelCopyWith<$Res> {
  factory _$GrpcRequestModelCopyWith(_GrpcRequestModel value, $Res Function(_GrpcRequestModel) _then) = __$GrpcRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String host, int port, String? service, String? method, String? protoFile, bool useTLS, GrpcStreamingType streamingType, List<WebSocketMessage> messageHistory, String requestBody, bool useReflection, List<NameValueModel>? metadata, List<bool>? isMetadataEnabled, List<String> availableServices, List<String> availableMethods, List<GrpcParameterModel> parameters
});




}
/// @nodoc
class __$GrpcRequestModelCopyWithImpl<$Res>
    implements _$GrpcRequestModelCopyWith<$Res> {
  __$GrpcRequestModelCopyWithImpl(this._self, this._then);

  final _GrpcRequestModel _self;
  final $Res Function(_GrpcRequestModel) _then;

/// Create a copy of GrpcRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? port = null,Object? service = freezed,Object? method = freezed,Object? protoFile = freezed,Object? useTLS = null,Object? streamingType = null,Object? messageHistory = null,Object? requestBody = null,Object? useReflection = null,Object? metadata = freezed,Object? isMetadataEnabled = freezed,Object? availableServices = null,Object? availableMethods = null,Object? parameters = null,}) {
  return _then(_GrpcRequestModel(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,protoFile: freezed == protoFile ? _self.protoFile : protoFile // ignore: cast_nullable_to_non_nullable
as String?,useTLS: null == useTLS ? _self.useTLS : useTLS // ignore: cast_nullable_to_non_nullable
as bool,streamingType: null == streamingType ? _self.streamingType : streamingType // ignore: cast_nullable_to_non_nullable
as GrpcStreamingType,messageHistory: null == messageHistory ? _self._messageHistory : messageHistory // ignore: cast_nullable_to_non_nullable
as List<WebSocketMessage>,requestBody: null == requestBody ? _self.requestBody : requestBody // ignore: cast_nullable_to_non_nullable
as String,useReflection: null == useReflection ? _self.useReflection : useReflection // ignore: cast_nullable_to_non_nullable
as bool,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as List<NameValueModel>?,isMetadataEnabled: freezed == isMetadataEnabled ? _self._isMetadataEnabled : isMetadataEnabled // ignore: cast_nullable_to_non_nullable
as List<bool>?,availableServices: null == availableServices ? _self._availableServices : availableServices // ignore: cast_nullable_to_non_nullable
as List<String>,availableMethods: null == availableMethods ? _self._availableMethods : availableMethods // ignore: cast_nullable_to_non_nullable
as List<String>,parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as List<GrpcParameterModel>,
  ));
}


}

// dart format on
