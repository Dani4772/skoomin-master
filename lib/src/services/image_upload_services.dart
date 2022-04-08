import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadServices {
  Future<List<String>> uploadImages(List<String> images) async {
    List<String> imageUrls = <String>[];
    try {
      for (String f in images) {
        String fileName = DateTime.now().toIso8601String();
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(fileName);
        final uploadTask = await firebaseStorageRef.putFile(File(f));
        imageUrls.add(await uploadTask.ref.getDownloadURL());
      }
      return imageUrls;
    } catch (e) {
      rethrow;
    }
  }
}
