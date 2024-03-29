import 'package:cloud_firestore/cloud_firestore.dart';

class FoodModel {
  final String name, foodType;
  final String price; // TODO maybe change price to decimal

  FoodModel({required this.name, required this.foodType, required this.price});

  // to get Data from Database
  factory FoodModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return FoodModel(
      name: data["name"],
      foodType: data["food_type"],
      price: data["price"],
    );
  }
}
