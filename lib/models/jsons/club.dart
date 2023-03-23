import 'package:json_annotation/json_annotation.dart';

part "club.g.dart";

@JsonSerializable()
class ClubModel {
  String? id;
  String? userId;
  String? name;
  String? icon;
  String? imageUrl;
  String? description;
  String? category;
  String? access;
  String? dateCreate;

  ClubModel({
    this.id,
    this.userId,
    this.name,
    this.icon,
    this.imageUrl,
    this.description,
    this.category,
    this.access,
    this.dateCreate,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return _$ClubModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ClubModelToJson(this);
}
