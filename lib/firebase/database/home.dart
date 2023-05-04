import 'package:firebase_database/firebase_database.dart';

RealtimeFirebase realtime = RealtimeFirebase();

class RealtimeFirebase {
  final _firebaseDatabase = FirebaseDatabase.instance;

  DatabaseReference get ref => _firebaseDatabase.ref();
}
