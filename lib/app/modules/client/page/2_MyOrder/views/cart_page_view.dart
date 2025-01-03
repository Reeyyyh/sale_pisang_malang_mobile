import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/components/component.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/chats/views/client_chats_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/2_MyOrder/controllers/cart_page_controller.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartPageController orderController = Get.put(CartPageController());

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
                          'My Orders',
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
          // Konten ListView atau pesan jika user belum login
          Obx(() {
            if (orderController.isGuest.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Please login to see your orders.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            if (orderController.orders.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No Orders Yet.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final order = orderController.orders[index];
                  return Dismissible(
                    key: Key(order.id), // Pastikan ID unik untuk setiap item
                    direction:
                        DismissDirection.endToStart, // Swipe dari kanan ke kiri
                    onDismissed: (direction) {
                      // Menghapus item dari daftar
                      orderController.removeFromOrders(order.id, order.name);
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              'Swipe to delete',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    child: Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          order.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price: ${order.price}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Status: ${order.status}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.chevron_left,
                          color: Colors.grey[600],
                        ),
                        onTap: () {
                          // Tambahkan fungsionalitas onTap di sini jika diperlukan
                        },
                      ),
                    ),
                  );
                },
                childCount: orderController.orders.length,
              ),
            );
          }),
        ],
      ),
      // Floating Action Button untuk chat

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final CartPageController cartController =
              Get.find<CartPageController>();

          // Periksa apakah user adalah guest
          if (cartController.isGuest.value) {
            // Jika user belum login
            Get.defaultDialog(
              title: "",
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Login Required",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You need to login to use the chat feature.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
              confirm: ElevatedButton.icon(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.off(() => LoginPageView()); // Navigasi ke halaman login
                },
                icon: const Icon(
                  Icons.login,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey, // Warna teks
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Kurangi radius jika ingin lebih kecil
                    side: const BorderSide(
                        color: Colors.grey), // Tambahkan border
                  ),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500, // Teks sedikit lebih tebal
                  ),
                ),
              ),
              radius: 8, // Membuat sudut dialog melengkung
            );
          } else {
            // Jika user sudah login
            final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
            if (userId.isNotEmpty) {
              Get.to(() => ClientChatsAdminPageView(userId: userId));
            }
          }
        },
        backgroundColor: Colors.blueAccent,
        tooltip: "Chat with Admin",
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Custom SliverPersistentHeader Delegate
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double height;
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
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
