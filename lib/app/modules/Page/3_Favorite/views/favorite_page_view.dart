import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/components/component.dart';
import 'package:sale_pisang_malang/app/modules/Page/3_Favorite/controllers/favorite_page_controller.dart';

class FavoritePageView extends StatelessWidget {
  const FavoritePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.put(FavoriteController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: 1.10,
                child: ClipPath(
                  clipper: AppBarClipper(),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: AppBarClipper(),
              child: AppBar(
                title: const Text(
                  'Favorites',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Print user status for verification
          print(
              'Current user status: ${favoriteController.isGuest.value ? "Guest" : "Logged in"}');

          // Condition 1: User is a guest
          if (favoriteController.isGuest.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Login to add and view your favorites.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Condition 2: User is logged in but has no favorites
          if (favoriteController.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Favorites Yet. Add some items to your favorites!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Condition 3: User is logged in and has favorites
          return ListView.builder(
            itemCount: favoriteController.favorites.length,
            itemBuilder: (context, index) {
              final favorite = favoriteController.favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  leading: const FaIcon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                  title: Text(
                    favorite.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    'Price: ${favorite.price}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const FaIcon(Icons.delete_outline_rounded,
                        color: Colors.red),
                    onPressed: () {
                      // Implement function to remove favorite if necessary
                      // favoriteController.removeFavorite(favorite);
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
