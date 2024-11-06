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
        if (favoriteController.favorites.isEmpty) {
          return const Center(child: Text('No Favorites Yet.'));
        }

        return ListView.builder(
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            final favorite = favoriteController.favorites[index];
            return ListTile(
              title: Text(favorite.name),
              subtitle: Text('Price: ${favorite.price}'),
            );
          },
        );
      }),
    );
  }
}
