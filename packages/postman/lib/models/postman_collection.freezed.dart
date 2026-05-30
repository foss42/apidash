// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'postman_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostmanCollection {

 Info? get info; List<Item>? get item; Auth? get auth; List<Variable>? get variable;
/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostmanCollectionCopyWith<PostmanCollection> get copyWith => _$PostmanCollectionCopyWithImpl<PostmanCollection>(this as PostmanCollection, _$identity);

  /// Serializes this PostmanCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostmanCollection&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other.item, item)&&(identical(other.auth, auth) || other.auth == auth)&&const DeepCollectionEquality().equals(other.variable, variable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(item),auth,const DeepCollectionEquality().hash(variable));

@override
String toString() {
  return 'PostmanCollection(info: $info, item: $item, auth: $auth, variable: $variable)';
}


}

/// @nodoc
abstract mixin class $PostmanCollectionCopyWith<$Res>  {
  factory $PostmanCollectionCopyWith(PostmanCollection value, $Res Function(PostmanCollection) _then) = _$PostmanCollectionCopyWithImpl;
@useResult
$Res call({
 Info? info, List<Item>? item, Auth? auth, List<Variable>? variable
});


$InfoCopyWith<$Res>? get info;$AuthCopyWith<$Res>? get auth;

}
/// @nodoc
class _$PostmanCollectionCopyWithImpl<$Res>
    implements $PostmanCollectionCopyWith<$Res> {
  _$PostmanCollectionCopyWithImpl(this._self, this._then);

  final PostmanCollection _self;
  final $Res Function(PostmanCollection) _then;

/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? info = freezed,Object? item = freezed,Object? auth = freezed,Object? variable = freezed,}) {
  return _then(_self.copyWith(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as List<Item>?,auth: freezed == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as Auth?,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as List<Variable>?,
  ));
}
/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCopyWith<$Res>? get auth {
    if (_self.auth == null) {
    return null;
  }

  return $AuthCopyWith<$Res>(_self.auth!, (value) {
    return _then(_self.copyWith(auth: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostmanCollection].
extension PostmanCollectionPatterns on PostmanCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostmanCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostmanCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostmanCollection value)  $default,){
final _that = this;
switch (_that) {
case _PostmanCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostmanCollection value)?  $default,){
final _that = this;
switch (_that) {
case _PostmanCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Info? info,  List<Item>? item,  Auth? auth,  List<Variable>? variable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostmanCollection() when $default != null:
return $default(_that.info,_that.item,_that.auth,_that.variable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Info? info,  List<Item>? item,  Auth? auth,  List<Variable>? variable)  $default,) {final _that = this;
switch (_that) {
case _PostmanCollection():
return $default(_that.info,_that.item,_that.auth,_that.variable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Info? info,  List<Item>? item,  Auth? auth,  List<Variable>? variable)?  $default,) {final _that = this;
switch (_that) {
case _PostmanCollection() when $default != null:
return $default(_that.info,_that.item,_that.auth,_that.variable);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _PostmanCollection implements PostmanCollection {
  const _PostmanCollection({this.info, final  List<Item>? item, this.auth, final  List<Variable>? variable}): _item = item,_variable = variable;
  factory _PostmanCollection.fromJson(Map<String, dynamic> json) => _$PostmanCollectionFromJson(json);

@override final  Info? info;
 final  List<Item>? _item;
@override List<Item>? get item {
  final value = _item;
  if (value == null) return null;
  if (_item is EqualUnmodifiableListView) return _item;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Auth? auth;
 final  List<Variable>? _variable;
@override List<Variable>? get variable {
  final value = _variable;
  if (value == null) return null;
  if (_variable is EqualUnmodifiableListView) return _variable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostmanCollectionCopyWith<_PostmanCollection> get copyWith => __$PostmanCollectionCopyWithImpl<_PostmanCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostmanCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostmanCollection&&(identical(other.info, info) || other.info == info)&&const DeepCollectionEquality().equals(other._item, _item)&&(identical(other.auth, auth) || other.auth == auth)&&const DeepCollectionEquality().equals(other._variable, _variable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,info,const DeepCollectionEquality().hash(_item),auth,const DeepCollectionEquality().hash(_variable));

@override
String toString() {
  return 'PostmanCollection(info: $info, item: $item, auth: $auth, variable: $variable)';
}


}

/// @nodoc
abstract mixin class _$PostmanCollectionCopyWith<$Res> implements $PostmanCollectionCopyWith<$Res> {
  factory _$PostmanCollectionCopyWith(_PostmanCollection value, $Res Function(_PostmanCollection) _then) = __$PostmanCollectionCopyWithImpl;
@override @useResult
$Res call({
 Info? info, List<Item>? item, Auth? auth, List<Variable>? variable
});


@override $InfoCopyWith<$Res>? get info;@override $AuthCopyWith<$Res>? get auth;

}
/// @nodoc
class __$PostmanCollectionCopyWithImpl<$Res>
    implements _$PostmanCollectionCopyWith<$Res> {
  __$PostmanCollectionCopyWithImpl(this._self, this._then);

  final _PostmanCollection _self;
  final $Res Function(_PostmanCollection) _then;

/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? info = freezed,Object? item = freezed,Object? auth = freezed,Object? variable = freezed,}) {
  return _then(_PostmanCollection(
info: freezed == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as Info?,item: freezed == item ? _self._item : item // ignore: cast_nullable_to_non_nullable
as List<Item>?,auth: freezed == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as Auth?,variable: freezed == variable ? _self._variable : variable // ignore: cast_nullable_to_non_nullable
as List<Variable>?,
  ));
}

/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InfoCopyWith<$Res>? get info {
    if (_self.info == null) {
    return null;
  }

  return $InfoCopyWith<$Res>(_self.info!, (value) {
    return _then(_self.copyWith(info: value));
  });
}/// Create a copy of PostmanCollection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCopyWith<$Res>? get auth {
    if (_self.auth == null) {
    return null;
  }

  return $AuthCopyWith<$Res>(_self.auth!, (value) {
    return _then(_self.copyWith(auth: value));
  });
}
}


/// @nodoc
mixin _$Info {

@JsonKey(name: '_postman_id') String? get postmanId; String? get name; String? get schema;@JsonKey(name: '_exporter_id') String? get exporterId;
/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfoCopyWith<Info> get copyWith => _$InfoCopyWithImpl<Info>(this as Info, _$identity);

  /// Serializes this Info to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Info&&(identical(other.postmanId, postmanId) || other.postmanId == postmanId)&&(identical(other.name, name) || other.name == name)&&(identical(other.schema, schema) || other.schema == schema)&&(identical(other.exporterId, exporterId) || other.exporterId == exporterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postmanId,name,schema,exporterId);

@override
String toString() {
  return 'Info(postmanId: $postmanId, name: $name, schema: $schema, exporterId: $exporterId)';
}


}

/// @nodoc
abstract mixin class $InfoCopyWith<$Res>  {
  factory $InfoCopyWith(Info value, $Res Function(Info) _then) = _$InfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_postman_id') String? postmanId, String? name, String? schema,@JsonKey(name: '_exporter_id') String? exporterId
});




}
/// @nodoc
class _$InfoCopyWithImpl<$Res>
    implements $InfoCopyWith<$Res> {
  _$InfoCopyWithImpl(this._self, this._then);

  final Info _self;
  final $Res Function(Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postmanId = freezed,Object? name = freezed,Object? schema = freezed,Object? exporterId = freezed,}) {
  return _then(_self.copyWith(
postmanId: freezed == postmanId ? _self.postmanId : postmanId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,schema: freezed == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as String?,exporterId: freezed == exporterId ? _self.exporterId : exporterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Info].
extension InfoPatterns on Info {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Info value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Info() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Info value)  $default,){
final _that = this;
switch (_that) {
case _Info():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Info value)?  $default,){
final _that = this;
switch (_that) {
case _Info() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_postman_id')  String? postmanId,  String? name,  String? schema, @JsonKey(name: '_exporter_id')  String? exporterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.postmanId,_that.name,_that.schema,_that.exporterId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_postman_id')  String? postmanId,  String? name,  String? schema, @JsonKey(name: '_exporter_id')  String? exporterId)  $default,) {final _that = this;
switch (_that) {
case _Info():
return $default(_that.postmanId,_that.name,_that.schema,_that.exporterId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_postman_id')  String? postmanId,  String? name,  String? schema, @JsonKey(name: '_exporter_id')  String? exporterId)?  $default,) {final _that = this;
switch (_that) {
case _Info() when $default != null:
return $default(_that.postmanId,_that.name,_that.schema,_that.exporterId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Info implements Info {
  const _Info({@JsonKey(name: '_postman_id') this.postmanId, this.name, this.schema, @JsonKey(name: '_exporter_id') this.exporterId});
  factory _Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

@override@JsonKey(name: '_postman_id') final  String? postmanId;
@override final  String? name;
@override final  String? schema;
@override@JsonKey(name: '_exporter_id') final  String? exporterId;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfoCopyWith<_Info> get copyWith => __$InfoCopyWithImpl<_Info>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Info&&(identical(other.postmanId, postmanId) || other.postmanId == postmanId)&&(identical(other.name, name) || other.name == name)&&(identical(other.schema, schema) || other.schema == schema)&&(identical(other.exporterId, exporterId) || other.exporterId == exporterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postmanId,name,schema,exporterId);

@override
String toString() {
  return 'Info(postmanId: $postmanId, name: $name, schema: $schema, exporterId: $exporterId)';
}


}

/// @nodoc
abstract mixin class _$InfoCopyWith<$Res> implements $InfoCopyWith<$Res> {
  factory _$InfoCopyWith(_Info value, $Res Function(_Info) _then) = __$InfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_postman_id') String? postmanId, String? name, String? schema,@JsonKey(name: '_exporter_id') String? exporterId
});




}
/// @nodoc
class __$InfoCopyWithImpl<$Res>
    implements _$InfoCopyWith<$Res> {
  __$InfoCopyWithImpl(this._self, this._then);

  final _Info _self;
  final $Res Function(_Info) _then;

/// Create a copy of Info
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postmanId = freezed,Object? name = freezed,Object? schema = freezed,Object? exporterId = freezed,}) {
  return _then(_Info(
postmanId: freezed == postmanId ? _self.postmanId : postmanId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,schema: freezed == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as String?,exporterId: freezed == exporterId ? _self.exporterId : exporterId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Item {

 String? get name; List<Item>? get item; Request? get request; List<dynamic>? get response;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.item, item)&&(identical(other.request, request) || other.request == request)&&const DeepCollectionEquality().equals(other.response, response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(item),request,const DeepCollectionEquality().hash(response));

@override
String toString() {
  return 'Item(name: $name, item: $item, request: $request, response: $response)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String? name, List<Item>? item, Request? request, List<dynamic>? response
});


$RequestCopyWith<$Res>? get request;

}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? item = freezed,Object? request = freezed,Object? response = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as List<Item>?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as Request?,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}
/// Create a copy of Item
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
}
}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  List<Item>? item,  Request? request,  List<dynamic>? response)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.item,_that.request,_that.response);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  List<Item>? item,  Request? request,  List<dynamic>? response)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.name,_that.item,_that.request,_that.response);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  List<Item>? item,  Request? request,  List<dynamic>? response)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.name,_that.item,_that.request,_that.response);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Item implements Item {
  const _Item({this.name, final  List<Item>? item, this.request, final  List<dynamic>? response}): _item = item,_response = response;
  factory _Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

@override final  String? name;
 final  List<Item>? _item;
@override List<Item>? get item {
  final value = _item;
  if (value == null) return null;
  if (_item is EqualUnmodifiableListView) return _item;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Request? request;
 final  List<dynamic>? _response;
@override List<dynamic>? get response {
  final value = _response;
  if (value == null) return null;
  if (_response is EqualUnmodifiableListView) return _response;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._item, _item)&&(identical(other.request, request) || other.request == request)&&const DeepCollectionEquality().equals(other._response, _response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_item),request,const DeepCollectionEquality().hash(_response));

@override
String toString() {
  return 'Item(name: $name, item: $item, request: $request, response: $response)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 String? name, List<Item>? item, Request? request, List<dynamic>? response
});


@override $RequestCopyWith<$Res>? get request;

}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? item = freezed,Object? request = freezed,Object? response = freezed,}) {
  return _then(_Item(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,item: freezed == item ? _self._item : item // ignore: cast_nullable_to_non_nullable
as List<Item>?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as Request?,response: freezed == response ? _self._response : response // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,
  ));
}

/// Create a copy of Item
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
}
}


/// @nodoc
mixin _$Request {

 String? get method; List<Header>? get header; Body? get body; Url? get url; Auth? get auth;
/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestCopyWith<Request> get copyWith => _$RequestCopyWithImpl<Request>(this as Request, _$identity);

  /// Serializes this Request to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Request&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.header, header)&&(identical(other.body, body) || other.body == body)&&(identical(other.url, url) || other.url == url)&&(identical(other.auth, auth) || other.auth == auth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(header),body,url,auth);

@override
String toString() {
  return 'Request(method: $method, header: $header, body: $body, url: $url, auth: $auth)';
}


}

/// @nodoc
abstract mixin class $RequestCopyWith<$Res>  {
  factory $RequestCopyWith(Request value, $Res Function(Request) _then) = _$RequestCopyWithImpl;
@useResult
$Res call({
 String? method, List<Header>? header, Body? body, Url? url, Auth? auth
});


$BodyCopyWith<$Res>? get body;$UrlCopyWith<$Res>? get url;$AuthCopyWith<$Res>? get auth;

}
/// @nodoc
class _$RequestCopyWithImpl<$Res>
    implements $RequestCopyWith<$Res> {
  _$RequestCopyWithImpl(this._self, this._then);

  final Request _self;
  final $Res Function(Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = freezed,Object? header = freezed,Object? body = freezed,Object? url = freezed,Object? auth = freezed,}) {
  return _then(_self.copyWith(
method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as List<Header>?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Body?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Url?,auth: freezed == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as Auth?,
  ));
}
/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $BodyCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UrlCopyWith<$Res>? get url {
    if (_self.url == null) {
    return null;
  }

  return $UrlCopyWith<$Res>(_self.url!, (value) {
    return _then(_self.copyWith(url: value));
  });
}/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCopyWith<$Res>? get auth {
    if (_self.auth == null) {
    return null;
  }

  return $AuthCopyWith<$Res>(_self.auth!, (value) {
    return _then(_self.copyWith(auth: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? method,  List<Header>? header,  Body? body,  Url? url,  Auth? auth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that.method,_that.header,_that.body,_that.url,_that.auth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? method,  List<Header>? header,  Body? body,  Url? url,  Auth? auth)  $default,) {final _that = this;
switch (_that) {
case _Request():
return $default(_that.method,_that.header,_that.body,_that.url,_that.auth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? method,  List<Header>? header,  Body? body,  Url? url,  Auth? auth)?  $default,) {final _that = this;
switch (_that) {
case _Request() when $default != null:
return $default(_that.method,_that.header,_that.body,_that.url,_that.auth);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Request implements Request {
  const _Request({this.method, final  List<Header>? header, this.body, this.url, this.auth}): _header = header;
  factory _Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

@override final  String? method;
 final  List<Header>? _header;
@override List<Header>? get header {
  final value = _header;
  if (value == null) return null;
  if (_header is EqualUnmodifiableListView) return _header;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Body? body;
@override final  Url? url;
@override final  Auth? auth;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Request&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._header, _header)&&(identical(other.body, body) || other.body == body)&&(identical(other.url, url) || other.url == url)&&(identical(other.auth, auth) || other.auth == auth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(_header),body,url,auth);

@override
String toString() {
  return 'Request(method: $method, header: $header, body: $body, url: $url, auth: $auth)';
}


}

/// @nodoc
abstract mixin class _$RequestCopyWith<$Res> implements $RequestCopyWith<$Res> {
  factory _$RequestCopyWith(_Request value, $Res Function(_Request) _then) = __$RequestCopyWithImpl;
@override @useResult
$Res call({
 String? method, List<Header>? header, Body? body, Url? url, Auth? auth
});


@override $BodyCopyWith<$Res>? get body;@override $UrlCopyWith<$Res>? get url;@override $AuthCopyWith<$Res>? get auth;

}
/// @nodoc
class __$RequestCopyWithImpl<$Res>
    implements _$RequestCopyWith<$Res> {
  __$RequestCopyWithImpl(this._self, this._then);

  final _Request _self;
  final $Res Function(_Request) _then;

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = freezed,Object? header = freezed,Object? body = freezed,Object? url = freezed,Object? auth = freezed,}) {
  return _then(_Request(
method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self._header : header // ignore: cast_nullable_to_non_nullable
as List<Header>?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as Body?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Url?,auth: freezed == auth ? _self.auth : auth // ignore: cast_nullable_to_non_nullable
as Auth?,
  ));
}

/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BodyCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $BodyCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UrlCopyWith<$Res>? get url {
    if (_self.url == null) {
    return null;
  }

  return $UrlCopyWith<$Res>(_self.url!, (value) {
    return _then(_self.copyWith(url: value));
  });
}/// Create a copy of Request
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthCopyWith<$Res>? get auth {
    if (_self.auth == null) {
    return null;
  }

  return $AuthCopyWith<$Res>(_self.auth!, (value) {
    return _then(_self.copyWith(auth: value));
  });
}
}


/// @nodoc
mixin _$Header {

 String? get key; String? get value; String? get type; bool? get disabled;
/// Create a copy of Header
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeaderCopyWith<Header> get copyWith => _$HeaderCopyWithImpl<Header>(this as Header, _$identity);

  /// Serializes this Header to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Header&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'Header(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $HeaderCopyWith<$Res>  {
  factory $HeaderCopyWith(Header value, $Res Function(Header) _then) = _$HeaderCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
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
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Header():
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Header() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Header implements Header {
  const _Header({this.key, this.value, this.type, this.disabled});
  factory _Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);

@override final  String? key;
@override final  String? value;
@override final  String? type;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Header&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'Header(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$HeaderCopyWith<$Res> implements $HeaderCopyWith<$Res> {
  factory _$HeaderCopyWith(_Header value, $Res Function(_Header) _then) = __$HeaderCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
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
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_Header(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Url {

 String? get raw; String? get protocol; List<String>? get host; List<String>? get path; List<Query>? get query;
/// Create a copy of Url
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlCopyWith<Url> get copyWith => _$UrlCopyWithImpl<Url>(this as Url, _$identity);

  /// Serializes this Url to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Url&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&const DeepCollectionEquality().equals(other.host, host)&&const DeepCollectionEquality().equals(other.path, path)&&const DeepCollectionEquality().equals(other.query, query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,raw,protocol,const DeepCollectionEquality().hash(host),const DeepCollectionEquality().hash(path),const DeepCollectionEquality().hash(query));

@override
String toString() {
  return 'Url(raw: $raw, protocol: $protocol, host: $host, path: $path, query: $query)';
}


}

/// @nodoc
abstract mixin class $UrlCopyWith<$Res>  {
  factory $UrlCopyWith(Url value, $Res Function(Url) _then) = _$UrlCopyWithImpl;
@useResult
$Res call({
 String? raw, String? protocol, List<String>? host, List<String>? path, List<Query>? query
});




}
/// @nodoc
class _$UrlCopyWithImpl<$Res>
    implements $UrlCopyWith<$Res> {
  _$UrlCopyWithImpl(this._self, this._then);

  final Url _self;
  final $Res Function(Url) _then;

/// Create a copy of Url
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? raw = freezed,Object? protocol = freezed,Object? host = freezed,Object? path = freezed,Object? query = freezed,}) {
  return _then(_self.copyWith(
raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as List<String>?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<String>?,query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as List<Query>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Url].
extension UrlPatterns on Url {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Url value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Url() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Url value)  $default,){
final _that = this;
switch (_that) {
case _Url():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Url value)?  $default,){
final _that = this;
switch (_that) {
case _Url() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? raw,  String? protocol,  List<String>? host,  List<String>? path,  List<Query>? query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Url() when $default != null:
return $default(_that.raw,_that.protocol,_that.host,_that.path,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? raw,  String? protocol,  List<String>? host,  List<String>? path,  List<Query>? query)  $default,) {final _that = this;
switch (_that) {
case _Url():
return $default(_that.raw,_that.protocol,_that.host,_that.path,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? raw,  String? protocol,  List<String>? host,  List<String>? path,  List<Query>? query)?  $default,) {final _that = this;
switch (_that) {
case _Url() when $default != null:
return $default(_that.raw,_that.protocol,_that.host,_that.path,_that.query);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Url implements Url {
  const _Url({this.raw, this.protocol, final  List<String>? host, final  List<String>? path, final  List<Query>? query}): _host = host,_path = path,_query = query;
  factory _Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

@override final  String? raw;
@override final  String? protocol;
 final  List<String>? _host;
@override List<String>? get host {
  final value = _host;
  if (value == null) return null;
  if (_host is EqualUnmodifiableListView) return _host;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _path;
@override List<String>? get path {
  final value = _path;
  if (value == null) return null;
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Query>? _query;
@override List<Query>? get query {
  final value = _query;
  if (value == null) return null;
  if (_query is EqualUnmodifiableListView) return _query;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Url
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrlCopyWith<_Url> get copyWith => __$UrlCopyWithImpl<_Url>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrlToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Url&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&const DeepCollectionEquality().equals(other._host, _host)&&const DeepCollectionEquality().equals(other._path, _path)&&const DeepCollectionEquality().equals(other._query, _query));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,raw,protocol,const DeepCollectionEquality().hash(_host),const DeepCollectionEquality().hash(_path),const DeepCollectionEquality().hash(_query));

@override
String toString() {
  return 'Url(raw: $raw, protocol: $protocol, host: $host, path: $path, query: $query)';
}


}

/// @nodoc
abstract mixin class _$UrlCopyWith<$Res> implements $UrlCopyWith<$Res> {
  factory _$UrlCopyWith(_Url value, $Res Function(_Url) _then) = __$UrlCopyWithImpl;
@override @useResult
$Res call({
 String? raw, String? protocol, List<String>? host, List<String>? path, List<Query>? query
});




}
/// @nodoc
class __$UrlCopyWithImpl<$Res>
    implements _$UrlCopyWith<$Res> {
  __$UrlCopyWithImpl(this._self, this._then);

  final _Url _self;
  final $Res Function(_Url) _then;

/// Create a copy of Url
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? raw = freezed,Object? protocol = freezed,Object? host = freezed,Object? path = freezed,Object? query = freezed,}) {
  return _then(_Url(
raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String?,protocol: freezed == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self._host : host // ignore: cast_nullable_to_non_nullable
as List<String>?,path: freezed == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<String>?,query: freezed == query ? _self._query : query // ignore: cast_nullable_to_non_nullable
as List<Query>?,
  ));
}


}


/// @nodoc
mixin _$Query {

 String? get key; String? get value; bool? get disabled;
/// Create a copy of Query
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCopyWith<Query> get copyWith => _$QueryCopyWithImpl<Query>(this as Query, _$identity);

  /// Serializes this Query to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Query&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,disabled);

@override
String toString() {
  return 'Query(key: $key, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $QueryCopyWith<$Res>  {
  factory $QueryCopyWith(Query value, $Res Function(Query) _then) = _$QueryCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, bool? disabled
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
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that.key,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Query():
return $default(_that.key,_that.value,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Query() when $default != null:
return $default(_that.key,_that.value,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Query implements Query {
  const _Query({this.key, this.value, this.disabled});
  factory _Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);

@override final  String? key;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Query&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,disabled);

@override
String toString() {
  return 'Query(key: $key, value: $value, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$QueryCopyWith<$Res> implements $QueryCopyWith<$Res> {
  factory _$QueryCopyWith(_Query value, $Res Function(_Query) _then) = __$QueryCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, bool? disabled
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
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? disabled = freezed,}) {
  return _then(_Query(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Body {

 String? get mode; String? get raw; Options? get options; List<Formdatum>? get formdata; List<Urlencoded>? get urlencoded;
/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BodyCopyWith<Body> get copyWith => _$BodyCopyWithImpl<Body>(this as Body, _$identity);

  /// Serializes this Body to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Body&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other.formdata, formdata)&&const DeepCollectionEquality().equals(other.urlencoded, urlencoded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,raw,options,const DeepCollectionEquality().hash(formdata),const DeepCollectionEquality().hash(urlencoded));

@override
String toString() {
  return 'Body(mode: $mode, raw: $raw, options: $options, formdata: $formdata, urlencoded: $urlencoded)';
}


}

/// @nodoc
abstract mixin class $BodyCopyWith<$Res>  {
  factory $BodyCopyWith(Body value, $Res Function(Body) _then) = _$BodyCopyWithImpl;
@useResult
$Res call({
 String? mode, String? raw, Options? options, List<Formdatum>? formdata, List<Urlencoded>? urlencoded
});


$OptionsCopyWith<$Res>? get options;

}
/// @nodoc
class _$BodyCopyWithImpl<$Res>
    implements $BodyCopyWith<$Res> {
  _$BodyCopyWithImpl(this._self, this._then);

  final Body _self;
  final $Res Function(Body) _then;

/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = freezed,Object? raw = freezed,Object? options = freezed,Object? formdata = freezed,Object? urlencoded = freezed,}) {
  return _then(_self.copyWith(
mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Options?,formdata: freezed == formdata ? _self.formdata : formdata // ignore: cast_nullable_to_non_nullable
as List<Formdatum>?,urlencoded: freezed == urlencoded ? _self.urlencoded : urlencoded // ignore: cast_nullable_to_non_nullable
as List<Urlencoded>?,
  ));
}
/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptionsCopyWith<$Res>? get options {
    if (_self.options == null) {
    return null;
  }

  return $OptionsCopyWith<$Res>(_self.options!, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// Adds pattern-matching-related methods to [Body].
extension BodyPatterns on Body {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Body value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Body() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Body value)  $default,){
final _that = this;
switch (_that) {
case _Body():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Body value)?  $default,){
final _that = this;
switch (_that) {
case _Body() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? mode,  String? raw,  Options? options,  List<Formdatum>? formdata,  List<Urlencoded>? urlencoded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Body() when $default != null:
return $default(_that.mode,_that.raw,_that.options,_that.formdata,_that.urlencoded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? mode,  String? raw,  Options? options,  List<Formdatum>? formdata,  List<Urlencoded>? urlencoded)  $default,) {final _that = this;
switch (_that) {
case _Body():
return $default(_that.mode,_that.raw,_that.options,_that.formdata,_that.urlencoded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? mode,  String? raw,  Options? options,  List<Formdatum>? formdata,  List<Urlencoded>? urlencoded)?  $default,) {final _that = this;
switch (_that) {
case _Body() when $default != null:
return $default(_that.mode,_that.raw,_that.options,_that.formdata,_that.urlencoded);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Body implements Body {
  const _Body({this.mode, this.raw, this.options, final  List<Formdatum>? formdata, final  List<Urlencoded>? urlencoded}): _formdata = formdata,_urlencoded = urlencoded;
  factory _Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);

@override final  String? mode;
@override final  String? raw;
@override final  Options? options;
 final  List<Formdatum>? _formdata;
@override List<Formdatum>? get formdata {
  final value = _formdata;
  if (value == null) return null;
  if (_formdata is EqualUnmodifiableListView) return _formdata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Urlencoded>? _urlencoded;
@override List<Urlencoded>? get urlencoded {
  final value = _urlencoded;
  if (value == null) return null;
  if (_urlencoded is EqualUnmodifiableListView) return _urlencoded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BodyCopyWith<_Body> get copyWith => __$BodyCopyWithImpl<_Body>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BodyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Body&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.raw, raw) || other.raw == raw)&&(identical(other.options, options) || other.options == options)&&const DeepCollectionEquality().equals(other._formdata, _formdata)&&const DeepCollectionEquality().equals(other._urlencoded, _urlencoded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,raw,options,const DeepCollectionEquality().hash(_formdata),const DeepCollectionEquality().hash(_urlencoded));

@override
String toString() {
  return 'Body(mode: $mode, raw: $raw, options: $options, formdata: $formdata, urlencoded: $urlencoded)';
}


}

/// @nodoc
abstract mixin class _$BodyCopyWith<$Res> implements $BodyCopyWith<$Res> {
  factory _$BodyCopyWith(_Body value, $Res Function(_Body) _then) = __$BodyCopyWithImpl;
@override @useResult
$Res call({
 String? mode, String? raw, Options? options, List<Formdatum>? formdata, List<Urlencoded>? urlencoded
});


@override $OptionsCopyWith<$Res>? get options;

}
/// @nodoc
class __$BodyCopyWithImpl<$Res>
    implements _$BodyCopyWith<$Res> {
  __$BodyCopyWithImpl(this._self, this._then);

  final _Body _self;
  final $Res Function(_Body) _then;

/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = freezed,Object? raw = freezed,Object? options = freezed,Object? formdata = freezed,Object? urlencoded = freezed,}) {
  return _then(_Body(
mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as String?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Options?,formdata: freezed == formdata ? _self._formdata : formdata // ignore: cast_nullable_to_non_nullable
as List<Formdatum>?,urlencoded: freezed == urlencoded ? _self._urlencoded : urlencoded // ignore: cast_nullable_to_non_nullable
as List<Urlencoded>?,
  ));
}

/// Create a copy of Body
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OptionsCopyWith<$Res>? get options {
    if (_self.options == null) {
    return null;
  }

  return $OptionsCopyWith<$Res>(_self.options!, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// @nodoc
mixin _$Options {

 Raw? get raw;
/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionsCopyWith<Options> get copyWith => _$OptionsCopyWithImpl<Options>(this as Options, _$identity);

  /// Serializes this Options to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Options&&(identical(other.raw, raw) || other.raw == raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,raw);

@override
String toString() {
  return 'Options(raw: $raw)';
}


}

/// @nodoc
abstract mixin class $OptionsCopyWith<$Res>  {
  factory $OptionsCopyWith(Options value, $Res Function(Options) _then) = _$OptionsCopyWithImpl;
@useResult
$Res call({
 Raw? raw
});


$RawCopyWith<$Res>? get raw;

}
/// @nodoc
class _$OptionsCopyWithImpl<$Res>
    implements $OptionsCopyWith<$Res> {
  _$OptionsCopyWithImpl(this._self, this._then);

  final Options _self;
  final $Res Function(Options) _then;

/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? raw = freezed,}) {
  return _then(_self.copyWith(
raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Raw?,
  ));
}
/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RawCopyWith<$Res>? get raw {
    if (_self.raw == null) {
    return null;
  }

  return $RawCopyWith<$Res>(_self.raw!, (value) {
    return _then(_self.copyWith(raw: value));
  });
}
}


/// Adds pattern-matching-related methods to [Options].
extension OptionsPatterns on Options {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Options value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Options() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Options value)  $default,){
final _that = this;
switch (_that) {
case _Options():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Options value)?  $default,){
final _that = this;
switch (_that) {
case _Options() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Raw? raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Options() when $default != null:
return $default(_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Raw? raw)  $default,) {final _that = this;
switch (_that) {
case _Options():
return $default(_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Raw? raw)?  $default,) {final _that = this;
switch (_that) {
case _Options() when $default != null:
return $default(_that.raw);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Options implements Options {
  const _Options({this.raw});
  factory _Options.fromJson(Map<String, dynamic> json) => _$OptionsFromJson(json);

@override final  Raw? raw;

/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionsCopyWith<_Options> get copyWith => __$OptionsCopyWithImpl<_Options>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Options&&(identical(other.raw, raw) || other.raw == raw));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,raw);

@override
String toString() {
  return 'Options(raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$OptionsCopyWith<$Res> implements $OptionsCopyWith<$Res> {
  factory _$OptionsCopyWith(_Options value, $Res Function(_Options) _then) = __$OptionsCopyWithImpl;
@override @useResult
$Res call({
 Raw? raw
});


@override $RawCopyWith<$Res>? get raw;

}
/// @nodoc
class __$OptionsCopyWithImpl<$Res>
    implements _$OptionsCopyWith<$Res> {
  __$OptionsCopyWithImpl(this._self, this._then);

  final _Options _self;
  final $Res Function(_Options) _then;

/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? raw = freezed,}) {
  return _then(_Options(
raw: freezed == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Raw?,
  ));
}

/// Create a copy of Options
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RawCopyWith<$Res>? get raw {
    if (_self.raw == null) {
    return null;
  }

  return $RawCopyWith<$Res>(_self.raw!, (value) {
    return _then(_self.copyWith(raw: value));
  });
}
}


/// @nodoc
mixin _$Raw {

 String? get language;
/// Create a copy of Raw
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawCopyWith<Raw> get copyWith => _$RawCopyWithImpl<Raw>(this as Raw, _$identity);

  /// Serializes this Raw to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Raw&&(identical(other.language, language) || other.language == language));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language);

@override
String toString() {
  return 'Raw(language: $language)';
}


}

/// @nodoc
abstract mixin class $RawCopyWith<$Res>  {
  factory $RawCopyWith(Raw value, $Res Function(Raw) _then) = _$RawCopyWithImpl;
@useResult
$Res call({
 String? language
});




}
/// @nodoc
class _$RawCopyWithImpl<$Res>
    implements $RawCopyWith<$Res> {
  _$RawCopyWithImpl(this._self, this._then);

  final Raw _self;
  final $Res Function(Raw) _then;

/// Create a copy of Raw
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? language = freezed,}) {
  return _then(_self.copyWith(
language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Raw].
extension RawPatterns on Raw {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Raw value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Raw() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Raw value)  $default,){
final _that = this;
switch (_that) {
case _Raw():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Raw value)?  $default,){
final _that = this;
switch (_that) {
case _Raw() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Raw() when $default != null:
return $default(_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? language)  $default,) {final _that = this;
switch (_that) {
case _Raw():
return $default(_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? language)?  $default,) {final _that = this;
switch (_that) {
case _Raw() when $default != null:
return $default(_that.language);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Raw implements Raw {
  const _Raw({this.language});
  factory _Raw.fromJson(Map<String, dynamic> json) => _$RawFromJson(json);

@override final  String? language;

/// Create a copy of Raw
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RawCopyWith<_Raw> get copyWith => __$RawCopyWithImpl<_Raw>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Raw&&(identical(other.language, language) || other.language == language));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,language);

@override
String toString() {
  return 'Raw(language: $language)';
}


}

/// @nodoc
abstract mixin class _$RawCopyWith<$Res> implements $RawCopyWith<$Res> {
  factory _$RawCopyWith(_Raw value, $Res Function(_Raw) _then) = __$RawCopyWithImpl;
@override @useResult
$Res call({
 String? language
});




}
/// @nodoc
class __$RawCopyWithImpl<$Res>
    implements _$RawCopyWith<$Res> {
  __$RawCopyWithImpl(this._self, this._then);

  final _Raw _self;
  final $Res Function(_Raw) _then;

/// Create a copy of Raw
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? language = freezed,}) {
  return _then(_Raw(
language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Formdatum {

 String? get key; String? get value; String? get type; String? get src; bool? get disabled;
/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormdatumCopyWith<Formdatum> get copyWith => _$FormdatumCopyWithImpl<Formdatum>(this as Formdatum, _$identity);

  /// Serializes this Formdatum to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Formdatum&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.src, src) || other.src == src)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,src,disabled);

@override
String toString() {
  return 'Formdatum(key: $key, value: $value, type: $type, src: $src, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $FormdatumCopyWith<$Res>  {
  factory $FormdatumCopyWith(Formdatum value, $Res Function(Formdatum) _then) = _$FormdatumCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, String? type, String? src, bool? disabled
});




}
/// @nodoc
class _$FormdatumCopyWithImpl<$Res>
    implements $FormdatumCopyWith<$Res> {
  _$FormdatumCopyWithImpl(this._self, this._then);

  final Formdatum _self;
  final $Res Function(Formdatum) _then;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? src = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,src: freezed == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Formdatum].
extension FormdatumPatterns on Formdatum {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Formdatum value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Formdatum value)  $default,){
final _that = this;
switch (_that) {
case _Formdatum():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Formdatum value)?  $default,){
final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  String? src,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.src,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  String? src,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Formdatum():
return $default(_that.key,_that.value,_that.type,_that.src,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  String? type,  String? src,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Formdatum() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.src,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Formdatum implements Formdatum {
  const _Formdatum({this.key, this.value, this.type, this.src, this.disabled});
  factory _Formdatum.fromJson(Map<String, dynamic> json) => _$FormdatumFromJson(json);

@override final  String? key;
@override final  String? value;
@override final  String? type;
@override final  String? src;
@override final  bool? disabled;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormdatumCopyWith<_Formdatum> get copyWith => __$FormdatumCopyWithImpl<_Formdatum>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormdatumToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Formdatum&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.src, src) || other.src == src)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,src,disabled);

@override
String toString() {
  return 'Formdatum(key: $key, value: $value, type: $type, src: $src, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$FormdatumCopyWith<$Res> implements $FormdatumCopyWith<$Res> {
  factory _$FormdatumCopyWith(_Formdatum value, $Res Function(_Formdatum) _then) = __$FormdatumCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, String? type, String? src, bool? disabled
});




}
/// @nodoc
class __$FormdatumCopyWithImpl<$Res>
    implements _$FormdatumCopyWith<$Res> {
  __$FormdatumCopyWithImpl(this._self, this._then);

  final _Formdatum _self;
  final $Res Function(_Formdatum) _then;

/// Create a copy of Formdatum
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? src = freezed,Object? disabled = freezed,}) {
  return _then(_Formdatum(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,src: freezed == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Auth {

 String? get type; List<AuthKeyValue>? get bearer; List<AuthKeyValue>? get basic; List<AuthKeyValue>? get apikey; List<AuthKeyValue>? get digest; List<AuthKeyValue>? get oauth1; List<AuthKeyValue>? get oauth2;
/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCopyWith<Auth> get copyWith => _$AuthCopyWithImpl<Auth>(this as Auth, _$identity);

  /// Serializes this Auth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Auth&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.bearer, bearer)&&const DeepCollectionEquality().equals(other.basic, basic)&&const DeepCollectionEquality().equals(other.apikey, apikey)&&const DeepCollectionEquality().equals(other.digest, digest)&&const DeepCollectionEquality().equals(other.oauth1, oauth1)&&const DeepCollectionEquality().equals(other.oauth2, oauth2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(bearer),const DeepCollectionEquality().hash(basic),const DeepCollectionEquality().hash(apikey),const DeepCollectionEquality().hash(digest),const DeepCollectionEquality().hash(oauth1),const DeepCollectionEquality().hash(oauth2));

@override
String toString() {
  return 'Auth(type: $type, bearer: $bearer, basic: $basic, apikey: $apikey, digest: $digest, oauth1: $oauth1, oauth2: $oauth2)';
}


}

/// @nodoc
abstract mixin class $AuthCopyWith<$Res>  {
  factory $AuthCopyWith(Auth value, $Res Function(Auth) _then) = _$AuthCopyWithImpl;
@useResult
$Res call({
 String? type, List<AuthKeyValue>? bearer, List<AuthKeyValue>? basic, List<AuthKeyValue>? apikey, List<AuthKeyValue>? digest, List<AuthKeyValue>? oauth1, List<AuthKeyValue>? oauth2
});




}
/// @nodoc
class _$AuthCopyWithImpl<$Res>
    implements $AuthCopyWith<$Res> {
  _$AuthCopyWithImpl(this._self, this._then);

  final Auth _self;
  final $Res Function(Auth) _then;

/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? bearer = freezed,Object? basic = freezed,Object? apikey = freezed,Object? digest = freezed,Object? oauth1 = freezed,Object? oauth2 = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,bearer: freezed == bearer ? _self.bearer : bearer // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,basic: freezed == basic ? _self.basic : basic // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,apikey: freezed == apikey ? _self.apikey : apikey // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,digest: freezed == digest ? _self.digest : digest // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,oauth1: freezed == oauth1 ? _self.oauth1 : oauth1 // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,oauth2: freezed == oauth2 ? _self.oauth2 : oauth2 // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Auth].
extension AuthPatterns on Auth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Auth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Auth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Auth value)  $default,){
final _that = this;
switch (_that) {
case _Auth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Auth value)?  $default,){
final _that = this;
switch (_that) {
case _Auth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  List<AuthKeyValue>? bearer,  List<AuthKeyValue>? basic,  List<AuthKeyValue>? apikey,  List<AuthKeyValue>? digest,  List<AuthKeyValue>? oauth1,  List<AuthKeyValue>? oauth2)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Auth() when $default != null:
return $default(_that.type,_that.bearer,_that.basic,_that.apikey,_that.digest,_that.oauth1,_that.oauth2);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  List<AuthKeyValue>? bearer,  List<AuthKeyValue>? basic,  List<AuthKeyValue>? apikey,  List<AuthKeyValue>? digest,  List<AuthKeyValue>? oauth1,  List<AuthKeyValue>? oauth2)  $default,) {final _that = this;
switch (_that) {
case _Auth():
return $default(_that.type,_that.bearer,_that.basic,_that.apikey,_that.digest,_that.oauth1,_that.oauth2);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  List<AuthKeyValue>? bearer,  List<AuthKeyValue>? basic,  List<AuthKeyValue>? apikey,  List<AuthKeyValue>? digest,  List<AuthKeyValue>? oauth1,  List<AuthKeyValue>? oauth2)?  $default,) {final _that = this;
switch (_that) {
case _Auth() when $default != null:
return $default(_that.type,_that.bearer,_that.basic,_that.apikey,_that.digest,_that.oauth1,_that.oauth2);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Auth implements Auth {
  const _Auth({this.type, final  List<AuthKeyValue>? bearer, final  List<AuthKeyValue>? basic, final  List<AuthKeyValue>? apikey, final  List<AuthKeyValue>? digest, final  List<AuthKeyValue>? oauth1, final  List<AuthKeyValue>? oauth2}): _bearer = bearer,_basic = basic,_apikey = apikey,_digest = digest,_oauth1 = oauth1,_oauth2 = oauth2;
  factory _Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

@override final  String? type;
 final  List<AuthKeyValue>? _bearer;
@override List<AuthKeyValue>? get bearer {
  final value = _bearer;
  if (value == null) return null;
  if (_bearer is EqualUnmodifiableListView) return _bearer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthKeyValue>? _basic;
@override List<AuthKeyValue>? get basic {
  final value = _basic;
  if (value == null) return null;
  if (_basic is EqualUnmodifiableListView) return _basic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthKeyValue>? _apikey;
@override List<AuthKeyValue>? get apikey {
  final value = _apikey;
  if (value == null) return null;
  if (_apikey is EqualUnmodifiableListView) return _apikey;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthKeyValue>? _digest;
@override List<AuthKeyValue>? get digest {
  final value = _digest;
  if (value == null) return null;
  if (_digest is EqualUnmodifiableListView) return _digest;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthKeyValue>? _oauth1;
@override List<AuthKeyValue>? get oauth1 {
  final value = _oauth1;
  if (value == null) return null;
  if (_oauth1 is EqualUnmodifiableListView) return _oauth1;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthKeyValue>? _oauth2;
@override List<AuthKeyValue>? get oauth2 {
  final value = _oauth2;
  if (value == null) return null;
  if (_oauth2 is EqualUnmodifiableListView) return _oauth2;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCopyWith<_Auth> get copyWith => __$AuthCopyWithImpl<_Auth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Auth&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._bearer, _bearer)&&const DeepCollectionEquality().equals(other._basic, _basic)&&const DeepCollectionEquality().equals(other._apikey, _apikey)&&const DeepCollectionEquality().equals(other._digest, _digest)&&const DeepCollectionEquality().equals(other._oauth1, _oauth1)&&const DeepCollectionEquality().equals(other._oauth2, _oauth2));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_bearer),const DeepCollectionEquality().hash(_basic),const DeepCollectionEquality().hash(_apikey),const DeepCollectionEquality().hash(_digest),const DeepCollectionEquality().hash(_oauth1),const DeepCollectionEquality().hash(_oauth2));

@override
String toString() {
  return 'Auth(type: $type, bearer: $bearer, basic: $basic, apikey: $apikey, digest: $digest, oauth1: $oauth1, oauth2: $oauth2)';
}


}

/// @nodoc
abstract mixin class _$AuthCopyWith<$Res> implements $AuthCopyWith<$Res> {
  factory _$AuthCopyWith(_Auth value, $Res Function(_Auth) _then) = __$AuthCopyWithImpl;
@override @useResult
$Res call({
 String? type, List<AuthKeyValue>? bearer, List<AuthKeyValue>? basic, List<AuthKeyValue>? apikey, List<AuthKeyValue>? digest, List<AuthKeyValue>? oauth1, List<AuthKeyValue>? oauth2
});




}
/// @nodoc
class __$AuthCopyWithImpl<$Res>
    implements _$AuthCopyWith<$Res> {
  __$AuthCopyWithImpl(this._self, this._then);

  final _Auth _self;
  final $Res Function(_Auth) _then;

/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? bearer = freezed,Object? basic = freezed,Object? apikey = freezed,Object? digest = freezed,Object? oauth1 = freezed,Object? oauth2 = freezed,}) {
  return _then(_Auth(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,bearer: freezed == bearer ? _self._bearer : bearer // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,basic: freezed == basic ? _self._basic : basic // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,apikey: freezed == apikey ? _self._apikey : apikey // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,digest: freezed == digest ? _self._digest : digest // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,oauth1: freezed == oauth1 ? _self._oauth1 : oauth1 // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,oauth2: freezed == oauth2 ? _self._oauth2 : oauth2 // ignore: cast_nullable_to_non_nullable
as List<AuthKeyValue>?,
  ));
}


}


/// @nodoc
mixin _$AuthKeyValue {

 String? get key; String? get value; String? get type; bool? get disabled;
/// Create a copy of AuthKeyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthKeyValueCopyWith<AuthKeyValue> get copyWith => _$AuthKeyValueCopyWithImpl<AuthKeyValue>(this as AuthKeyValue, _$identity);

  /// Serializes this AuthKeyValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthKeyValue&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'AuthKeyValue(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $AuthKeyValueCopyWith<$Res>  {
  factory $AuthKeyValueCopyWith(AuthKeyValue value, $Res Function(AuthKeyValue) _then) = _$AuthKeyValueCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
});




}
/// @nodoc
class _$AuthKeyValueCopyWithImpl<$Res>
    implements $AuthKeyValueCopyWith<$Res> {
  _$AuthKeyValueCopyWithImpl(this._self, this._then);

  final AuthKeyValue _self;
  final $Res Function(AuthKeyValue) _then;

/// Create a copy of AuthKeyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthKeyValue].
extension AuthKeyValuePatterns on AuthKeyValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthKeyValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthKeyValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthKeyValue value)  $default,){
final _that = this;
switch (_that) {
case _AuthKeyValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthKeyValue value)?  $default,){
final _that = this;
switch (_that) {
case _AuthKeyValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthKeyValue() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _AuthKeyValue():
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _AuthKeyValue() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _AuthKeyValue implements AuthKeyValue {
  const _AuthKeyValue({this.key, this.value, this.type, this.disabled});
  factory _AuthKeyValue.fromJson(Map<String, dynamic> json) => _$AuthKeyValueFromJson(json);

@override final  String? key;
@override final  String? value;
@override final  String? type;
@override final  bool? disabled;

/// Create a copy of AuthKeyValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthKeyValueCopyWith<_AuthKeyValue> get copyWith => __$AuthKeyValueCopyWithImpl<_AuthKeyValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthKeyValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthKeyValue&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'AuthKeyValue(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$AuthKeyValueCopyWith<$Res> implements $AuthKeyValueCopyWith<$Res> {
  factory _$AuthKeyValueCopyWith(_AuthKeyValue value, $Res Function(_AuthKeyValue) _then) = __$AuthKeyValueCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
});




}
/// @nodoc
class __$AuthKeyValueCopyWithImpl<$Res>
    implements _$AuthKeyValueCopyWith<$Res> {
  __$AuthKeyValueCopyWithImpl(this._self, this._then);

  final _AuthKeyValue _self;
  final $Res Function(_AuthKeyValue) _then;

/// Create a copy of AuthKeyValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_AuthKeyValue(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Urlencoded {

 String? get key; String? get value; String? get type; bool? get disabled;
/// Create a copy of Urlencoded
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlencodedCopyWith<Urlencoded> get copyWith => _$UrlencodedCopyWithImpl<Urlencoded>(this as Urlencoded, _$identity);

  /// Serializes this Urlencoded to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Urlencoded&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'Urlencoded(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $UrlencodedCopyWith<$Res>  {
  factory $UrlencodedCopyWith(Urlencoded value, $Res Function(Urlencoded) _then) = _$UrlencodedCopyWithImpl;
@useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
});




}
/// @nodoc
class _$UrlencodedCopyWithImpl<$Res>
    implements $UrlencodedCopyWith<$Res> {
  _$UrlencodedCopyWithImpl(this._self, this._then);

  final Urlencoded _self;
  final $Res Function(Urlencoded) _then;

/// Create a copy of Urlencoded
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Urlencoded].
extension UrlencodedPatterns on Urlencoded {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Urlencoded value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Urlencoded() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Urlencoded value)  $default,){
final _that = this;
switch (_that) {
case _Urlencoded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Urlencoded value)?  $default,){
final _that = this;
switch (_that) {
case _Urlencoded() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Urlencoded() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  String? value,  String? type,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Urlencoded():
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  String? value,  String? type,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Urlencoded() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Urlencoded implements Urlencoded {
  const _Urlencoded({this.key, this.value, this.type, this.disabled});
  factory _Urlencoded.fromJson(Map<String, dynamic> json) => _$UrlencodedFromJson(json);

@override final  String? key;
@override final  String? value;
@override final  String? type;
@override final  bool? disabled;

/// Create a copy of Urlencoded
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UrlencodedCopyWith<_Urlencoded> get copyWith => __$UrlencodedCopyWithImpl<_Urlencoded>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UrlencodedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Urlencoded&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,type,disabled);

@override
String toString() {
  return 'Urlencoded(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$UrlencodedCopyWith<$Res> implements $UrlencodedCopyWith<$Res> {
  factory _$UrlencodedCopyWith(_Urlencoded value, $Res Function(_Urlencoded) _then) = __$UrlencodedCopyWithImpl;
@override @useResult
$Res call({
 String? key, String? value, String? type, bool? disabled
});




}
/// @nodoc
class __$UrlencodedCopyWithImpl<$Res>
    implements _$UrlencodedCopyWith<$Res> {
  __$UrlencodedCopyWithImpl(this._self, this._then);

  final _Urlencoded _self;
  final $Res Function(_Urlencoded) _then;

/// Create a copy of Urlencoded
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_Urlencoded(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Variable {

 String? get key; dynamic get value; String? get type; bool? get disabled;
/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VariableCopyWith<Variable> get copyWith => _$VariableCopyWithImpl<Variable>(this as Variable, _$identity);

  /// Serializes this Variable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Variable&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(value),type,disabled);

@override
String toString() {
  return 'Variable(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class $VariableCopyWith<$Res>  {
  factory $VariableCopyWith(Variable value, $Res Function(Variable) _then) = _$VariableCopyWithImpl;
@useResult
$Res call({
 String? key, dynamic value, String? type, bool? disabled
});




}
/// @nodoc
class _$VariableCopyWithImpl<$Res>
    implements $VariableCopyWith<$Res> {
  _$VariableCopyWithImpl(this._self, this._then);

  final Variable _self;
  final $Res Function(Variable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_self.copyWith(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Variable].
extension VariablePatterns on Variable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Variable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Variable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Variable value)  $default,){
final _that = this;
switch (_that) {
case _Variable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Variable value)?  $default,){
final _that = this;
switch (_that) {
case _Variable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  dynamic value,  String? type,  bool? disabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Variable() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  dynamic value,  String? type,  bool? disabled)  $default,) {final _that = this;
switch (_that) {
case _Variable():
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  dynamic value,  String? type,  bool? disabled)?  $default,) {final _that = this;
switch (_that) {
case _Variable() when $default != null:
return $default(_that.key,_that.value,_that.type,_that.disabled);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, anyMap: true, includeIfNull: false)
class _Variable implements Variable {
  const _Variable({this.key, this.value, this.type, this.disabled});
  factory _Variable.fromJson(Map<String, dynamic> json) => _$VariableFromJson(json);

@override final  String? key;
@override final  dynamic value;
@override final  String? type;
@override final  bool? disabled;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VariableCopyWith<_Variable> get copyWith => __$VariableCopyWithImpl<_Variable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VariableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Variable&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.type, type) || other.type == type)&&(identical(other.disabled, disabled) || other.disabled == disabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(value),type,disabled);

@override
String toString() {
  return 'Variable(key: $key, value: $value, type: $type, disabled: $disabled)';
}


}

/// @nodoc
abstract mixin class _$VariableCopyWith<$Res> implements $VariableCopyWith<$Res> {
  factory _$VariableCopyWith(_Variable value, $Res Function(_Variable) _then) = __$VariableCopyWithImpl;
@override @useResult
$Res call({
 String? key, dynamic value, String? type, bool? disabled
});




}
/// @nodoc
class __$VariableCopyWithImpl<$Res>
    implements _$VariableCopyWith<$Res> {
  __$VariableCopyWithImpl(this._self, this._then);

  final _Variable _self;
  final $Res Function(_Variable) _then;

/// Create a copy of Variable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? value = freezed,Object? type = freezed,Object? disabled = freezed,}) {
  return _then(_Variable(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
