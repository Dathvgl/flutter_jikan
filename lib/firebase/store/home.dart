import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

StoreFirebase get firestore => Get.find<StoreFirebase>();

class StoreFirebase {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> Function(String) get collection {
    return _firestore.collection;
  }
}
