import 'package:firebase_storage/firebase_storage.dart';

StorageFirebase storage = StorageFirebase();

class StorageFirebase {
  final _firestorage = FirebaseStorage.instance;

  Reference get ref => _firestorage.ref();
}
