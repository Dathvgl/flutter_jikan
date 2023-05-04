import 'package:cloud_firestore/cloud_firestore.dart';

StoreFirebase firestore = StoreFirebase();

class StoreFirebase {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> Function(String) get collection {
    return _firestore.collection;
  }
}
