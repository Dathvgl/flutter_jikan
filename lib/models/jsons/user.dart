import 'package:firebase_database/firebase_database.dart';
import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class UserModel {
  String? id;
  String? name;
  String? imageUrl;
  String? gender;
  String? dateBirth;
  String? dateCreate;

  UserModel({
    this.id,
    this.name,
    this.imageUrl,
    this.gender,
    this.dateBirth,
    this.dateCreate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class UserMemberModel {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? role;

  UserMemberModel({
    this.id,
    this.name,
    this.imageUrl,
    this.role,
  });

  static List<UserMemberModel> init(DataSnapshot snapshot) {
    List<UserMemberModel> list = [];
    final data = snapshot.value;

    if (data != null) {
      Map<String, Object>.from(data as Map).forEach((key, value) {
        final map = value as Map;
        Map<String, dynamic> myListItem = {};

        myListItem["id"] = key;
        map.forEach((key, value) {
          myListItem[key.toString()] = value;
        });

        list.add(UserMemberModel.fromJson(myListItem));
      });
    }

    return list;
  }

  factory UserMemberModel.fromJson(Map<String, dynamic> json) {
    return UserMemberModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      role: json['role'] as String?,
    );
  }
}
