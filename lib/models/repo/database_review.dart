import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DatabaseReview {
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection("ReviewCollection");
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<void> addReview({
    required String imagePath,
    required String foodName,
    required double rating,
    required String reviewMessage,
  }) async {
    DocumentReference reviewDocument =
        reviewCollection.doc(foodName).collection("Bewertung").doc();

    final imageDatabasePath =
        storageRef.child("images/${reviewDocument.id}.jpg");
    File file = File(imagePath);
    await imageDatabasePath.putFile(file);

    String downloadURL = await imageDatabasePath.getDownloadURL();
    final imageBytes = await imageDatabasePath.getData(10000000);
    await DefaultCacheManager().putFile(
      downloadURL,
      imageBytes!,
      fileExtension: "jpg",
    );
    // Upload review data to Firestore
    await _uploadReviewData(
      imagePath: downloadURL,
      foodName: foodName,
      rating: rating,
      reviewMessage: reviewMessage,
      reviewDocument: reviewDocument.id,
    );
  }

  Future<void> _uploadReviewData({
    required String imagePath,
    required String foodName,
    required double rating,
    required String reviewMessage,
    required String reviewDocument,
  }) async {
    await reviewCollection
        .doc(foodName)
        .collection("Bewertung")
        .doc(reviewDocument)
        .set({
      "food_name": foodName,
      "image_path": imagePath,
      "message": reviewMessage,
      "rating": rating,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getReviews(String foodName) {
    return reviewCollection.doc(foodName).collection('Bewertung').snapshots();
  }
}
