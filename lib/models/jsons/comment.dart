import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_jikan/firebase/database/comment.dart';
import 'package:json_annotation/json_annotation.dart';

part "comment.g.dart";

@JsonSerializable()
class CommentModel {
  String? id;
  String? userId;
  String? userName;
  String? userImage;
  String? content;
  String? dateCreate;

  CommentModel({
    this.id,
    this.userId,
    this.userName,
    this.userImage,
    this.content,
    this.dateCreate,
  });

  static List<CommentModel> init(DataSnapshot snapshot) {
    List<CommentModel> list = [];
    final data = snapshot.value;

    if (data != null) {
      Map<String, Object>.from(data as Map).forEach((key, value) {
        Map<String, dynamic> myListItem = {};
        Map<dynamic, dynamic> mapValue = {};
        myListItem["userId"] = key;

        final map = value as Map;
        map.forEach((key, value) {
          if (key != CommentReal.childPath) {
            switch (key) {
              case "name":
                myListItem["userName"] = value;
                break;
              case "imageUrl":
                myListItem["userImage"] = value;
                break;
            }
          } else {
            mapValue = value as Map;
          }
        });

        mapValue.forEach((key, value) {
          final mapChildDeep = value as Map;
          mapChildDeep.forEach((key, value) {
            myListItem[key.toString()] = value;
          });

          list.add(CommentModel.fromJson(myListItem));
        });
      });
    }

    return list;
  }

  Map<String, dynamic> toJsonUser() {
    return {
      "id": userId,
      "name": userName,
      "imageUrl": userImage,
    };
  }

  Map<String, dynamic> toJsonPost() {
    return {
      'id': id,
      'content': content,
      'dateCreate': dateCreate,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return _$CommentModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}
