import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    // TODO: implement uploadProfileImageMobile
    throw UnimplementedError();
  }

  // web platform
  @override
  Future<String?> uploadProfileImageWeb(String fileBytes, String fileName) {
    // TODO: implement uploadProfileImageWeb
    throw UnimplementedError();
  }

  /* 
  
  Helper Methods - to upload files to storage

  */

  // mobile platforms(file)
  Future<String?> _uploadFile(
    String path,
    String fileName,
    String folder,
  ) async {
    try {
      // get file
      final file = File(path);

      // find place to store
      final storgeRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storgeRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {}
  }

  // web platform (bytes)
}
