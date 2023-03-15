import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part "my_list.g.dart";

@JsonSerializable()
class MyListModel extends Equatable {
  final String? id;
  final int? malId;
  final String? title;
  final String? imageUrl;
  final String? type;
  final String? status;
  final String? season;
  final int? year;
  final String? state;
  final int? progress;
  final int? totalProgress;
  final int? score;
  final String? comment;
  final String? dateStart;
  final String? dateEnd;

  const MyListModel({
    this.id,
    this.malId,
    this.title,
    this.imageUrl,
    this.type,
    this.status,
    this.season,
    this.year,
    this.state,
    this.progress,
    this.totalProgress,
    this.score,
    this.comment,
    this.dateStart,
    this.dateEnd,
  });

  factory MyListModel.fromJson(Map<String, dynamic> json) {
    return _$MyListModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyListModelToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      state,
      progress,
      score,
      comment,
      dateStart,
      dateEnd,
    ];
  }
}
