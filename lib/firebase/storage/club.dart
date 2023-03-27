import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_jikan/firebase/storage/home.dart';

const _path = "club";

abstract class ClubStorage {
  static Reference _ref(String uid, String name) {
    return storage.ref.child("$_path/$uid/$name");
  }

  static UploadTask putFile({
    required String uid,
    required String name,
    required File file,
  }) {
    return _ref(uid, name).putFile(file);
  }
}
