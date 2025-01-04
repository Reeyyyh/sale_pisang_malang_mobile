import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/components/component.dart';
import 'package:sale_pisang_malang/app/modules/client/page/1_Home/controllers/home_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/client/widget/card_detail_view.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      body: Obx(
        () {
          // Jika item kosong, tampilkan SliverPersistentHeader dan CircularProgressIndicator
          if (homeController.isLoading.value) {
            // Tampilkan loading jika sedang loading
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: AppBarSliverDelegate(),
                ),
                const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              ],
            );
          } else if (homeController.hasError.value) {
            // Tampilkan pesan error jika tidak ada data setelah 2 detik
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: AppBarSliverDelegate(),
                ),
                const SliverFillRemaining(
                  hasScrollBody: false, // Menghindari scroll pada bagian ini
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          color: Colors.red,
                          size: 60,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No data available',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: AppBarSliverDelegate(),
                ),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.737,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = homeController.items[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => CardDetailView(
                                title: item.name,
                                description: item.description,
                                imgUrl: item.imgUrl,
                                harga: item.harga),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar produk penuh
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Hero(
                                  tag: item
                                      .name, // Sesuai dengan tag di CardDetailView
                                  child: Image.network(
                                    item.imgUrl.isNotEmpty
                                        ? item.imgUrl
                                        : 'https://via.placeholder.com/150?text=No+Image',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150, // Tinggi tetap untuk gambar
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Nama, harga, dan ikon
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nama item
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    // description
                                    const SizedBox(height: 4),
                                    Text(
                                      item.description,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    // Harga dan ikon
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Harga
                                        Text(
                                          'Rp ${item.harga}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        // Ikon Add to Cart dan Favorite
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.add_shopping_cart),
                                              onPressed: () {
                                                homeController
                                                    .checkUserAccess('Cart');
                                                if (!homeController
                                                    .isUserGuest.value) {
                                                  homeController
                                                      .addToCart(item);
                                                }
                                              },
                                            ),
                                            Obx(
                                              () {
                                                return IconButton(
                                                  icon: Icon(
                                                    homeController
                                                            .isUserGuest.value
                                                        ? Icons
                                                            .favorite_border_rounded
                                                        : (homeController
                                                                .isItemInFavorites(
                                                                    item.id)
                                                                .value
                                                            ? Icons
                                                                .favorite_rounded
                                                            : Icons
                                                                .favorite_border_rounded),
                                                    color: homeController
                                                            .isUserGuest.value
                                                        ? null
                                                        : (homeController
                                                                .isItemInFavorites(
                                                                    item.id)
                                                                .value
                                                            ? Colors.redAccent
                                                            : null),
                                                  ),
                                                  onPressed: () {
                                                    homeController
                                                        .checkUserAccess(
                                                            'Favorites');
                                                    if (!homeController
                                                        .isUserGuest.value) {
                                                      if (homeController
                                                          .isItemInFavorites(
                                                              item.id)
                                                          .value) {
                                                        homeController
                                                            .removeFromFavorites(
                                                                item.id,
                                                                item.name);
                                                      } else {
                                                        homeController
                                                            .addToFavorites(
                                                                item);
                                                      }
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: homeController.items.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class AppBarSliverDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        // Background shadow layer, slightly larger than the foreground layer
        Positioned.fill(
          child: Transform.scale(
            scale: 1.10, // Sedikit lebih besar dari layer depan
            child: ClipPath(
              clipper: AppBarClipper(),
              child: Container(
                color: const Color.fromARGB(105, 0, 0, 0), // Shadow color
              ),
            ),
          ),
        ),
        // Foreground gradient layer
        ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            height: maxExtent,
            color: const Color.fromRGBO(255, 170, 0, 1),
            child: const Center(
              child: Text(
                'Welcome To Sale Pisang Malang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 120.0;
  @override
  double get minExtent => 120.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
