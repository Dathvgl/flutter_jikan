import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

RealtimeFirebase get realtime => Get.find<RealtimeFirebase>();

class RealtimeFirebase {
  final _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get ref => _firebaseDatabase.ref();
}
