import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image
  Future<String?> uploadImage(File? file, String path) async {
    try {
      if (file == null) return null;

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('$path/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }

  // Upload image for web
  Future<String?> uploadImageWeb(
    Uint8List fileBytes,
    String fileName,
    String path,
  ) async {
    try {
      String fullFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      Reference ref = _storage.ref().child('$path/$fullFileName');

      UploadTask uploadTask = ref.putData(fileBytes);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload image web error: $e');
      return null;
    }
  }

  // Delete image
  Future<bool> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Delete image error: $e');
      return false;
    }
  }

  // Upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> files,
    String path,
  ) async {
    List<String> downloadUrls = [];

    for (File file in files) {
      String? url = await uploadImage(file, path);
      if (url != null) {
        downloadUrls.add(url);
      }
    }

    return downloadUrls;
  }

  // Upload nail art images
  Future<String?> uploadNailArt(File file, String userId) async {
    return await uploadImage(file, 'nail_arts/$userId');
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(File file, String userId) async {
    return await uploadImage(file, 'profile_pictures/$userId');
  }

  // Upload service images
  Future<String?> uploadServiceImage(File file) async {
    return await uploadImage(file, 'service_images');
  }

  // Upload product images
  Future<String?> uploadProductImage(File file) async {
    return await uploadImage(file, 'product_images');
  }

  // Get image metadata
  Future<FullMetadata?> getImageMetadata(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      FullMetadata metadata = await ref.getMetadata();
      return metadata;
    } catch (e) {
      print('Get image metadata error: $e');
      return null;
    }
  }

  // List files in a path
  Future<List<Reference>> listFiles(String path) async {
    try {
      ListResult result = await _storage.ref(path).listAll();
      return result.items;
    } catch (e) {
      print('List files error: $e');
      return [];
    }
  }
}
