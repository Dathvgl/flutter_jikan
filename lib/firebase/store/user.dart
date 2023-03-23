import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter_jikan/firebase/auth/home.dart';
import 'package:flutter_jikan/firebase/store/home.dart';
import 'package:flutter_jikan/models/jsons/user.dart';

const _path = "user";
final _store = firestore.collection(_path);

abstract class UserStore {
  static Future<void> addUser(UserModel user) async {
    await _store.doc(user.id).set(user.toJson());
  }

  static Future<void> getUser(String uid) async {
    await _store.doc(uid).get().then((value) {
      auth.info = value.data() ?? UserModel().toJson();
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listenUser(
      Iterable<String?> map) {
    return _store.where("id", whereIn: map).snapshots();
  }

  static Future<void> updateUser(UserModel user) async {
    await _store.doc(user.id).update(user.toJson());
  }
}
