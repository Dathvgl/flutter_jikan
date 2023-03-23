import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jikan/firebase/database/comment.dart';
import 'package:flutter_jikan/firebase/database/home.dart';
import 'package:flutter_jikan/models/jsons/post.dart';
import 'package:go_router_flow/go_router_flow.dart';

const _path = "clubPost";

abstract class PostReal {
  static const childPath = "posts";

  static DatabaseReference _ref(String uid) {
    return realtime.ref.child(_path).child(uid);
  }

  static Stream<DatabaseEvent> getPosts(String uid) {
    return _ref(uid).onValue;
  }

  static Future<List<String>> getIdPosts({
    required String clubId,
    required String userId,
  }) async {
    return await _ref(clubId).child(userId).get().then((value) {
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

  static Future<void> updatePosts({
    required String clubId,
    required String userId,
    required Map<String, dynamic> map,
  }) async {
    await _ref(clubId).child(userId).update(map);
  }

  static void setPost({
    required String uid,
    required String userId,
    required PostModel data,
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

  static void deletePost({
    required BuildContext context,
    required String uid,
    required String userId,
    required String postId,
  }) async {
    await _ref(uid)
        .child(userId)
        .child(childPath)
        .child(postId)
        .remove()
        .then((value) {
      CommentReal.deleteComments(postId);
      context.pop();
    });
  }
}
