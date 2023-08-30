import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webmo_group4/models/review/review_model.dart';

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
    final imageDatabasePath = storageRef.child("images/$foodName.jpg");

    // Upload review data to Firestore
    await _uploadReviewData(
      imagePath: imageDatabasePath.fullPath,
      foodName: foodName,
      rating: rating,
      reviewMessage: reviewMessage,
    );

    File file = File(imagePath);
    await imageDatabasePath.putFile(file);
  }

  Future<void> _uploadReviewData({
    required String imagePath,
    required String foodName,
    required double rating,
    required String reviewMessage,
  }) async {
    await reviewCollection.add({
      "food_name": foodName,
      "image_path": imagePath,
      "message": reviewMessage,
      "rating": rating,
    });
  }

  Future<List> getReviewForFood({required foodName}) async {
    final snapshot =
        await reviewCollection.where("food_name", isEqualTo: foodName).get();
    return snapshot.docs
        .map((doc) => ReviewModel.fromSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
}