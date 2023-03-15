// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyListModel _$MyListModelFromJson(Map<String, dynamic> json) => MyListModel(
      id: json['id'] as String?,
      malId: json['malId'] as int?,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      season: json['season'] as String?,
      year: json['year'] as int?,
      state: json['state'] as String?,
      progress: json['progress'] as int?,
      totalProgress: json['totalProgress'] as int?,
      score: json['score'] as int?,
      comment: json['comment'] as String?,
      dateStart: json['dateStart'] as String?,
      dateEnd: json['dateEnd'] as String?,
    );

Map<String, dynamic> _$MyListModelToJson(MyListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'malId': instance.malId,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'type': instance.type,
      'status': instance.status,
      'season': instance.season,
      'year': instance.year,
      'state': instance.state,
      'progress': instance.progress,
      'totalProgress': instance.totalProgress,
      'score': instance.score,
      'comment': instance.comment,
      'dateStart': instance.dateStart,
      'dateEnd': instance.dateEnd,
    };
