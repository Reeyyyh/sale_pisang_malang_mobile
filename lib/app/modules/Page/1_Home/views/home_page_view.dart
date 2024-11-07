import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/modules/Page/1_Home/controllers/home_page_controller.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      body: Obx(() {
        if (homeController.items.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        }
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              Get.snackbar(
                                                'Item Added',
                                                '${item.name} has been added to your cart',
                                                snackPosition:
                                                    SnackPosition.TOP,
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                              width:
                                                  16), // Memberikan jarak antara ikon
                                          IconButton(
                                            icon: const Icon(Icons.favorite),
                                            onPressed: () {
                                              Get.snackbar(
                                                'Item Added',
                                                '${item.name} has been added to your cart',
                                                snackPosition:
                                                    SnackPosition.TOP,
                                              );
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
      }),
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
                  Color(0xFFFFE135),
                  Color(0xFFFFA500),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                'Welcome To Sale Pisang Malang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
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

// Custom clipper untuk membuat bentuk AppBar
class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
