import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_jikan/enums/club.dart';
import 'package:flutter_jikan/firebase/database/home.dart';

const _pathClub = "clubClubUser";
const _pathUser = "clubUserClub";

abstract class ClubReal {
  static DatabaseReference _refClub(String uid) {
    return realtime.ref.child(_pathClub).child(uid);
  }

  static DatabaseReference _refUser(String uid) {
    return realtime.ref.child(_pathUser).child(uid);
  }

  static Stream<DatabaseEvent> getManyMember(String clubId) {
    return _refClub(clubId).onValue;
  }

  static Future<void> updateManyMember({
    required String userId,
    required String clubId,
    required Map<String, dynamic> map,
  }) async {
    await _refClub(clubId).child(userId).update(map);
  }

  static Future<void> addManyHost({
    required String userId,
    required String userName,
    required String userImage,
    required String clubId,
  }) async {
    final role = RoleClubType.host.name;

    await _refClub(clubId).child(userId).set({
      "name": userName,
      "imageUrl": userImage,
      "role": role,
    });

    await _refUser(userId).child(clubId).set(true);
  }

  static Future<void> addManyMember({
    required String userId,
    required String userName,
    required String userImage,
    required String clubId,
    required String clubAccess,
  }) async {
    String role = "";

    if (clubAccess == AccessClubType.public.name) {
      role = RoleClubType.member.name;
    } else {
      role = RoleClubType.none.name;
    }

    await _refClub(clubId).child(userId).set({
      "name": userName,
      "imageUrl": userImage,
      "role": role,
    });

    await _refUser(userId).child(clubId).set(true);
  }

  static Future<void> deleteManyMember({
    required String userId,
    required String clubId,
  }) async {
    await _refClub(clubId).child(userId).remove();
    await _refUser(userId).child(clubId).remove();
  }

  static Future<void> updateRoleMember({
    required String clubId,
    required String userId,
    required String role,
  }) async {
    await _refClub(clubId).child(userId).update({
      "role": role,
    });
  }
}
