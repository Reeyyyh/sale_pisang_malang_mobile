import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/1_Home/controllers/home_page_controller.dart';
import 'package:sale_pisang_malang/app/modules/auth/services/auth_service.dart';
import 'package:sale_pisang_malang/app/components/component.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final AuthService authService = Get.find<AuthService>();

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
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = homeController.items[index];
                      return Card(
                        elevation: 8, // Menambahkan shadow untuk card
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize
                                .min, // Menjaga tinggi card tetap minimal
                            children: [
                              ListTile(
                                title: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(item.description),
                              ),
                              const Divider(), // Pemisah antara deskripsi dan harga
                              Flexible(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rp ${item.harga}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .green, // Memberi warna pada harga
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // Menghindari overflow harga
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Memberikan jarak antara harga dan ikon
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.add_shopping_cart),
                                                onPressed: () {
                                                  print(
                                                      'User ID at cart icon pressed: ${homeController.isUserGuest ? "Guest" : authService.currentUser?.uid}');
                                                  homeController
                                                      .checkUserAccess('Cart');
                                                  if (!homeController
                                                      .isUserGuest) {
                                                    homeController
                                                        .addToCart(item);
                                                  }
                                                },
                                              ),
IconButton(
  icon: Icon(
    homeController.isUserGuest
        ? Icons.favorite_border_rounded // Jika user guest, tampilkan ikon border
        : (homeController.isItemInFavorites(item.id)
            ? Icons.favorite_rounded // Jika item di favorit, tampilkan ikon penuh
            : Icons.favorite_border_rounded), // Jika item tidak di favorit, tampilkan ikon border
    color: homeController.isUserGuest // Periksa status login terlebih dahulu
        ? Colors.grey  // Jika user guest, ikon menjadi abu-abu
        : (homeController.isItemInFavorites(item.id) ? Colors.redAccent : null),
  ),
  onPressed: () {
    homeController.checkUserAccess('Favorites');
    if (!homeController.isUserGuest) {
      if (homeController.isItemInFavorites(item.id)) {
        homeController.removeFromFavorites(item.id, item.name);
      } else {
        homeController.addToFavorites(item);
      }
    }
  },
),

                                            ],
                                          ),
                                        ],
                                      ),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.blue,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
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
