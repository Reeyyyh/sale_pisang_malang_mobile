import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/3_Favorite/controllers/favorite_page_controller.dart';

class FavoritePageView extends StatelessWidget {
  const FavoritePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: Obx(() {
        // Cetak user ID atau nama untuk verifikasi
        print('Current user status: ${favoriteController.isGuest.value ? "Guest" : "Logged in"}');
        
        // Kondisi 1: Pengguna adalah guest
        if (favoriteController.isGuest.value) {
          return const Center(
            child: Text(
              'Login to add and view your favorites.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Kondisi 2: Pengguna sudah login tetapi belum ada favorit
        if (favoriteController.favorites.isEmpty) {
          return const Center(
            child: Text(
              'No Favorites Yet. Add some items to your favorites!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Kondisi 3: Pengguna sudah login dan memiliki favorit
        return ListView.builder(
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final favorite = favoriteController.favorites[index];
            return ListTile(
              title: Text(favorite.name),
              subtitle: Text('Price: ${favorite.price}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  // Implementasikan fungsi untuk menghapus favorit jika diperlukan
                  // favoriteController.removeFavorite(favorite);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
