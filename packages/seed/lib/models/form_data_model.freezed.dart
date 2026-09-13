// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormDataModel {

 String get name; String get value; FormDataType get type;
/// Create a copy of FormDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormDataModelCopyWith<FormDataModel> get copyWith => _$FormDataModelCopyWithImpl<FormDataModel>(this as FormDataModel, _$identity);

  /// Serializes this FormDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormDataModel&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,type);

@override
String toString() {
  return 'FormDataModel(name: $name, value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class $FormDataModelCopyWith<$Res>  {
  factory $FormDataModelCopyWith(FormDataModel value, $Res Function(FormDataModel) _then) = _$FormDataModelCopyWithImpl;
@useResult
$Res call({
 String name, String value, FormDataType type
});




}
/// @nodoc
class _$FormDataModelCopyWithImpl<$Res>
    implements $FormDataModelCopyWith<$Res> {
  _$FormDataModelCopyWithImpl(this._self, this._then);

  final FormDataModel _self;
  final $Res Function(FormDataModel) _then;

/// Create a copy of FormDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? value = null,Object? type = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FormDataType,
  ));
}

}


/// Adds pattern-matching-related methods to [FormDataModel].
extension FormDataModelPatterns on FormDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormDataModel value)  $default,){
final _that = this;
switch (_that) {
case _FormDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _FormDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String value,  FormDataType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormDataModel() when $default != null:
return $default(_that.name,_that.value,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String value,  FormDataType type)  $default,) {final _that = this;
switch (_that) {
case _FormDataModel():
return $default(_that.name,_that.value,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String value,  FormDataType type)?  $default,) {final _that = this;
switch (_that) {
case _FormDataModel() when $default != null:
return $default(_that.name,_that.value,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormDataModel implements FormDataModel {
  const _FormDataModel({required this.name, required this.value, required this.type});
  factory _FormDataModel.fromJson(Map<String, dynamic> json) => _$FormDataModelFromJson(json);

@override final  String name;
@override final  String value;
@override final  FormDataType type;

/// Create a copy of FormDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormDataModelCopyWith<_FormDataModel> get copyWith => __$FormDataModelCopyWithImpl<_FormDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormDataModel&&(identical(other.name, name) || other.name == name)&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,value,type);

@override
String toString() {
  return 'FormDataModel(name: $name, value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class _$FormDataModelCopyWith<$Res> implements $FormDataModelCopyWith<$Res> {
  factory _$FormDataModelCopyWith(_FormDataModel value, $Res Function(_FormDataModel) _then) = __$FormDataModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String value, FormDataType type
});




}
/// @nodoc
class __$FormDataModelCopyWithImpl<$Res>
    implements _$FormDataModelCopyWith<$Res> {
  __$FormDataModelCopyWithImpl(this._self, this._then);

  final _FormDataModel _self;
  final $Res Function(_FormDataModel) _then;

/// Create a copy of FormDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? value = null,Object? type = null,}) {
  return _then(_FormDataModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FormDataType,
  ));
}


}

// dart format on
