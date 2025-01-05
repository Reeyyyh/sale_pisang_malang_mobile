import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sale_pisang_malang/app/modules/auth/views/login_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/chats/views/client_chats_page_view.dart';
import 'package:sale_pisang_malang/app/modules/client/page/2_MyOrder/controllers/cart_page_controller.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartPageController orderController = Get.put(CartPageController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(255, 170, 0, 1),
          title: const Text(
            'My Orders',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 4.0,
          shadowColor: Colors.black26,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white, // Warna teks aktif
            unselectedLabelColor: Colors.white70, // Warna teks tidak aktif
            tabs: const [
              Tab(
                icon: Icon(Icons.shopping_basket),
                text: 'Orders',
              ),
              Tab(
                icon: Icon(Icons.history),
                text: 'History',
              ),
            ],
            onTap: (index) {
              orderController.setActiveTab(index); // Update activeTab
            },
          ),
        ),
        body: TabBarView(
          children: [
            // Tab pertama: daftar pesanan
            CustomScrollView(
              slivers: [
                Obx(() {
                  if (orderController.isGuest.value) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Please login to see your cart.',
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
                          'No Item Yet.',
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
                          key: Key(order.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            orderController.removeFromOrders(
                                order.id, order.name);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          child: Card(
                            elevation: 2.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                              trailing: const Icon(
                                Icons.chevron_left,
                                color: Colors.grey,
                              ),
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
            // Tab kedua: riwayat pesanan
            CustomScrollView(
              slivers: [
                Obx(() {
                  if (orderController.isGuest.value) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Please login to see your order history.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  if (orderController.history.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No Order History Yet.',
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
                        final history = orderController.history[index];
                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              history.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price: ${history.price}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Ordered on: ${DateFormat('yyyy-MM-dd HH:mm').format(history.timestamp.toDate())}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Panggil fungsi deleteHistory dengan ID history yang dipilih
                                orderController.deleteHistory(history.id);
                              },
                            ),
                          ),
                        );
                      },
                      childCount: orderController.history.length,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final CartPageController cartController =
                Get.find<CartPageController>();
            if (cartController.isGuest.value) {
              Get.defaultDialog(
                title: "",
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 60,
                      color: Color.fromRGBO(255, 170, 0, 1),
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
                    Get.back();
                    Get.off(() => LoginPageView());
                  },
                  icon: const Icon(
                    Icons.login,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text("Login"),
                ),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
              );
            } else {
              final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
              if (userId.isNotEmpty) {
                Get.to(() => ClientChatsAdminPageView(userId: userId));
              }
            }
          },
          backgroundColor: const Color.fromRGBO(255, 170, 0, 1),
          tooltip: "Chat with Admin",
          child: const Icon(Icons.chat, color: Colors.white),
        ),
        bottomNavigationBar: Obx(() {
          orderController.setActiveTab(0);
          final isGuest = orderController.isGuest.value;
          final hasOrders = orderController.orders.isNotEmpty;
          final isInOrdersTab = orderController.activeTab.value == 0;

          print(isGuest);
          print(hasOrders);
          print(isInOrdersTab);

          // Cek apakah pengguna adalah guest atau pesanan kosong
          if (isGuest || !hasOrders || !isInOrdersTab) {
            print('Conditions not met for checkout button');

            return const SizedBox
                .shrink(); // Tidak menampilkan tombol jika kondisi tidak terpenuhi
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Aksi ketika tombol checkout ditekan
                orderController.checkoutOrders();
              },
              icon: const Icon(
                Icons.shopping_cart_checkout_sharp,
                color: Colors.white,
              ),
              label: const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 170, 0, 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
