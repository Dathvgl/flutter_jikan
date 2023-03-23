// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClubModel _$ClubModelFromJson(Map<String, dynamic> json) => ClubModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      access: json['access'] as String?,
      dateCreate: json['dateCreate'] as String?,
    );

Map<String, dynamic> _$ClubModelToJson(ClubModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'icon': instance.icon,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'category': instance.category,
      'access': instance.access,
      'dateCreate': instance.dateCreate,
    };
