import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_jikan/firebase/store/home.dart';
import 'package:flutter_jikan/models/jsons/club.dart';

const _path = "club";
final _store = firestore.collection(_path);

abstract class ClubStore {
  static Future<void> addClub(ClubModel club) async {
    await _store.doc(club.id).set(club.toJson());
  }

  static Future<void> updateClub(ClubModel club) async {
    final map = club.toJson()
      ..removeWhere((key, value) {
        return value == null;
      });

    await _store.doc(club.id).update(map);
  }

  static Future<void> updateMembersClub(String id, int num) async {
    await _store.doc(id).update({"members": num});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> listenClub() {
    return _store.snapshots();
  }

  // static Future<void> deleteClub(String uid) async {
  //   await _store.doc(uid).delete();
  // }
}
