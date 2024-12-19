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
      body: CustomScrollView(
        slivers: [
          // SliverAppBar melengkung
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              height: 150.0,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 1.1,
                      child: ClipPath(
                        clipper: AppBarClipper(),
                        child: Container(color: Colors.black.withOpacity(0.2)),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: AppBarClipper(),
                    child: Container(
                      color: Colors.blueAccent,
                      child: const Center(
                        child: Text(
                          'Favorites',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Konten ListView
          Obx(() {
            // Condition 1: Guest User
            if (favoriteController.isGuest.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Please Login to see and add favorites.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              );
            }

            // Condition 2: No Favorites
            if (favoriteController.favorites.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No Favorites Yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              );
            }

            // Condition 3: List Favorites
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                          favoriteController.removeFromFavorites(favorite.id);
                        },
                      ),
                    ),
                  );
                },
                childCount: favoriteController.favorites.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Custom SliverPersistentHeader Delegate
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double height; // Menggunakan satu nilai tinggi tetap
  final Widget child;

  _SliverAppBarDelegate({
    required this.height,
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => height; // Tinggi tetap
  @override
  double get minExtent => height; // Tinggi tetap

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}