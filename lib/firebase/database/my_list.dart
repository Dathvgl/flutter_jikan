import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_jikan/enums/item.dart';
import 'package:flutter_jikan/firebase/database/home.dart';
import 'package:intl/intl.dart';
import 'package:jikan_api/jikan_api.dart';

const _path = "myList";

abstract class MyListReal {
  static DatabaseReference _ref(String uid) {
    return realtime.ref.child(_path).child(uid);
  }

  static Stream<DatabaseEvent> getUserList({
    required String uid,
  }) {
    return _ref(uid).onValue;
  }

  static Future<void> setUserList({
    required String uid,
    required Anime anime,
  }) async {
    final data = {
      "malId": anime.malId,
      "title": anime.title,
      "imageUrl": anime.imageUrl,
      "type": anime.type,
      "status": anime.status,
      "season": anime.season,
      "year": anime.year,
      "state": ItemStateType.planToWatch.name,
      "progress": 0,
      "score": 0,
      "totalProgress": anime.episodes,
      "comment": "",
      "dateStart": DateFormat.yMMMMd().format(DateTime.now()),
      "dateEnd": DateFormat.yMMMMd().format(DateTime.now()),
    };

    await _ref(uid).push().set(data);
  }

  static Future<void> updateUserList({
    required String uid,
    required String id,
    required Map<String, dynamic> map
  }) async {
    await _ref(uid).child(id).update(map);
  }

  static Future<void> deleteUserList({
    required String uid,
    required String id,
  }) async {
    await _ref(uid).child(id).remove();
  }
}
