// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionModel _$CollectionModelFromJson(Map<String, dynamic> json) =>
    _CollectionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      requestMetaList:
          (json['requestMetaList'] as List<dynamic>?)
              ?.map((e) => RequestMetaModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <RequestMetaModel>[],
    );

Map<String, dynamic> _$CollectionModelToJson(_CollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'requestMetaList': instance.requestMetaList,
    };
