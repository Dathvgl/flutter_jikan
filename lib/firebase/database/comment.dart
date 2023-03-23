import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_jikan/firebase/database/home.dart';
import 'package:flutter_jikan/models/jsons/comment.dart';

const _path = "clubComment";

abstract class CommentReal {
  static const childPath = "comments";

  static DatabaseReference _ref(String uid) {
    return realtime.ref.child(_path).child(uid);
  }

  static Stream<DatabaseEvent> getComments(String uid) {
    return _ref(uid).onValue;
  }

  static Future<List<String>> getIdComments({
    required String postId,
    required String userId,
  }) async {
    return await _ref(postId).child(userId).get().then((value) {
      List<String> list = [];
      final data = value.value;

      if (data != null) {
        Map<String, Object>.from(data as Map).forEach((key, value) {
          list.add(key);
        });
      }

      return list;
    });
  }

  static Future<void> updateComments({
    required String postId,
    required String userId,
    required Map<String, dynamic> map,
  }) async {
    await _ref(postId).child(userId).update(map);
  }

  static void setComment({
    required String uid,
    required String userId,
    required CommentModel data,
  }) async {
    final check = await _ref(uid).child(userId).get().then((value) {
      return value.exists;
    });

    if (!check) {
      await _ref(uid).child(userId).set(data.toJsonUser());
    }

    await _ref(uid)
        .child(userId)
        .child(childPath)
        .child(data.id ?? "")
        .set(data.toJsonPost());
  }

  static void deleteComments(String uid) async {
    await _ref(uid).remove();
  }
}
