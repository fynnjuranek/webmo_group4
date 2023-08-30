import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:webmo_group4/shared/constants.dart';
import 'package:webmo_group4/views/food/food_view.dart';
import 'package:webmo_group4/views/food_rating/show_ratings.dart';

import '../../../viewmodels/auth/auth_service.dart';
import '../../food_rating/food_rating_view.dart';

class HomeAdmin extends StatelessWidget {
  HomeAdmin({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorbg1,
        appBar: AppBar(
          backgroundColor: colorbg2,
          title: const Text("Admin Home Screen"),
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorbg2,
                elevation: 0,
              ),
              icon: const Icon(Icons.person),
              label: const Text("logout"),
              onPressed: () async {
                await _authService.signOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FoodView()));
              },
              child: const Text("Go to FoodView"),
            ),
            TextButton(
              onPressed: () async {
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                              camera: firstCamera,
                              foodName:
                                  "Bolognese", // TODO needs to be changed to variable name which will be chosen before review call
                            )));
              },
              child: const Text("Go to Review"),
            ),
            TextButton(
              onPressed: () {
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Reviews(),
                    ));
              },
              child: const Text("Show Reviews"),
            ),
          ],
        ));
  }
}