// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'http_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HttpResponseModel {

 int? get statusCode; Map<String, String>? get headers; Map<String, String>? get requestHeaders; String? get body; String? get formattedBody;@Uint8ListConverter() Uint8List? get bodyBytes;@DurationConverter() Duration? get time; List<String>? get sseOutput;
/// Create a copy of HttpResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpResponseModelCopyWith<HttpResponseModel> get copyWith => _$HttpResponseModelCopyWithImpl<HttpResponseModel>(this as HttpResponseModel, _$identity);

  /// Serializes this HttpResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpResponseModel&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.requestHeaders, requestHeaders)&&(identical(other.body, body) || other.body == body)&&(identical(other.formattedBody, formattedBody) || other.formattedBody == formattedBody)&&const DeepCollectionEquality().equals(other.bodyBytes, bodyBytes)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.sseOutput, sseOutput));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(requestHeaders),body,formattedBody,const DeepCollectionEquality().hash(bodyBytes),time,const DeepCollectionEquality().hash(sseOutput));

@override
String toString() {
  return 'HttpResponseModel(statusCode: $statusCode, headers: $headers, requestHeaders: $requestHeaders, body: $body, formattedBody: $formattedBody, bodyBytes: $bodyBytes, time: $time, sseOutput: $sseOutput)';
}


}

/// @nodoc
abstract mixin class $HttpResponseModelCopyWith<$Res>  {
  factory $HttpResponseModelCopyWith(HttpResponseModel value, $Res Function(HttpResponseModel) _then) = _$HttpResponseModelCopyWithImpl;
@useResult
$Res call({
 int? statusCode, Map<String, String>? headers, Map<String, String>? requestHeaders, String? body, String? formattedBody,@Uint8ListConverter() Uint8List? bodyBytes,@DurationConverter() Duration? time, List<String>? sseOutput
});




}
/// @nodoc
class _$HttpResponseModelCopyWithImpl<$Res>
    implements $HttpResponseModelCopyWith<$Res> {
  _$HttpResponseModelCopyWithImpl(this._self, this._then);

  final HttpResponseModel _self;
  final $Res Function(HttpResponseModel) _then;

/// Create a copy of HttpResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusCode = freezed,Object? headers = freezed,Object? requestHeaders = freezed,Object? body = freezed,Object? formattedBody = freezed,Object? bodyBytes = freezed,Object? time = freezed,Object? sseOutput = freezed,}) {
  return _then(_self.copyWith(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,requestHeaders: freezed == requestHeaders ? _self.requestHeaders : requestHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,formattedBody: freezed == formattedBody ? _self.formattedBody : formattedBody // ignore: cast_nullable_to_non_nullable
as String?,bodyBytes: freezed == bodyBytes ? _self.bodyBytes : bodyBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration?,sseOutput: freezed == sseOutput ? _self.sseOutput : sseOutput // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HttpResponseModel].
extension HttpResponseModelPatterns on HttpResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HttpResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HttpResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HttpResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _HttpResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HttpResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _HttpResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? statusCode,  Map<String, String>? headers,  Map<String, String>? requestHeaders,  String? body,  String? formattedBody, @Uint8ListConverter()  Uint8List? bodyBytes, @DurationConverter()  Duration? time,  List<String>? sseOutput)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HttpResponseModel() when $default != null:
return $default(_that.statusCode,_that.headers,_that.requestHeaders,_that.body,_that.formattedBody,_that.bodyBytes,_that.time,_that.sseOutput);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? statusCode,  Map<String, String>? headers,  Map<String, String>? requestHeaders,  String? body,  String? formattedBody, @Uint8ListConverter()  Uint8List? bodyBytes, @DurationConverter()  Duration? time,  List<String>? sseOutput)  $default,) {final _that = this;
switch (_that) {
case _HttpResponseModel():
return $default(_that.statusCode,_that.headers,_that.requestHeaders,_that.body,_that.formattedBody,_that.bodyBytes,_that.time,_that.sseOutput);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? statusCode,  Map<String, String>? headers,  Map<String, String>? requestHeaders,  String? body,  String? formattedBody, @Uint8ListConverter()  Uint8List? bodyBytes, @DurationConverter()  Duration? time,  List<String>? sseOutput)?  $default,) {final _that = this;
switch (_that) {
case _HttpResponseModel() when $default != null:
return $default(_that.statusCode,_that.headers,_that.requestHeaders,_that.body,_that.formattedBody,_that.bodyBytes,_that.time,_that.sseOutput);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true)
class _HttpResponseModel extends HttpResponseModel {
  const _HttpResponseModel({this.statusCode, final  Map<String, String>? headers, final  Map<String, String>? requestHeaders, this.body, this.formattedBody, @Uint8ListConverter() this.bodyBytes, @DurationConverter() this.time, final  List<String>? sseOutput}): _headers = headers,_requestHeaders = requestHeaders,_sseOutput = sseOutput,super._();
  factory _HttpResponseModel.fromJson(Map<String, dynamic> json) => _$HttpResponseModelFromJson(json);

@override final  int? statusCode;
 final  Map<String, String>? _headers;
@override Map<String, String>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String>? _requestHeaders;
@override Map<String, String>? get requestHeaders {
  final value = _requestHeaders;
  if (value == null) return null;
  if (_requestHeaders is EqualUnmodifiableMapView) return _requestHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? body;
@override final  String? formattedBody;
@override@Uint8ListConverter() final  Uint8List? bodyBytes;
@override@DurationConverter() final  Duration? time;
 final  List<String>? _sseOutput;
@override List<String>? get sseOutput {
  final value = _sseOutput;
  if (value == null) return null;
  if (_sseOutput is EqualUnmodifiableListView) return _sseOutput;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of HttpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HttpResponseModelCopyWith<_HttpResponseModel> get copyWith => __$HttpResponseModelCopyWithImpl<_HttpResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HttpResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HttpResponseModel&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other._requestHeaders, _requestHeaders)&&(identical(other.body, body) || other.body == body)&&(identical(other.formattedBody, formattedBody) || other.formattedBody == formattedBody)&&const DeepCollectionEquality().equals(other.bodyBytes, bodyBytes)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other._sseOutput, _sseOutput));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusCode,const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(_requestHeaders),body,formattedBody,const DeepCollectionEquality().hash(bodyBytes),time,const DeepCollectionEquality().hash(_sseOutput));

@override
String toString() {
  return 'HttpResponseModel(statusCode: $statusCode, headers: $headers, requestHeaders: $requestHeaders, body: $body, formattedBody: $formattedBody, bodyBytes: $bodyBytes, time: $time, sseOutput: $sseOutput)';
}


}

/// @nodoc
abstract mixin class _$HttpResponseModelCopyWith<$Res> implements $HttpResponseModelCopyWith<$Res> {
  factory _$HttpResponseModelCopyWith(_HttpResponseModel value, $Res Function(_HttpResponseModel) _then) = __$HttpResponseModelCopyWithImpl;
@override @useResult
$Res call({
 int? statusCode, Map<String, String>? headers, Map<String, String>? requestHeaders, String? body, String? formattedBody,@Uint8ListConverter() Uint8List? bodyBytes,@DurationConverter() Duration? time, List<String>? sseOutput
});




}
/// @nodoc
class __$HttpResponseModelCopyWithImpl<$Res>
    implements _$HttpResponseModelCopyWith<$Res> {
  __$HttpResponseModelCopyWithImpl(this._self, this._then);

  final _HttpResponseModel _self;
  final $Res Function(_HttpResponseModel) _then;

/// Create a copy of HttpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,Object? headers = freezed,Object? requestHeaders = freezed,Object? body = freezed,Object? formattedBody = freezed,Object? bodyBytes = freezed,Object? time = freezed,Object? sseOutput = freezed,}) {
  return _then(_HttpResponseModel(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,requestHeaders: freezed == requestHeaders ? _self._requestHeaders : requestHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,formattedBody: freezed == formattedBody ? _self.formattedBody : formattedBody // ignore: cast_nullable_to_non_nullable
as String?,bodyBytes: freezed == bodyBytes ? _self.bodyBytes : bodyBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as Duration?,sseOutput: freezed == sseOutput ? _self._sseOutput : sseOutput // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
