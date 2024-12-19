import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_pisang_malang/app/components/component.dart';
import 'package:sale_pisang_malang/app/modules/Page/2_MyOrder/controllers/cart_page_controller.dart'; // Pastikan import controller

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
        direction: DismissDirection.endToStart, // Swipe dari kanan ke kiri
        onDismissed: (direction) {
          // Menghapus item dari daftar
          orderController.removeFromOrders(order.id, order.name);
        },
        background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
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
              Icons.chevron_right,
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
