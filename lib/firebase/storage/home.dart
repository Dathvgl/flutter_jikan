import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

StorageFirebase get storage => Get.find<StorageFirebase>();

class StorageFirebase {
  final _firestorage = FirebaseStorage.instance;

  Reference get ref => _firestorage.ref();
}
